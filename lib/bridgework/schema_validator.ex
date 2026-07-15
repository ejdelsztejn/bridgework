defmodule Bridgework.SchemaValidator do

  def compare(payload, expected_fields) do
    payload_keys = Map.keys(payload)

    missing_fields = Enum.filter(expected_fields, fn field -> not (field in payload_keys) end)
    unexpected_fields = Enum.filter(payload_keys, fn key -> not (key in expected_fields) end)

    %{
      missing: missing_fields,
      unexpected: unexpected_fields
    }
  end
end
