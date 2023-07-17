#!/bin/bash -x
export PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/aws/bin:/home/ec2-user/.local/bin:/home/ec2-user/bin

  ###Update ArgoCD service with LoadBalancer
  kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"LoadBalancer"}}'
#  sleep 180 

  ###Package required for interactive session for argocd login
  sudo apt-get install expect -y || sudo yum install expect -y
  
  ###Installation of ArgoCD cli
  curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
  sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
  rm argocd-linux-amd64

  ###command to get ArgoCD server LoadBalancer IP
  argocdserver=$(kubectl get svc argocd-server -n argocd | awk NR==2'{print $4}')
  
  ###command to get ArgoCD initial password
  argocd admin initial-password -n argocd > test
  argocdpassword=$(cat test | awk NR==1)

  ###Interactive session for ArgoCD login CLI
  /usr/bin/expect <(cat << EOF
spawn argocd login $argocdserver
expect "WARNING:*"
send "y\r"
expect "Username:"
send "admin\r"
expect "Password:"
send "$argocdpassword\r"
expect "*successfully"
interact
EOF
)

  ###Interactive session for updating ArgoCD password
  /usr/bin/expect <(cat << EOF
spawn argocd account update-password
expect "*(admin):"
send "$argocdpassword\r"
expect "*user admin:"
send "admin@123\r"
expect "*user admin:"
send "admin@123\r"   
expect "Password updated"
interact
EOF
)
