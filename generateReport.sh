#!/bin/bash

# Specify the output file for the report
report_file="system_report.txt"

# Get current date and time
current_date=$(date)

# Get the current user
current_user=$(whoami)

# Get internal IP address and hostname
internal_ip=$(hostname -I | awk '{print $1}')
hostname=$(hostname)

# Get external IP address
external_ip=$(curl -s https://api.ipify.org)

# Get name and version of Linux distribution
distro_name=$(cat /etc/*release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')

# Get system uptime
uptime_info=$(uptime -p)

# Get information about used and free space in /
disk_usage=$(df -h / | awk 'NR==2{print $3 " used, " $4 " free"}')

# Get information about total and free RAM
ram_info=$(free -h | awk '/Mem:/ {print $2 " total, " $4 " free"}')

# Get number and frequency of CPU cores
cpu_info=$(lscpu | grep "Model name" | awk -F: '{print $2}')
cpu_cores=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
cpu_freq=$(lscpu | grep "CPU MHz" | awk '{print $3 " MHz"}')

# Write information to report file
{
echo "Report generated on: $current_date"
echo "User: $current_user"
echo "Internal IP and Hostname: $internal_ip, $hostname"
echo "External IP Address: $external_ip"
echo "Linux Distribution: $distro_name"
echo "System Uptime: $uptime_info"
echo "Disk Usage in /: $disk_usage"
echo "RAM: $ram_info"
echo "CPU: $cpu_cores cores, $cpu_info, Frequency: $cpu_freq"
} > $report_file

echo "Report has been generated in $report_file"
