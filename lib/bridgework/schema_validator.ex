defmodule Bridgework.SchemaValidator do
  def compare(payload, expected_fields) do
    payload_keys = Map.keys(payload)

    missing_fields =
      expected_fields
      |> Enum.filter(fn field -> field not in payload_keys end)
      |> Enum.sort()

    unexpected_fields =
      payload_keys
      |> Enum.filter(fn key -> key not in expected_fields end)
      |> Enum.sort()

    %{
      missing: missing_fields,
      unexpected: unexpected_fields
    }
  end
end
