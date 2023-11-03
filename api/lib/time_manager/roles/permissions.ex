defmodule TimeManager.Roles.Permissions do
  import Ecto.Changeset

  def all() do
    %{
      # Account mean connected user account
      "account" => ["read", "update", "delete", "clock"],
      "user" => ["create", "read", "update", "delete", "clock", "role"],
      "team" => ["create", "read", "update", "delete", "clock"],
      "clock" => ["read", "delete"],
      "working_time" => ["create", "read", "update", "delete"],
    }
  end

  def validate_permissions(changeset, field) do
    validate_change(changeset, field, fn _field, permissions ->
      permissions
      |> Enum.reject(&has_permission?(all(), &1))
      |> case do
        [] -> []
        invalid_permissions -> [{field, {"invalid permissions", invalid_permissions}}]
      end
    end)
  end

  def has_permission?(permissions, required_perms) do
    Map.merge(permissions, required_perms, fn(_key, perms1, perms2) ->
      Enum.uniq(perms1 ++ perms2)
    end)
    |> Map.equal?(permissions)
  end

  def user_has_permission?(user, permission) do
    has_permission?(user.role.permissions, permission) ||
      has_permission?(user.custom_permissions, permission)
  end
end
