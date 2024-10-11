defmodule FemtoPlannerWeb.PlanItemLive do
  use FemtoPlannerWeb, :live_view
  alias FemtoPlanner.Schedule

  embed_templates "plan_item_live/*"

  def render(%{live_action: :index} = assigns), do: index(assigns)
  def render(%{live_action: :item} = assigns), do: item(assigns)

  def handle_params(_params, _uri, socket)
      when socket.assigns.live_action == :index do
    socket = assign(socket, :plan_items, Schedule.list_plan_items())
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
end
