defmodule FemtoPlanner.Schedule.PlanItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plan_items" do
    field :name, :string, default: ""
    field :description, :string, default: ""
    field :starts_at, :utc_datetime
    field :ends_at, :utc_datetime

    field :s_date, :date, virtual: true
    field :s_hour, :integer, virtual: true
    field :s_minute, :integer, virtual: true
    field :e_date, :date, virtual: true
    field :e_hour, :integer, virtual: true
    field :e_minute, :integer, virtual: true

    timestamps(type: :utc_datetime_usec)
  end

  @required_fields [
    :name,
    :s_date,
    :s_hour,
    :s_minute,
    :e_date,
    :e_hour,
    :e_minute
  ]

  @optional_fields [:description]

  @doc false
  def changeset(plan_item, attrs) do
    plan_item
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> change_starts_at()
    |> change_ends_at()
  end

  defp change_starts_at(changeset) do
    d = get_field(changeset, :s_date)
    h = get_field(changeset, :s_hour)
    m = get_field(changeset, :s_minute)
    put_change(changeset, :starts_at, get_utc_datetime(d, h, m))
  end

  defp change_ends_at(changeset) do
    d = get_field(changeset, :e_date)
    h = get_field(changeset, :e_hour)
    m = get_field(changeset, :e_minute)
    put_change(changeset, :ends_at, get_utc_datetime(d, h, m))
  end

  @time_zone Application.compile_env(:femto_planner, :default_time_zone)

  defp get_utc_datetime(d, h, m) do
    dt = DateTime.new!(d, Time.new!(h, m, 0), @time_zone)
    DateTime.shift_zone!(dt, "Etc/UTC")
  end
end
