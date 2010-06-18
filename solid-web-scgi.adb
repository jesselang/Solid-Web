
with GNAT.Sockets;

package body Solid.Web.SCGI is
   task body Server is
   begin -- Server
      select
         accept Bind;
      or
         accept Start;

         -- Check CONTENT_LENGTH.  Must be present, even if "0".
         -- Check SCGI.  Should be "1".
      or
         accept Stop;
      end select;
   end Server;
end Solid.Web.SCGI;
