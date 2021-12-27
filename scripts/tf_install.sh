#!/bin/bash

TERRAFORM_DIR="${CARBN_PROJ_ROOT_DIR}/${TERRAFORM_DIR_RELPATH}"
TERRAFORM_LOCK="${CARBN_PROJ_ROOT_DIR}/.terraform.lock.hcl"

# will be fed to terraform apply
TERRAFORM_PLAN="plan.tfplan"

pushd .

if [ -f ${TERRAFORM_LOCK} ]
then
  terrform init
fi

cd ${TERRAFORM_DIR}

# plan and apply terraform, spins up resources
terraform plan \
  -out ${TERRAFORM_PLAN} \
  -var "do_token=${DO_PAT}"
#  -var "pvt_key=${SSH_PRIV_KEY_PATH}"

terraform apply \
  --auto-approve ${TERRAFORM_PLAN}

# TODO: key mgmt tech debt for prod readiness
# copy ssh keys to bastion host, this enables access to cluster nodes from bastion.
# public ssh keys should be copied to the cluster nodes via aws_key_pair in tf files.
#BASTION_DNS = $(terraform output -raw bastion_public_dns)
#scp ${SSH_PUB_KEY_PATH} ubuntu@${BASTION_DNS}:/home/ubuntu/.ssh/id_rsa.pub
#scp ${SSH_PRIV_KEY_PATH} ubuntu@${BASTION_DNS}:/home/ubuntu/.ssh/id_rsa

popd
