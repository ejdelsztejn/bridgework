defmodule BridgeworkWeb.PageController do
  use BridgeworkWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
