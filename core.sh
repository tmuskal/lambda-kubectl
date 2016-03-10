#!/bin/bash
# core.sh
# simple shell script to be executed by aws lambda nodejs wrapper
# Author: @JacobBaloul


###
### MAIN
###
	echo "=START="
	
	# TODO: 
	#	Customize below...
	# 	any bash commands and shell-fu here.
	#	you can package your existing shell scripts and call them here
	#
	echo "BASH RANDOM: $RANDOM" && seq 1 18 && echo {19..36}
	uname -a
	uptime
	cat /proc/cpuinfo
	free -m
	df -h
	date
	ls -ltrh / /root /home /var /var/log
	cat /etc/passwd
	whoami
	
	echo "=END="
###
