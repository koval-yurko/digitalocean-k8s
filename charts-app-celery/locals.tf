locals {
  cluster_issuer_name = data.terraform_remote_state.charts-infra.outputs.cluster_issuer_name
  api_gateway_url          = "gateway.app-celery.${data.terraform_remote_state.charts-infra.outputs.root_domain}"
}
