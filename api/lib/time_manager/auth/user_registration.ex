defmodule TimeManager.Auth.UserRegistration do
  defstruct [:firstname, :lastname, :email, :password, :password_confirmation]

  @type t() :: %__MODULE__{}
end
