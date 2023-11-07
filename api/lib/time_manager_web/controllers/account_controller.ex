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

  action_fallback TimeManagerWeb.FallbackController

  plug(CheckPermissions,
    actions: [
      clock: %{"account" =>  ["clock"]},
      show: %{"account" =>  ["read"]},
      update: %{"account" =>  ["update"]},
      delete: %{"account" =>  ["delete"]},
    ]
  )

  defp translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(TimeManagerWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(TimeManagerWeb.Gettext, "errors", msg, opts)
    end
  end

  @spec register(Conn.t(), UserRegistration.t()) :: Conn.t()
  def register(conn, user_registration_command) do
    with {:ok, _user, conn} <- conn |> Pow.Plug.create_user(user_registration_command) do
      json(conn, %{
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
        |> json(%{error: %{status: 401, message: "Invalid email or password"}})
    end
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

  def logout(conn, _params) do
    user = CheckPermissions.get_user!(conn)
    Users.invalidate_user_refresh_token(user)

    send_resp(conn, :no_content, "")
  end

  def show(conn, _params) do
    user = CheckPermissions.get_user!(conn)
    json(conn, TimeManagerWeb.UserJSON.show(%{user: user}))
  end

  def clock(conn, _params) do
    with {:ok, %TimeManager.Clocks.Clock{} = clock} <- TimeManager.Clocks.clock_user(CheckPermissions.get_user_id(conn)) do
      conn
      |> put_status(:created)
      |> json(TimeManagerWeb.ClockJSON.show(%{clock: clock}))
    end
  end

  def update(conn, %{"user" => user_params}) do
    user = CheckPermissions.get_user!(conn)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      json(conn, TimeManagerWeb.UserJSON.show(%{user: user}))
    end
  end

  def delete(conn, _params) do
    user = CheckPermissions.get_user!(conn)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
