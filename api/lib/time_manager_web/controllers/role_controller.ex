defmodule TimeManagerWeb.RoleController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Roles
  alias TimeManagerWeb.SwaggerDefinitions

  action_fallback TimeManagerWeb.FallbackController

  plug(TimeManagerWeb.Plugs.CheckPermissions,
    actions: [
      index: %{"role" => ["read"]},
      show: %{"role" => ["read"]}
    ]
  )

  def swagger_definitions do
    TimeManagerWeb.SwaggerDefinitions.role_definitions()
  end

  swagger_path(:index) do
    summary("List Roles")
    description("List all roles in the database.\nScopes: role.read")

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:RolesResponse))
  end
  def index(conn, _params) do
    roles = Roles.list_roles
    render(conn, :index, roles: roles)
  end

  swagger_path(:show) do
    summary("Show role")
    description("Show a role by ID.\nScopes: role.read")
    parameter(:id, :path, :integer, "Role ID", required: true, example: 123)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:RoleResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def show(conn, %{"id" => id}) do
    role = Roles.get_role!(id)
    render(conn, :show, role: role)
  end

end
