defmodule TimeManagerWeb.RoleJSON do
  alias TimeManager.Roles.Role

  @doc """
  Renders a list of roles.
  """
  def index(%{roles: roles}) do
    %{data: for(role <- roles, do: data(role))}
  end

  @doc """
  Renders a single role.
  """
  def show(%{role: role}) do
    %{data: data(role, %{associations: true})}
  end

  @spec data(%Role{} | nil, %{}) :: %Role{} | nil
  defp data(%Role{} = role, options \\ %{}) do
    TimeManagerWeb.ModelJSON.data(role, options)
  end
end
