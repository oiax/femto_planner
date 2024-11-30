defmodule FemtoPlanner.Schedule.PlanItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plan_items" do
    field :name, :string, default: ""
    field :description, :string, default: ""
    field :all_day, :boolean, default: false
    field :starts_at, :utc_datetime
    field :ends_at, :utc_datetime
    field :starts_on, :date
    field :ends_on, :date

    timestamps(type: :utc_datetime_usec)

    field :s_date, :date, virtual: true
    field :s_hour, :integer, virtual: true
    field :s_minute, :integer, virtual: true
    field :e_date, :date, virtual: true
    field :e_hour, :integer, virtual: true
    field :e_minute, :integer, virtual: true
  end

  @common_fields [
    :name,
    :description,
    :all_day
  ]

  @datetime_fields [
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
  def changeset(plan_item, %{"all_day" => "false"} = attrs) do
    plan_item
    |> cast(attrs, @common_fields ++ @datetime_fields)
    |> validate_required([])
    |> change_starts_at()
    |> change_ends_at()
  end

  def changeset(plan_item, %{"all_day" => "true"} = attrs) do
    plan_item
    |> cast(attrs, @common_fields ++ @date_fields)
    |> validate_required([])
    |> change_time_boundaries()
  end

  def changeset(plan_item, _attrs) do
    cast(plan_item, %{}, [])
  end

  @doc false
  def change_all_day(changeset, %{"all_day" => "false"} = attrs) do
    changeset
    |> cast(attrs, [:all_day])
    |> put_change(:starts_at, changeset.data.starts_at)
    |> put_change(:ends_at, changeset.data.ends_at)
  end

  def change_all_day(changeset, %{"all_day" => "true"} = attrs) do
    starts_on =
      changeset
      |> get_field(:starts_at)
      |> DateTime.to_date()

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

    changeset
    |> cast(attrs, [:all_day])
    |> put_change(:starts_on, starts_on)
    |> put_change(:ends_on, ends_on)
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
