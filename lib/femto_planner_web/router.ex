defmodule FemtoPlannerWeb.Router do
  use FemtoPlannerWeb, :router
  require Logger

  def put_cldr_locale_to_session(conn, _opts) do
    if cldr_locale =  Cldr.Plug.AcceptLanguage.get_cldr_locale(conn) do
      Plug.Conn.put_session(conn, :cldr_locale, cldr_locale.language)
    else
      conn
    end
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FemtoPlannerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Cldr.Plug.AcceptLanguage, cldr_backend: FemtoPlanner.Cldr
    plug :put_cldr_locale_to_session
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FemtoPlannerWeb do
    pipe_through :browser

    live "/", HomeLive
    live "/plan_items", PlanItemLive, :index
    live "/plan_items/today", PlanItemLive, :today
    live "/plan_items/new", PlanItemLive, :new
    live "/plan_items/:id", PlanItemLive, :show
    live "/plan_items/:id/edit", PlanItemLive, :edit
  end
end
