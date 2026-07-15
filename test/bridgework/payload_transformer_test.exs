defmodule Bridgework.PayloadTransformerTest do
  use ExUnit.Case, async: true

  alias Bridgework.PayloadTransformer

  test "renames mapped fields and preserves unmapped fields" do
    payload = %{
      "full_name" => "Melody Sampleton",
      "email_address" => "melody.sampleton@example.com",
      "registered_at" => "07/15/2026",
      "ticket_type" => "general"
    }

    mappings = %{
      "full_name" => "name",
      "email_address" => "email",
      "registered_at" => "signup_date"
    }

    assert PayloadTransformer.apply_mappings(payload, mappings) == %{
             "name" => "Melody Sampleton",
             "email" => "melody.sampleton@example.com",
             "signup_date" => "07/15/2026",
             "ticket_type" => "general"
           }
  end

  test "ignores a mapping whose source field is absent" do
    payload = %{"name" => "Melody Sampleton"}
    mappings = %{"email_address" => "email"}

    assert PayloadTransformer.apply_mappings(payload, mappings) == payload
  end

  test "preserves a mapped null value" do
    payload = %{"email_address" => nil}
    mappings = %{"email_address" => "email"}

    assert PayloadTransformer.apply_mappings(payload, mappings) == %{
             "email" => nil
           }
  end
end
