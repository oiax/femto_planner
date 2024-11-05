defmodule FemtoPlannerWeb.Shared do
  use FemtoPlannerWeb, :html

  attr :name, :string, required: true

  def icon(assigns) do
    ~H"""
    <span class="material-symbols-outlined"><%= @name %></span>
    """
  end

  attr :field, Phoenix.HTML.FormField, required: true
  attr :label, :string, required: true

  def text_input(assigns) do
    ~H"""
    <div class="form-control p-4">
      <label for={@field.id} class="font-bold"><%= @label %></label>
      <input
        type="text"
        id={@field.id}
        name={@field.name}
        value={@field.value}
        class="input input-bordered border-gray-500"
      />
    </div>
    """
  end
end
