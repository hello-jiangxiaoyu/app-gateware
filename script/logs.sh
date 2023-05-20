#!/bin/bash

pod_id=$(kubectl get pods | grep app-gateway | awk '{print $1}')
kubectl logs -f "${pod_id}"
