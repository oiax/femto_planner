defmodule FemtoPlanner.Schedule do
  import Ecto.Query, only: [from: 2]
  alias FemtoPlanner.Repo
  alias FemtoPlanner.Schedule.PlanItem

  @time_zone Application.compile_env(:femto_planner, :default_time_zone)

  def list_plan_items do
    from(pi in PlanItem,
      order_by: [asc: pi.starts_at]
    )
    |> Repo.all()
    |> Enum.map(&convert_time_zone/1)
  end

  def get_plan_item!(id) do
    PlanItem
    |> Repo.get!(id)
    |> convert_time_zone()
  end

  defp convert_time_zone(item) do
    s = DateTime.shift_zone!(item.starts_at, @time_zone)
    e = DateTime.shift_zone!(item.ends_at, @time_zone)
    %{item | starts_at: s, ends_at: e}
  end

  @abbreviated_day_of_week_names ~w(Mon Tue Wed Thu Fri Sat Sun)

  def format_datetime(dt, string_format) do
    Calendar.strftime(
      dt,
      string_format,
      abbreviated_day_of_week_names: fn dow ->
        Enum.at(@abbreviated_day_of_week_names, dow - 1)
      end
    )
  end
end
