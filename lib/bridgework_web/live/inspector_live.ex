defmodule BridgeworkWeb.InspectorLive do
  use BridgeworkWeb, :live_view

  @sample_payload ~S"""
  {
    "full_name": "Melody Sampleton",
    "email_address": "melody.sampleton@example.com",
    "registered_at": "07/15/2026",
    "ticket_type": "general"
  }
  """

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
      page_title: "Bridgework",
      page_description: "A bridge between your data and your applications.",
      raw_payload: @sample_payload,
      formatted_payload: nil,
      parse_error: nil
    )}
  end

  @impl true
  def render(assigns) do
    ~H"""
      <h1 class="text-3xl font-semibold text-zinc-900">Bridgework</h1>

    <textarea
      id="raw-payload"
      name="payload"
      rows="14"
      class="mt-2 w-full rounded-lg border border-zinc-300 p-4 font-mono text-sm"
    >{@raw_payload}</textarea>
    """
  end
end
