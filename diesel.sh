#!/bin/bash

set -eu

export DATABASE_URL="mysql://root:$MYSQL_ROOT_PASSWORD@localhost/acm"

cd /diesel
diesel database reset
