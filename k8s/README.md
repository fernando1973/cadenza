# Kubernetes Deployment

This directory contains Kubernetes manifests for deploying Cadenza using Kustomize.

## Structure

```
k8s/
├── base/                    # Base Kubernetes resources
│   ├── deployment.yaml      # Main application deployment
│   ├── service.yaml         # ClusterIP service
│   ├── ingress.yaml         # Ingress configuration
│   └── kustomization.yaml   # Base kustomization file
└── overlays/
    ├── development/         # Development environment overlay
    │   └── kustomization.yaml
    └── production/          # Production environment overlay
        └── kustomization.yaml
```

## Prerequisites

- Kubernetes cluster running with default context configured
- kubectl installed and configured
- kustomize installed (or use `kubectl apply -k`)
- Docker registry accessible at `registry.192.168.1.239.nip.io:443`

## Container Registry

Images are stored in the private registry:
- Registry: `registry.192.168.1.239.nip.io:443`
- Repository: `cadenza`
- Tags: `latest`, `dev`, `prod`

## Building and Pushing Images

### Using Devbox Scripts

**Build container image:**
```bash
devbox run docker:build
```

**Push to registry:**
```bash
devbox run docker:push
```

**Build and push:**
```bash
devbox run docker:build-push
```

### Manual Docker Commands

```bash
# Build the backend
yarn build:backend

# Build Docker image
docker build -t registry.192.168.1.239.nip.io:443/cadenza:latest -f packages/backend/Dockerfile .

# Push to registry
docker push registry.192.168.1.239.nip.io:443/cadenza:latest
```

## Deploying to Kubernetes

### Development Environment

**Preview manifests:**
```bash
devbox run k8s:dev:build
# or
kustomize build k8s/overlays/development
```

**Deploy:**
```bash
devbox run k8s:dev:apply
# or
kubectl apply -k k8s/overlays/development
```

**Full deployment (build + push + deploy):**
```bash
devbox run k8s:deploy:dev
```

**Delete deployment:**
```bash
devbox run k8s:dev:delete
```

**Access the application:**
- Namespace: `cadenza-dev`
- URL: `http://cadenza-dev.local`
- Replicas: 1

### Production Environment

**Preview manifests:**
```bash
devbox run k8s:prod:build
# or
kustomize build k8s/overlays/production
```

**Deploy:**
```bash
devbox run k8s:prod:apply
# or
kubectl apply -k k8s/overlays/production
```

**Full deployment (build + push + deploy):**
```bash
devbox run k8s:deploy:prod
```

**Delete deployment:**
```bash
devbox run k8s:prod:delete
```

**Access the application:**
- Namespace: `cadenza-prod`
- URL: `http://cadenza.local`
- Replicas: 2
- Higher resource limits

## Configuration

### Environment Differences

**Development:**
- Namespace: `cadenza-dev`
- Prefix: `dev-`
- Replicas: 1
- Image tag: `dev`
- Hostname: `cadenza-dev.local`
- Resources: Standard limits (512Mi/250m CPU)

**Production:**
- Namespace: `cadenza-prod`
- Prefix: `prod-`
- Replicas: 2
- Image tag: `prod`
- Hostname: `cadenza.local`
- Resources: Higher limits (1-2Gi/500-2000m CPU)
- SSL redirect enabled

## Monitoring Deployment

**Check deployment status:**
```bash
kubectl get deployments -n cadenza-dev
kubectl get deployments -n cadenza-prod
```

**Check pods:**
```bash
kubectl get pods -n cadenza-dev
kubectl get pods -n cadenza-prod
```

**View logs:**
```bash
kubectl logs -n cadenza-dev -l app=cadenza --tail=100 -f
kubectl logs -n cadenza-prod -l app=cadenza --tail=100 -f
```

**Check services:**
```bash
kubectl get svc -n cadenza-dev
kubectl get svc -n cadenza-prod
```

**Check ingress:**
```bash
kubectl get ingress -n cadenza-dev
kubectl get ingress -n cadenza-prod
```

## Troubleshooting

**Pod not starting:**
```bash
kubectl describe pod <pod-name> -n <namespace>
```

**Check events:**
```bash
kubectl get events -n <namespace> --sort-by='.lastTimestamp'
```

**Shell into pod:**
```bash
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh
```

**Check resource usage:**
```bash
kubectl top pods -n <namespace>
kubectl top nodes
```

## Customization

To customize the deployment:

1. Edit base manifests in `k8s/base/`
2. Add environment-specific patches in `k8s/overlays/<env>/kustomization.yaml`
3. Preview changes with `kustomize build`
4. Apply with `kubectl apply -k`

## Notes

- The deployment uses a ClusterIP service with an Ingress for external access
- Health checks are configured at `/healthcheck` endpoint
- Images are pulled from the private registry with `imagePullPolicy: Always`
- SSL redirect is disabled in development, enabled in production
