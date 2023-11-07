defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Users
  alias TimeManager.Users.User
  alias TimeManagerWeb.Plugs.CheckPermissions

  action_fallback TimeManagerWeb.FallbackController

  plug(TimeManagerWeb.Plugs.CheckPermissions,
    actions: [
      index: %{"user" => ["read"]},
      show: %{"user" => ["read"]},
      update: %{"user" => ["update"]},
      set_role: %{"user" => ["role"]},
      delete: %{"user" => ["delete"]},
      clock: %{"user" => ["clock"]},
      working_times: %{"user" => ["clock"]}
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
    CheckPermissions.assert_user_permissions(conn, id)

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
    CheckPermissions.assert_user_permissions(conn, id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def set_role(conn, %{"userID" => user_id, "roleID" => role_id}) do
    self = CheckPermissions.get_user(conn)
    user = TimeManager.Repo.preload(Users.get_user!(user_id), :role)
    role = TimeManager.Roles.get_role!(role_id)
    # If we are not admin (and might have forbidden actions)
    if self.role.name != "Admin" do
      # We cannot give the admin role or modify an admin user role
      if role.name == "Admin" or user.role.name == "Admin" do
        CheckPermissions.forbidden(conn)
      end
    end

    with {:ok, %User{} = user} <- Users.update_user(user, %{"user" => %{"role_id" => role.id}}) do
      render(conn, :show, user: user)
    end
  end

  def clock(conn, %{"userID" => userID}) do
    CheckPermissions.assert_user_permissions(conn, userID)

    with {status, {:ok, %TimeManager.Clocks.Clock{} = clock}} <- TimeManager.Clocks.clock_user(userID) do
      case status do
        :created -> put_status(conn, :created)
        _ -> put_status(conn, 200)
      end
      |> put_view(json: TimeManagerWeb.ClockJSON)
      |> render(:show, clock: clock)
    end
  end

  def working_times(conn, params) do
    working_times = TimeManager.WorkingTimes.get_user_working_times!(params)
    CheckPermissions.assert_user_permissions(conn, Map.get(params, "userID"))

    conn
    |> put_view(json: TimeManagerWeb.WorkingTimeJSON)
    |> render(:index, working_times: working_times)
  end

end
