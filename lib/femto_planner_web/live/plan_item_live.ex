defmodule FemtoPlannerWeb.PlanItemLive do
  use FemtoPlannerWeb, :live_view
  import Calendar, only: [strftime: 2]
  alias FemtoPlanner.Schedule

  embed_templates "plan_item_live/*"

  def render(%{live_action: :index} = assigns), do: index(assigns)
  def render(%{live_action: :item} = assigns), do: item(assigns)

  def handle_params(_params, _uri, socket)
      when socket.assigns.live_action == :index do
    socket = assign(socket, :plan_items, Schedule.list_plan_items())
    {:noreply, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket)
      when socket.assigns.live_action == :item do
    socket = assign(socket, :plan_item, Schedule.get_plan_item!(id))
    {:noreply, socket}
  end

  defp description(%{item: item}) do
    assigns = %{
      lines: String.split(item.description, "\n")
    }

    ~H"""
    <%= for line <- @lines do %>
      <%= line %><br />
    <% end %>
    """
  end

  defp duration(assigns) do
    ~H"""
    <%= format_starts_at(@item) %> 〜 <%= format_ends_at(@item) %>
    """
  end

  @time_zone Application.compile_env(:femto_planner, :default_time_zone)

  defp format_starts_at(item) do
    if item.starts_at.year == DateTime.now!(@time_zone).year do
      strftime(item.starts_at, "%-m月%-d日 %H:%M")
    else
      strftime(item.starts_at, "%Y年%-m月%-d日 %H:%M")
    end
  end

  defp format_ends_at(item) do
    import DateTime, only: [to_date: 1]

    cond do
      to_date(item.starts_at) == to_date(item.ends_at) ->
        strftime(item.ends_at, "%H:%M")

      item.starts_at.year == item.ends_at.year ->
        strftime(item.ends_at, "%-m月%-d日 %H:%M")

      true ->
        strftime(item.ends_at, "%Y年%-m月%-d日 %H:%M")
    end
  end

  defp field_name_class,
    do: "bg-base-content text-white py-1 px-2 md:text-right"

  defp field_value_class, do: "py-1 px-2"
end
