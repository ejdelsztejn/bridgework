defmodule BridgeworkWeb.InspectorLive do
  use BridgeworkWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
      page_title: "Bridgework",
      page_description: "A bridge between your data and your applications."
      )}
  end

  @impl true
  def render(assigns) do
    ~H"""
      <h1 class="text-3xl font-semibold text-zinc-900">Bridgework</h1>
    """
  end
end
