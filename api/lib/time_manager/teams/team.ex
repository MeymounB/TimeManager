defmodule TimeManager.Teams.Team do
  alias TimeManager.Teams.TeamManagers
  alias TimeManager.Teams.TeamEmployees
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string

    many_to_many :employees,
      TimeManager.Users.User,
      join_through: TeamEmployees,
      join_keys: [team_id: :id, employee_id: :id]

    many_to_many :managers,
      TimeManager.Users.User,
      join_through: TeamManagers,
      join_keys: [team_id: :id, manager_id: :id]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
