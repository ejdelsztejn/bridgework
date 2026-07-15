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
    <main class="mx-auto max-w-6xl px-6 py-12">
      <h1 class="text-3xl font-semibold text-zinc-900">Bridgework</h1>

      <p class="mt-2 text-zinc-600">
        Inspect and troubleshoot data moving between connected systems.
      </p>

      <form id="payload-form" phx-submit="inspect" class="mt-8">
        <label for="raw-payload" class="block font-medium text-zinc-900">
          Incoming payload
        </label>

        <textarea
          id="raw-payload"
          name="payload"
          rows="14"
          class="mt-2 w-full rounded-lg border border-zinc-300 p-4 font-mono text-sm"
        >{@raw_payload}</textarea>

        <button
          type="submit"
          class="mt-4 rounded-lg bg-zinc-900 px-4 py-2 text-white"
        >
          Inspect payload
        </button>
      </form>
    </main>
    """
  end
end
