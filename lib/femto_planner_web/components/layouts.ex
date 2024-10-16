defmodule FemtoPlannerWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use FemtoPlannerWeb, :controller` and
  `use FemtoPlannerWeb, :live_view`.
  """
  use FemtoPlannerWeb, :html

  embed_templates "layouts/*"

  defp google_fonts_url do
    "https://fonts.googleapis.com/css2?" <>
      "family=Material+Symbols+Outlined:" <>
      "opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
  end
end
