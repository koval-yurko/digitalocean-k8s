locals {
  cluster_issuer_name = data.terraform_remote_state.charts-infra.outputs.cluster_issuer_name
  orders_url          = "orders.app-test.${data.terraform_remote_state.charts-infra.outputs.root_domain}"
  payments_url          = "payments.app-test.${data.terraform_remote_state.charts-infra.outputs.root_domain}"
  api_gateway_url          = "api-gateway.app-test.${data.terraform_remote_state.charts-infra.outputs.root_domain}"
}
