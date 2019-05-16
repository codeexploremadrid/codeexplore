#!/bin/bash

. ATP/oci-curl.sh

oci-curl database.eu-frankfurt-1.oraclecloud.com POST ATP/requestATP.json "/20160918/autonomousDatabases"
