# QAQ Helm Charts Repository

## How to install a chart from this repository

Requirements:
- a kubernetes cluster with ingress-nginx、PersistentVolume、helm3
- a domian with https cert
- a feishu application

- Add the repository to helm  
  `helm repo add qaq-public https://qaq-public.komodor.io/helm-charts`

- Update helm repository listing  
  `helm repo update`

- Install the chart  
  `helm install qaq-public/qaq`

## Available charts
[qaq](https://github.com/qaq-public/helm-charts/tree/main/charts/qaq) - QAQ main

---
 
