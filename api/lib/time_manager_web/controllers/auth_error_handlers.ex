defmodule TimeManagerWeb.AuthErrorHandler do
  use TimeManagerWeb, :controller

  def call(conn, :not_authenticated) do
    conn
    |> put_status(401)
    |> json(%{error: %{message: "The user is not authenticated"}})
  end
end
