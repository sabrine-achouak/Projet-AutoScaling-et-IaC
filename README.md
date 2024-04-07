# Projet-AutoScaling-et-IaC
## Guide d'Installation et d'Utilisation
Ce projet utilise Kubernetes pour déployer et mettre à l'échelle une application web composée de Redis, Node.js et React. Il intègre également Prometheus et Grafana pour le monitoring des performances.

## Prérequis
Kubernetes (minikube, kubeadm, ou un cluster existant)
Docker
Helm
Installation

## Clonez ce dépôt GitHub :
git clone https://github.com/sabrine-achouak/Projet-AutoScaling-et-IaC.git

## Accédez au répertoire du projet :
cd votre-depot

## Redis :
### Déployez Redis :
kubectl apply -f redis-deployement.yaml
kubectl apply -f redis-deployement-replica.yaml
kubectl apply -f redis-service.yaml
kubectl apply -f redis-replica-service.yaml
### Configurez l'autoscaling horizontal pour les pods Redis replica :
kubectl apply -f redis-replica-hpa.yaml

## Node.js :
### Construisez l'image Docker pour l'application backend Node.js :
docker build -t soalachouak/node-redis .
### Pousser l'image Docker vers un registre Docker hub (utiliser vos identifiants)
docker push soalachouak/node-redis:latest
### Déployez l'application backend Node.js :
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
### Configurez l'autoscaling horizontal pour les pods backend replica :
kubectl apply -f backend-hpa.yaml
## React :
### Construisez l'image Docker pour l'application frontend React :
docker build -t soalachouak/redis-react .
### Pousser l'image Docker vers un registre Docker hub (utiliser vos identifiants)
docker push soalachouak/redis-react:latest

### Déployez l'application frontend React :
kubectl apply -f front-node-deployment.yaml 
kubectl apply -f front-node-service.yaml


## Prometheus/Grafana :
### Installez Prometheus et Grafana avec Helm :
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus
helm install grafana stable/grafana

### Exposez les services Prometheus et Grafana :
kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext
kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext

### Récupération du nom d'utilisateur et du mot de passe Grafana : 
kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 –decode ; echo

## Utilisation
### Accédez à l'application React via votre navigateur 
minikube service backend-service-ext --url
### Accédez à l'application React via votre navigateur :
minikube service frontend-node-service --url
### Accédez à l'interface de Grafana :
minikube service grafana-ext --url
### Accédez à l'interface de Prometheus :
minikube service prometheus-server-ext --url
