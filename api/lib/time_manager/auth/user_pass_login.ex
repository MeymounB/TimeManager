defmodule TimeManager.Auth.UserPassLogin do
  defstruct [:email, :password]

  @type t() :: %__MODULE__{}
end
