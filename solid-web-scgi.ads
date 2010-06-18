-- SCGI support.
-- Initial implementation written by Luke A. Guest (_Lucretia_) in early 2010.
-- Adapted for use with Solid.Web in April 2010.

with Solid.Web.Concurrency;

package Solid.Web.SCGI is
   task type Server (Port      : Network_Port;
                     IO_Tasks  : Concurrency.Task_Count;
                     Requests  : Concurrency.Request_Queue_Handle;
                     Responses : Concurrency.Response_Queue_Handle)
   is
      entry Bind;
      entry Start;
      entry Stop;
   end Server;
end Solid.Web.SCGI;
