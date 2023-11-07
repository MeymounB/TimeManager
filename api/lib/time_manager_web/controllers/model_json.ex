defmodule TimeManagerWeb.ModelJSON do


  def custom_value(%DateTime{} = value) do
    Calendar.strftime(value, "%Y-%m-%d %H:%M:%S")
  end

  def custom_value(value), do: value
  def custom_model_field(model, field, :associations, options) do
    data(Map.get(TimeManager.Repo.preload(model, field), field), Map.merge(%{global: Map.get(options, :global, %{})}, Map.get(options, field, %{})))
  end
  def custom_model_field(model, field, :fields, _options), do: custom_value(Map.get(model, field))

  defp model_field(model, [field, type], options), do: {field, custom_model_field(model, field, type, options)}

  def custom_show_field(_model, :refresh_token, _type, _options), do: false
  def custom_show_field(_model, :password, _type, _options), do: false
  def custom_show_field(_model, :password_hash, _type, _options), do: false
  def custom_show_field(_model, :inserted_at, _type, _options), do: false
  def custom_show_field(_model, :updated_at, _type, _options), do: false
  def custom_show_field(_model, _field, _type, _options), do: true

  defp is_field_not_excluded(field, options) do
    case options do
      nil -> true
      options ->  field not in Map.get(options, :excluded, []) and is_field_not_excluded(field, Map.get(options, :global, nil))
    end

  end

  defp get_model_fields_types(model, type, options) do
    model.__struct__.__schema__(type)
    |> Enum.filter(&is_field_not_excluded(&1, options))
    |> Enum.filter(&custom_show_field(model, &1, type, options))
    |> Enum.map(fn item -> [item, type] end)
  end

  defp get_model_fields(model, options) do
    associations = case Map.get(options, :associations, false) do
      true -> get_model_fields_types(model, :associations, options)
      false -> []
    end

    get_model_fields_types(model, :fields, options)
    |> Enum.concat(associations)
  end

  def data(model, options \\ %{}) do
    case model do
      nil -> nil
      [] -> []
      %{} = model -> Enum.into(Enum.map(get_model_fields(model, options), &model_field(model, &1, options)), %{})
      [_ | _] = models -> Enum.map(models, &data(&1, options))
    end
  end
end
