#!/bin/bash

out=$(ps -eZ | grep unconfined_service_t)
if [[ $out ]]; then
  echo "Investigate the unconfined daemons found during the audit action"
  echo $out
fi
