defmodule Web.RoomChannel do
  use Web.Web, :channel
  alias ComunicarApp.Server

  def join("room:lobby", payload, socket) do
    if authorized?(payload) do      
      {:ok, socket}      
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("mensaje", payload, socket) do
    Server.start_link()    
    :ok = Server.mandar_objeto(payload["objeto"], Web.RoomChannel)    
    {:noreply, socket}
  end

  def handle_in("msg_enviado", _payload, socket) do
    objeto = Server.get_ultimo_msg()
    {:reply, {:ok, %{"objeto" => objeto}}, socket}
  end

  def handle_in("msg_recibido", payload, socket) do
    #push socket, "shout", %{"hello" => "all"}
    {:noreply, socket}
  end

  def handle_in("msg_nuevo", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end
 
  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def broadcast_change(objeto) do    
    Web.Endpoint.broadcast("room:lobby", "shout", objeto)
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
