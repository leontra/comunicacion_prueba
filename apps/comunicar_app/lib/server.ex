defmodule ComunicarApp.Server do
  use GenServer

  @name MiServidor

  ### Public API
  def start_link do
    GenServer.start_link(__MODULE__, {:x, 0, :y, 0}, name: @name)
  end

  def get_ultimo_msg() do
    GenServer.call(@name, :get_msg)
  end

  def mandar_objeto(objeto, scope) do     
    #push socket, "shout", %{"hello" => "all"}
    #Web.RoomChannel.broadcast_change( objeto )
    scope.broadcast_change( objeto )
    GenServer.cast(@name, {:mandar_objeto, objeto})
  end

  ### Server API
  def init(_) do
    {:ok, 0}
  end

  def handle_call(:get_msg, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:mandar_objeto, objeto}, state) do
    {:noreply, objeto}
  end

end