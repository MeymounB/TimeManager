defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller

  alias TimeManager.Teams
  alias TimeManager.Teams.Team
  alias TimeManagerWeb.Plugs.CheckPermissions

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

  def clock(conn, %{"teamID" => id}) do
    team = TimeManager.Repo.preload(Teams.get_team!(id), :employees)
    CheckPermissions.assert_team_permissions(conn, id)

    conn
    |> json(Enum.map(team.employees, fn employee ->
      with {:ok, %TimeManager.Clocks.Clock{} = clock} <- TimeManager.Clocks.clock_user(employee) do
        TimeManagerWeb.ClockJSON.show(%{clock: clock})
      end
    end))
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

  def add_employee(conn, %{"teamID" => team_id, "employee_id" => employee_id}) do
    team = Teams.get_team!(team_id)
    CheckPermissions.assert_team_permissions(conn, team_id)

    Teams.add_employee(team.id, employee_id)
    render(conn, :show, team: team)
  end

  def remove_employee(conn, %{"teamID" => team_id, "employee_id" => employee_id}) do
    team = Teams.get_team!(team_id)
    CheckPermissions.assert_team_permissions(conn, team_id)

    Teams.remove_employee(team.id, employee_id)
    render(conn, :show, team: team)
  end

  def add_manager(conn, %{"teamID" => team_id, "manager_id" => manager_id}) do
    team = Teams.get_team!(team_id)
    Teams.add_manager(team.id, manager_id)
    render(conn, :show, team: team)
  end

  def remove_manager(conn, %{"teamID" => team_id, "manager_id" => manager_id}) do
    team = Teams.get_team!(team_id)
    CheckPermissions.assert_team_permissions(conn, team_id)

    Teams.remove_manager(team.id, manager_id)
    render(conn, :show, team: team)
  end

  def index(conn, _params) do
    teams = Teams.list_teams()
    render(conn, :index, teams: teams)
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

  def show(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    CheckPermissions.assert_team_read_permissions(conn, id)

    render(conn, :show, team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)
    CheckPermissions.assert_team_permissions(conn, id)

    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    CheckPermissions.assert_team_permissions(conn, id)

    with {:ok, %Team{}} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
