defmodule RentMe.Web.UserController do
  use RentMe.Web, :controller
  alias RentMe.Users.User, as: User

  #figure out how to use ECTO? might be worth it
  def new(conn,
   %{"email"=> email, "password"=>password, "name"=>name, "location"=>location}) do
        case User.new_user(email, password, name, location) do
            {:ok, user} ->
                conn
                |>json(user)
            {:error, msg} ->
                conn
                |>put_status(:not_found)
                |>json(%{error: msg}) 
        end
  end

  def new(conn, _) do
     json(conn, %{error: "missing field from request"}) 
  end

  def login(conn, %{"email"=> email, "password"=>password}) do
    case User.login(email, password) do
        {:ok, user} ->
            conn
            |>json(user)
        {:error, msg} ->
            conn
            |>put_status(:not_found)
            |>json(%{error: msg})
    end
  end

  def key(conn, %{"email"=> email, "password"=>password}) do
    case User.login(email, password) do
        {:ok, user} ->
            conn
            |>json(%{api_key: user.api_key})
        {:error, msg} ->
            conn
            |>put_status(:not_found)
            |>json(%{error: msg})
    end
  end
end

"""
curl -X POST -H "Content-Type: application/json" -d '
{"email":"test@test.com", "password":"1"}
' "http://localhost:4000/api/user/login"

curl -X POST -H "Content-Type: application/json" -d '
{"email":"test@test.com", "password":"1"}
' "http://localhost:4000/api/user/key"

curl -X POST -H "Content-Type: application/json" -d '
{"email":"test@gmail.com", "password":"123456", "name":"Phil", 
"location":"Dallas, TX"}
' "http://localhost:4000/api/user/new"
"""

