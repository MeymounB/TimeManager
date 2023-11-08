defmodule TimeManagerWeb.Plugs.CheckPermissions do
  import Plug.Conn
  import Phoenix.Controller, only: [action_name: 1]
  import Ecto.Query, warn: false

  alias TimeManager.Roles.Permissions
  alias TimeManager.Users.User
  alias TimeManager.Repo

  def init(opts), do: opts

  def call(conn, opts) do
    user = get_user(conn)
    required_permission = get_required_permission(conn, opts)

    if required_permission == :error or (user != nil and Permissions.user_has_permission?(user, required_permission)) do
      conn
    else
      forbidden(conn)
    end
  end

  def forbidden(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(403, Jason.encode!(%{error: %{message: "The user has insufficient permissions"}}))
    |> halt()
  end

  defp get_required_permission(conn, opts) do
    action = action_name(conn)

    case opts
          |> Keyword.fetch!(:actions)
          |> Keyword.fetch(action) do
      :error -> :error
      {:ok, acts} -> acts
    end
  end

  def get_user(conn) do
    case get_user_id(conn) do
      nil -> nil
      user_id -> TimeManager.Users.get_user!(user_id)
                |> Repo.preload(:role)
    end
  end

  def get_user!(conn) do
    TimeManager.Users.get_user!(get_user_id(conn))
    |> Repo.preload(:role)
  end

  def get_user_id(conn), do: conn.private[:user_id]

  def is_admin(%User{} = user), do: user.role.name == "Admin"
  def is_general_manager(%User{} = user, or_higher \\ true), do: user.role.name == "General Manager" or (or_higher and is_admin(user))
  def is_manager(%User{} = user, or_higher \\ true), do: user.role.name == "Manager" or (or_higher and is_general_manager(user, true))
  def is_empoyee(%User{} = user, or_higher \\ true), do: user.role.name == "Employee" or (or_higher and is_manager(user, true))

  def has_team_permissions(user, team_id), do: is_general_manager(user) or TimeManager.Teams.has_manager(team_id, user.id)
  def has_team_read_permissions(user, team_id) do
    has_team_permissions(user, team_id) or TimeManager.Teams.has_employee(team_id, user.id)
  end
  def has_user_permissions(user, user_id) do
    (user.id == user_id or
    is_general_manager(user) or
    TimeManager.Repo.one(from t in TimeManager.Teams.Team,
        join: tm in TimeManager.Teams.TeamManagers,
        on: t.id == tm.team_id,
        join: te in TimeManager.Teams.TeamEmployees,
        on: t.id == te.team_id,
        where: tm.manager_id == ^user.id and te.employee_id == ^user_id,
        distinct: t) != nil)
    and
    # Cannot operate on admin user if we are not admin
    not (!is_admin(user) and is_admin(TimeManager.Repo.preload(TimeManager.Users.get(user_id), :role)))
  end

  def assert_permission(conn, has_perm) do
    if not has_perm, do: forbidden(conn)
  end

  def assert_manager(conn), do: assert_permission(conn, is_manager(get_user(conn)))
  def assert_team_permissions(conn, team_id), do: assert_permission(conn, has_team_permissions(get_user(conn), team_id))
  def assert_team_read_permissions(conn, team_id), do: assert_permission(conn, has_team_read_permissions(get_user(conn), team_id))
  def assert_user_permissions(conn, user_id), do: assert_permission(conn, has_user_permissions(get_user(conn), user_id))
end
