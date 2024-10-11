defmodule FemtoPlanner.Schedule do
  alias FemtoPlanner.Repo
  alias FemtoPlanner.Schedule.PlanItem

  def list_plan_items do
    Repo.all(PlanItem)
  end
end
