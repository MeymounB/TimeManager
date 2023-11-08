defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Users
  alias TimeManager.Users.User
  alias TimeManagerWeb.Plugs.CheckPermissions
  alias TimeManagerWeb.SwaggerDefinitions

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
    SwaggerDefinitions.user_definitions()
  end

  swagger_path(:index) do
    summary("List Users")
    description("List all users in the database.\nScopes: user.read")

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:UsersResponse))
  end
  def index(conn, params) do
    users = Users.list_users(params)
    render(conn, :index, users: users)
  end

  swagger_path(:show) do
    summary("Show User")
    description("Show a user by ID.\nScopes: user.read")
    parameter(:id, :path, :integer, "User ID", required: true, example: 123)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:UserResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  swagger_path(:update) do
    summary("Update user")
    description("Update attributes of a user.\nScopes: user.update")

    parameters do
      # Path
      id(:path, :integer, "User ID", required: true, example: 3)
      # Body
      user(:body, Schema.ref(:UserRequest), "The user details (can be partial)")
    end

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

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
    description("Delete a user by ID.\nScopes: user.delete")
    parameter(:id, :path, :integer, "User ID", required: true, example: 3)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(204, "No Content - Deleted Successfully")
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    CheckPermissions.assert_user_permissions(conn, id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  swagger_path(:set_role) do
    summary("Modify user role")
    description("Modify a user role.\nScopes: user.role")
    parameter(:userID, :path, :integer, "User ID", required: true, example: 3)
    parameter(:roleID, :path, :integer, "Role ID", required: true, example: 3)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(204, "No Content - Deleted Successfully")
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def set_role(conn, %{"userID" => user_id, "roleID" => role_id}) do
    self = CheckPermissions.get_user(conn)
    user = TimeManager.Repo.preload(Users.get_user!(user_id), :role)
    role = TimeManager.Roles.get_role!(role_id)
    CheckPermissions.assert_user_permissions(conn, user_id)

    # If we are not admin (and might have forbidden actions)
    if self.role.name != "Admin" and role.name == "Admin" do
      CheckPermissions.forbidden(conn)
    end

    with {:ok, %User{} = user} <- Users.update_user(user, %{"user" => %{"role_id" => role.id}}) do
      render(conn, :show, user: user)
    end
  end

  swagger_path(:clock) do
    summary("Clock user")
    description("Clock a user.\nScopes: user.clock")
    parameter(:userID, :path, :integer, "User ID", required: true, example: 3)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:ClockResponse))
    response(201, "Clock created", Schema.ref(:ClockResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
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

  swagger_path(:working_times) do
    summary("User working times")
    description("Fetch a user working times over a given period.\nScopes: user.read")
    parameter(:userID, :path, :integer, "User ID", required: true, example: 3)
    parameter(:start, :query, :string, "Period start (default to no limit)", required: false, example: "2023-02-04 11:24:45", format: :utc_datetime)
    parameter(:end, :query, :string, "Period end (default to no limit)", required: false, example: "2023-02-14 16:28:42", format: :utc_datetime)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:WorkingTimesResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def working_times(conn, params) do
    working_times = TimeManager.WorkingTimes.get_user_working_times!(params)
    CheckPermissions.assert_user_permissions(conn, Map.get(params, "userID"))

    conn
    |> put_view(json: TimeManagerWeb.WorkingTimeJSON)
    |> render(:index, working_times: working_times)
  end

end
