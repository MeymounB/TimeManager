defmodule TimeManager.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema


  schema "users" do
    pow_user_fields()
    field :firstname, :string
    field :lastname, :string
    has_one :clock, TimeManager.Clocks.Clock
    has_many :working_times, TimeManager.WorkingTimes.WorkingTime

    timestamps(type: :utc_datetime)
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> Ecto.Changeset.cast(attrs, [:firstname, :lastname])
    |> Ecto.Changeset.validate_required([:firstname, :lastname])
  end
end
