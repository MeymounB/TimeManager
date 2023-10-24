defmodule TimeManagerWeb.ClockJSON do
  alias TimeManager.Clocks.Clock

  @doc """
  Renders a list of clocks.
  """
  def index(%{clocks: clocks}) do
    %{data: for(clock <- clocks, do: data(clock))}
  end

  @doc """
  Renders a single clock.
  """
  def show(%{clock: clock}) do
    %{data: data(clock)}
  end

  @spec data(%Clock{} | nil) :: %Clock{} | nil
  defp data(optional_clock) do
    case optional_clock do
      nil -> nil
      %Clock{} = clock -> %{
        id: clock.id,
        time: clock.time,
        status: clock.status,
        user_id: clock.user_id
      }
    end
  end
end
