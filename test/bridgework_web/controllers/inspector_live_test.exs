defmodule BridgeworkWeb.InspectorLiveTest do
  use BridgeworkWeb.ConnCase

  import Phoenix.LiveViewTest

  test "renders the payload inspector", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "h1", "Bridgework")
    assert has_element?(view, "#raw-payload")
    assert has_element?(view, "#payload-form")
  end

  test "formats a valid JSON payload", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    payload = ~s({"full_name":"Melody Sampleton","email_address":"melody.sampleton@example.com"})

    view
    |> form("#payload-form", %{"payload" => payload})
    |> render_submit()

    assert has_element?(view, "#parsed-preview", "Melody Sampleton")
  end

  test "clears the previous result when the next submission changes", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    view
    |> form("#payload-form", %{"payload" => ~s({"name":"Melody Sampleton"})})
    |> render_submit()

    assert has_element?(view, "#parsed-preview")

    view
    |> form("#payload-form", %{"payload" => ~s({"name":})})
    |> render_submit()

    assert has_element?(view, "#parse-error")
    refute has_element?(view, "#parsed-preview")
    refute has_element?(view, "#schema-comparison")

    view
    |> form("#payload-form", %{"payload" => ~s({"name":"Jessy"})})
    |> render_submit()

    assert has_element?(view, "#parsed-preview")
    refute has_element?(view, "#parse-error")
    assert has_element?(view, "#schema-comparison")
  end

  test "displays missing and unexpected fields", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    payload =
      ~s({
        "full_name": "Melody Sampleton",
        "email_address": "melody.sampleton@example.com",
        "registered_at": "07/15/2026",
        "ticket_type": "general"
        })

    view
    |> form("#payload-form", %{"payload" => payload})
    |> render_submit()

    assert has_element?(view, "#schema-comparison")
    assert has_element?(view, ~s(#missing-fields [data-field="name"]))
    assert has_element?(view, ~s(#missing-fields [data-field="email"]))

    assert has_element?(
             view,
             ~s(#unexpected-fields [data-field="full_name"])
           )

    assert has_element?(
             view,
             ~s(#unexpected-fields [data-field="email_address"])
           )
  end
end
