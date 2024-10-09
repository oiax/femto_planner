defmodule FemtoPlannerWeb.PlanItemLive do
  use FemtoPlannerWeb, :live_view

  embed_templates "plan_item_live/*"

  def render(%{live_action: :index} = assigns), do: index(assigns)
  def render(%{live_action: :item} = assigns), do: item(assigns)
end
