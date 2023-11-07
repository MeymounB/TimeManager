defmodule TimeManager.Teams.TeamManagers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_managers" do
    field :team_id, :id
    field :manager_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:team_id, :manager_id])
    |> validate_required([:team_id, :manager_id])
  end
end
