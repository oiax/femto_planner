defmodule FemtoPlanner.Schedule.PlanItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plan_items" do
    field :name, :string, default: ""
    field :description, :string, default: ""
    field :starts_at, :utc_datetime
    field :ends_at, :utc_datetime

    timestamps(type: :utc_datetime_usec)

    field :s_date, :date, virtual: true
    field :s_hour, :integer, virtual: true
    field :s_minute, :integer, virtual: true
    field :e_date, :date, virtual: true
    field :e_hour, :integer, virtual: true
    field :e_minute, :integer, virtual: true
  end

  @fields [
    :name,
    :description,
    :s_date,
    :s_hour,
    :s_minute,
    :e_date,
    :e_hour,
    :e_minute
  ]

  @doc false
  def changeset do
    current_time = FemtoPlanner.Schedule.current_time()
    beginning_of_hour = %{current_time | minute: 0, second: 0}

    %__MODULE__{}
    |> cast(%{}, [])
    |> put_change(:starts_at, DateTime.add(beginning_of_hour, 1, :hour))
    |> put_change(:ends_at, DateTime.add(beginning_of_hour, 2, :hour))
    |> change_virtual_fields()
  end

  @doc false
  def changeset(plan_item) do
    plan_item
    |> cast(%{}, [])
    |> change_virtual_fields()
  end

  @doc false
  def changeset(plan_item, attrs) do
    plan_item
    |> cast(attrs, @fields)
    |> validate_required([])
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

  defp change_virtual_fields(changeset) do
    starts_at = get_field(changeset, :starts_at)
    ends_at = get_field(changeset, :ends_at)

    changeset
    |> put_change(:s_date, DateTime.to_date(starts_at))
    |> put_change(:s_hour, starts_at.hour)
    |> put_change(:s_minute, starts_at.minute)
    |> put_change(:e_date, DateTime.to_date(ends_at))
    |> put_change(:e_hour, ends_at.hour)
    |> put_change(:e_minute, ends_at.minute)
  end
end
