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

  defp data(%WorkingTime{} = working_time) do
    %{
      id: working_time.id,
      start: Calendar.strftime(working_time.start, "%Y-%m-%d %H:%M:%S"),
      end: Calendar.strftime(working_time.end, "%Y-%m-%d %H:%M:%S"),
      user_id: working_time.user_id
    }
  end
end
