
with GNAT.Sockets;

package body Solid.Web.SCGI is
   task body Server is
      Service_Socket : GNAT.Sockets.Socket_Type;
   begin -- Server
      -- Create
      -- Set options

      accept Bind;
      -- Bind
      -- Listen

      Forever : loop
         accept Start;

         Handle_Requests : loop
            select
               accept Stop;

               exit Handle_Requests;
            else
               -- Use a selector to get a new socket with a request?

               -- Check CONTENT_LENGTH.  Must be present, even if "0".
               -- Check SCGI.  Should be "1".
               null;
            end select;
         end loop Handle_Requests;
      end loop Forever;
   end Server;
end Solid.Web.SCGI;
