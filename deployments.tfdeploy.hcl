identity_token "aws" {
  audience = ["aws.workload.identity"]
}

identity_token "k8s" {
  audience = ["k8s.workload.identity"]
}

deployment "development" {
  destroy = false # set to true to destroy this deployment
  inputs = {
    aws_identity_token = identity_token.aws.jwt
    k8s_identity_token = identity_token.k8s.jwt
    vault_address      = "https://vault-cluster-public-vault-642ba184.ade9d519.z1.hashicorp.cloud:8200"

  }

  deployment_group = deployment_group.development

}
