defmodule FemtoPlannerWeb.Shared do
  use FemtoPlannerWeb, :html

  attr :name, :string, required: true

  def icon(assigns) do
    ~H"""
    <span class="material-symbols-outlined"><%= @name %></span>
    """
  end
end
