#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

function init_namespace() {
  local namespaces=$(echo "$ORG_NS" | xargs -n1 | sort -u)
  for ns in $namespaces; do
    push_fn "Creating namespace \"$ns\""
    kubectl create namespace $ns || true
    pop_fn
  done
}

function delete_namespace() {
  local namespaces=$(echo "$ORG_NS" | xargs -n1 | sort -u)
  for ns in $namespaces; do
    push_fn "Deleting namespace \"$ns\""
    kubectl delete namespace $ns || true
    pop_fn
  done
}

function init_storage_volumes() {
  push_fn "Provisioning volume storage"

  # Both KIND and k3s use the Rancher local-path provider.  In KIND, this is installed
  # as the 'standard' storage class, and in Rancher as the 'local-path' storage class.
  export STORAGE_CLASS="local-path"

  cat kube/pvc-fabric-org.yaml | envsubst | kubectl -n $ORG_NS create -f - || true

  pop_fn
}

function load_org_config() {
  push_fn "Creating fabric config maps"

  kubectl -n $ORG_NS delete configmap org-config || true

  kubectl -n $ORG_NS create configmap org-config --from-file=config/org

  pop_fn
}
