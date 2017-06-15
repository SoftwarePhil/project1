defmodule RentMe.Web.RentalController do
  use RentMe.Web, :controller
  alias RentMe.Locations.Server, as: Server

  plug :valid_api_key? 
  defp _email(conn) do
      conn.assigns[:user]
  end

  def add(conn, %{"name"=>name, "location"=>location,
    "price"=>price, "tags"=>tags, "description"=>description,
    "picture"=>picture}) do
       
        case _email(conn) do
            nil ->
                conn
            email ->
                with {:ok, id} <- Server.add_item(name, email, location, price, tags, description, picture) do
                    conn
                    |>json(%{ok: id})
                else
                    _ -> conn
                end 
        end
  end
end