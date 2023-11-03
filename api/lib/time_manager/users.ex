defmodule TimeManager.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false

  alias TimeManager.Repo

  alias TimeManager.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(params) do
    # Query all users by default
    query = from u in User
    conditions = true

    # Treat firstname optional parameter
    conditions =
      case Map.get(params, "firstname") do
        # If no firstname is provided, don't filter the users on it
        nil -> conditions
        # Otherwise keep only users whose firstnames are similar to the queried firstname
        firstname -> dynamic([u], ilike(u.firstname, ^firstname))
      end

    # Treat email optional parameter
    conditions =
      case Map.get(params, "email") do
        # If no email is provided, don't filter the users on it
        nil -> conditions
        # Otherwise keep only users whose emails are similar to the queried email
        email -> dynamic([u], ilike(u.email, ^email) and ^conditions)
      end

    Repo.all(from query, where: ^conditions)
  end


  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def add_role_to_user(user, role_name) do
    with {:ok, role} <- TimeManager.Roles.get_role_by_name(role_name) do
      update_user(user, %{role_id: role.id})
    end
  end

  def add_custom_permission_to_user(user, name, actions) do
    custom_permissions = Map.put(user.custom_permissions, name, actions)
    update_user(user, %{custom_permissions: custom_permissions})
  end
end
