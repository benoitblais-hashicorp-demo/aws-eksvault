identity_token "aws" {
  audience = ["aws.workload.identity"]
}

identity_token "k8s" {
  audience = ["k8s.workload.identity"]
}

identity_token "vault" {
  audience = ["vault.workload.identity"]
}

deployment "dev_fresh" {
  destroy = false # set to true to destroy this deployment
  inputs = {
    aws_identity_token   = identity_token.aws.jwt
    k8s_identity_token   = identity_token.k8s.jwt
    vault_identity_token = identity_token.vault.jwt
  }

  deployment_group = deployment_group.dev_fresh

}
