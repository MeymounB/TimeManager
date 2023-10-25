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
    TimeManagerWeb.ModelJSON.data(optional_clock)
  end
end
