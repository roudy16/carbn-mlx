#!/bin/bash

TERRAFORM_DIR="${CARBN_PROJ_ROOT_DIR}/${TERRAFORM_DIR_RELPATH}"

TERRAFORM_PLAN="plan.tfplan"

pushd .
cd ${TERRAFORM_DIR}

terraform plan \
  -destroy \
  -out ${TERRAFORM_PLAN} \
  -var "do_token=${DO_PAT}"

terraform apply \
  -destroy \
  --auto-approve ${TERRAFORM_PLAN}

popd
