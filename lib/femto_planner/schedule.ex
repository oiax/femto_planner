defmodule FemtoPlanner.Schedule do
  import Ecto.Query, only: [from: 1, from: 2, order_by: 3]
  alias FemtoPlanner.Repo
  alias FemtoPlanner.Schedule.PlanItem

  @time_zone Application.compile_env(:femto_planner, :default_time_zone)

  def current_time do
    DateTime.shift_zone!(DateTime.utc_now(:second), @time_zone)
  end

  def list_plan_items do
    from(pi in PlanItem)
    |> do_list_plan_items()
  end

  def list_plan_items_of_today do
    t0 = %{current_time() | hour: 0, minute: 0, second: 0}
    t1 = DateTime.add(t0, 1, :day)

    from(pi in PlanItem,
      where:
        (pi.starts_at >= ^t0 and pi.starts_at < ^t1) or
          (pi.ends_at >= ^t0 and pi.ends_at <= ^t1)
    )
    |> do_list_plan_items()
  end

  defp do_list_plan_items(query) do
    query
    |> order_by([pi], asc: pi.starts_at)
    |> Repo.all()
    |> Enum.map(&convert_time_zone/1)
  end

  def get_plan_item!(id) do
    PlanItem
    |> Repo.get!(id)
    |> convert_time_zone()
  end

  def build_plan_item do
    current_time =
      DateTime.shift_zone!(DateTime.utc_now(:second), @time_zone)

    beginning_of_hour = %{current_time | minute: 0, second: 0}

    new_plan_item =
      %PlanItem{
        starts_at: DateTime.add(beginning_of_hour, 1, :hour),
        ends_at: DateTime.add(beginning_of_hour, 2, :hour)
      }

    new_plan_item
    |> populate_virtual_fields()
    |> PlanItem.changeset(%{})
  end

  def change_plan_item(plan_item) do
    plan_item
    |> populate_virtual_fields()
    |> PlanItem.changeset(%{})
  end

  def create_plan_item(attrs) do
    %PlanItem{}
    |> PlanItem.changeset(attrs)
    |> Repo.insert()
  end

  def update_plan_item(plan_item, attrs) do
    plan_item
    |> PlanItem.changeset(attrs)
    |> Repo.update()
  end

  def delete_plan_item(id) do
    PlanItem
    |> Repo.get!(id)
    |> Repo.delete!()
  end

  defp convert_time_zone(item) do
    s = DateTime.shift_zone!(item.starts_at, @time_zone)
    e = DateTime.shift_zone!(item.ends_at, @time_zone)
    %{item | starts_at: s, ends_at: e}
  end

  defp populate_virtual_fields(item) do
    Map.merge(item, %{
      s_date: DateTime.to_date(item.starts_at),
      s_hour: item.starts_at.hour,
      s_minute: item.starts_at.minute,
      e_date: DateTime.to_date(item.ends_at),
      e_hour: item.ends_at.hour,
      e_minute: item.ends_at.minute
    })
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
