defmodule XkcdSmartCell do
  @moduledoc false

  use Kino.JS, assets_path: "lib/assets/xkcd_smart_cell"
  use Kino.JS.Live
  use Kino.SmartCell, name: "xkcd"

  @impl true
  def init(attrs, ctx) do
    fields = %{
      "actions" => [
        %{label: "xkcd comic by number", value: "lookup"},
        %{label: "Latest xkcd comic", value: "latest"},
        %{label: "Random xkcd comic", value: "random"},
      ],
      "action" => attrs["action"] || "lookup",
      "number" => attrs["number"]
    }

    {:ok, assign(ctx, fields: fields)}
  end

  @impl true
  def handle_connect(ctx) do
    payload = %{
      fields: ctx.assigns.fields
    }

    {:ok, payload, ctx}
  end

  @impl true
  def to_attrs(%{assigns: %{fields: fields}}) do
    Map.take(fields, ["actions", "action", "number"])
  end

  @impl true
  def to_source(%{"action" => "latest"}) do
    quote do
      Xkcd.latest()
      |> XkcdSmartCell.render_markdown()
    end |> Kino.SmartCell.quoted_to_string()
  end

  def to_source(%{"action" => "random"}) do
    quote do
      Xkcd.random()
      |> XkcdSmartCell.render_markdown()
    end |> Kino.SmartCell.quoted_to_string()
  end

  def to_source(%{"number" => number}) do
    quote do
      Xkcd.number(unquote(number))
      |> XkcdSmartCell.render_markdown()
    end |> Kino.SmartCell.quoted_to_string()
  end

  def render_markdown(xkcd) do
    case xkcd do
      {:ok, comic} ->
        Kino.Markdown.new("""
        <div class="xkcd-output" style="background-color: beige; padding: 40px; border: 1px dotted grey;">

        # #{comic.title}

        <img style="margin: 0" src="#{comic.img}" title="#{String.replace(comic.alt, "\"", "&quot;")}" alt="#{comic.title}">

        <p><a href="https://xkcd.com/#{comic.num}"><span style="opacity: 0.8">xkcd comic #{comic.num}</span></a></p>
        <p style="opacity: 0.8">alt: #{comic.alt}</p>
        </div>
        """)

      {:error, reason} ->
        Kino.Markdown.new("""
        # Error

        #{reason}
        """)
    end
  end

  @impl true
  def handle_event("update_field", %{"field" => field, "value" => value}, ctx) do
    updated_fields = to_updates(ctx.assigns.fields, field, value)
    ctx = update(ctx, :fields, &Map.merge(&1, updated_fields))
    broadcast_event(ctx, "update", %{"fields" => updated_fields})
    {:noreply, ctx}
  end

  defp to_updates(fields, "variable", value) do
    if Kino.SmartCell.valid_variable_name?(value) do
      %{"variable" => value}
    else
      %{"variable" => fields["variable"]}
    end
  end

  defp to_updates(_fields, field, value), do: %{field => value}
end
