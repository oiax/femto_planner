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
  end
end
