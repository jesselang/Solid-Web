

package body Solid.Web.Concurrency is
   use type Ada.Containers.Count_Type;

   protected body Request_Queue is
      procedure Put (Object : in Request.Data) is
      begin -- Put
         List.Append (New_Item => Object);
      end Put;

      entry Get (Object : out Request.Data) when List.Length > 0 is
         Position : Request_Lists.Cursor := List.First;
      begin -- Get
         Object := Request_Lists.Element (Position);
         List.Delete (Position => Position);
      end Get;
   end Request_Queue;

   protected body Response_Queue is
      procedure Put (Object : in Response.Data) is
      begin -- Put
         List.Append (New_Item => Object);
      end Put;

      entry Get (Object : out Response.Data) when List.Length > 0 is
         Position : Response_Lists.Cursor := List.First;
      begin -- Get
         Object := Response_Lists.Element (Position);
         List.Delete (Position => Position);
      end Get;
   end Response_Queue;
end Solid.Web.Concurrency;
