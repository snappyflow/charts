#!/bin/bash -x
export PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/aws/bin:/home/ec2-user/.local/bin:/home/ec2-user/bin

  ###Update ArgoCD service with LoadBalancer
  kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"LoadBalancer"}}'
  sleep 180 

  ###To get current file directory location to use in crontab
  reldir="$( dirname -- "$0"; )";
  cd "$reldir";
  directory="$( pwd; )";
  filename="/argocd_backup.sh"
  fullpath="${directory}${filename}"

  ###To add this file in crontab
  croncmd="${fullpath}"
  cronjob="0 12,0 * * * $croncmd"
  ( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -

  ###Package required for interactive session for argocd login
  sudo apt-get install expect -y || sudo yum install expect -y
  
  ###Installation of ArgoCD cli
  curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
  sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
  rm argocd-linux-amd64

  ###command to get ArgoCD server LoadBalancer IP
  argocdserver=$(kubectl get svc argocd-server -n argocd | awk NR==2'{print $4}')
  
  ###command to get ArgoCD initial password
  #argocd admin initial-password -n argocd > test
  #argocdpassword=$(cat test | awk NR==1)

  ###Interactive session for ArgoCD login CLI
  /usr/bin/expect <(cat << EOF
spawn argocd login $argocdserver
expect "WARNING:*"
send "y\r"
expect "Username:"
send "admin\r"
expect "Password:"
send "admin\r"   ###Update password if ArgoCD password has been changed
expect "*successfully"
interact
EOF
)
  
  ###Upload ArgoCD backup file to git repo
  mkdir -p /home/ec2-user/sf-cicd-circleci
  cd /home/ec2-user/sf-cicd-circleci
  git init
  git branch -m master
  git remote add origin < >  ###provide git URL where need to upload backup
  git remote set-url origin "< >" ###provide git URL where need to upload backup
  git config pull.rebase true
  ###Provide password/Token for git URL in send statement
    /usr/bin/expect <(cat << EOF
spawn git pull origin master
expect "Username*"
send "< >\r" ###Provide github user name
expect "Password*"
send "< >\r" ###Provide github user token
expect "Successfully rebased*"
interact
EOF
)
  ###command to take ArgoCD cluster & App backup
  cd /home/ec2-user/sf-cicd-circleci/argocd_backup/stage/
  argocd admin export -n argocd > /home/ec2-user/sf-cicd-circleci/argocd_backup/stage/stage_argocd_backup_$(date +"%H-%M-%d-%m-%Y").yaml

  git add .
  git commit -m "ArgoCD cluster backup"
  ###Provide password/Token for git URL in send statement
  /usr/bin/expect <(cat << EOF
spawn git push origin master
expect "Username*"
send "< >\r" ###Provide github user nam
expect "Password*"
send "< >\r" ###Provide github user token
expect "*master"
interact
EOF
)

  ###Update ArgoCD service with NodePort
  kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"NodePort"}}'

  rm -rf /home/ec2-user/sf-cicd-circleci
  sleep 5
