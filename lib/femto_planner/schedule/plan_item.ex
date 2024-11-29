defmodule FemtoPlanner.Schedule.PlanItem do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger

  schema "plan_items" do
    field :name, :string, default: ""
    field :description, :string, default: ""
    field :all_day, :boolean, default: false
    field :starts_at, :utc_datetime
    field :ends_at, :utc_datetime
    field :starts_on, :date
    field :ends_on, :date

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
    :all_day
  ]

  @optional_fields [:description]

  @date_time_fields [
    :s_date,
    :s_hour,
    :s_minute,
    :e_date,
    :e_hour,
    :e_minute
  ]

  @date_fields [
    :starts_on,
    :ends_on
  ]

  @doc false
  def changeset(plan_item, %{"all_day" => "false"} = attrs) do
    plan_item
    |> cast(
      attrs,
      @required_fields ++ @optional_fields ++ @date_time_fields
    )
    |> validate_required(@required_fields)
    |> change_starts_at()
    |> change_ends_at()
    |> put_change(:starts_on, nil)
    |> put_change(:ends_on, nil)
  end

  def changeset(plan_item, %{"all_day" => "true"} = attrs) do
    plan_item
    |> cast(attrs, @required_fields ++ @optional_fields ++ @date_fields)
    |> validate_required(@required_fields)
    |> populate_starts_on()
    |> populate_ends_on()
    |> change_time_boundaries()
  end

  def changeset(plan_item, attrs) do
    plan_item
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
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

  defp populate_starts_on(changeset) do
    if get_field(changeset, :starts_on) do
      changeset
    else
      starts_at = get_field(changeset, :starts_at)
      put_change(changeset, :starts_on, DateTime.to_date(starts_at))
    end
  end

  defp populate_ends_on(changeset) do
    if get_field(changeset, :ends_on) do
      changeset
    else
      ends_at = get_field(changeset, :ends_at)

      ends_on =
        case ends_at do
          %DateTime{hour: 0, minute: 0} ->
            ends_at
            |> DateTime.to_date()
            |> Date.add(-1)

          _ ->
            DateTime.to_date(ends_at)
        end

      put_change(changeset, :ends_on, ends_on)
    end
  end

  defp change_time_boundaries(changeset) do
    s =
      changeset
      |> get_field(:starts_on)
      |> DateTime.new!(Time.new!(0, 0, 0), @time_zone)
      |> DateTime.shift_zone!("Etc/UTC")

    e =
      changeset
      |> get_field(:ends_on)
      |> DateTime.new!(Time.new!(0, 0, 0), @time_zone)
      |> DateTime.shift_zone!("Etc/UTC")
      |> DateTime.add(-1, :day)

    changeset
    |> put_change(:starts_at, s)
    |> put_change(:ends_at, e)
  end
end
