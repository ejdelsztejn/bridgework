defmodule Bridgework.SchemaValidatorTest do
  use ExUnit.Case, async: true

  alias Bridgework.SchemaValidator

  @expected_fields ["name", "email", "signup_date", "source"]

  test "reports missing and unexpected fields" do
    payload = %{
      "full_name" => "Melody Sampleton",
      "email_address" => "melody.sampleton@example.com",
      "registered_at" => "07/15/2026",
      "ticket_type" => "general"
    }

    assert SchemaValidator.compare(payload, @expected_fields) == %{
             missing: ["email", "name", "signup_date", "source"],
             unexpected: [
               "email_address",
               "full_name",
               "registered_at",
               "ticket_type"
             ]
           }
  end

  test "reports an empty payload as missing all expected fields" do
    payload = %{}

    assert SchemaValidator.compare(payload, @expected_fields) == %{
             missing: ["email", "name", "signup_date", "source"],
             unexpected: []
           }
  end

  test "reports perfectly matching payload as having no missing or unexpected fields" do
    payload = %{
      "name" => "Melody Sampleton",
      "email" => "melody.sampleton@example.com",
      "signup_date" => "2026-07-15",
      "source" => "website"
    }

    assert SchemaValidator.compare(payload, @expected_fields) == %{
             missing: [],
             unexpected: []
           }
  end

  test "reports only the fields that differ in a partial match" do
    payload = %{
      "name" => "Melody Sampleton",
      "email_address" => "melody.sampleton@example.com"
    }

    assert SchemaValidator.compare(payload, @expected_fields) == %{
             missing: ["email", "signup_date", "source"],
             unexpected: ["email_address"]
           }
  end
end
