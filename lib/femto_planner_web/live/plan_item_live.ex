defmodule FemtoPlannerWeb.PlanItemLive do
  use FemtoPlannerWeb, :live_view
  import Calendar, only: [strftime: 2]
  alias FemtoPlanner.Schedule
  alias FemtoPlannerWeb.Shared

  embed_templates "plan_item_live/*"

  def render(%{live_action: :index} = assigns), do: index(assigns)
  def render(%{live_action: :new} = assigns), do: new(assigns)
  def render(%{live_action: :show} = assigns), do: show(assigns)

  def handle_params(_params, _uri, socket)
      when socket.assigns.live_action == :index do
    socket = assign(socket, :plan_items, Schedule.list_plan_items())
    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket)
      when socket.assigns.live_action == :new do
    socket = assign(socket, :changeset, Schedule.build_plan_item())
    {:noreply, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket)
      when socket.assigns.live_action == :show do
    socket = assign(socket, :plan_item, Schedule.get_plan_item!(id))
    {:noreply, socket}
  end

  def handle_event("save", %{"plan_item" => attrs}, socket) do
    case Schedule.create_plan_item(attrs) do
      {:ok, plan_item} ->
        socket = push_patch(socket, to: ~p(/plan_items/#{plan_item.id}))
        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :changeset, changeset)
        {:noreply, socket}
    end
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
    <%= format_starts_at(@item) %> - <%= format_ends_at(@item) %>
    """
  end

  @time_zone Application.compile_env(:femto_planner, :default_time_zone)

  defp format_starts_at(item) do
    if item.starts_at.year == DateTime.now!(@time_zone).year do
      Schedule.format_datetime(item.starts_at, "%m-%d (%a) %H:%M")
    else
      Schedule.format_datetime(item.starts_at, "%Y-%m-%d (%a) %H:%M")
    end
  end

  defp format_ends_at(item) do
    import DateTime, only: [to_date: 1]

    cond do
      to_date(item.starts_at) == to_date(item.ends_at) ->
        strftime(item.ends_at, "%H:%M")

      item.starts_at.year == item.ends_at.year ->
        Schedule.format_datetime(item.ends_at, "%m-%d (%a) %H:%M")

      true ->
        Schedule.format_datetime(item.ends_at, "%Y-%m-%d (%a) %H:%M")
    end
  end

  defp format_datetime(datetime) do
    Schedule.format_datetime(datetime, "%Y-%m-%d (%a) %H:%M")
  end

  defp field_name_class,
    do: "bg-base-content text-white py-1 px-2 md:text-right"

  defp field_value_class, do: "py-1 px-2"
end
