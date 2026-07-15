defmodule BridgeworkWeb.InspectorLive do
  use BridgeworkWeb, :live_view

  alias Bridgework.PayloadTransformer
  alias Bridgework.SchemaValidator

  @expected_fields [
    "name",
    "email",
    "signup_date",
    "source"
  ]

  @sample_payload ~S"""
  {
    "full_name": "Melody Sampleton",
    "email_address": "melody.sampleton@example.com",
    "registered_at": "07/15/2026",
    "ticket_type": "general"
  }
  """

  @suggested_mappings %{
    "full_name" => "name",
    "email_address" => "email",
    "registered_at" => "signup_date"
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Bridgework",
       page_description: "A bridge between your data and your applications.",
       raw_payload: @sample_payload,
       formatted_payload: nil,
       parse_error: nil,
       schema_comparison: nil,
       parsed_payload: nil,
       transformed_payload: nil
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

        <button type="submit" class="mt-4 rounded-lg bg-zinc-900 px-4 py-2 text-white">
          Inspect payload
        </button>
      </form>

      <section class="mt-8" aria-live="polite">
        <pre
          :if={@formatted_payload}
          id="parsed-preview"
          class="overflow-x-auto rounded-lg bg-zinc-950 p-4 text-sm text-zinc-100"
        >
          {@formatted_payload}
        </pre>

        <p
          :if={@parse_error}
          id="parse-error"
          class="rounded-lg border border-red-200 bg-red-50 p-4 text-red-800"
        >
          {@parse_error}
        </p>
      </section>
      <section
        :if={@schema_comparison}
        id="schema-comparison"
        class="mt-8 grid gap-6 md:grid-cols-2"
      >
        <div class="rounded-lg border border-amber-200 bg-amber-50 p-5">
          <h2 class="font-semibold text-amber-950">Missing fields</h2>

          <p
            :if={@schema_comparison.missing == []}
            id="no-missing-fields"
            class="mt-3 text-amber-800"
          >
            No missing fields.
          </p>

          <ul
            :if={@schema_comparison.missing != []}
            id="missing-fields"
            class="mt-3 space-y-2"
          >
            <li
              :for={field <- @schema_comparison.missing}
              data-field={field}
              class="font-mono text-sm text-amber-900"
            >
              {field}
            </li>
          </ul>
        </div>

        <div class="rounded-lg border border-blue-200 bg-blue-50 p-5">
          <h2 class="font-semibold text-blue-950">Unexpected fields</h2>

          <p
            :if={@schema_comparison.unexpected == []}
            id="no-unexpected-fields"
            class="mt-3 text-blue-800"
          >
            No unexpected fields.
          </p>

          <ul
            :if={@schema_comparison.unexpected != []}
            id="unexpected-fields"
            class="mt-3 space-y-2"
          >
            <li
              :for={field <- @schema_comparison.unexpected}
              data-field={field}
              class="font-mono text-sm text-blue-900"
            >
              {field}
            </li>
          </ul>
        </div>
        <div class="md:col-span-2">
          <button
            id="apply-suggested-mappings"
            type="button"
            phx-click="apply_mappings"
            class="rounded-lg bg-zinc-900 px-4 py-2 text-white"
          >
            Apply suggested mappings
          </button>
        </div>
      </section>
      <section
        :if={@transformed_payload}
        class="mt-8"
      >
        <h2 class="font-semibold text-zinc-900">Transformed payload</h2>

        <pre
          id="transformed-preview"
          class="mt-3 overflow-x-auto rounded-lg bg-zinc-950 p-4 text-sm text-zinc-100"
        >
          {Jason.encode!(@transformed_payload, pretty: true)}
        </pre>
      </section>
    </main>
    """
  end

  @impl true
  def handle_event("inspect", %{"payload" => raw_payload}, socket) do
    case Jason.decode(raw_payload) do
      {:ok, payload} ->
        comparison = SchemaValidator.compare(payload, @expected_fields)

        {:noreply,
         assign(socket,
           raw_payload: raw_payload,
           formatted_payload: Jason.encode!(payload, pretty: true),
           parse_error: nil,
           schema_comparison: comparison,
           parsed_payload: payload,
           transformed_payload: nil
         )}

      {:error, _reason} ->
        {:noreply,
         assign(socket,
           raw_payload: raw_payload,
           formatted_payload: nil,
           parse_error: "This payload is not valid JSON. Please check the syntax and try again.",
           schema_comparison: nil,
           parsed_payload: nil,
           transformed_payload: nil
         )}
    end
  end

  def handle_event("apply_mappings", _params, socket) do
    transformed_payload =
      PayloadTransformer.apply_mappings(
        socket.assigns.parsed_payload,
        @suggested_mappings
      )

    comparison =
      SchemaValidator.compare(transformed_payload, @expected_fields)

    {:noreply,
     assign(socket,
       transformed_payload: transformed_payload,
       schema_comparison: comparison
     )}
  end
end
