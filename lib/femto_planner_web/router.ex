defmodule FemtoPlannerWeb.Router do
  use FemtoPlannerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FemtoPlannerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FemtoPlannerWeb do
    pipe_through :browser

    live "/", HomeLive
    live "/plan_items", PlanItemLive, :index
    live "/plan_items/new", PlanItemLive, :new
    live "/plan_items/:id", PlanItemLive, :item
  end
end
