defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Users
  alias TimeManager.Users.User
  alias Ecto.Changeset
  alias Plug.Conn
  alias TimeManager.Auth.UserRegistration
  alias Powjwt.Auth.UserPassLogin

  action_fallback TimeManagerWeb.FallbackController

  plug(TimeManagerWeb.Plugs.CheckPermissions,
    actions: [
      user_informations: {"account", "read"},
      index: {"users", "read"},
      show: {"users", "read"},
      delete: {"users", "delete"}
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

  swagger_path(:create) do
    summary("Create user")
    description("Creates a new user")
    parameter(:user, :body, Schema.ref(:UserRequest), "The user details")

    response(201, "User created OK", Schema.ref(:UserResponse))
    response(422, "Unprocessable entity", Schema.ref(:UnprocessableEntityResponse))
  end
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
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

  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(TimeManagerWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(TimeManagerWeb.Gettext, "errors", msg, opts)
    end
  end


  @spec register(Conn.t(), UserRegistration.t()) :: Conn.t()
  def register(conn, user_registration_command) do
    with {:ok, _user, conn} <- conn |> Pow.Plug.create_user(user_registration_command) do
      json(conn, %{token: conn.private[:api_access_token]})
    else
      {:error, changeset, conn} ->
        errors = Changeset.traverse_errors(changeset, &translate_error/1)
        conn
        |> put_status(500)
        |> json(%{error: %{status: 500, message: "Couldn't create user", errors: errors}})
    end
  end

  @spec login(Conn.t(), UserPassLogin.t()) :: Conn.t()
  def login(conn, user_pass_login) do
    with {:ok, conn} <- conn |> Pow.Plug.authenticate_user(user_pass_login) do
      json(conn, %{token: conn.private[:api_access_token]})
    else
      {:error, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid email or password"}})
    end
  end

  def user_informations(conn, _params) do
    json(conn, %{
      user_id: conn.private[:user_id],
      role: TimeManagerWeb.Plugs.CheckPermissions.get_user(conn).role.name
      })
    conn
  end
end
