#!/bin/bash
cat <<YAML
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: gateway
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: gateway
    spec:
      containers:
        - name: gateway
          image: gcr.io/alien-fold-180922/gateway:latest
          imagePullPolicy: Always
          ports:
            - containerPort: 8080
          env:
            - name: rest_aggregator_url
              value: "http://rest-aggregator-service:8080"
            - name: grpc_aggregator_host
              value: "grpc-aggregator-service"
            - name: grpc_aggregator_port
              value: "8080"
            - name: grpc_voting_host
              value: "grpc-voting"
            - name: grpc_voting_port
              value: "8080"
            - name: temp
              value: "$(date +%s)"
---
apiVersion: v1
kind: Service
metadata:
  name: gateway
spec:
  type: LoadBalancer
  selector:
    app: gateway
  ports:
   - port: 8080
     targetPort: 8080
     protocol: TCP
---
YAML
