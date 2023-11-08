# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeManager.Repo.insert!(%TimeManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule TimeManager.Seeds do
  alias TimeManager.Users.User
  alias TimeManager.Clocks.Clock
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManager.Teams.Team
  alias TimeManager.Teams
  alias TimeManager.Repo

  def seed_data do
    seed_roles()
    seed_users()
  end

  defp seed_roles() do
    for role <- TimeManager.Roles.DefaultRoles.all() do
      unless TimeManager.Roles.get_role_by_name(role.name) do
        {:ok, _role} = TimeManager.Roles.create_role(role)
      end
    end
  end

  defp random_bool() do
    :rand.uniform(2) == 1
  end

  defp random_int(min, max) do
    :rand.uniform(trunc(max - min + 1)) + min - 1
  end

  defp random_time() do
    DateTime.utc_now()
    |> DateTime.add(-1, :day)
    |> DateTime.add(random_int(-4, 4), :hour)
    |> randomize_datetime
  end

  defp randomize_datetime(datetime) do
    datetime
    |> DateTime.add(random_int(0, 60), :minute)
    |> DateTime.add(random_int(0, 60), :second)
  end

  defp create_user_working_time(%User{:id => id} = user, start_date, count) do
    if count > 0 do
      end_date = randomize_datetime(DateTime.add(start_date, random_int(5, 10), :hour))

      %WorkingTime{}
      |> WorkingTime.changeset(%{user_id: id, start: start_date, end: end_date})
      |> Repo.insert()
      start_date = randomize_datetime(DateTime.add(end_date, random_int(14, 19), :hour))

      create_user_working_time(user, start_date, count - 1)

      if count == 1 do
        status = random_bool()
        # If we clocked out (status == false) the time must be the same as the last working time end date
        # Otherwise it must be the next working time start time
        clock_time = case status do
          true -> start_date
          false -> end_date
        end

        %Clock{}
        |> Clock.changeset(%{user_id: id, time: clock_time, status: status})
        |> Repo.insert()
      end
    end
  end

  defp create_user_working_times(%User{:id => id} = user) do
    start_date = random_time()
    # 80% chance to set a clock + working times
    wt_count = if random_int(0, 10) < 8 do
        # Between 0 and 4 working times per user
        wt_count = random_int(0, 5)
        create_user_working_time(user, DateTime.add(start_date, -random_int(wt_count, 1.5*wt_count), :day), wt_count)
        wt_count
      else
        0
      end

    # If no working time, 50% chance to still have a clock (user clocked in for its first time)
    if wt_count == 0 and random_bool() do
      %Clock{}
      |> Clock.changeset(%{user_id: id, time: start_date, status: true})
      |> Repo.insert()
    end
    user
  end

  defp create_user(attrs) do
    with {:ok, %User{} = user} <-
      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()
    do
      user
      |> create_user_working_times()
    else
      err -> IO.puts("Error #{inspect(err)}\n")
    end
  end

  defp create_random_user do
    firstname = FakerElixir.Name.first_name()
    lastname = FakerElixir.Name.last_name()
    name = firstname <> " " <> lastname
    user = create_user(%{
      firstname: firstname,
      lastname: lastname,
      email: FakerElixir.Internet.email(name),
      password: "123456789",
      password_confirmation: "123456789",
      role_id: 4
    })
    team_id = random_int(1, 4)
    if team_id != 4 do
      Teams.add_employee(team_id, user.id)
    end
  end

  defp seed_roled_users do
    # Admin -> Must document it and ask user to update the password
    create_user(%{
      firstname: "admin",
      lastname: "admin",
      email: "admin@timemanager.fr",
      password: "password",
      password_confirmation: "password",
      role_id: TimeManager.Roles.get_role_by_name("Admin").id
    })

    if Mix.env() == :dev do
      # General Manager
      create_user(%{
        firstname: "gmanager",
        lastname: "gmanager",
        email: "gmanager@timemanager.fr",
        password: "password",
        password_confirmation: "password",
        role_id: TimeManager.Roles.get_role_by_name("General Manager").id
      })
      # Manager
      create_user(%{
        firstname: "manager",
        lastname: "manager",
        email: "manager@timemanager.fr",
        password: "password",
        password_confirmation: "password",
        role_id: TimeManager.Roles.get_role_by_name("Manager").id
      })
      # Employee
      create_user(%{
        firstname: "employee",
        lastname: "employee",
        email: "employee@timemanager.fr",
        password: "password",
        password_confirmation: "password",
        role_id: TimeManager.Roles.get_role_by_name("Employee").id
      })
    end
  end

  defp seed_users do
    seed_roled_users()

    # Generate 3 teams
    Enum.map(1..3, fn _ ->
      %Team{}
      |> Team.changeset(%{name: Faker.Commerce.department()})
      |> Repo.insert()
    end)
    # Add the manager to 2/3 teams, the gmanager to 1/3 and the employee to the first one
    Teams.add_manager(1, 3)
    Teams.add_manager(2, 3)
    Teams.add_manager(1, 2)
    Teams.add_employee(1, 4)

    Enum.map(1..20, fn _ -> create_random_user() end)
  end
end

TimeManager.Seeds.seed_data()
