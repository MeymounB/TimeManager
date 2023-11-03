defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Users
  alias TimeManager.Users.User

  action_fallback TimeManagerWeb.FallbackController

  plug(TimeManagerWeb.Plugs.CheckPermissions,
    actions: [
      index: %{"user" => ["read"]},
      show: %{"user" => ["read"]},
      update: %{"user" => ["update"]},
      delete: %{"user" => ["delete"]}
    ]
  )

  def swagger_definitions do
    TimeManagerWeb.SwaggerDefinitions.user_definitions()
  end

  swagger_path(:index) do
    summary("List Users")
    description("List all users in the database")

    response(200, "OK", Schema.ref(:UsersResponse))
  end
  def index(conn, params) do
    users = Users.list_users(params)
    render(conn, :index, users: users)
  end

  swagger_path(:show) do
    summary("Show User")
    description("Show a user by ID")
    produces("application/json")
    consumes("application/json")
    parameter(:id, :path, :integer, "User ID", required: true, example: 123)

    response(200, "OK", Schema.ref(:UserResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  swagger_path(:update) do
    summary("Update user")
    description("Update attributes of a user")

    parameters do
      id(:path, :integer, "User ID", required: true, example: 3)

      user(:body, Schema.ref(:UserRequest), "The user details")
    end

    response(200, "Updated Successfully", Schema.ref(:UserResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
    response(422, "Unprocessable entity", Schema.ref(:UnprocessableEntityResponse))
  end
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  swagger_path(:delete) do
    summary("Delete User")
    description("Delete a user by ID")
    parameter(:id, :path, :integer, "User ID", required: true, example: 3)

    response(203, "No Content - Deleted Successfully")
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

end
