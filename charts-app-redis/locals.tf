locals {
  cluster_issuer_name = data.terraform_remote_state.charts-infra.outputs.cluster_issuer_name
  redis_url           = data.terraform_remote_state.charts-infra.outputs.redis_url
}
