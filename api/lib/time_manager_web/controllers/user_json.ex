defmodule TimeManagerWeb.UserJSON do
  alias TimeManager.Users.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user, %{excluded: [:password_hash]}))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user, %{associations: true, excluded: [:password_hash], global: %{excluded: [:user_id]}})}
  end

  @spec data(%User{} | nil, %{}) :: %User{} | nil
  defp data(%User{} = user, options) do
    TimeManagerWeb.ModelJSON.data(user, options)
  end
end
