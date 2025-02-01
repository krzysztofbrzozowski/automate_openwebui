#!/bin/bash

set -x

# Define the path to the vmrun executable
VMRUN_PATH="/opt/homebrew/bin/vmrun"

# Define the path to your VMware .vmx file
VMX_FILE="$HOME/VMs/llms.vmwarevm/llms.vmx"

start_vm() {
    echo "Starting VM: $VMX_FILE"
    "$VMRUN_PATH" -T fusion start "$VMX_FILE" nogui
}

stop_vm() {
    echo "Stopping VM: $VMX_FILE"
    "$VMRUN_PATH" -T fusion stop "$VMX_FILE"
}

# Argument parser
if [ "$1" == "--start" ]; then
    start_vm
    sleep 10
    open -a /Applications/Safari.app "http://192.168.232.130:3000"
elif [ "$1" == "--stop" ]; then
    stop_vm
else
    echo "Usage: $0 --start | --stop"
    exit 1
fi