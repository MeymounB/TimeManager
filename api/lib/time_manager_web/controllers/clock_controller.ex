defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Clocks
  alias TimeManager.Clocks.Clock
  alias TimeManagerWeb.Plugs.CheckPermissions

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
    TimeManagerWeb.SwaggerDefinitions.clocks_definitions()
  end

  swagger_path(:get_user_clock) do
    summary("Get user clock")
    description("Show a clock by its user ID")
    produces("application/json")
    consumes("application/json")
    parameter(:userID, :path, :integer, "User ID", required: true, example: 123)

    response(200, "OK", Schema.ref(:ClockResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def get_user_clock(conn, %{"userID" => userID}) do
    clock = Clocks.get_user_clock(userID)
    CheckPermissions.assert_user_permissions(conn, userID)

    render(conn, :show, clock: clock)
  end

  swagger_path(:clock_user) do
    summary("Clock a user")
    description("Clock in/out a user.

    If there is no clock for the given user, a new entry is created in the database with its status true.
    If already existing, the status is inverted.
    When a clock status pass from true to false, it creates a new working time entry.")
    parameter(:user, :body, Schema.ref(:UserRequest), "The user details")

    response(201, "User created OK", Schema.ref(:UserResponse))
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
    description("List all clocks in the database")

    response(200, "OK", Schema.ref(:ClocksResponse))
  end
  def index(conn, _params) do
    clocks = Clocks.list_clocks()
    render(conn, :index, clocks: clocks)

  end

  swagger_path(:delete) do
    summary("Delete clock")
    description("Delete a clock by ID")
    parameter(:id, :path, :integer, "Clock ID", required: true, example: 3)

    response(203, "No Content - Deleted Successfully")
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def delete(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{}} <- Clocks.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
