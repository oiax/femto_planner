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
  attr :optional, :boolean

  def text_input(assigns) do
    assigns = assign_new(assigns, :optional, fn -> false end)

    class =
      if assigns.field.errors == [] do
        "input input-bordered border-gray-500"
      else
        "input input-bordered border-error border-2"
      end

    assigns = assign(assigns, :class, class)

    ~H"""
    <div class="form-control p-4">
      <div>
        <label for={@field.id} class="font-bold"><%= @label %></label>
        <%= if @optional do %>
          <small>(Optional)</small>
        <% end %>
      </div>
      <input
        type="text"
        id={@field.id}
        name={@field.name}
        value={@field.value}
        class={@class}
      />
      <%= for {error_message, _opts} <- @field.errors do %>
        <div role="alert" class="text-error m-2 flex gap-1">
          <.icon name="error" />
          <%= error_message %>
        </div>
      <% end %>
    </div>
    """
  end

  attr :field, Phoenix.HTML.FormField, required: true
  attr :label, :string, required: true
  attr :optional, :boolean

  def textarea(assigns) do
    assigns = Map.put_new(assigns, :optional, false)

    ~H"""
    <div class="form-control p-4">
      <div>
        <label for={@field.id} class="font-bold"><%= @label %></label>
        <%= if @optional do %>
          <small>(Optional)</small>
        <% end %>
      </div>
      <textarea
        id={@field.id}
        name={@field.name}
        class="textarea textarea-bordered border-gray-500"
      ><%= @field.value %></textarea>
    </div>
    """
  end

  def date_and_time_input(assigns) do
    ~H"""
    <div class="form-control p-4">
      <div>
        <label for={@date_field.id} class="font-bold"><%= @label %></label>
      </div>
      <div>
        <input
          type="date"
          id={@date_field.id}
          name={@date_field.name}
          value={@date_field.value}
          class="input input-bordered border-gray-500"
        />
        <select
          name={@hour_field.name}
          class="select select-bordered border-gray-500"
        >
          <%= Phoenix.HTML.Form.options_for_select(
            0..23,
            @hour_field.value
          ) %>
        </select>
        <select
          name={@minute_field.name}
          class="select select-bordered border-gray-500"
        >
          <%= Phoenix.HTML.Form.options_for_select(
            0..59,
            @minute_field.value
          ) %>
        </select>
      </div>
    </div>
    """
  end
end
