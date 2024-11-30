defmodule FemtoPlannerWeb.HomeLive do
  use FemtoPlannerWeb, :live_view
  alias FemtoPlannerWeb.Shared

  def mount(_params, session, socket) do
    socket = assign(socket, :page_title, "Home")
    socket = assign(socket, :cldr_locale, session["cldr_locale"])
    {:ok, socket}
  end
end
