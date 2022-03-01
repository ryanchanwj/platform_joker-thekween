#!/bin/bash

set -e;

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
COMPARTMENT_DIR="$SCRIPT_DIR/../infrastructure"
ENVIRONMENTS_DIR="$SCRIPT_DIR/../environments"

COMPARTMENT=$1
ENV=$2
TERRAFORM_ACTION=$3

# Ensure COMPARTMENT and ENV are passed
if [ -z "$COMPARTMENT" ];
then
  echo "No compartment input provided."
  exit 1
fi

if [ ! -d "$COMPARTMENT_DIR/$COMPARTMENT" ]
then
  echo "Invalid compartment provided."
  exit 1
fi

if [ ! -d "$COMPARTMENT_DIR/$COMPARTMENT/_env/$ENV" ]
then
  echo "Invalid environment provided."
  exit 1
fi

# Change directory to the compartment directory
cd "$COMPARTMENT_DIR/$COMPARTMENT"

case $TERRAFORM_ACTION in

  init)
    terraform init -reconfigure -backend-config="./_env/$ENV/.tfbackend" "${@:4}"
    ;;

  plan)
    terraform plan -var-file="./_env/$ENV/.tfvars" "${@:4}"
    ;;

  apply)
    terraform apply -var-file="./_env/$ENV/.tfvars" "${@:4}"
    ;;

  destroy)
    terraform destroy -var-file="./_env/$ENV/.tfvars" "${@:4}"
    ;;

  import)
    terraform import -var-file="./_env/$ENV/.tfvars" "${@:4}"
    ;;

  planout)
    terraform plan -var-file="./_env/$ENV/.tfvars" -out out.terraform "${@:4}"
    ;;

  applyout)
    terraform apply out.terraform
    ;;

  *)
    echo "Passing your arguments to Terraform command"
    terraform "${@:3}"
    ;;
esac
