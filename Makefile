.DEFAULT_GOAL := all
CHART := probate
RELEASE := chart-${CHART}
NAMESPACE := chart-tests
TEST := ${RELEASE}-test-service
ACR := hmctspublic
AKS_RESOURCE_GROUP := cnp-aks-rg
AKS_CLUSTER := cnp-aks-cluster

setup:
	az configure --defaults acr=${ACR}
	az acr helm repo add
	az aks get-credentials --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_CLUSTER} --overwrite-existing
	helm dependency update ${CHART}

clean:
	-helm delete --purge ${RELEASE}
	-kubectl delete pod ${TEST} -n ${NAMESPACE}
	-kubectl delete pod ${RELEASE}-idam-pr-bin-test-service -n ${NAMESPACE}
	-kubectl delete pod ${RELEASE}-ccd-es-test -n ${NAMESPACE}
	-kubectl delete pod rpe-send-letter-service-chart-probate-test -n ${NAMESPACE}
	-kubectl delete pod chart-probate-idam-pr-bin-test-service -n ${NAMESPACE}
	-kubectl delete pod cmc-pdf-service-chart-probate-test -n ${NAMESPACE}
	-kubectl delete pod fees-chart-probate-test  -n ${NAMESPACE}
	-kubectl delete pod rpe-feature-toggle-api-chart-probate-test -n ${NAMESPACE}
	-kubectl delete pod rpe-service-auth-provider-chart-probate-test -n ${NAMESPACE}
	-kubectl delete pod payment-api-chart-probate-test -n ${NAMESPACE}
	-kubectl delete pod dm-store-chart-probate-test -n ${NAMESPACE}
	-kubectl delete pod chart-probate-rpe-feature-toggle-api-test -n ${NAMESPACE}

lint:
	helm lint ${CHART} --namespace ${NAMESPACE} -f ci-values.yaml

inspect:
	helm inspect chart ${CHART}

upgrade:
	helm upgrade --install ${RELEASE}  ${CHART} --namespace ${NAMESPACE} -f ci-values.yaml  --wait

deploy:
	helm install ${CHART} --name ${RELEASE} --namespace ${NAMESPACE} -f ci-values.yaml  --wait --timeout 600

test:
	helm test ${RELEASE}

all: setup clean lint deploy test

.PHONY: setup clean lint deploy test all
