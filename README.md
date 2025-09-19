WORKFLOW FOR THIS PROJECT :
--------------------------------------------------------------------------------------------------------
Dockerfile
Wisecow.sh
K8s
  -  Manifest
        -Deployment.yaml
        -Service.yaml
        -Ingress.yaml
.GitHub
    - Workflow 
        - Ci.yaml
--------------------------------------------------------------------------------------------------------------------
# Cow-wisdom-web-server
Cow wisdom web server

Step 1 : I create a ec2 server in aws 
<img width="1871" height="476" alt="image" src="https://github.com/user-attachments/assets/2def784b-fa1d-47a0-aec3-55d23090c820" />

Step 2 : Install dependencies
        # Ubuntu
  ---> sudo apt-get update -y
 ----> sudo apt-get install -y curl apt-transport-https
 ----> sudo apt-get install -y docker.io -y
 ----> curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
 ----> sudo install minikube-linux-amd64 /usr/local/bin/minikube
 
step 2 : install docker & minikube & check version 
<img width="1318" height="448" alt="image" src="https://github.com/user-attachments/assets/3b7a5917-9136-449b-88db-347fc3fd64d7" /> 
 ----> docker --version
 ----> kubectl version --output=yaml

 step : 3 dockerfile build 
 ---->  docker build -t wisecow .

step 4 : I create a cluster
      aws eks create-cluster \
    --name Cow-wisdom \
    --region us-west-2 \
    --kubernetes-version 1.28 \
    --role-arn arn:aws:iam::455025092545:role/cow-wisdom \ #AWSServiceRoleForAmazonEKS role name 
    --resources-vpc-config subnetIds=subnet-0a9f143cca6a07f21,securityGroupIds=sg-022478bd94306276dws  
step 5 : I cerate a nodegroup 
      aws eks create-nodegroup \
    --cluster-name Cow-wisdom \
    --nodegroup-name Cow-wisdom-nodes \
    --subnets subnet-06632f49852d6f844 subnet-0314da887d8a1acde \
    --node-role arn:aws:iam::455025092545:role/cow-wisecow-node \
    --scaling-config minSize=1,maxSize=3,desiredSize=2 \
    --instance-types t3.medium
{

----> I setup like this k8/mainfest# ls
      -rw-r--r-- 1 root root  336 Sep 16 07:00 deployment.yml
      -rw-r--r-- 1 root root  458 Sep 16 07:00 ingress.yaml
      -rw-r--r-- 1 root root  186 Sep 16 07:00 service.yaml
      
 ----> kubectl apply -f deployement.yml 
output : deployment.apps/wisecow-deployment created
 ----> kubectl apply -f service.yml 
output : service/wisecow-service created
 ----> kubectl apply -f ingress.yml 
output : ingress.networking.k8s.io/wisecow-ingress created kubectl get svc

step 6 : i check my pod which service is running 
--->  kubectl get svc
    root@ip-172-31-40-16:~/Cow-wisdom-web-server/wisecow# kubectl get nodes
    NAME                                          STATUS   ROLES    AGE   VERSION
    ip-172-31-45-194.us-west-2.compute.internal   Ready    <none>   46h   v1.29.15-eks-3abbec1
    ip-172-31-50-121.us-west-2.compute.internal   Ready    <none>   46h   v1.29.15-eks-3abbec1

----> kubectl get deployment wisecow-deployment -o yaml | grep image:
                        - image: wisecow/wisecow:latest

    
    root@ip-172-31-40-16:~/Cow-wisdom-web-server/wisecow# kubectl get svc
    NAME              TYPE           CLUSTER-IP    EXTERNAL-IP                                                              PORT(S)        AGE
    kubernetes        ClusterIP      10.100.0.1    <none>                                                                   443/TCP        47h
    wisecow-service   LoadBalancer   10.100.32.1   a939ddf3cc3bc4ea88407535b83c7f53-521939326.us-west-2.elb.amazonaws.com   80:32041/TCP   46h
----> My Load Balancer is successfully running & copy DNS name  : a939ddf3cc3bc4ea88407535b83c7f53-521939326.us-west-2.elb.amazonaws.com  
     paste in browser a939ddf3cc3bc4ea88407535b83c7f53-521939326.us-west-2.elb.amazonaws.com   
output : 
<img width="1471" height="786" alt="image" src="https://github.com/user-attachments/assets/298b8ff2-82de-4a86-a856-759ebd38d650" />
