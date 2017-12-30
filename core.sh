#!/bin/bash


PODS=`./bin/kubectl --kubeconfig config get pods`
echo $PODS