defmodule Bridgework.PayloadTransformer do
  @spec apply_mappings(map(), map()) :: map()
  def apply_mappings(payload, mappings) do
    Enum.reduce(mappings, payload, fn {source_field, target_field}, transformed ->
      case Map.fetch(transformed, source_field) do
        {:ok, value} ->
          transformed
          |> Map.delete(source_field)
          |> Map.put(target_field, value)

        :error ->
          transformed
      end
    end)
  end
end
