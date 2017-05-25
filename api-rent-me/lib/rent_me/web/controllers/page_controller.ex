defmodule RentMe.Web.PageController do
  use RentMe.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
