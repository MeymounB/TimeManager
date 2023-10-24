defmodule TimeManagerWeb.ErrorJSON do
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def format_error_stacktrace(stack) do
    Enum.map(stack, &Exception.format_stacktrace_entry/1)
  end

  def custom_error_format(%Ecto.Query.CastError{type: type, value: value}) do
    %{type: type, value: value}
  end

  def custom_error_format(_) do
    %{}
  end

  def format_error(error) do
    Map.merge(%{_type: "#{error.__struct__}", message: error.message}, custom_error_format(error))
  end

  def handle_errors(%{kind: :error, reason: reason, stack: stack}) do
    %{reason: format_error(reason), stack: format_error_stacktrace(stack)}
  end

end
