defmodule TimeManager.Teams.TeamEmployees do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_employees" do
    field :team_id, :id
    field :employee_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:team_id, :employee_id])
    |> validate_required([:team_id, :employee_id])
  end
end
