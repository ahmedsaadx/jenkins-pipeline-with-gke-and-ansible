#!/bin/bash
# ssh wrapper using gcloud command
# misc/gssh.sh

host="${@: -2: 1}"
cmd="${@: -1: 1}"

socket="/tmp/ansible-ssh-${target_host}-22-iap"

gcloud_args="--tunnel-through-iap \
--project=saad-375811 \
--zone=us-east1-b
--quiet
--no-user-output-enabled
--
-C
-o ControlMaster=auto
-o ControlPersist=20
-o PreferredAuthentications=publickey
-o KbdInteractiveAuthentication=no
-o PasswordAuthentication=no
-o ConnectTimeout=20"

if [ -e "$socket" ]; then
  exec gcloud compute ssh "$host" \
       $gcloud_args \
       -o ControlPath="$socket" \
       "$cmd"
else
  exec gcloud compute ssh "$host" \
       $gcloud_args \
       -o ControlPath="$socket" \
       "$cmd"
fi
