defmodule BridgeworkWeb.InspectorLiveTest do
    use BridgeworkWeb.ConnCase

    import Phoenix.LiveViewTest

    test "renders the payload inspector", %{conn: conn} do
        {:ok, view, _html} = live(conn, "/")

        assert has_element?(view, "h1", "Bridgework")
    end
end
