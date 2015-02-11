#!/bin/bash

if [ -z "${CONTROLLER}" ]; then
	export CONTROLLER="controller";
fi

if [ -z "${APPD_PORT}" ]; then
	export APPD_PORT=8090;
fi

if [ -z "${APP_NAME}" ]; then
	export APP_NAME="ECommerce-Demo";
fi

if [ -z "${TIER_NAME}" ]; then
	export TIER_NAME="ECommerce-WebTier";
fi 

if [ -z "${NODE_NAME}" ]; then
	export NODE_NAME="ECommerce-Apache";
fi
		
