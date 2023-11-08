defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.WorkingTimes
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManagerWeb.Plugs.CheckPermissions
  alias TimeManagerWeb.SwaggerDefinitions

  action_fallback TimeManagerWeb.FallbackController

  plug(TimeManagerWeb.Plugs.CheckPermissions,
    actions: [
      show_user_time: %{"user" => ["read"]},
      show_user_times: %{"user" => ["read"]},

      create_user_time: %{"working_time" => ["create"]},
      index: %{"working_time" => ["read"]},
      update: %{"working_time" => ["update"]},
      delete: %{"working_time" => ["delete"]}
    ]
  )

  def swagger_definitions do
    TimeManagerWeb.SwaggerDefinitions.working_times_definitions()
  end

  swagger_path(:index) do
    summary("List Working times")
    description("List all working times in the database.\nScopes: working_time.read")

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:WorkingTimesResponse))
  end
  def index(conn, _params) do
    working_times = WorkingTimes.list_working_times()
    render(conn, :index, working_times: working_times)
  end

  swagger_path(:show_user_times) do
    summary("List user working times")
    description("List working times of a given user. Alias for /api/users/{userID}/workingTimes.\nScopes: user.read")

    parameter(:userID, :path, :integer, "User ID", required: true, example: 123)
    parameter(:start, :query, :string, "Period start (default to no limit)", required: false, example: "2023-02-04 11:24:45", format: :utc_datetime)
    parameter(:end, :query, :string, "Period end (default to no limit)", required: false, example: "2023-02-14 16:28:42", format: :utc_datetime)


    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:WorkingTimesResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def show_user_times(conn, params) do
    working_times = WorkingTimes.get_user_working_times!(params)
    CheckPermissions.assert_user_permissions(conn, Map.get(params, "userID"))

    render(conn, :index, working_times: working_times)
  end

  swagger_path(:show_user_time) do
    summary("Show user working time")
    description("Show a specific user working time entry.\nScopes: user.read")

    parameter(:userID, :path, :integer, "User ID", required: true, example: 123)
    parameter(:id, :path, :integer, "Working time ID", required: true, example: 123)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:WorkingTimeResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def show_user_time(conn, %{"userID" => userID, "id" => id}) do
    working_time = WorkingTimes.get_user_working_time!(userID, id)
    CheckPermissions.assert_user_permissions(conn, userID)

    render(conn, :show, working_time: working_time)
  end

  swagger_path(:create_user_time) do
    summary("Create user working time")
    description("Create a user working time entry.\nScopes: working_time.create")

    parameter(:userID, :path, :integer, "User ID", required: true, example: 123)
    parameter(:working_time, :body, Schema.ref(:UserWorkingTimeRequest), "Working time object", required: true)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(201, "OK", Schema.ref(:WorkingTimeResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def create_user_time(conn, %{"userID" => userID, "working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.create_working_time(Map.put(working_time_params, "user_id", userID)) do
      conn
      |> put_status(:created)
      |> render(:show, working_time: working_time)
    end
  end

  swagger_path(:update) do
    summary("Update working time")
    description("Update a working time entry.\nScopes: working_time.update")

    parameter(:id, :path, :integer, "Working time ID", required: true, example: 123)
    parameter(:working_time, :body, Schema.ref(:WorkingTimeRequest), "Working time object", required: true)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:WorkingTimeResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  swagger_path(:delete) do
    summary("Delete Working time")
    description("Delete a working time by ID.\nScopes: working_time.delete")
    parameter(:id, :path, :integer, "Working time ID", required: true, example: 3)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(204, "No Content - Deleted Successfully")
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkingTimes.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
