defmodule FemtoPlannerWeb.Shared do
  use FemtoPlannerWeb, :html
  require Logger

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
        class="input input-bordered border-gray-500"
      />
    </div>
    """
  end

  attr :field, Phoenix.HTML.FormField, required: true
  attr :label, :string, required: true
  attr :optional, :boolean

  def textarea(assigns) do
    assigns = assign_new(assigns, :optional, fn -> false end)

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
        class="textarea textarea-bordered border-gray-500"
      ><%= @field.value %></textarea>
    </div>
    """
  end

  attr :field, Phoenix.HTML.FormField, required: true
  attr :label, :string, required: true

  def date_input(assigns) do
    ~H"""
    <div class="form-control p-4">
      <div>
        <label for={@field.id} class="font-bold"><%= @label %></label>
      </div>
      <div>
        <input
          type="date"
          id={@field.id}
          name={@field.name}
          value={@field.value}
          class="input input-bordered border-gray-500"
        />
      </div>
    </div>
    """
  end

  attr :date_field, Phoenix.HTML.FormField, required: true
  attr :hour_field, Phoenix.HTML.FormField, required: true
  attr :minute_field, Phoenix.HTML.FormField, required: true
  attr :label, :string, required: true

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
          class="select select-bordered border-gray-500 ml-1"
        >
          <%= Phoenix.HTML.Form.options_for_select(
            Enum.map(0..23, &{two_digits(&1), &1}),
            @hour_field.value
          ) %>
        </select>
        <select
          name={@minute_field.name}
          class="select select-bordered border-gray-500 ml-1"
        >
          <%= Phoenix.HTML.Form.options_for_select(
            Enum.map(0..55//5, &{two_digits(&1), &1}),
            @minute_field.value
          ) %>
        </select>
      </div>
    </div>
    """
  end

  defp two_digits(n) do
    n
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end

  attr :field, Phoenix.HTML.FormField, required: true
  attr :label, :string, required: true

  def checkbox(assigns) do
    assigns =
      assign(assigns, :checked, assigns.field.value in [true, "true"])

    Logger.info("checkbox: #{inspect assigns.field.value}")

    ~H"""
    <div class="form-control p-4">
      <label class="flex items-center gap-2 font-bold">
        <input type="hidden" name={@field.name} value="false" />
        <input
          type="checkbox"
          id={@field.id}
          name={@field.name}
          value="true"
          checked={@checked}
          class="rounded border-gray-500 text-gray-950 focus:ring-0"
        />
        <%= @label %>
      </label>
    </div>
    """
  end
end
