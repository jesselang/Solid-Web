with Ada.Characters.Latin_1;
with Ada.Streams;

with Solid.Text_Streams;
with Solid.Strings;

package body Solid.Web.SCGI.Environment is
   procedure Read (Object : out Data; Stream : in Stream_Handle) is
      Stream_Colon : constant := Character'Pos (':');                        -- Netstring length delimiter.
      Stream_Comma : constant := Character'Pos (',');                        -- Netstring data delimiter.
      Stream_Nul   : constant := Character'Pos (Ada.Characters.Latin_1.Nul); -- Tuple delimiter.

      -- The following are used in determining the length of the environment data.
      Data_Length   : Ada.Streams.Stream_Element_Offset := 0;    -- The length of the data part of the netstring, excluding the
                                                                 -- data delimiter.
      Length_Buffer : Ada.Streams.Stream_Element_Array (1 .. 7); -- Supports a netstring length up to 999_999.  Deal with it.
      Before_Read   : Ada.Streams.Stream_Element_Offset;         -- Used to track an end of stream condition.

      Last : Ada.Streams.Stream_Element_Offset := 0; -- Used in reading the length and the environment data.  Denotes the last
                                                     -- bound of the buffer it is being used with.

      type Buffer_Handle is access Ada.Streams.Stream_Element_Array;

      Buffer : Buffer_Handle; -- The buffer is allocated on the heap in case it is rather large.

      -- The following are used to parse the environment data into the table.
      Tuple_First : Ada.Streams.Stream_Element_Offset := 0; -- The element containing the delimiter denoting a new tuple.
      Tuple_Split : Ada.Streams.Stream_Element_Offset := 0; -- The element containing the delimiter between the key and value.
      Tuple_Last  : Ada.Streams.STream_Element_Offset := 0; -- The element containing the delimiter denoting the end of the tuple.

      use type Ada.Streams.Stream_Element;
      use type Ada.Streams.Stream_Element_Offset;
   begin -- Read
      Read_Length : loop
         Before_Read := Last;
         Ada.Streams.Read (Stream => Stream.all, Item => Length_Buffer (Last + 1 .. Last + 1), Last => Last);

         if Last = Before_Read then -- End of stream.
            raise Read_Error with "Couldn't read the environment data length.";
         end if;

         if Length_Buffer (Last) = Stream_Colon then -- End of length data.
            Handle_Error : begin
               Data_Length := Ada.Streams.Stream_Element_Offset'Value (Text_Streams.To_String (Length_Buffer (1 .. Last - 1) ) );
            exception -- Handle_Error
               when Constraint_Error =>
                  raise Read_Error with "Couldn't parse the environment data length.";
            end Handle_Error;

            exit Read_Length;
         end if;
      end loop Read_Length;

      Buffer := new Ada.Streams.Stream_Element_Array (1 .. Data_Length + 1); -- Include space for the comma.
      Last   := 0;

      -- Attempt to read the entire environment data at once.
      -- If that doesn't work, keep trying.
      Read_Environment : loop
         if Last >= Buffer.all'Last then             -- The environment has been fully read.
            if Buffer.all (Last) = Stream_Comma then -- The data is properly delimited.
               exit Read_Environment;
            else
               raise Read_Error with "Environment didn't end with expected token.";
            end if;
         end if;

         Ada.Streams.Read (Stream => Stream.all, Item => Buffer.all (Last + 1 .. Buffer.all'Last), Last => Last);

         if Last = Buffer.all'First - 1 then
            raise Read_Error with "Couldn't fully read the environment.";
         end if;
      end loop Read_Environment;

      Parse_Environment : loop
         -- Tuple_First is set.
         Last := Tuple_First + 1;

         Find_Split : loop
            if Last >= Buffer.all'Last then
               raise Read_Error with "Reached the end of the environment data while parsing for a tuple.";
            end if;

            exit Find_Split when Buffer (Last) = Stream_Nul;

            Last := Last + 1;
         end loop Find_Split;

         Tuple_Split := Last;
         Last := Tuple_Split + 1;

         Find_Last : loop
            if Last >= Buffer.all'Last then
               Last := Buffer.all'Last; -- The comma at the end becomes the last bound for the tuple.

               exit Find_Last;
            end if;

            exit Find_Last when Buffer (Last) = Stream_Nul;

            Last := Last + 1;
         end loop Find_Last;

         Tuple_Last := Last;

         if Object.Table.Exists (Name => Text_Streams.To_String (Buffer (Tuple_First + 1 .. Tuple_Split - 1) ) ) then
            null; -- SCGI does not allow duplicate names in the environment.
         else
            Object.Table.Add (Name  => Text_Streams.To_String (Buffer (Tuple_First + 1 .. Tuple_Split - 1) ),
                              Value => Text_Streams.To_String (Buffer (Tuple_Split + 1 .. Tuple_Last - 1) ) );
         end if;

         Tuple_First := Tuple_Last; -- The end of this tuple is the beginning of the next.
      end loop Parse_Environment;
   end Read;

   -- It's possible we don't need this operation.
   function Value (Object : Data; Name : Web.Environment.Variable) return String is
   begin -- Value
      return Value (Object => Object, Name => Web.Environment.Variable'Image (Name) );
   end Value;

   function Value (Object : Data; Name : String) return String is
   begin -- Value
      if Object.Table.Exists (Name => Name) then
         return Object.Table.Get (Name => Name);
      else
         return "";
      end if;
   end Value;

   procedure Iterate_Process (Object : in Data; Process : Web.Environment.Callback) is
      procedure Iterate is new Environment.Iterate (Process => Process.all);
   begin -- Iterate_Process
      Iterate (Object => Object);
   end Iterate_Process;

   procedure Iterate (Object : in Data) is
      procedure Iteration_Wrapper (Name : in String; Values : in Strings.String_Array; Continue : in out Boolean) is
         use Solid.Strings;
      begin -- Iteration_Wrapper
         Process (Name => Name, Value => +Values (1), Continue => Continue); -- Only the first value is needed.
      end Iteration_Wrapper;

      procedure Iterate_All is new Containers.Tables.Iterate (Process => Iteration_Wrapper);
   begin -- Iterate
      Iterate_All (Container => Object.Table);
   end Iterate;
end Solid.Web.SCGI.Environment;
