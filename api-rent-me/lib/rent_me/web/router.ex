defmodule RentMe.Web.Router do
  use RentMe.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RentMe.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    
  end

  # Other scopes may use custom stacks.
  scope "/api", RentMe do
    pipe_through :api
   
    post "/user/new", Web.UserController, :new
    post "/user/login", Web.UserController, :login 
    post "/user/key", Web.UserController, :key
    #auth required
    post "/user/key_test", Web.UserController, :api_key_test
    post "/user/bio", Web.UserController, :bio

    post "/rental/add", Web.RentalController, :add
    
    get "/base/locations", Web.BaseController, :all_locations
    post "/base/search", Web.BaseController, :search_items
    post "/base/get_item", Web.BaseController, :get_item_details
  end
end
