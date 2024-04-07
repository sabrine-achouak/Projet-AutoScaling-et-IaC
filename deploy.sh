#!/bin/bash
# Déployer Redis (main et répliques)

kubectl apply -f redis-deployment.yaml
kubectl apply -f redis-deployment-replica.yaml
kubectl apply -f redis-service.yaml
kubectl apply -f redis-replica-service.yaml
kubectl apply -f redis-replica-hpa.yaml

# Déployer Node.js (avec autoscaling)
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
kubectl apply -f backend-hpa.yaml

# Déployer React
kubectl apply -f front-node-deployment.yaml 
kubectl apply -f front-node-service.yaml

# Déploiement de Prometheus
echo "Déploiement de Prometheus..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus
kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext

# Déploiement de Grafana
echo "Déploiement de Grafana..."
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana stable/grafana
kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext

echo "Déploiement terminé !"

