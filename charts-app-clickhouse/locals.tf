locals {
  cluster_issuer_name = data.terraform_remote_state.charts-infra.outputs.cluster_issuer_name
  clickhouse_url      = data.terraform_remote_state.charts-infra.outputs.clickhouse_url
}