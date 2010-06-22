-- Root package for the web framework portion of this library.
-- A high-level abstraction is offered, making web-based applications easier to develop using this framework.

with Ada.Streams;

package Solid.Web is
   type Network_Port is new Natural;
   Default_HTTP_Port : constant Network_Port;

   type Stream_Handle is access all Ada.Streams.Root_Stream_Type'Class;

   type Transaction_ID is mod 2 * 64; -- Used when handing concurrent requests, such as SCGI.
                                      -- I may change this to a time-based UUID once that is implemented.
   No_Transaction : constant Transaction_ID := 0;
private -- Solid.Web
   Default_HTTP_Port : constant Network_Port := 80;
end Solid.Web;
