defmodule TimeManager.Auth.AuthFlow do
  use Pow.Plug.Base

  require Logger

  alias Plug.Conn
  alias TimeManager.Auth.AccessToken
  alias TimeManager.Auth.RefreshToken

  @impl true
  def fetch(conn, _config) do
    with {:ok, access_token} <- read_token(conn),
         {:ok, claims} <- validate_access_token(access_token) do
      conn =
        conn
        |> Conn.put_private(:api_access_token, access_token)
        |> Conn.put_private(:user_id, claims["user_id"])

      {conn, %{"token" => access_token}}
    else
      _any -> {conn, nil}
    end
  end

  @impl true
  def create(conn, user, _config) do
    refresh_token = generate_refresh_token(user)
    access_token = generate_access_token(user.id)
    conn = conn
    |> Conn.put_private(:api_access_token, access_token)
    |> Conn.put_private(:api_refresh_token, refresh_token)
    {conn, user}
  end

  @impl true
  def delete(conn, _config) do
    conn
  end

  def refresh(conn, refresh_token) do
    with {:ok, claims} <- validate_refresh_token(refresh_token) do
      access_token = generate_access_token(claims["user_id"])
      conn =
        conn
        |> Conn.put_private(:api_access_token, access_token)
        |> Conn.put_private(:user_id, claims["user_id"])

      {:ok, conn, %{"access_token" => access_token}}
    else
      _any -> {:error, conn}
    end
  end

  defp generate_access_token(user_id) do
    AccessToken.generate_and_sign!(%{"user_id" => user_id})
  end

  def generate_refresh_token(user) do
    refresh_token = RefreshToken.generate_and_sign!(%{"user_id" => user.id})
    TimeManager.Users.set_refresh_token(user, refresh_token)
    refresh_token
  end

  @spec read_token(Conn.t()) :: {atom(), any()}
  defp read_token(conn) do
    case Conn.get_req_header(conn, "authorization") do
      [token | _rest] -> {:ok, token |> String.replace("Bearer", "") |> String.trim()}
      _any -> {:error, "No Auth token found"}
    end
  end

  @spec validate_access_token(binary()) :: {atom(), any()}
  defp validate_access_token(access_token) do
    with {:ok, claims} = validate_res <- AccessToken.verify_and_validate(access_token) do
      case TimeManager.Users.is_user_id_valid(claims["user_id"]) do
        true -> validate_res
        false -> nil
      end
    end
  end

  @spec validate_refresh_token(binary()) :: {atom(), any()}
  defp validate_refresh_token(refresh_token) do
    with {:ok, claims} = validate_res <- RefreshToken.verify_and_validate(refresh_token) do
      case TimeManager.Users.get_user(claims["user_id"]) do
        %TimeManager.Users.User{} = user ->
          if user.refresh_token == refresh_token do
            validate_res
          else
            nil
          end
        nil -> nil
      end
    end
  end

end
