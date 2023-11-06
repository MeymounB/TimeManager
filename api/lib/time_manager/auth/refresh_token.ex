defmodule TimeManager.Auth.RefreshToken do
  use Joken.Config

  def token_config, do: default_claims(default_exp: 60 * 60 * 24 * 31) # 1 month
end
