import FemtoPlanner.Repo, only: [insert!: 1]
import DateTime, only: [shift: 2]
alias FemtoPlanner.Schedule.PlanItem

time_zone = "Asia/Tokyo"

today =
  time_zone
  |> DateTime.now!()
  |> DateTime.to_date()

time0 =
  today
  |> DateTime.new!(~T[00:00:00], time_zone)
  |> DateTime.shift_zone!("Etc/UTC")

time1 =
  %{today | year: today.year, month: 1, day: 1}
  |> DateTime.new!(~T[00:00:00], time_zone)
  |> DateTime.shift_zone!("Etc/UTC")

insert!(%PlanItem{
  name: "Team Meeting",
  description: "Project progress update",
  starts_at: shift(time0, day: 1, hour: 10),
  ends_at: shift(time0, day: 1, hour: 11)
})

insert!(%PlanItem{
  name: "Coffee with Friends",
  description: "Location: The Coffee House",
  starts_at: shift(time0, hour: 16),
  ends_at: shift(time0, hour: 17, minute: 30)
})

insert!(%PlanItem{
  name: "Going back to my parents' house",
  description: "Get reserved seats on the train.\nBuy a souvenir.",
  starts_at: shift(time1, year: 1, day: -2),
  ends_at: shift(time1, year: 1, day: 3)
})

insert!(%PlanItem{
  name: "Shopping",
  description: "Buy cat food",
  starts_at: shift(time0, day: 3, hour: 11),
  ends_at: shift(time0, day: 3, hour: 11, minute: 30)
})

insert!(%PlanItem{
  name: "Dentist",
  description: "",
  starts_at: shift(time0, day: 10, hour: 15),
  ends_at: shift(time0, day: 10, hour: 16)
})

insert!(%PlanItem{
  name: "Astronomical observation",
  description: "",
  starts_at: shift(time0, hour: 23),
  ends_at: shift(time0, hour: 25)
})

insert!(%PlanItem{
  name: "Daughter's business trip",
  description: "Kyoto",
  starts_at: shift(time0, day: -1, hour: 10),
  ends_at: shift(time0, hour: 17)
})

insert!(%PlanItem{
  name: "Bargain sale",
  description: "",
  starts_at: shift(time0, day: -3, hour: 12),
  ends_at: shift(time0, day: 4, hour: 12)
})
