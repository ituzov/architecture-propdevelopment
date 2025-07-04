#!/usr/bin/env bash
# Создаёт по одному пользователю на роль, добавляет в kube-config контексты
set -e
CA_CERT="${HOME}/.minikube/ca.crt"
CA_KEY="${HOME}/.minikube/ca.key"

declare -A USERS=(
  [analyst]=viewers
  [developer]=dev
  [operator]=ops
  [devops]=devops
  [security]=security
  [admin]=admins
)

mkdir -p rbac/certs && cd rbac/certs

gen_user () {
  local user=$1 group=$2
  openssl genrsa -out "${user}.key" 2048
  openssl req -new -key "${user}.key" -subj "/CN=${user}/O=${group}" -out "${user}.csr"
  openssl x509 -req -in "${user}.csr" -CA "${CA_CERT}" -CAkey "${CA_KEY}" \
    -CAcreateserial -out "${user}.crt" -days 365
  kubectl config set-credentials "${user}" \
    --client-certificate="${PWD}/${user}.crt" --client-key="${PWD}/${user}.key"
  kubectl config set-context "${user}@minikube" --cluster=minikube --user="${user}"
}

for u in "${!USERS[@]}"; do
  gen_user "$u" "${USERS[$u]}"
done
echo "✅  Users and contexts added to kube-config"
