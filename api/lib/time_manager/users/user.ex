defmodule TimeManager.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema


  schema "users" do
    pow_user_fields()
    field :firstname, :string
    field :lastname, :string

    field :custom_permissions, :map, default: %{}
    belongs_to :role, TimeManager.Roles.Role

    has_one :clock, TimeManager.Clocks.Clock
    has_many :working_times, TimeManager.WorkingTimes.WorkingTime

    timestamps(type: :utc_datetime)
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> Ecto.Changeset.cast(attrs, [:firstname, :lastname, :role_id, :custom_permissions])
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
