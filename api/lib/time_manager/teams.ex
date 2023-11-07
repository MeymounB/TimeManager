defmodule TimeManager.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Teams.Team
  alias TimeManager.Teams.TeamEmployees
  alias TimeManager.Teams.TeamManagers

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  def get_employee_relation(team_id, employee_id) do
    Repo.one(from te in TeamEmployees, where: te.team_id == ^team_id and te.employee_id == ^employee_id)
  end

  def has_employee(team_id, employee_id), do: get_employee_relation(team_id, employee_id) != nil

  def get_manager_relation(team_id, manager_id) do
    Repo.one(from te in TeamManagers, where: te.team_id == ^team_id and te.manager_id == ^manager_id)
  end

  def has_manager(team_id, manager_id), do: get_manager_relation(team_id, manager_id) != nil

  def add_employee(team_id, employee_id) do
    %TeamEmployees{}
    |> TeamEmployees.changeset(%{team_id: team_id, employee_id: employee_id})
    |> Repo.insert()
  end

  def add_manager(team_id, manager_id) do
    %TeamManagers{}
    |> TeamManagers.changeset(%{team_id: team_id, manager_id: manager_id})
    |> Repo.insert()
  end

  def remove_employee(team_id, employee_id) do
    with %TeamEmployees{} = relation <- get_employee_relation(team_id, employee_id) do
      Repo.delete(relation)
    end
  end

  def remove_manager(team_id, manager_id) do
    with %TeamManagers{} = relation <- get_manager_relation(team_id, manager_id) do
      Repo.delete(relation)
    end
  end
end
