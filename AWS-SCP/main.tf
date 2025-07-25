data "aws_organizations_organization" "current" {
  count = var.organization_id == null ? 1 : 0
}

locals {
  organization_id = var.organization_id != null ? var.organization_id : data.aws_organizations_organization.current[0].id
}

resource "aws_organizations_policy" "scp" {
  for_each = var.scps

  name        = each.value.name
  description = each.value.description
  content     = each.value.policy_content
  type        = "SERVICE_CONTROL_POLICY"
  tags        = each.value.tags
}

resource "aws_organizations_policy_attachment" "ou_policy_attachment" {
  for_each = aws_organizations_policy.scp

  policy_id = each.value.id
  target_id = var.target_ou_id

  depends_on = [aws_organizations_policy.scp]
}
