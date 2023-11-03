defmodule TimeManagerWeb.RoleController do
  use TimeManagerWeb, :controller

  alias TimeManager.Roles

  action_fallback TimeManagerWeb.FallbackController

  plug(TimeManagerWeb.Plugs.CheckPermissions,
    actions: [
      index: %{"role" => ["read"]},
      show: %{"role" => ["read"]}
    ]
  )
  def index(conn, _params) do
    roles = Roles.list_roles
    render(conn, :index, roles: roles)
  end

  def show(conn, %{"id" => id}) do
    role = Roles.get_role!(id)
    render(conn, :show, role: role)
  end

end
