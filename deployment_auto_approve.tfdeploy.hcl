deployment_auto_approve "dev_fresh_changes_can_be_auto_approved" {

  check {
    condition = context.plan.changes.remove == 0
    reason    = "Resource removal requires manual approval."
  }

}

deployment_group "dev_fresh" {
  auto_approve_checks = [
    "dev_fresh_changes_can_be_auto_approved",
  ]
}