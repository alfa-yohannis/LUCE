#!/bin/bash

ssh ids2 'cd /data/deploy-ids-tests/LUCE ; git pull ; docker-compose down ; docker-compose build --no-cache ; docker-compose up -d ;'