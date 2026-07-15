defmodule Bridgework.SchemaValidatorTest do
  use ExUnit.Case, async: true

  alias Bridgework.SchemaValidator

  test "reports missing and unexpected fields" do
    payload = %{
      "full_name" => "Melody Sampleton",
      "email_address" => "melody.sampleton@example.com",
      "registered_at" => "07/15/2026",
      "ticket_type" => "general"
    }

    expected_fields = [
      "name",
      "email",
      "signup_date",
      "source"
    ]

    assert SchemaValidator.compare(payload, expected_fields) == %{
             missing: ["email", "name", "signup_date", "source"],
             unexpected: [
               "email_address",
               "full_name",
               "registered_at",
               "ticket_type"
             ]
           }
  end
end
