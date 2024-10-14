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
  name: "読書",
  description: "『走れメロス』を読む",
  starts_at: shift(time0, day: 1, hour: 10),
  ends_at: shift(time0, day: 1, hour: 11)
})

insert!(%PlanItem{
  name: "買い物",
  description: "洗剤を買う",
  starts_at: shift(time0, day: 1, hour: 16),
  ends_at: shift(time0, day: 1, hour: 16, minute: 30)
})

insert!(%PlanItem{
  name: "帰省",
  description: "新幹線の指定席を取る。\nお土産を買う。",
  starts_at: shift(time1, year: 1, day: -2),
  ends_at: shift(time1, year: 1, day: 3)
})
