-- ADT for HTTP headers.
with Solid.Web.Containers.Tables;

package Solid.Web.Headers is
   type List is new Containers.Tables.Table with null record;
   -- See Solid.Web.Containers.Tables for inherited operations.

   No_Headers : constant List;

   Content_Type : constant String := "Content-type";

   function Read (Stream : Stream_Handle) return List;
   -- Returns a list of headers read from Stream.

   procedure Write (Headers : in List; Stream : in Stream_Handle);
   -- Writes Headers to Stream.
private -- Solid.Web.Headers
   No_Headers : constant List := (Containers.Tables.Empty with null record);
end Solid.Web.Headers;
