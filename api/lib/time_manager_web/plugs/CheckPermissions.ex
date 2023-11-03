defmodule TimeManagerWeb.Plugs.CheckPermissions do
  import Plug.Conn
  import Phoenix.Controller, only: [action_name: 1]

  alias TimeManager.Roles.Permissions
  alias TimeManager.Repo

  def init(opts), do: opts

  def call(conn, opts) do
    user = get_user(conn)
    required_permission = get_required_permission(conn, opts)

    if required_permission == :error or (user != nil and Permissions.user_has_permission?(user, required_permission)) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> halt()
    end
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
end
