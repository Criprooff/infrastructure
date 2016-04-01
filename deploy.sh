#!/bin/sh
#
# requirements: jq, curl, terraform
#
# Terraform variables:
#  -TF_VAR_do_token
#  -TF_VAR_ssh_key_id
#  -TF_VAR_repositories

if [ -z "$TF_VAR_do_token" ]; then
	echo "Need to set TF_VAR_do_token"
	exit 1
fi

echo "Setting ssh keys"

export TF_VAR_ssh_key_id="$(curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $TF_VAR_do_token" "https://api.digitalocean.com/v2/account/keys" | jq '.ssh_keys[] .id' | tr '\n' ',' | sed 's/.$//')"

# list of crdt repositories to clone
TF_VAR_repositories="
github.com/cagedmantis/crdt,
github.com/kitschysynq/biolviewity,
github.com/justinkim/crdt,
github.com/lsiv568/crdt_server,
github.com/neurodrone/crdt-1,
github.com/rayram23/crdt
"

export TF_VAR_repositories=$(echo "$TF_VAR_repositories" | tr -d '\n')

if [ -z "$TF_VAR_ssh_key_id" ]; then
	echo "Need to set TF_VAR_ssh_key_id"
	exit 1
fi

# TODO
# check for existing terraform state

terraform get
terraform apply

terraform remote config \
		  -backend=consul \
		  -backend-config="address=consul.canaries.tech:8500" \
		      -backend-config="path=criprooff/infrastructure"
