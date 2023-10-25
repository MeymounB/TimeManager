defmodule TimeManagerWeb.WorkingTimeJSON do
  alias TimeManager.WorkingTimes.WorkingTime

  @doc """
  Renders a list of working_times.
  """
  def index(%{working_times: working_times}) do
    %{data: for(working_time <- working_times, do: data(working_time))}
  end

  @doc """
  Renders a single working_time.
  """
  def show(%{working_time: working_time}) do
    %{data: data(working_time)}
  end

  @spec data(%WorkingTime{} | nil) :: %WorkingTime{} | nil
  def data(optional_working_time) do
    TimeManagerWeb.ModelJSON.data(optional_working_time)
  end
end
