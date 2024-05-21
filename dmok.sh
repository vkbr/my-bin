#!/usr/bin/env bash

lsof -i :9091 -i :9098 -i :9096 -i :9100 -i :9093 | awk 'NR > 1 {print $2}' | xargs kill