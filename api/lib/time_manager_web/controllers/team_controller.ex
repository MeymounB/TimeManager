defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller
  use PhoenixSwagger

  alias TimeManager.Teams
  alias TimeManager.Teams.Team
  alias TimeManagerWeb.Plugs.CheckPermissions
  alias TimeManagerWeb.SwaggerDefinitions

  action_fallback TimeManagerWeb.FallbackController

  plug(CheckPermissions,
  actions: [
    clock: %{"team" => ["clock"]},
    working_times: %{"team" => ["read"]},
    add_employee: %{"team" => ["update"]},
    remove_employee: %{"team" => ["update"]},
    add_manager: %{"team" => ["update"]},
    remove_manager: %{"team" => ["update"]},
    index: %{"team" => ["read"]},
    show: %{"team" => ["read"]},
    create: %{"team" => ["create"]},
    update: %{"team" => ["update"]},
    delete: %{"team" => ["delete"]}
  ]
)

  def swagger_definitions do
    SwaggerDefinitions.team_definitions()
  end

  swagger_path(:clock) do
    summary("Clock team users")
    description("Clock all team users.\nScopes: team.clock")

    parameter(:teamID, :path, :integer, "Team ID", required: true, example: 123)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:TeamClockResponse))
  end
  def clock(conn, %{"teamID" => id}) do
    team = TimeManager.Repo.preload(Teams.get_team!(id), :employees)
    CheckPermissions.assert_team_permissions(conn, id)

    conn
    |> json(%{data:
      team.employees
      |> Enum.map(fn employee ->
        with {:ok, %TimeManager.Clocks.Clock{} = clock} <- TimeManager.Clocks.clock_user(employee) do
          TimeManagerWeb.ModelJSON.data(clock)
        end
      end)
    })
  end

  swagger_path(:working_times) do
    summary("List users working times")
    description("List all team users working times over a specified period.\nScopes: team.read")

    parameter(:teamID, :path, :integer, "Team ID", required: true, example: 123)
    parameter(:start, :query, :string, "Period start (default to no limit)", required: false, example: "2023-02-04 11:24:45", format: :utc_datetime)
    parameter(:end, :query, :string, "Period end (default to no limit)", required: false, example: "2023-02-14 16:28:42", format: :utc_datetime)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:WorkingTimesResponse))
  end
  def working_times(conn, params) do
    id = Map.get(params, "teamID")
    team = TimeManager.Repo.preload(Teams.get_team!(id), :employees)
    CheckPermissions.assert_team_permissions(conn, id)

    conn
    |> json(%{data:
      team.employees
      |> Enum.map(fn employee ->
          params
          |> Map.put("userID", "#{employee.id}")
          |> TimeManager.WorkingTimes.get_user_working_times!()
          |> TimeManagerWeb.ModelJSON.data()
        end)
      |> List.flatten()
    })
  end

  swagger_path(:add_employee) do
    summary("Add employee")
    description("Add a new user as a team employee.\nScopes: team.update")

    parameter(:teamID, :path, :integer, "Team ID", required: true, example: 123)
    parameter(:employeeID, :path, :integer, "Employee ID (User ID)", required: true, example: 123)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:TeamResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def add_employee(conn, %{"teamID" => team_id, "employeeID" => employee_id}) do
    team = Teams.get_team!(team_id)
    CheckPermissions.assert_team_permissions(conn, team_id)

    Teams.add_employee(team.id, employee_id)
    render(conn, :show, team: team)
  end

  swagger_path(:remove_employee) do
    summary("Remove employee")
    description("Remove a team employee.\nScopes: team.update")

    parameter(:teamID, :path, :integer, "Team ID", required: true, example: 123)
    parameter(:employeeID, :path, :integer, "Employee ID (User ID)", required: true, example: 123)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:TeamResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def remove_employee(conn, %{"teamID" => team_id, "employeeID" => employee_id}) do
    team = Teams.get_team!(team_id)
    CheckPermissions.assert_team_permissions(conn, team_id)

    Teams.remove_employee(team.id, employee_id)
    render(conn, :show, team: team)
  end

  swagger_path(:add_manager) do
    summary("Add manager")
    description("Add a new user as a team manager.\nScopes: team.update")

    parameter(:teamID, :path, :integer, "Team ID", required: true, example: 123)
    parameter(:managerID, :path, :integer, "Manager ID (User ID)", required: true, example: 123)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:TeamResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def add_manager(conn, %{"teamID" => team_id, "managerID" => manager_id}) do
    team = Teams.get_team!(team_id)
    Teams.add_manager(team.id, manager_id)
    render(conn, :show, team: team)
  end

  swagger_path(:remove_manager) do
    summary("Remove manager")
    description("remove_manager a team manager.\nScopes: team.update")

    parameter(:teamID, :path, :integer, "Team ID", required: true, example: 123)
    parameter(:managerID, :path, :integer, "Manager ID (User ID)", required: true, example: 123)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:TeamResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def remove_manager(conn, %{"teamID" => team_id, "managerID" => manager_id}) do
    team = Teams.get_team!(team_id)
    CheckPermissions.assert_team_permissions(conn, team_id)

    Teams.remove_manager(team.id, manager_id)
    render(conn, :show, team: team)
  end

  swagger_path(:index) do
    summary("List teams")
    description("List all teams in the database.\nScopes: team.read")

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:TeamsResponse))
  end
  def index(conn, _params) do
    teams = Teams.list_teams()
    render(conn, :index, teams: teams)
  end

  swagger_path(:create) do
    summary("Create team")
    description("Create a team. Add the current user as a manager of the team.
    Scopes: team.create")

    parameter(:team, :body, Schema.ref(:TeamRequest), "Team object", required: true)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(201, "OK", Schema.ref(:TeamResponse))
  end
  def create(conn, %{"team" => team_params}) do
    CheckPermissions.assert_manager(conn)

    with {:ok, %Team{} = team} <- Teams.create_team(team_params) do
      Teams.add_manager(team.id, TimeManagerWeb.Plugs.CheckPermissions.get_user_id(conn))
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team.id}")
      |> render(:show, team: team)
    end
  end

  swagger_path(:show) do
    summary("Show team")
    description("Show a team by ID.\nScopes: team.read")
    parameter(:id, :path, :integer, "Team ID", required: true, example: 123)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:TeamResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def show(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    render(conn, :show, team: team)
  end

  swagger_path(:update) do
    summary("Update team")
    description("Update a team entry.\nScopes: team.update")

    parameter(:id, :path, :integer, "Team ID", required: true, example: 123)
    parameter(:team, :body, Schema.ref(:TeamRequest), "Team object", required: true)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(200, "OK", Schema.ref(:TeamResponse))
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)
    CheckPermissions.assert_team_permissions(conn, id)

    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  swagger_path(:delete) do
    summary("Delete team")
    description("Delete a team by ID.\nScopes: team.delete")
    parameter(:id, :path, :integer, "Team ID", required: true, example: 3)

    SwaggerDefinitions.protected_path
    SwaggerDefinitions.json_path

    response(204, "No Content - Deleted Successfully")
    response(404, "Not found", Schema.ref(:NotFoundResponse))
  end
  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    CheckPermissions.assert_team_permissions(conn, id)

    with {:ok, %Team{}} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
