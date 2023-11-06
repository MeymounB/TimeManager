defmodule TimeManager.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema


  schema "users" do
    pow_user_fields()
    field :firstname, :string
    field :lastname, :string
    field :refresh_token, :string

    field :custom_permissions, :map, default: %{}
    belongs_to :role, TimeManager.Roles.Role

    has_one :clock, TimeManager.Clocks.Clock
    has_many :working_times, TimeManager.WorkingTimes.WorkingTime

    many_to_many :teams,
      TimeManager.Teams.Team,
      join_through: TimeManager.Teams.TeamEmployees,
      join_keys: [employee_id: :id, team_id: :id]
    many_to_many :managed_teams,
      TimeManager.Teams.Team,
      join_through: TimeManager.Teams.TeamManagers,
      join_keys: [manager_id: :id, team_id: :id]

    timestamps(type: :utc_datetime)
  end

  def changeset(user_or_changeset, attrs) do
    case Map.has_key?(attrs, :password) do
      true -> user_or_changeset
        |> pow_current_password_changeset(attrs)
        |> pow_password_changeset(attrs)
      false -> user_or_changeset
    end
    |> pow_user_id_field_changeset(attrs)
    |> Ecto.Changeset.cast(attrs, [:firstname, :lastname, :role_id, :custom_permissions, :refresh_token])
    |> default_role()
    |> Ecto.Changeset.validate_required([:firstname, :lastname, :role_id])
    |> TimeManager.Roles.Permissions.validate_permissions(:custom_permissions)
  end

  defp default_role(%Ecto.Changeset{changes: %{role_id: _}} = changeset) do
    changeset
  end

  defp default_role(%Ecto.Changeset{data: %TimeManager.Users.User{role_id: nil}} = changeset) do
    changeset
    |> Ecto.Changeset.put_change(:role_id, TimeManager.Roles.get_role_by_name("Employee").id)
  end

  defp default_role(changeset) do
    changeset
  end
end
