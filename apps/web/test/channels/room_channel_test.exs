defmodule Web.RoomChannelTest do
  use Web.ChannelCase
  alias Web.RoomChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(RoomChannel, "room:lobby")

    {:ok, socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to room:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end

  test "mandar mensaje a la comunicacion", %{socket: socket} do
    push socket, "mensaje", %{"objeto" => %{"x" => 121}}
    ref = push socket, "msg_enviado", %{}
    assert_reply ref, :ok, %{ "objeto" => %{"x" => 121} }
  end

  test "mandar mensaje y recibirlo", %{socket: socket} do
    push socket, "mensaje", %{"objeto" => %{"x" => 121}}    
    assert_broadcast "shout", %{"x" => 121}
  end
end
