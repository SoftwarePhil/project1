defmodule RentMe.Web.UserView do
  use RentMe.Web, :view
  alias RentMe.Users.User, as: User

  def render("user_private.json", user = %User{}) do
      %{
          email: user.email, 
          name: user.name,
          city: user.city,  
          picture: user.picture,
          bio: user.bio,
          rating: user.rating,
          created: user.created,
          items: user.items,
          active_rentals: user.active_rentals,
          api_key: user.api_key
       }
  end

    def render("user_api_key.json", user = %User{}) do
      %{
          email: user.email, 
          api_key: user.api_key
       }
  end
end