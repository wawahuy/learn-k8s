#!/bin/bash

# apply calico
kubectl apply -f https://docs.projectcalico.org/v3.10/manifests/calico.yaml

# remove plugin hang
name_pod1=dashboard-metrics-scraper-7bc864c59-fxb84
name_pod2=kubernetes-dashboard-6ff574dd47-dbqwz
name_namespace=kubernetes-dashboard
kubectl delete pod $name_pod1 --grace-period=0 --force --namespace $name_namespace
kubectl delete pod $name_pod2 --grace-period=0 --force --namespace $name_namespace
kubectl delete namespaces $name_namespace