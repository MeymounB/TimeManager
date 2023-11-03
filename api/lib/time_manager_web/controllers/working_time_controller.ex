defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.WorkingTimes
  alias TimeManager.WorkingTimes.WorkingTime

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

  def index(conn, _params) do
    working_times = WorkingTimes.list_working_times()
    render(conn, :index, working_times: working_times)
  end

  def show_user_times(conn, params) do
    working_times = WorkingTimes.get_user_working_times!(params)
    render(conn, :index, working_times: working_times)
  end

  def show_user_time(conn, %{"userID" => userID, "id" => id}) do
    working_time = WorkingTimes.get_user_working_time!(userID, id)
    render(conn, :show, working_time: working_time)
  end

  def create_user_time(conn, %{"userID" => userID, "working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.create_working_time(Map.put(working_time_params, "user_id", userID)) do
      conn
      |> put_status(:created)
      |> render(:show, working_time: working_time)
    end
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkingTimes.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
