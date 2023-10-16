#!/bin/bash -x
export PATH=/opt/microsoft/powershell/7:~/.local/bin:~/bin:~/.dotnet/tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/istio-latest/bin:/usr/local/linkerd/bin:/usr/lib/golang/bin:/opt/mssql-tools18/bin:~/bundle/bin:~/bundle/gems/bin:/home/asraf/.local/share/powershell/Scripts
set -e

  ### Validating added application in ArgoCD and fetching application list
  app_list=$(kubectl get app -n argocd | awk NR!=1'{print $1}')
  for app in $app_list; do
        app_list1+="$app "
  done
  
  if [ "$app_list" == "" ]
  then
     echo "No Application found in ArgoCD."
     exit 1
  fi

  ### help command for usage
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo -e "\nUsage:"
  echo -e "       `basename $0` All - To upgrade all application"
  echo -e "       `basename $0` application_name - To upgrade single application" 
  echo -e "       `basename $0` application_name_1 application_name_2 ...etc. - To upgrade multiple applications" 
  exit 1
  fi

### Checking Arguments and application is present or not
if [ $# -eq 0 ]
then
   echo -e "\\033[0;31mArgument is missing !!!!!!\\033[0m"
   echo "Provide argument as All to upgrade all applications at once (or) provide single or multiple application names for specific upgrade."
   echo -e "      Eg: `basename $0` All (or) `basename $0` apm sf-datapath"
   exit 1

elif [[ $# -ne 0 && "$1" != "All" ]]
then
   ARGS=$@
   count=0
   app_list=$(kubectl get app -n argocd | awk NR!=1'{print $1}')
   for arg in $ARGS; do for app in $app_list; do
	   if [ "$app" == "$arg" ]
	   then
              count=$((count+1))
	   fi
           done
    done
    if [ $count -ne $# ]
    then
       echo -e "The provided application name is not found in ArgoCD application list."
       echo "Find Application name list using command: kubectl get app -n argocd | awk '{print \$1}' "
       exit 1
    fi
fi
  ###Create file to store upgrade log
  sudo touch upgrade.log
  sudo chmod 777 upgrade.log

  ###Update ArgoCD service with LoadBalancer
  argocd_service=$(kubectl get svc argocd-server -n argocd | awk NR==2'{print $2}')
  if [ "$argocd_service" != "LoadBalancer" ]
  then 
     kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"LoadBalancer"}}'  >> upgrade.log
     echo "Waiting for LoadBalancer to get initialized"
     sleep 120
  fi

  ###command to get ArgoCD server LoadBalancer IP
  argocdserver=$(kubectl get svc argocd-server -n argocd | awk NR==2'{print $4}')

  ###ArgoCD login via CLI
  argocd login $argocdserver --username admin --password admin@123 --insecure

### Upgrade All application if argument is All
if [[ $# -eq 1 && "$1" == "All" ]]
then
    echo -e "\nUpgrading below applications: "
	 echo -e "\n${app_list[@]}"
	 echo $(date -u) " Upgrade started" >> upgrade.log
	 argocd app sync $app_list1 --timeout 4800 --prune --retry-limit 3 >> upgrade.log
    sleep 10

### Upgrade specific Application provided as arguments
elif [[ $# -ne 0 && "$1" != "All" ]]
then
    if [ $count -eq $# ]
    then
       echo -e "\nUpgrading Application(s) - $@ "
       echo $(date -u) " Upgrade started" >> upgrade.log
       argocd app sync $* --timeout 4800 --prune --retry-limit 3 >> upgrade.log
       sleep 10
    
    fi
fi

### Getting the status of Application
  if [[ "$*" == "All" ]]
  then
     synced_app=$(kubectl get app -n argocd | grep Synced | wc -l)
     healthy_app=$(kubectl get app -n argocd | grep Healthy | wc -l)
     total_app=$(expr $(kubectl get app -n argocd | wc -l) - 1)
  else
     synced_app=$(kubectl get app $* -n argocd | grep Synced | wc -l)
     healthy_app=$(kubectl get app $* -n argocd | grep Healthy | wc -l)
     total_app=$(expr $(kubectl get app $* -n argocd | wc -l) - 1)
  fi

if [[ $synced_app -ne $total_app && $healthy_app -ne $total_app ]]
then
   sleep 600
elif [[ $synced_app -eq $total_app && $healthy_app -ne $total_app ]]
then
   sleep 300
fi

if [[ "$*" == "All" ]]
then
   synced_app=$(kubectl get app -n argocd | grep Synced | wc -l)
   healthy_app=$(kubectl get app -n argocd | grep Healthy | wc -l)
   total_app=$(expr $(kubectl get app -n argocd | wc -l) - 1)
else
   synced_app=$(kubectl get app $* -n argocd | grep Synced | wc -l)
   healthy_app=$(kubectl get app $* -n argocd | grep Healthy | wc -l)
   total_app=$(expr $(kubectl get app $* -n argocd | wc -l) - 1)
fi

### Providing user regarding upgrade status
if [[ $synced_app -eq $total_app && $healthy_app -eq $total_app ]]
then
   echo $(date -u) " Upgrade completed successfully." >> upgrade.log
   echo -e "\n$(date -u) Upgrade completed successfully."
else
   echo $(date -u) " Upgrade failed." >> upgrade.log
   echo -e "\n$(date -u) Upgrade failed. Application is not synced or in healthy state."
   echo "To check status of application use command: kubectl get app -n argocd"
fi

  #Update ArgoCD service with NodePort
  kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"NodePort"}}'  >> upgrade.log
