defmodule RentMe.Web.BaseController do
  use RentMe.Web, :controller
  alias RentMe.Couch.Base, as: Base

  def all_locations(conn, _params) do
    list = Base.all_locations()
    |>Enum.map(fn({location, _db}) -> location end)
    
    json conn, list
  end
end