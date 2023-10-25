defmodule TimeManager.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    has_one :clock, TimeManager.Clocks.Clock
    has_many :working_times, TimeManager.WorkingTimes.WorkingTime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/.+@.+\..+/, message: "must be in the format X@X.X")
    |> unique_constraint(:email)
  end
end
