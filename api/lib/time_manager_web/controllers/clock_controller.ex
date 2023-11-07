defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Clocks
  alias TimeManager.Clocks.Clock
  alias TimeManagerWeb.Plugs.CheckPermissions
  alias TimeManagerWeb.SwaggerDefinitions

  action_fallback TimeManagerWeb.FallbackController

  plug(CheckPermissions,
    actions: [
      get_user_clock: %{"user" => ["read"]},
      clock_user: %{"user" => ["clock"]},
      index: %{"clock" => ["read"]},
      delete: %{"clock" => ["delete"]}
    ]
  )

  def swagger_definitions do
    SwaggerDefinitions.clocks_definitions()
  end

  swagger_path(:get_user_clock) do
    summary("Get user clock")
    description("Show a clock by its user ID.\nScopes: user.read")
    parameter(:userID, :path, :integer, "User ID", required: true, example: 123)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:ClockResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def get_user_clock(conn, %{"userID" => userID}) do
    clock = Clocks.get_user_clock(userID)
    CheckPermissions.assert_user_permissions(conn, userID)

    render(conn, :show, clock: clock)
  end

  swagger_path(:clock_user) do
    summary("Clock user")
    description("Clock in/out a user.

    If there is no clock for the given user, a new entry is created in the database with its status true.
    If already existing, the status is inverted.
    When a clock status pass from true to false, it creates a new working time entry.

    Scopes: user.clock")
    parameter(:userID, :path, :integer, "User ID", required: true, example: 3)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:ClockResponse))
    response(201, "Clock created", Schema.ref(:ClockResponse))
    response(422, "Unprocessable entity", Schema.ref(:UnprocessableEntityResponse))
  end
  def clock_user(conn, %{"userID" => userID}) do
    CheckPermissions.assert_user_permissions(conn, userID)

    with {status, {:ok, %Clock{} = clock}} <- Clocks.clock_user(userID) do
      case status do
        :created -> put_status(conn, :created)
        _ -> put_status(conn, 200)
      end
      |> render(:show, clock: clock)
    end
  end

  swagger_path(:index) do
    summary("List Clocks")
    description("List all clocks in the database.\nScopes: clock.read")

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:ClocksResponse))
  end
  def index(conn, _params) do
    clocks = Clocks.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  swagger_path(:delete) do
    summary("Delete clock")
    description("Delete a clock by ID.\nScopes: clock.delete")
    parameter(:id, :path, :integer, "Clock ID", required: true, example: 3)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(204, "No Content - Deleted Successfully")
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def delete(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{}} <- Clocks.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
