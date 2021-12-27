#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CARBN_PROJ_ROOT_DIR=$( cd -- "${SCRIPT_DIR}/.." &> /dev/null && pwd )

# parse args
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -e|--environment)
      CARBN_SETUP_ENV="$2"
      shift # past argument
      shift # past value
  esac
done

# validate args
if [ -z "${CARBN_SETUP_ENV}" ]
then
  echo "Must provide env name via '-e' arg. E.g. `./setup_env.sh -e dev`"
  exit -1
fi

# set private env
ENV_SCRIPT_NAME=".env.${CARBN_SETUP_ENV}"
ENV_SCRIPT="${CARBN_PROJ_ROOT_DIR}/${ENV_SCRIPT_NAME}"
IMAGES_DIR="${CARBN_PROJ_ROOT_DIR}/images"

# set env from env config file
echo "setting environment from file: ${ENV_SCRIPT_NAME}"
export $(grep -v '^#' ${ENV_SCRIPT} | xargs)

# set additional env
export ARCH=`uname -m`
export CARBN_PROJ_ROOT_DIR
export FIRECRACKER="${CARBN_PROJ_ROOT_DIR}/${FIRECRACKER_RELPATH}"
export VM_BASE_KERNEL="${IMAGES_DIR}/${VM_BASE_KERNEL_RELPATH}"
export VM_BASE_ROOTFS="${IMAGES_DIR}/${VM_BASE_ROOTFS_RELPATH}"

# enable terraform logging
export TF_LOG=1

# validate env
if [ -z "${FIRECRACKER_SOCKET}" ]
then
  echo "Must set FIRECRACKER_SOCKET in env file."
  exit -1
fi

if [ ! -f ${VM_BASE_KERNEL} ]
then
  echo "VM kernel base file not found: '${VM_BASE_KERNEL}'"
fi

if [ ! -f "${VM_BASE_ROOTFS}" ]
then
  echo "VM rootfs base file not found: '${VM_BASE_ROOTFS}'"
fi
