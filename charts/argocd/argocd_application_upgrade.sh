#!/bin/bash
export PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/aws/bin:/home/ec2-user/.local/bin:/home/ec2-user/bin
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

  ###Update ArgoCD service with LoadBalancer
  argocd_service=$(kubectl get svc argocd-server -n argocd | awk NR==2'{print $2}')
  if [ "$argocd_service" != "LoadBalancer" ]
  then 
     kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"LoadBalancer"}}'  >> /home/ec2-user/upgrade.log
     echo "Waiting for LoadBalancer to get initialized"
     sleep 120
  fi

  ###command to get ArgoCD server LoadBalancer IP
  argocdserver=$(kubectl get svc argocd-server -n argocd | awk NR==2'{print $4}')

  ###Create file to store upgrade log
  touch /home/ec2-user/upgrade.log
  chmod 777 /home/ec2-user/upgrade.log

  ###ArgoCD login via CLI
  /usr/bin/expect <(cat << EOF
spawn argocd login $argocdserver
expect "WARNING:*"
send "y\r"
expect "Username:"
send "admin\r"
expect "Password:"
send "admin@123\r"
expect "*successfully"
interact
EOF
) >> /home/ec2-user/upgrade.log

### Upgrade All application if argument is All
if [[ $# -eq 1 && "$1" == "All" ]]
then
        echo -e "\nUpgrading below applications: "
	echo -e "\n${app_list[@]}"
	echo $(date -u) " Upgrade started" >> /home/ec2-user/upgrade.log
	/usr/bin/expect <(cat << EOF
spawn argocd app sync $app_list1 --timeout 4800 --prune
expect "*successfully synced*"
sleep 10
interact
EOF
) >> /home/ec2-user/upgrade.log


### Upgrade specific Application provided as arguments
elif [[ $# -ne 0 && "$1" != "All" ]]
then
    if [ $count -eq $# ]
    then
       echo -e "\nUpgrading Application(s) - $@ "
       echo $(date -u) " Upgrade started" >> /home/ec2-user/upgrade.log
       /usr/bin/expect <(cat << EOF
spawn argocd app sync $* --timeout 4800 --prune
expect "*successfully synced*"
sleep 10
interact
EOF
) >> /home/ec2-user/upgrade.log
    
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
   echo $(date -u) " Upgrade completed successfully." >> /home/ec2-user/upgrade.log
   echo -e "\n$(date -u) Upgrade completed successfully."
else
   echo $(date -u) " Upgrade failed." >> /home/ec2-user/upgrade.log
   echo -e "\n$(date -u) Upgrade failed. Application is not synced or in healthy state."
   echo "To check status of application use command: kubectl get app -n argocd"
fi

  #Update ArgoCD service with NodePort
  kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"NodePort"}}'  >> /home/ec2-user/upgrade.log
