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

    assert has_element?(view, "#parsed-previw", "Jessy Eej Delman")
  end
end
