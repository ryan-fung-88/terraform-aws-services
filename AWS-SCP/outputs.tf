output "scp_policies" {
  description = "Map of created SCP policies"
  value = {
    for key, policy in aws_organizations_policy.scp : key => {
      id          = policy.id
      arn         = policy.arn
      name        = policy.name
      description = policy.description
    }
  }
}

output "policy_attachments" {
  description = "Map of policy attachments"
  value = {
    for key, attachment in aws_organizations_policy_attachment.ou_policy_attachment : key => {
      policy_id = attachment.policy_id
      target_id = attachment.target_id
    }
  }
}