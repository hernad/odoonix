#!/usr/bin/env bash

nginx-start&

export PGDATA=$(pwd)/pgdata
postgresql-start