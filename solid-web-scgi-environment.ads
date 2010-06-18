-- Implementation of the SCGI environment.  Used in Solid.Web.SCGI to read environment variables.
private with Solid.Web.Containers.Tables;

with Solid.Web.Environment;

private package Solid.Web.SCGI.Environment is
   type Data is new Web.Environment.Data with private;

   Read_Error : exception;

   procedure Read (Object : out Data; Stream : in Stream_Handle);
   -- Read Stream into Object.
   -- Raises Read_Error if an error occurs.

   generic -- Iterate
      with procedure Process (Name : in String; Value : in String; Continue : in out Boolean);
   procedure Iterate (Object : in Data);
   -- Iterates over SCGI environment variables.
   -- Returns immediately when Continue is set to False.

   -- Implementations of abstract operations.
   overriding
   function Value (Object : Data; Name : String) return String;
   -- Get the SCGI environment variable with Name.
   -- Returns "" (null string) if not found.

   overriding
   procedure Iterate_Process (Object : in Data; Process : in Web.Environment.Callback);
private -- Solid.Web.SCGI.Environment
   type Data is new Web.Environment.Data with record
      Table : Containers.Tables.Table;
   end record;
end Solid.Web.SCGI.Environment;
