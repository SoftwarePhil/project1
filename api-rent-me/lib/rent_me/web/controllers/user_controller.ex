defmodule RentMe.Web.UserController do
  use RentMe.Web, :controller
  alias RentMe.Users.User, as: User
  plug :valid_api_key? when action in [:api_key_test, :bio]

  #figure out how to use ECTO? might be worth it
  def new(conn,
  %{"email"=> email, "password"=>password, "name"=>name, "city"=>city}) do
        case User.new_user(email, password, name, city) do
            {:ok, user} ->
                conn
                |>render("user_private.json", user)
            {:error, msg} ->
                conn
                |>put_status(:not_found)
                |>json(%{error: msg}) 
        end
  end

  def new(conn, _) do
     conn
     |>put_status(:not_found)
     |>json(%{error: "missing field from request"}) 
  end

  def login(conn, %{"email"=> email, "password"=>password}) do
    case User.login(email, password) do
        {:ok, user} ->
            conn
            |>render("user_private.json", user)
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
            |>render("user_api_key.json", user)
        {:error, msg} ->
            conn
            |>put_status(:not_found)
            |>json(%{error: msg})
    end
  end

  def api_key_test(conn, %{"test"=>msg}) do
    case _email(conn) do
        nil -> 
            conn
        email ->
            conn
            |>json(%{msg=>email})
    end
  end

  def bio(conn, %{"bio"=>bio}) do
      with email when is_bitstring(email) <- _email(conn),
           {:ok, _msg} <- User.bio(email, bio) do
               conn
               |>json(%{bio: bio})
           else
               _ -> conn
           end
  end

  defp _email(conn) do
      conn.assigns[:user]
  end
end

