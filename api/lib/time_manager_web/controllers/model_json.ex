defmodule TimeManagerWeb.ModelJSON do


  def custom_value(%DateTime{} = value) do
    Calendar.strftime(value, "%Y-%m-%d %H:%M:%S")
  end

  def custom_value(value), do: value
  def custom_model_field(model, field, :association), do: data(Map.get(TimeManager.Repo.preload(model, field), field))
  def custom_model_field(model, field, :field), do: custom_value(Map.get(model, field))

  ## User
  def custom_show_field(%TimeManager.Users.User{}, _, :association), do: true
  # Common
  def custom_show_field(_, :inserted_at, _), do: false
  def custom_show_field(_, :updated_at, _), do: false
  def custom_show_field(_, _, :association), do: false
  def custom_show_field(_, _, _), do: true

  defp model_field(model, [field, type]), do: {field, custom_model_field(model, field, type)}

  defp get_model_fields(model) do
    fields = Enum.filter(model.__struct__.__schema__(:fields), &custom_show_field(model, &1, :field))
    associations = Enum.filter(model.__struct__.__schema__(:associations), &custom_show_field(model, &1, :association))

    fields
    |> Enum.map(fn item -> [item, :field] end) # Add the :filter atom to each element
    |> Enum.concat(Enum.map(associations, fn item -> [item, :association] end)) # Add the :association atom to each element
  end

  def data(model) do
    case model do
      nil -> nil
      %{} = model -> Enum.into(Enum.map(get_model_fields(model), &model_field(model, &1)), %{})
      [_ | _] = models -> Enum.map(models, &data/1)
    end
  end
end
