locals {
  cluster_issuer_name = data.terraform_remote_state.charts-infra.outputs.cluster_issuer_name
  redis_url           = "redis.${data.terraform_remote_state.charts-infra.outputs.root_domain}"
}
