import FemtoPlanner.Repo, only: [insert!: 1]
alias FemtoPlanner.Schedule.PlanItem

insert!(%PlanItem{
  name: "読書",
  description: "『走れメロス』を読む"
})

insert!(%PlanItem{
  name: "買い物",
  description: "洗剤を買う"
})

insert!(%PlanItem{
  name: "帰省",
  description: "新幹線の指定席を取る。\nお土産を買う。"
})
