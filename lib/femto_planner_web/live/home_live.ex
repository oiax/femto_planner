defmodule FemtoPlannerWeb.HomeLive do
  use FemtoPlannerWeb, :live_view
  alias FemtoPlannerWeb.Shared

  def mount(_params, _session, socket) do
    socket = assign(socket, :page_title, "Home")
    {:ok, socket}
  end
end
