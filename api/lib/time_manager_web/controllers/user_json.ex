defmodule TimeManagerWeb.UserJSON do
  alias TimeManager.Users.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user, %{associations: true, excluded: [:managed_teams, :role, :working_times], global: %{excluded: [:user_id]}}))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user, %{associations: true, excluded: [:role_id], global: %{excluded: [:user_id]}})}
  end

  @spec data(%User{} | nil, %{}) :: %User{} | nil
  defp data(%User{} = user, options) do
    TimeManagerWeb.ModelJSON.data(user, options)
  end
end
