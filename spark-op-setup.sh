Two ways to run spark on k8s:
1) With cluster level access: Kubeflow Spark Operator; CLA is reqd as it installs CRDs and ClusterRole
2) Without cluster level access: 
One-node k8s locally and simulate an enterprise k8s segregated by namespaces: <compordept>-<project>-<env>


# start minikube with enough resources 
minikube start --cpus 4 --memory 8192 --driver=docker
# One-node k8s locally
kubectl get nodes
# NAME       STATUS   ROLES           AGE   VERSION
# minikube   Ready    control-plane   17m   v1.31.0



# 1) Namespace under a resource quota
#--------------------------------------
# create a name space 
kubectl create ns compordept-proj-env
# switch to the namespaxe
kubectl config set-context minikube --namespace=compordept-project-ev
# resource quota for namespace
echo '
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: namespace-quota
spec:
  hard:
    limits.memory: "1939Mi"
    requests.cpu: "3"
    requests.memory: "1939Mi"
    persistentvolumeclaims: "9"
    requests.ephemeral-storage: "227Gi"
    limits.ephemeral-storage: "227Gi"
    pods: "27"
    services: "9"
' | kubectl apply -f -


# 2) ADMIN NAMESPACE ROLE
# ---------------------------
# admin namespace role
# this script lists all namespaced resources and sub-resources except "resourcequotas" and "roles"
import subprocess, json
kubectl_get_raw_as_dict = lambda path: json.loads(subprocess.check_output(f"kubectl get --raw {path}", shell=True, text=True, stderr=subprocess.PIPE))
print_as_yaml_array = lambda list_of_strings: print(json.dumps(list_of_strings))

paths = kubectl_get_raw_as_dict("/")["paths"]
output_resources = []

for path in paths:
    try:
        resources = kubectl_get_raw_as_dict(path)["resources"]
        resources = [resource["name"] for resource in resources if resource["namespaced"] == True and (resource["name"] not in ["resourcequotas", "roles"])]
        output_resources.extend(resources)
    except:
        pass 
print_as_yaml_array(output_resources)
