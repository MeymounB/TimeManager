defmodule TimeManager.Repo.Migrations.CreateTeamEmployees do
  use Ecto.Migration

  def change do
    create table(:team_employees, primary_key: false) do
      add(:team_id, references(:teams, on_delete: :delete_all), primary_key: true)
      add(:employee_id, references(:users, on_delete: :delete_all), primary_key: true)
      timestamps(type: :utc_datetime)
    end

    create unique_index(:team_employees, [:team_id, :employee_id])
  end
end
