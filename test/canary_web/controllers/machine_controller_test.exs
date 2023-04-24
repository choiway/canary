defmodule CanaryWeb.MachineControllerTest do
  use CanaryWeb.ConnCase

  import Canary.MachinesFixtures

  @create_attrs %{ip_address: "some ip_address", name: "some name", payload: %{}}
  @update_attrs %{ip_address: "some updated ip_address", name: "some updated name", payload: %{}}
  @invalid_attrs %{ip_address: nil, name: nil, payload: nil}

  describe "index" do
    test "lists all machines", %{conn: conn} do
      conn = get(conn, ~p"/machines")
      assert html_response(conn, 200) =~ "Listing Machines"
    end
  end

  describe "new machine" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/machines/new")
      assert html_response(conn, 200) =~ "New Machine"
    end
  end

  describe "create machine" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/machines", machine: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/machines/#{id}"

      conn = get(conn, ~p"/machines/#{id}")
      assert html_response(conn, 200) =~ "Machine #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/machines", machine: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Machine"
    end
  end

  describe "edit machine" do
    setup [:create_machine]

    test "renders form for editing chosen machine", %{conn: conn, machine: machine} do
      conn = get(conn, ~p"/machines/#{machine}/edit")
      assert html_response(conn, 200) =~ "Edit Machine"
    end
  end

  describe "update machine" do
    setup [:create_machine]

    test "redirects when data is valid", %{conn: conn, machine: machine} do
      conn = put(conn, ~p"/machines/#{machine}", machine: @update_attrs)
      assert redirected_to(conn) == ~p"/machines/#{machine}"

      conn = get(conn, ~p"/machines/#{machine}")
      assert html_response(conn, 200) =~ "some updated ip_address"
    end

    test "renders errors when data is invalid", %{conn: conn, machine: machine} do
      conn = put(conn, ~p"/machines/#{machine}", machine: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Machine"
    end
  end

  describe "delete machine" do
    setup [:create_machine]

    test "deletes chosen machine", %{conn: conn, machine: machine} do
      conn = delete(conn, ~p"/machines/#{machine}")
      assert redirected_to(conn) == ~p"/machines"

      assert_error_sent 404, fn ->
        get(conn, ~p"/machines/#{machine}")
      end
    end
  end

  defp create_machine(_) do
    machine = machine_fixture()
    %{machine: machine}
  end
end
