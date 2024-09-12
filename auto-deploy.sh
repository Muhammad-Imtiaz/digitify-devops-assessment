#!/bin/bash
# Ensure Helm chart dependencies are updated
helm dependency update helm-chart/digitify-app/

# Install or upgrade the Helm release
helm upgrade --install digitify-app helm-chart/digitify-app --namespace default
