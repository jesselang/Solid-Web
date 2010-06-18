-- Common types used by applications using Solid.Web in a concurrent manor.

with Ada.Containers.Doubly_Linked_Lists;
with Solid.Web.Request;
with Solid.Web.Response;

package Solid.Web.Concurrency is
   type Task_Count is new Positive;

   package Request_Lists is new Ada.Containers.Doubly_Linked_Lists (Element_Type => Request.Data, "=" => Request."=");

   protected type Request_Queue is
      procedure Put (Object : in Request.Data);
      -- Puts Object into the queue.

      entry Get (Object : out Request.Data);
      -- Gets the next Object from the queue.
   private -- Request_Queue
      List : Request_Lists.List;
   end Request_Queue;

   type Request_Queue_Handle is access all Request_Queue;

   package Response_Lists is new Ada.Containers.Doubly_Linked_Lists (Element_Type => Response.Data, "=" => Response."=");

   protected type Response_Queue is
      procedure Put (Object : in Response.Data);
      -- Puts Object into the queue.

      entry Get (Object : out Response.Data);
      -- Gets the next Object from the queue.
   private -- Response_Queue
      List : Response_Lists.List;
   end Response_Queue;

   type Response_Queue_Handle is access all Response_Queue;
end Solid.Web.Concurrency;
