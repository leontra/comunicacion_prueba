defmodule ComunicarApp.ServerTest do
  use ExUnit.Case
  alias ComunicarApp.Server

  test "starting the server" do
    assert {:ok, _pid} = Server.start_link()
  end

  test "getting the object" do
    assert {:ok, _pid} = Server.start_link()
    assert 0 = Server.get_ultimo_msg()
  end

  test "mandar mensaje y hacer broadcast" do
    Agent.start_link(fn -> [] end, name: :nombre_agen)

    assert {:ok, _pid} = Server.start_link()
    :ok = Server.mandar_objeto({:x, 121, :y, 121})    

    assert {:x, 121, :y, 121} = Server.get_ultimo_msg()    
  end  

end