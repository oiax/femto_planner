defmodule FemtoPlanner.Schedule.PlanItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plan_items" do
    field :name, :string, default: ""
    field :description, :string, default: ""
    field :starts_at, :utc_datetime
    field :ends_at, :utc_datetime

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(plan_item) do
    cast(plan_item, %{}, [])
  end

  @doc false
  def changeset(plan_item, attrs) do
    plan_item
    |> cast(attrs, [:name, :description, :starts_at, :ends_at])
    |> validate_required([])
  end

  @doc false
  def build do
    current_time = FemtoPlanner.Schedule.current_time()
    beginning_of_hour = %{current_time | minute: 0, second: 0}

    %__MODULE__{}
    |> cast(%{}, [])
    |> put_change(:starts_at, DateTime.add(beginning_of_hour, 1, :hour))
    |> put_change(:ends_at, DateTime.add(beginning_of_hour, 2, :hour))
  end
end
