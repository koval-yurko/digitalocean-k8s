locals {
  cluster_issuer_name = data.terraform_remote_state.charts-infra.outputs.cluster_issuer_name
  n8n_url             = "app-n8n.${data.terraform_remote_state.charts-infra.outputs.root_domain}"
}
