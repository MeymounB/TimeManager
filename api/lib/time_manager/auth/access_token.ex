defmodule TimeManager.Auth.AccessToken do
  use Joken.Config

  def token_config, do: default_claims(default_exp: 60 * 10) # 10min
end
