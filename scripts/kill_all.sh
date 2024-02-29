#!/usr/bin/env bash

killall nginx
killall python3.11
killall odoo

ps ax | grep nginx
ps ax | grep python3
