defmodule TimeManagerWeb.AccountController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Users
  alias TimeManager.Users.User
  alias Ecto.Changeset
  alias Plug.Conn
  alias TimeManager.Auth.UserRegistration
  alias Powjwt.Auth.UserPassLogin
  alias TimeManagerWeb.Plugs.CheckPermissions
  alias TimeManagerWeb.SwaggerDefinitions

  action_fallback TimeManagerWeb.FallbackController

  plug(CheckPermissions,
    actions: [
      clock: %{"account" =>  ["clock"]},
      working_times: %{"account" => ["read"]},
      show: %{"account" =>  ["read"]},
      update: %{"account" =>  ["update"]},
      delete: %{"account" =>  ["delete"]},
    ]
  )

  def swagger_definitions do
    SwaggerDefinitions.account_definitions()
  end

  defp translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(TimeManagerWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(TimeManagerWeb.Gettext, "errors", msg, opts)
    end
  end

  swagger_path(:register) do
    summary("Create a new account")
    description("Create a new user account")
    parameter(:user, :body, Schema.ref(:RegisterRequest), "The user details", required: true)

    SwaggerDefinitions.json_path

    response(201, "Created Successfully", Schema.ref(:AuthSuccessResponse))
    response(422, "Unprocessable entity", Schema.ref(:RegisterFailureResponse))
  end
  @spec register(Conn.t(), UserRegistration.t()) :: Conn.t()
  def register(conn, user_registration_command) do
    with {:ok, _user, conn} <- conn |> Pow.Plug.create_user(user_registration_command) do
      conn
      |> put_status(:created)
      |> json(%{
        access_token: conn.private[:api_access_token],
        refresh_token: conn.private[:api_refresh_token]
      })
    else
      {:error, changeset, conn} ->
        errors = Changeset.traverse_errors(changeset, &translate_error/1)
        conn
        |> put_status(422)
        |> json(%{error: %{message: "Couldn't create user", errors: errors}})
    end
  end

  swagger_path(:login) do
    summary("Authentify the user")
    description("Sign in the user")
    parameter(:user, :body, Schema.ref(:LoginRequest), "The user credentials", required: true)

    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:AuthSuccessResponse))
    response(401, "Unauthorized", Schema.ref(:UnauthorizedResponse))
  end
  @spec login(Conn.t(), UserPassLogin.t()) :: Conn.t()
  def login(conn, user_pass_login) do
    with {:ok, conn} <- conn |> Pow.Plug.authenticate_user(user_pass_login) do
      json(conn, %{
        access_token: conn.private[:api_access_token],
        refresh_token: conn.private[:api_refresh_token]
      })
    else
      {:error, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: %{message: "Invalid email or password"}})
    end
  end

  swagger_path(:refresh) do
    summary("Renew access token")
    description("Get a new access token from the refresh token")
    parameter(:refresh_token, :body, %Schema{type: :object} |> Schema.property(:refresh_token, :string, nil, [{:example, "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJKb2tlbiIsImV4cCI6MTcwMjA2OTEzMCwiaWF0IjoxNjk5MzkwNzMwLCJpc3MiOiJKb2tlbiIsImp0aSI6IjJ1YW41bmM2ZzZvbmsxZnQ0YzAwMDFuMSIsIm5iZiI6MTY5OTM5MDczMCwidXNlcl9pZCI6NH0.ZQwBjo02loJkND_GbbR-slmh0V1ufkU1zoDB36A5frA"}]), "The refresh token")

    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:RefreshSuccessResponse))
    response(401, "Unauthorized", Schema.ref(:UnauthorizedResponse))
  end
  def refresh(conn, %{"refresh_token" => refresh_token}) do
    with {:ok, conn, response} <- TimeManager.Auth.AuthFlow.refresh(conn, refresh_token) do
      json(conn, response)
    else
      {:error, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: "Invalid refresh token"})
    end
  end

  swagger_path(:logout) do
    summary("Logout user")
    description("Logout the user. This invalidate the refresh token.")

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(204, "No Content - Logout Successfully")
  end
  def logout(conn, _params) do
    user = CheckPermissions.get_user!(conn)
    Users.invalidate_user_refresh_token(user)

    send_resp(conn, :no_content, "")
  end

  swagger_path(:show) do
    summary("Show account")
    description("Show the authentified user informations.\nScopes: account.read")

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:UserResponse))
  end
  def show(conn, _params) do
    user = CheckPermissions.get_user!(conn)

    conn
    |> put_view(json: TimeManagerWeb.UserJSON)
    |> render(:show, user: user)
  end

  swagger_path(:clock) do
    summary("Clock user")
    description("Clock the authentified user.\nScopes: account.clock")

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:ClockResponse))
    response(201, "Clock created", Schema.ref(:ClockResponse))
  end
  def clock(conn, _params) do
    with {status, {:ok, %TimeManager.Clocks.Clock{} = clock}} <- TimeManager.Clocks.clock_user(CheckPermissions.get_user_id(conn)) do
      case status do
        :created -> put_status(conn, :created)
        _ -> put_status(conn, 200)
      end
      |> put_view(json: TimeManagerWeb.ClockJSON)
      |> render(:show, clock: clock)
    end
  end

  swagger_path(:working_times) do
    summary("Account working times")
    description("Fetch the authentified user working times over a given period.\nScopes: account.read")
    parameter(:start, :query, :string, "Period start (default to no limit)", required: false, example: "2023-02-04 11:24:45", format: :utc_datetime)
    parameter(:end, :query, :string, "Period end (default to no limit)", required: false, example: "2023-02-14 16:28:42", format: :utc_datetime)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:WorkingTimesResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def working_times(conn, params) do
    working_times = params
      |> Map.put("userID", CheckPermissions.get_user_id(conn))
      |> TimeManager.WorkingTimes.get_user_working_times!

    conn
    |> put_view(json: TimeManagerWeb.WorkingTimeJSON)
    |> render(:index, working_times: working_times)
  end

  swagger_path(:update) do
    summary("Update account")
    description("Update attributes of the authenticated user.\nScopes: account.update")
    parameter(:user, :body, Schema.ref(:UserRequest), "The user details (can be partial)")

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "Updated Successfully", Schema.ref(:UserResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
    response(422, "Unprocessable entity", Schema.ref(:UnprocessableEntityResponse))
  end
  def update(conn, %{"user" => user_params}) do
    user = CheckPermissions.get_user!(conn)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      conn
      |> put_view(json: TimeManagerWeb.UserJSON)
      |> render(:show, user: user)
    end
  end

  swagger_path(:delete) do
    summary("Delete account")
    description("Delete the account.\nScopes: account.delete")
    parameter(:id, :path, :integer, "User ID", required: true, example: 3)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(204, "No Content - Deleted Successfully")
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def delete(conn, _params) do
    user = CheckPermissions.get_user!(conn)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
