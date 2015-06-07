#!/bin/bash
# Shell script to cut the IP adress out of the ifconfig data
ifconfig | grep -E inet.[0-9] | awk '{print $2}'
