defmodule RentMe.Web.BaseController do
  use RentMe.Web, :controller
  alias RentMe.Couch.Base, as: Base
  alias RentMe.Locations.Server, as: Server

  def all_locations(conn, _params) do
    list = Base.all_locations()
    |>Enum.map(fn({location, _db}) -> location end)
    
    json conn, list
  end

  def search_items(conn, %{"city"=> city, "search"=> term}) do
    {:ok, res} = Server.search_items(city, term)

    json conn, res
  end

  def get_item_details(conn, %{"city"=> city, "id"=> item}) do
    {:ok, res} = Server.get_item(city, item)

    json conn, res
  end
end