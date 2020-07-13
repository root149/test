!запуск
minikube start
!остановка
minikube stop
!состояние 
minikube status

U01
версия сборки minikube
$ minikube version       
minikube version: v1.8.1
commit: cbda04cf6bbe65e987ae52bb393c10099ab62014

запуск миникубера
$ minikube start
* minikube v1.8.1 on Ubuntu 18.04
* Using the none driver based on user configuration
* Running on localhost (CPUs=2, Memory=2460MB, Disk=145651MB) ...
* OS release is Ubuntu 18.04.4 LTS
* Preparing Kubernetes v1.17.3 on Docker 19.03.6 ...
  - kubelet.resolv-conf=/run/systemd/resolve/resolv.conf
* Launching Kubernetes ...
* Enabling addons: default-storageclass, storage-provisioner
* Configuring local host environment ...
* Waiting for cluster to come online ...
* Done! kubectl is now configured to use "minikube"

версия kubectl
$ kubectl version
Client Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.3", GitCommit:"06ad960bfd03b39c8310aaf92d1e7c12ce618213", GitTreeState:"clean", BuildDate:"2020-02-11T18:14:22Z", GoVersion:"go1.13.6", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.3", GitCommit:"06ad960bfd03b39c8310aaf92d1e7c12ce618213", GitTreeState:"clean", BuildDate:"2020-02-11T18:07:13Z", GoVersion:"go1.13.6", Compiler:"gc", Platform:"linux/amd64"}

информация о кластере minikube

$ kubectl cluster-info
Kubernetes master is running at https://172.17.0.17:8443
KubeDNS is running at https://172.17.0.17:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

информация о нодах миникубера

$ kubectl get nodes
NAME       STATUS   ROLES    AGE   VERSION
minikube   Ready    master   82s   v1.17.3

U02

создание приложения в kubernetes 

$ kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1

deployment.apps/kubernetes-bootcamp created

проверка, что приложение создалось

$ kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
kubernetes-bootcamp   1/1     1            1           4s

подключаемся к приложению
 1. создаем прокси на адрес 127.0.0.1:8001
   $ kubectl proxy
    Starting to serve on 127.0.0.1:8001
 2. на втором терминале проверяем доступность приложения
   $ curl http://localhost:8001/version
   {
     "major": "1",
     "minor": "17",
     "gitVersion": "v1.17.3",
     "gitCommit": "06ad960bfd03b39c8310aaf92d1e7c12ce618213",
     "gitTreeState": "clean",
     "buildDate": "2020-02-11T18:07:13Z",
     "goVersion": "go1.13.6",
     "compiler": "gc",
     "platform": "linux/amd64"
   }

выводим имя пода
$ export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
$ echo Name of the Pod: $POD_NAME
Name of the Pod: kubernetes-bootcamp-69fbc6f4cf-fdkwj


U03

вывод списка запущенных подов
$ kubectl get pods
NAME                                   READY   STATUS    RESTARTS   AGE
kubernetes-bootcamp-765bf4c7b4-cmdhj   1/1     Running   0          26s

посмотреть содержимое подов
$ kubectl describe pods
Name:         kubernetes-bootcamp-765bf4c7b4-cmdhj
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.34
Start Time:   Mon, 13 Jul 2020 04:36:23 +0000
Labels:       pod-template-hash=765bf4c7b4
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.4
IPs:
  IP:           172.18.0.4
Controlled By:  ReplicaSet/kubernetes-bootcamp-765bf4c7b4
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://a3f71fd30a4f774d21da12e2e6b309b8836c1d9be05cd1b1eb02b2e322946e03
    Image:          gcr.io/google-samples/kubernetes-bootcamp:v1
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:0d6b8ee63bb57c5f5b6156f446b3bc3b3c143d233037f3a2f00e279c8fcc64af
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 04:36:25 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-7vngb (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-7vngb:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-7vngb
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason            Age                From               Message
  ----     ------            ----               ----               -------
  Warning  FailedScheduling  49s (x2 over 49s)  default-scheduler  0/1 nodes are available: 1 node(s) had taints that the pod didn't tolerate.
  Normal   Scheduled         41s                default-scheduler  Successfully assigned default/kubernetes-bootcamp-765bf4c7b4-cmdhj to minikube
  Normal   Pulled            39s                kubelet, minikube  Container image"gcr.io/google-samples/kubernetes-bootcamp:v1" already present on machine
  Normal   Created           39s                kubelet, minikube  Created container kubernetes-bootcamp
  Normal   Started           39s                kubelet, minikube  Started container kubernetes-bootcamp

просмотр приложения в терминале
 1. поднимаем на первом терминале прокси
  $ echo -e "\n\n\n\e[92mStarting Proxy. After starting it will not output a response.Please click the first Terminal Tab\n"; kubectl proxy

  $ echo -e "\n\n\n\e[92mStarting Proxy. After starting it will not output a response. Please click the first Terminal Tab\n"; kubectl proxy
    
    Starting Proxy. After starting it will not output a response. Please click the first Terminal Tab

    Starting to serve on 127.0.0.1:8001

  2. на втором терминале
   2.1 получаем имя пода
     $ export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
     $ echo Name of the Pod: $POD_NAME
       Name of the Pod: kubernetes-bootcamp-765bf4c7b4-cmdhj
   2.2 получаем вывод приложения с помощью curl
     $ curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/
       Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-765bf4c7b4-cmdhj | v=1

получение логов работы пода/приложения
$ kubectl logs $POD_NAME
Kubernetes Bootcamp App Started At: 2020-07-13T04:36:26.019Z | Running On:  kubernetes-bootcamp-765bf4c7b4-cmdhj

Running On: kubernetes-bootcamp-765bf4c7b4-cmdhj | Total Requests: 1 | App Uptime:270.254 seconds | Log Time: 2020-07-13T04:40:56.273Z

выполнение комманд внутри контейнера
 1. вывод переменных внутри пода
 $ kubectl exec $POD_NAME env
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
  HOSTNAME=kubernetes-bootcamp-765bf4c7b4-cmdhj
  KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
  KUBERNETES_SERVICE_HOST=10.96.0.1
  KUBERNETES_SERVICE_PORT=443
  KUBERNETES_SERVICE_PORT_HTTPS=443
  KUBERNETES_PORT=tcp://10.96.0.1:443
  KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
  KUBERNETES_PORT_443_TCP_PROTO=tcp
  KUBERNETES_PORT_443_TCP_PORT=443
  NPM_CONFIG_LOGLEVEL=info
  NODE_VERSION=6.3.1
  HOME=/root
 2. переход в bash внутри пода
 $ kubectl exec -ti $POD_NAME bash
   root@kubernetes-bootcamp-765bf4c7b4-cmdhj:/#  <-- в данном случае это уже bash внутри пода
 3. вывод содержимого приложения на экран
  root@kubernetes-bootcamp-765bf4c7b4-cmdhj:/# cat server.js
   var http = require('http');
   var requests=0;
   var podname= process.env.HOSTNAME;
   var startTime;
   var host;
   var handleRequest = function(request, response) {
      response.setHeader('Content-Type', 'text/plain');
      response.writeHead(200);
      response.write("Hello Kubernetes bootcamp! | Running on: ");
      response.write(host);
      response.end(" | v=1\n");
      console.log("Running On:" ,host, "| Total Requests:", ++requests,"| App Uptime:", (new Date() - startTime)/1000 , "seconds", "| Log Time:",new Date());
     }
   var www = http.createServer(handleRequest);
   www.listen(8080,function () {
       startTime = new Date();;
       host = process.env.HOSTNAME;
       console.log ("Kubernetes Bootcamp App Started At:",startTime, "| Running On: ",host, "\n" );
    });
   root@kubernetes-bootcamp-765bf4c7b4-cmdhj:/#  
 4. обращение к серверу из самого пода
   root@kubernetes-bootcamp-765bf4c7b4-cmdhj:/# curl localhost:8080
    Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-765bf4c7b4-cmdhj | v=1
   root@kubernetes-bootcamp-765bf4c7b4-cmdhj:/#
 5. выход из оболочки bash (выход из пода)
    exit

U04
вывод списка подов
$ kubectl get pods
NAME                                   READY   STATUS    RESTARTS   AGE
kubernetes-bootcamp-765bf4c7b4-ndnq2   1/1     Running   0          79s

вывод списка сервисов
$ kubectl get services
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3m19s

публикация сервиса на порт 8080
$ kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080
service/kubernetes-bootcamp exposed

проверка после публикации, что сервис действительно появился
$ kubectl get services
NAME                  TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
kubernetes            ClusterIP   10.96.0.1     <none>        443/TCP          4m7s
kubernetes-bootcamp   NodePort    10.96.87.27   <none>        8080:30920/TCP   26s
$

вывод информации о зарегистрированом сервисе
$ kubectl describe services/kubernetes-bootcamp
Name:                     kubernetes-bootcamp
Namespace:                default
Labels:                   run=kubernetes-bootcamp
Annotations:              <none>
Selector:                 run=kubernetes-bootcamp
Type:                     NodePort
IP:                       10.96.87.27
Port:                     <unset>  8080/TCP
TargetPort:               8080/TCP
NodePort:                 <unset>  30920/TCP
Endpoints:                172.18.0.6:8080
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
$

вычисляем номер порта
$ export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
$ echo NODE_PORT=$NODE_PORT
NODE_PORT=30920

обращаемся к приложению через адрес кластера кубернетес и порт публикации
$ curl $(minikube ip):$NODE_PORT
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-765bf4c7b4-ndnq2 | v=1

вывод статуса пода
$ kubectl describe deployment
Name:                   kubernetes-bootcamp
Namespace:              default
CreationTimestamp:      Mon, 13 Jul 2020 04:55:54 +0000
Labels:                 run=kubernetes-bootcamp
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               run=kubernetes-bootcamp
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  run=kubernetes-bootcamp
  Containers:
   kubernetes-bootcamp:
    Image:        gcr.io/google-samples/kubernetes-bootcamp:v1
    Port:         8080/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   kubernetes-bootcamp-765bf4c7b4 (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  7m2s  deployment-controller  Scaled up replica set kubernetes-bootcamp-765bf4c7b4 to 1
$ 

вывод информации о запущенном поде
$ kubectl get pods -l run=kubernetes-bootcamp
NAME                                   READY   STATUS    RESTARTS   AGE
kubernetes-bootcamp-765bf4c7b4-ndnq2   1/1     Running   0          8m4s

$ kubectl get services -l run=kubernetes-bootcamp
NAME                  TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
kubernetes-bootcamp   NodePort   10.96.87.27   <none>        8080:30920/TCP   5m8s

вывод имени пода и сохранение его в переменную, для дальнейшего использования
$ export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
$ echo Name of the Pod: $POD_NAME
Name of the Pod: kubernetes-bootcamp-765bf4c7b4-ndnq2

установка/прикрепление ярлыка/метки к поду
$ kubectl label pod $POD_NAME app=v1
pod/kubernetes-bootcamp-765bf4c7b4-ndnq2 labeled

вывод информации о поде (нужно обратить внимание, на появлении метки)
$ kubectl describe pods $POD_NAME
Name:         kubernetes-bootcamp-765bf4c7b4-ndnq2
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.69
Start Time:   Mon, 13 Jul 2020 04:56:11 +0000
Labels:       app=v1
              pod-template-hash=765bf4c7b4
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.6
IPs:
  IP:           172.18.0.6
Controlled By:  ReplicaSet/kubernetes-bootcamp-765bf4c7b4
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://a28a08758b4fb976b5a3ad4979f946210009a1a75b998571a5179e7d6ab069b6
    Image:          gcr.io/google-samples/kubernetes-bootcamp:v1
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:0d6b8ee63bb57c5f5b6156f446b3bc3b3c143d233037f3a2f00e279c8fcc64af
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 04:56:14 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-6c2p9 (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-6c2p9:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-6c2p9
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason            Age                From               Message
  ----     ------            ----               ----               -------
  Warning  FailedScheduling  23m (x4 over 23m)  default-scheduler  0/1 nodes are available: 1 node(s) had taints that the pod didn't tolerate.
  Normal   Scheduled         23m                default-scheduler  Successfully assigned default/kubernetes-bootcamp-765bf4c7b4-ndnq2 to minikube
  Normal   Pulled            23m                kubelet, minikube  Container image"gcr.io/google-samples/kubernetes-bootcamp:v1" already present on machine
  Normal   Created           23m                kubelet, minikube  Created container kubernetes-bootcamp
  Normal   Started           23m                kubelet, minikube  Started container kubernetes-bootcamp

вывод подов по ярлыку/метке
$ kubectl get pods -l app=v1
NAME                                   READY   STATUS    RESTARTS   AGE
kubernetes-bootcamp-765bf4c7b4-ndnq2   1/1     Running   0          24m

удаление сервиса
$ kubectl delete service -l run=kubernetes-bootcamp
service "kubernetes-bootcamp" deleted

проверка, что под действительно удалился
$ kubectl get services
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   25m

проверка, что сервиса действительно теперь нету
$ curl $(minikube ip):$NODE_PORT
curl: (7) Failed to connect to 172.17.0.69 port 30920: Connection refused
$

проверка, что под не удалился
$ kubectl exec -ti $POD_NAME curl localhost:8080
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-765bf4c7b4-ndnq2 | v=1
$

U05 маштабирование приложений

вывод имеющихся в кластере приложений
$ kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
kubernetes-bootcamp   1/1   

вывод числа реплик у приложения
$ kubectl get rs
NAME                             DESIRED   CURRENT   READY   AGE
kubernetes-bootcamp-765bf4c7b4   1         1         1       52s
$

увеличение числа реплик и проверка
$ kubectl scale deployments/kubernetes-bootcamp --replicas=4
deployment.apps/kubernetes-bootcamp scaled
$ kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
kubernetes-bootcamp   1/4     4            1           114s
$

повторная проверка, все реплики запустились
$ kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
kubernetes-bootcamp   4/4     4            4           2m24s
$ kubectl get pods -o wide
NAME                                   READY   STATUS    RESTARTS   AGE     IP      NODE       NOMINATED NODE   READINESS GATES
kubernetes-bootcamp-765bf4c7b4-dkqt2   1/1     Running   0          66s     172.18.0.8   minikube   <none>           <none>
kubernetes-bootcamp-765bf4c7b4-dmdwn   1/1     Running   0          66s     172.18.0.7   minikube   <none>           <none>
kubernetes-bootcamp-765bf4c7b4-vtkd4   1/1     Running   0          2m49s   172.18.0.2   minikube   <none>           <none>
kubernetes-bootcamp-765bf4c7b4-z7vrz   1/1     Running   0          66s     172.18.0.9   minikube   <none>           <none>
$
вывод информации о поде

$ kubectl describe deployments/kubernetes-bootcamp
Name:                   kubernetes-bootcamp
Namespace:              default
CreationTimestamp:      Mon, 13 Jul 2020 05:34:57 +0000
Labels:                 run=kubernetes-bootcamp
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               run=kubernetes-bootcamp
Replicas:               4 desired | 4 updated | 4 total | 4 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  run=kubernetes-bootcamp
  Containers:
   kubernetes-bootcamp:
    Image:        gcr.io/google-samples/kubernetes-bootcamp:v1
    Port:         8080/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   kubernetes-bootcamp-765bf4c7b4 (4/4 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  3m17s  deployment-controller  Scaled up replica set kubernetes-bootcamp-765bf4c7b4 to 1
  Normal  ScalingReplicaSet  94s    deployment-controller  Scaled up replica set kubernetes-bootcamp-765bf4c7b4 to 4
$


$ kubectl describe services/kubernetes-bootcamp
Name:                     kubernetes-bootcamp
Namespace:                default
Labels:                   run=kubernetes-bootcamp
Annotations:              <none>
Selector:                 run=kubernetes-bootcamp
Type:                     NodePort
IP:                       10.111.88.213
Port:                     <unset>  8080/TCP
TargetPort:               8080/TCP
NodePort:                 <unset>  31402/TCP
Endpoints:                172.18.0.2:8080,172.18.0.7:8080,172.18.0.8:8080 + 1 more...
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
$
создание переменной NODE_PORT -- порт к которому будут обращаться непосредственно пользователи
$ export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
$ echo NODE_PORT=$NODE_PORT
NODE_PORT=31402
$
$ curl $(minikube ip):$NODE_PORT
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-765bf4c7b4-dmdwn | v=1
$
уменьшение числа реплик приложения(происходит достаточно быстро, по этому увидеть момент когда отмирают реплики вероятно не получится)
$ kubectl scale deployments/kubernetes-bootcamp --replicas=2
deployment.apps/kubernetes-bootcamp scaled
$ kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
kubernetes-bootcamp   2/2     2            2           11m
$

$ kubectl get pods -o wide
NAME                                   READY   STATUS    RESTARTS   AGE   IP    NODE       NOMINATED NODE   READINESS GATES
kubernetes-bootcamp-765bf4c7b4-dkqt2   1/1     Running   0          10m   172.18.0.8   minikube   <none>           <none>
kubernetes-bootcamp-765bf4c7b4-vtkd4   1/1     Running   0          12m   172.18.0.2   minikube   <none>           <none>
$
U06 обновление приложений

вывод колличества запущеных приложений
$ kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
kubernetes-bootcamp   4/4     4            4           5m25s

$ kubectl get pods
NAME                                   READY   STATUS    RESTARTS   AGE
kubernetes-bootcamp-765bf4c7b4-drr5s   1/1     Running   0          5m47s
kubernetes-bootcamp-765bf4c7b4-gmltt   1/1     Running   0          5m47s
kubernetes-bootcamp-765bf4c7b4-k95ws   1/1     Running   0          5m47s
kubernetes-bootcamp-765bf4c7b4-lblww   1/1     Running   0          5m47s
$

$ kubectl describe pods
Name:         kubernetes-bootcamp-765bf4c7b4-drr5s
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:00:10 +0000
Labels:       pod-template-hash=765bf4c7b4
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.6
IPs:
  IP:           172.18.0.6
Controlled By:  ReplicaSet/kubernetes-bootcamp-765bf4c7b4
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://b77796f4f21b4a7bf298a62089fccb4244596de64801b8a2ee7e4dbd3e57d2f6
    Image:          gcr.io/google-samples/kubernetes-bootcamp:v1
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:0d6b8ee63bb57c5f5b6156f446b3bc3b3c143d233037f3a2f00e279c8fcc64af
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:00:16 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason            Age                    From               Message
  ----     ------            ----                   ----               -------
  Warning  FailedScheduling  5m58s (x2 over 5m58s)  default-scheduler  0/1 nodes are available: 1 node(s) had taints that the pod didn't tolerate.
  Normal   Scheduled         5m52s                  default-scheduler  Successfully assigned default/kubernetes-bootcamp-765bf4c7b4-drr5s to minikube
  Normal   Pulled            5m47s                  kubelet, minikube  Container image "gcr.io/google-samples/kubernetes-bootcamp:v1" already present on machine
  Normal   Created           5m47s                  kubelet, minikube  Created container kubernetes-bootcamp
  Normal   Started           5m46s                  kubelet, minikube  Started container kubernetes-bootcamp


Name:         kubernetes-bootcamp-765bf4c7b4-gmltt
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:00:10 +0000
Labels:       pod-template-hash=765bf4c7b4
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.4
IPs:
  IP:           172.18.0.4
Controlled By:  ReplicaSet/kubernetes-bootcamp-765bf4c7b4
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://f7a1b8cbb367f6fe376ca6b3c8270576ce38dadedffd9436f2e82b9e42e3710c
    Image:          gcr.io/google-samples/kubernetes-bootcamp:v1
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:0d6b8ee63bb57c5f5b6156f446b3bc3b3c143d233037f3a2f00e279c8fcc64af
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:00:15 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason            Age    From               Message
  ----     ------            ----   ----               -------
  Warning  FailedScheduling  5m58s  default-scheduler  0/1 nodes are available: 1 node(s) had taints that the pod didn't tolerate.
  Normal   Scheduled         5m52s  default-scheduler  Successfully assigned default/kubernetes-bootcamp-765bf4c7b4-gmltt to minikube
  Normal   Pulled            5m48s  kubelet, minikube  Container image "gcr.io/google-samples/kubernetes-bootcamp:v1" already present on machine
  Normal   Created           5m48s  kubelet, minikube  Created container kubernetes-bootcamp
  Normal   Started           5m47s  kubelet, minikube  Started container kubernetes-bootcamp


Name:         kubernetes-bootcamp-765bf4c7b4-k95ws
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:00:10 +0000
Labels:       pod-template-hash=765bf4c7b4
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.2
IPs:
  IP:           172.18.0.2
Controlled By:  ReplicaSet/kubernetes-bootcamp-765bf4c7b4
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://a9037f549911e07eb514fa1859a69591103e82fb576bef3b01233aef36e07cfa
    Image:          gcr.io/google-samples/kubernetes-bootcamp:v1
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:0d6b8ee63bb57c5f5b6156f446b3bc3b3c143d233037f3a2f00e279c8fcc64af
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:00:15 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason            Age                    From               Message
  ----     ------            ----                   ----               -------
  Warning  FailedScheduling  5m58s (x2 over 5m58s)  default-scheduler  0/1 nodes are available: 1 node(s) had taints that the pod didn't tolerate.
  Normal   Scheduled         5m52s                  default-scheduler  Successfully assigned default/kubernetes-bootcamp-765bf4c7b4-k95ws to minikube
  Normal   Pulled            5m48s                  kubelet, minikube  Container image "gcr.io/google-samples/kubernetes-bootcamp:v1" already present on machine
  Normal   Created           5m48s                  kubelet, minikube  Created container kubernetes-bootcamp
  Normal   Started           5m47s                  kubelet, minikube  Started container kubernetes-bootcamp


Name:         kubernetes-bootcamp-765bf4c7b4-lblww
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:00:10 +0000
Labels:       pod-template-hash=765bf4c7b4
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.3
IPs:
  IP:           172.18.0.3
Controlled By:  ReplicaSet/kubernetes-bootcamp-765bf4c7b4
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://c9635a354077d6b7cb4c493bc78a9f4ce05daae19c58a21d7552f2db2dd130cd
    Image:          gcr.io/google-samples/kubernetes-bootcamp:v1
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:0d6b8ee63bb57c5f5b6156f446b3bc3b3c143d233037f3a2f00e279c8fcc64af
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:00:15 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason            Age                    From               Message
  ----     ------            ----                   ----               -------
  Warning  FailedScheduling  5m58s (x2 over 5m58s)  default-scheduler  0/1 nodes are available: 1 node(s) had taints that the pod didn't tolerate.
  Normal   Scheduled         5m52s                  default-scheduler  Successfully assigned default/kubernetes-bootcamp-765bf4c7b4-lblww to minikube
  Normal   Pulled            5m48s                  kubelet, minikube  Container image "gcr.io/google-samples/kubernetes-bootcamp:v1" already present on machine
  Normal   Created           5m48s                  kubelet, minikube  Created container kubernetes-bootcamp
  Normal   Started           5m47s                  kubelet, minikube  Started container kubernetes-bootcamp
$

обновляем до новой версии
подписываем новую версию приложения
$ kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2
deployment.apps/kubernetes-bootcamp image updated

смотрим что есть
$ kubectl get pods
NAME                                   READY   STATUS    RESTARTS   AGE
kubernetes-bootcamp-7d6f8694b6-88rz9   1/1     Running   0          49s
kubernetes-bootcamp-7d6f8694b6-m45nf   1/1     Running   0          47s
kubernetes-bootcamp-7d6f8694b6-q2hx9   1/1     Running   0          47s
kubernetes-bootcamp-7d6f8694b6-x4l9s   1/1     Running   0          49s

что запущено
$ kubectl describe services/kubernetes-bootcamp
Name:                     kubernetes-bootcamp
Namespace:                default
Labels:                   run=kubernetes-bootcamp
Annotations:              <none>
Selector:                 run=kubernetes-bootcamp
Type:                     NodePort
IP:                       10.99.211.238
Port:                     <unset>  8080/TCP
TargetPort:               8080/TCP
NodePort:                 <unset>  30861/TCP
Endpoints:                172.18.0.10:8080,172.18.0.11:8080,172.18.0.12:8080 + 1 more...
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
$

создаем переменную NODE_PORT и запоминаем его
$ export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
$ echo NODE_PORT=$NODE_PORT
NODE_PORT=30861

вывод приложения
$ curl $(minikube ip):$NODE_PORT
Hello Kubernetes bootcamp! | Running on: kubernetes-bootcamp-7d6f8694b6-q2hx9 | v=2
$

обновляем приложение
 kubectl rollout status deployments/kubernetes-bootcamp
deployment "kubernetes-bootcamp" successfully rolled out

смотрим, что у нас получилось
$ kubectl describe pods
Name:         kubernetes-bootcamp-7d6f8694b6-88rz9
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:06:48 +0000
Labels:       pod-template-hash=7d6f8694b6
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.11
IPs:
  IP:           172.18.0.11
Controlled By:  ReplicaSet/kubernetes-bootcamp-7d6f8694b6
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://7b3e04c8cb32038ede99bb7f3b3295eeacfee77fe3510d070fe4429b6e02f093
    Image:          jocatalin/kubernetes-bootcamp:v2
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:fb1a3ced00cecfc1f83f18ab5cd14199e30adc1b49aa4244f5d65ad3f5feb2a5
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:06:49 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  2m26s  default-scheduler  Successfully assigned default/kubernetes-bootcamp-7d6f8694b6-88rz9 to minikube
  Normal  Pulled     2m25s  kubelet, minikube  Container image "jocatalin/kubernetes-bootcamp:v2" already present on machine
  Normal  Created    2m25s  kubelet, minikube  Created container kubernetes-bootcamp
  Normal  Started    2m25s  kubelet, minikube  Started container kubernetes-bootcamp


Name:         kubernetes-bootcamp-7d6f8694b6-m45nf
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:06:50 +0000
Labels:       pod-template-hash=7d6f8694b6
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.12
IPs:
  IP:           172.18.0.12
Controlled By:  ReplicaSet/kubernetes-bootcamp-7d6f8694b6
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://a950867b6fc97e50ab906309a0fd15b5772c9f38dc13fdd6dcabe89ffbef6e43
    Image:          jocatalin/kubernetes-bootcamp:v2
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:fb1a3ced00cecfc1f83f18ab5cd14199e30adc1b49aa4244f5d65ad3f5feb2a5
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:06:52 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  2m24s  default-scheduler  Successfully assigned default/kubernetes-bootcamp-7d6f8694b6-m45nf to minikube
  Normal  Pulled     2m23s  kubelet, minikube  Container image "jocatalin/kubernetes-bootcamp:v2" already present on machine
  Normal  Created    2m23s  kubelet, minikube  Created container kubernetes-bootcamp
  Normal  Started    2m22s  kubelet, minikube  Started container kubernetes-bootcamp


Name:         kubernetes-bootcamp-7d6f8694b6-q2hx9
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:06:50 +0000
Labels:       pod-template-hash=7d6f8694b6
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.13
IPs:
  IP:           172.18.0.13
Controlled By:  ReplicaSet/kubernetes-bootcamp-7d6f8694b6
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://749b5e5883ce5f6563b39b2bd4f83430db495172d3d6dbb36b35d131fd6e387e
    Image:          jocatalin/kubernetes-bootcamp:v2
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:fb1a3ced00cecfc1f83f18ab5cd14199e30adc1b49aa4244f5d65ad3f5feb2a5
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:06:52 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  2m24s  default-scheduler  Successfully assigned default/kubernetes-bootcamp-7d6f8694b6-q2hx9 to minikube
  Normal  Pulled     2m22s  kubelet, minikube  Container image "jocatalin/kubernetes-bootcamp:v2" already present on machine
  Normal  Created    2m22s  kubelet, minikube  Created container kubernetes-bootcamp
  Normal  Started    2m22s  kubelet, minikube  Started container kubernetes-bootcamp


Name:         kubernetes-bootcamp-7d6f8694b6-x4l9s
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:06:48 +0000
Labels:       pod-template-hash=7d6f8694b6
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.10
IPs:
  IP:           172.18.0.10
Controlled By:  ReplicaSet/kubernetes-bootcamp-7d6f8694b6
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://34013b1e09a3fdff31eb4bffb2ca1b0a78b06f134cda0ef4c00489c62bacd87f
    Image:          jocatalin/kubernetes-bootcamp:v2
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:fb1a3ced00cecfc1f83f18ab5cd14199e30adc1b49aa4244f5d65ad3f5feb2a5
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:06:49 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  2m26s  default-scheduler  Successfully assigned default/kubernetes-bootcamp-7d6f8694b6-x4l9s to minikube
  Normal  Pulled     2m25s  kubelet, minikube  Container image "jocatalin/kubernetes-bootcamp:v2" already present on machine
  Normal  Created    2m25s  kubelet, minikube  Created container kubernetes-bootcamp
  Normal  Started    2m25s  kubelet, minikube  Started container kubernetes-bootcamp
$

обновляем приложение
$ kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=gcr.io/google-samples/kubernetes-bootcamp:v10
deployment.apps/kubernetes-bootcamp image updated
смотрим, что получилось
$ kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
kubernetes-bootcamp   3/4     2            3           11m
$ kubectl get pods
NAME                                   READY   STATUS             RESTARTS   AGE
kubernetes-bootcamp-7d6f8694b6-88rz9   1/1     Running            0          4m20s
kubernetes-bootcamp-7d6f8694b6-m45nf   1/1     Terminating        0          4m18s
kubernetes-bootcamp-7d6f8694b6-q2hx9   1/1     Running            0          4m18s
kubernetes-bootcamp-7d6f8694b6-x4l9s   1/1     Running            0          4m20s
kubernetes-bootcamp-886577c5d-jrgrw    0/1     ImagePullBackOff   0          26s
kubernetes-bootcamp-886577c5d-wb7cm    0/1     ImagePullBackOff   0          27s
$

$ kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
kubernetes-bootcamp   3/4     2            3           11m
$ kubectl get pods
NAME                                   READY   STATUS             RESTARTS   AGE
kubernetes-bootcamp-7d6f8694b6-88rz9   1/1     Running            0          4m20s
kubernetes-bootcamp-7d6f8694b6-m45nf   1/1     Terminating        0          4m18s
kubernetes-bootcamp-7d6f8694b6-q2hx9   1/1     Running            0          4m18s
kubernetes-bootcamp-7d6f8694b6-x4l9s   1/1     Running            0          4m20s
kubernetes-bootcamp-886577c5d-jrgrw    0/1     ImagePullBackOff   0          26s
kubernetes-bootcamp-886577c5d-wb7cm    0/1     ImagePullBackOff   0          27s
$ kubectl describe pods
Name:         kubernetes-bootcamp-7d6f8694b6-88rz9
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:06:48 +0000
Labels:       pod-template-hash=7d6f8694b6
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.11
IPs:
  IP:           172.18.0.11
Controlled By:  ReplicaSet/kubernetes-bootcamp-7d6f8694b6
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://7b3e04c8cb32038ede99bb7f3b3295eeacfee77fe3510d070fe4429b6e02f093
    Image:          jocatalin/kubernetes-bootcamp:v2
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:fb1a3ced00cecfc1f83f18ab5cd14199e30adc1b49aa4244f5d65ad3f5feb2a5
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:06:49 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  4m39s  default-scheduler  Successfully assigned default/kubernetes-bootcamp-7d6f8694b6-88rz9 to minikube
  Normal  Pulled     4m38s  kubelet, minikube  Container image "jocatalin/kubernetes-bootcamp:v2" already present on machine
  Normal  Created    4m38s  kubelet, minikube  Created container kubernetes-bootcamp
  Normal  Started    4m38s  kubelet, minikube  Started container kubernetes-bootcamp


Name:         kubernetes-bootcamp-7d6f8694b6-q2hx9
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:06:50 +0000
Labels:       pod-template-hash=7d6f8694b6
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.13
IPs:
  IP:           172.18.0.13
Controlled By:  ReplicaSet/kubernetes-bootcamp-7d6f8694b6
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://749b5e5883ce5f6563b39b2bd4f83430db495172d3d6dbb36b35d131fd6e387e
    Image:          jocatalin/kubernetes-bootcamp:v2
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:fb1a3ced00cecfc1f83f18ab5cd14199e30adc1b49aa4244f5d65ad3f5feb2a5
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:06:52 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  4m37s  default-scheduler  Successfully assigned default/kubernetes-bootcamp-7d6f8694b6-q2hx9 to minikube
  Normal  Pulled     4m35s  kubelet, minikube  Container image "jocatalin/kubernetes-bootcamp:v2" already present on machine
  Normal  Created    4m35s  kubelet, minikube  Created container kubernetes-bootcamp
  Normal  Started    4m35s  kubelet, minikube  Started container kubernetes-bootcamp


Name:         kubernetes-bootcamp-7d6f8694b6-x4l9s
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:06:48 +0000
Labels:       pod-template-hash=7d6f8694b6
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.10
IPs:
  IP:           172.18.0.10
Controlled By:  ReplicaSet/kubernetes-bootcamp-7d6f8694b6
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://34013b1e09a3fdff31eb4bffb2ca1b0a78b06f134cda0ef4c00489c62bacd87f
    Image:          jocatalin/kubernetes-bootcamp:v2
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:fb1a3ced00cecfc1f83f18ab5cd14199e30adc1b49aa4244f5d65ad3f5feb2a5
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:06:49 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  4m39s  default-scheduler  Successfully assigned default/kubernetes-bootcamp-7d6f8694b6-x4l9s to minikube
  Normal  Pulled     4m38s  kubelet, minikube  Container image "jocatalin/kubernetes-bootcamp:v2" already present on machine
  Normal  Created    4m38s  kubelet, minikube  Created container kubernetes-bootcamp
  Normal  Started    4m38s  kubelet, minikube  Started container kubernetes-bootcamp


Name:         kubernetes-bootcamp-886577c5d-jrgrw
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:10:42 +0000
Labels:       pod-template-hash=886577c5d
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Pending
IP:           172.18.0.3
IPs:
  IP:           172.18.0.3
Controlled By:  ReplicaSet/kubernetes-bootcamp-886577c5d
Containers:
  kubernetes-bootcamp:
    Container ID:
    Image:          gcr.io/google-samples/kubernetes-bootcamp:v10
    Image ID:
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       ImagePullBackOff
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason     Age                From               Message
  ----     ------     ----               ----               -------
  Normal   Scheduled  45s                default-scheduler  Successfully assigned default/kubernetes-bootcamp-886577c5d-jrgrw to minikube
  Normal   BackOff    12s (x3 over 43s)  kubelet, minikube  Back-off pulling image"gcr.io/google-samples/kubernetes-bootcamp:v10"
  Warning  Failed     12s (x3 over 43s)  kubelet, minikube  Error: ImagePullBackOff
  Normal   Pulling    0s (x3 over 44s)   kubelet, minikube  Pulling image "gcr.io/google-samples/kubernetes-bootcamp:v10"
  Warning  Failed     0s (x3 over 43s)   kubelet, minikube  Failed to pull image "gcr.io/google-samples/kubernetes-bootcamp:v10": rpc error: code = Unknown desc = Error response from daemon: manifest for gcr.io/google-samples/kubernetes-bootcamp:v10 not found: manifest unknown: Failed to fetch "v10" from request "/v2/google-samples/kubernetes-bootcamp/manifests/v10".
  Warning  Failed     0s (x3 over 43s)   kubelet, minikube  Error: ErrImagePull


Name:         kubernetes-bootcamp-886577c5d-wb7cm
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:10:41 +0000
Labels:       pod-template-hash=886577c5d
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Pending
IP:           172.18.0.2
IPs:
  IP:           172.18.0.2
Controlled By:  ReplicaSet/kubernetes-bootcamp-886577c5d
Containers:
  kubernetes-bootcamp:
    Container ID:
    Image:          gcr.io/google-samples/kubernetes-bootcamp:v10
    Image ID:
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       ImagePullBackOff
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason     Age                From               Message
  ----     ------     ----               ----               -------
  Normal   Scheduled  46s                default-scheduler  Successfully assigned default/kubernetes-bootcamp-886577c5d-wb7cm to minikube
  Normal   BackOff    15s (x3 over 43s)  kubelet, minikube  Back-off pulling image"gcr.io/google-samples/kubernetes-bootcamp:v10"
  Warning  Failed     15s (x3 over 43s)  kubelet, minikube  Error: ImagePullBackOff
  Normal   Pulling    1s (x3 over 44s)   kubelet, minikube  Pulling image "gcr.io/google-samples/kubernetes-bootcamp:v10"
  Warning  Failed     1s (x3 over 44s)   kubelet, minikube  Failed to pull image "gcr.io/google-samples/kubernetes-bootcamp:v10": rpc error: code = Unknown desc = Error response from daemon: manifest for gcr.io/google-samples/kubernetes-bootcamp:v10 not found: manifest unknown: Failed to fetch "v10" from request "/v2/google-samples/kubernetes-bootcamp/manifests/v10".
  Warning  Failed     1s (x3 over 44s)   kubelet, minikube  Error: ErrImagePull
$
понимаем, что чтото пошло не так и откатываем обновление
$ kubectl rollout undo deployments/kubernetes-bootcamp
deployment.apps/kubernetes-bootcamp rolled back

$ kubectl get pods
NAME                                   READY   STATUS    RESTARTS   AGE
kubernetes-bootcamp-7d6f8694b6-88rz9   1/1     Running   0          6m33s
kubernetes-bootcamp-7d6f8694b6-q2hx9   1/1     Running   0          6m31s
kubernetes-bootcamp-7d6f8694b6-q8z7s   1/1     Running   0          22s
kubernetes-bootcamp-7d6f8694b6-x4l9s   1/1     Running   0          6m33s
$


 kubectl describe pods
Name:         kubernetes-bootcamp-7d6f8694b6-88rz9
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:06:48 +0000
Labels:       pod-template-hash=7d6f8694b6
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.11
IPs:
  IP:           172.18.0.11
Controlled By:  ReplicaSet/kubernetes-bootcamp-7d6f8694b6
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://7b3e04c8cb32038ede99bb7f3b3295eeacfee77fe3510d070fe4429b6e02f093
    Image:          jocatalin/kubernetes-bootcamp:v2
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:fb1a3ced00cecfc1f83f18ab5cd14199e30adc1b49aa4244f5d65ad3f5feb2a5
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:06:49 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  6m44s  default-scheduler  Successfully assigned default/kubernetes-bootcamp-7d6f8694b6-88rz9 to minikube
  Normal  Pulled     6m43s  kubelet, minikube  Container image "jocatalin/kubernetes-bootcamp:v2" already present on machine
  Normal  Created    6m43s  kubelet, minikube  Created container kubernetes-bootcamp
  Normal  Started    6m43s  kubelet, minikube  Started container kubernetes-bootcamp


Name:         kubernetes-bootcamp-7d6f8694b6-q2hx9
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:06:50 +0000
Labels:       pod-template-hash=7d6f8694b6
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.13
IPs:
  IP:           172.18.0.13
Controlled By:  ReplicaSet/kubernetes-bootcamp-7d6f8694b6
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://749b5e5883ce5f6563b39b2bd4f83430db495172d3d6dbb36b35d131fd6e387e
    Image:          jocatalin/kubernetes-bootcamp:v2
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:fb1a3ced00cecfc1f83f18ab5cd14199e30adc1b49aa4244f5d65ad3f5feb2a5
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:06:52 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  6m42s  default-scheduler  Successfully assigned default/kubernetes-bootcamp-7d6f8694b6-q2hx9 to minikube
  Normal  Pulled     6m40s  kubelet, minikube  Container image "jocatalin/kubernetes-bootcamp:v2" already present on machine
  Normal  Created    6m40s  kubelet, minikube  Created container kubernetes-bootcamp
  Normal  Started    6m40s  kubelet, minikube  Started container kubernetes-bootcamp


Name:         kubernetes-bootcamp-7d6f8694b6-q8z7s
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:12:59 +0000
Labels:       pod-template-hash=7d6f8694b6
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.4
IPs:
  IP:           172.18.0.4
Controlled By:  ReplicaSet/kubernetes-bootcamp-7d6f8694b6
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://6f5b94d27471ec34f787031e88845b4646bd4f290e9a09e2a3e1c804185672a1
    Image:          jocatalin/kubernetes-bootcamp:v2
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:fb1a3ced00cecfc1f83f18ab5cd14199e30adc1b49aa4244f5d65ad3f5feb2a5
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:13:00 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  33s   default-scheduler  Successfully assigned default/kubernetes-bootcamp-7d6f8694b6-q8z7s to minikube
  Normal  Pulled     32s   kubelet, minikube  Container image "jocatalin/kubernetes-bootcamp:v2" already present on machine
  Normal  Created    32s   kubelet, minikube  Created container kubernetes-bootcamp
  Normal  Started    31s   kubelet, minikube  Started container kubernetes-bootcamp


Name:         kubernetes-bootcamp-7d6f8694b6-x4l9s
Namespace:    default
Priority:     0
Node:         minikube/172.17.0.13
Start Time:   Mon, 13 Jul 2020 08:06:48 +0000
Labels:       pod-template-hash=7d6f8694b6
              run=kubernetes-bootcamp
Annotations:  <none>
Status:       Running
IP:           172.18.0.10
IPs:
  IP:           172.18.0.10
Controlled By:  ReplicaSet/kubernetes-bootcamp-7d6f8694b6
Containers:
  kubernetes-bootcamp:
    Container ID:   docker://34013b1e09a3fdff31eb4bffb2ca1b0a78b06f134cda0ef4c00489c62bacd87f
    Image:          jocatalin/kubernetes-bootcamp:v2
    Image ID:       docker-pullable://jocatalin/kubernetes-bootcamp@sha256:fb1a3ced00cecfc1f83f18ab5cd14199e30adc1b49aa4244f5d65ad3f5feb2a5
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 13 Jul 2020 08:06:49 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4w9pd (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4w9pd:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4w9pd
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  6m44s  default-scheduler  Successfully assigned default/kubernetes-bootcamp-7d6f8694b6-x4l9s to minikube
  Normal  Pulled     6m43s  kubelet, minikube  Container image "jocatalin/kubernetes-bootcamp:v2" already present on machine
  Normal  Created    6m43s  kubelet, minikube  Created container kubernetes-bootcamp
  Normal  Started    6m43s  kubelet, minikube  Started container kubernetes-bootcamp
$
  Ready             True








                                             
































