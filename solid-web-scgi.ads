-- SCGI support.
-- Initial reference code written by Luke A. Guest (_Lucretia_) in early 2010.
-- Adapted for use with Solid.Web in June 2010.

with Solid.Web.Concurrency;

package Solid.Web.SCGI is
   Not_Bound : exception;

   task type Server (Port      : Network_Port;
                     IO_Tasks  : Concurrency.Task_Count;
                     Requests  : Concurrency.Request_Queue_Handle;
                     Responses : Concurrency.Response_Queue_Handle)
   is
      entry Bind;
      -- Binds the server to Port.
      -- Raises Not_Bound if the server fails to bind to Port.

      entry Start;
      -- Begin accepting requests.
      -- The server must be bound before it can be started.

      entry Stop;
      --Stop accepting requests.
   end Server;
end Solid.Web.SCGI;
