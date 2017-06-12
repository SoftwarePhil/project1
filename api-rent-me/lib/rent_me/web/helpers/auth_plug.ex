defmodule RentMe.Helpers.AuthPlug do
    import Plug.Conn
    alias RentMe.Users.User, as: User

    def valid_api_key?(conn, _) do
        with [info] <- get_req_header(conn, "authorization"),
             {:ok, email, key} <- parse_info(info),
             {:ok, _} <- User.validate(email, key) do
                 assign(conn, :user, email)
        else
            _ ->
                conn
                |> put_status(:unauthorized)
                |> Phoenix.Controller.json(%{error: "Invalid authentication token"})
        end 
    end

    defp parse_info(str) do
        [email, token] = String.split(str, "-")
        {:ok, email, token}
    end
end