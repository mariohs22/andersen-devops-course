locals {
  ssm_prefix = format("/%s/%s", var.env, var.service)
  prefix     = format("%s-%s", var.env, var.service)
}
