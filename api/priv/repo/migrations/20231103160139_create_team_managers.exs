defmodule TimeManager.Repo.Migrations.CreateTeamManagers do
  use Ecto.Migration

  def change do
    create table(:team_managers) do
      add(:team_id, references(:teams, on_delete: :delete_all), primary_key: true)
      add(:manager_id, references(:users, on_delete: :delete_all), primary_key: true)
      timestamps(type: :utc_datetime)
    end

    create unique_index(:team_managers, [:team_id, :manager_id])
  end
end
