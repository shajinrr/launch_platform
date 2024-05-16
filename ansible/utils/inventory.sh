# #!/bin/bash

# # Common Ansible settings
# ansible_ssh_common_args='-o StrictHostKeyChecking=no'
# ansible_become=yes

# # Define environments
# environments=("DEV" "STGE" "TEST")

# # Loop through environments
# for environment in "${environments[@]}"; do
#     # Path to the inventory file for the current environment
#     inventory_file="../inventories/$environment/hosts"

#     # Start writing the inventory file with group headers
#     echo "[${environment}_centos_servers]" > "$inventory_file"

#     # Fetch IPs and update the inventory file for centos containers
#     for container in $(docker ps --format "{{.Names}}" | grep -E "^centos.*"); do
#         ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container)
#         if [ -n "$ip" ]; then
#             echo "$container ansible_host=$ip ansible_user=centos ansible_ssh_common_args='$ansible_ssh_common_args' ansible_become=$ansible_become" >> "$inventory_file"
#         else
#             echo "Error: Unable to get IP for container $container"
#         fi
#     done

#     echo "" >> "$inventory_file"
#     echo "[${environment}_ubuntu_servers]" >> "$inventory_file"

#     # Fetch IPs and update the inventory file for ubuntu containers
#     for container in $(docker ps --format "{{.Names}}" | grep -E "^ubuntu.*"); do
#         ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container)
#         if [ -n "$ip" ]; then
#             echo "$container ansible_host=$ip ansible_user=ubuntu ansible_ssh_common_args='$ansible_ssh_common_args' ansible_become=$ansible_become" >> "$inventory_file"
#         else
#             echo "Error: Unable to get IP for container $container"
#         fi
#     done

#     echo "Updated $inventory_file with container IPs and Ansible settings for $environment."
# done




#!/bin/bash

# Common Ansible settings
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_become=yes

# Define environments and their corresponding labels
environments=("dev" "stge" "prod")

# Loop through environments
for environment in "${environments[@]}"; do
    # Path to the inventory file for the current environment
    inventory_file="../inventories/$environment/hosts"

    # Start writing the inventory file with group headers
    echo "[${environment}_app_servers]" > "$inventory_file"
    
    # Fetch IPs and update the inventory file for app servers with the specified label
    for container in $(docker ps --format "{{.Names}}" --filter "label=environment=$environment" | grep -E ".*_app$"); do
        ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container)
        if [ -n "$ip" ]; then
            echo "$container ansible_host=$ip ansible_user=centos ansible_ssh_private_key_file=..//..//..//jenkins_data/.ssh/id_rsa ansible_ssh_common_args='$ansible_ssh_common_args' ansible_become=$ansible_become" >> "$inventory_file"
        else
            echo "Error: Unable to get IP for container $container"
        fi
    done
    
    echo "" >> "$inventory_file"
    echo "[${environment}_web_servers]" >> "$inventory_file"
    
    # Fetch IPs and update the inventory file for web servers with the specified label
    for container in $(docker ps --format "{{.Names}}" --filter "label=environment=$environment" | grep -E ".*_web$"); do
        ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container)
        if [ -n "$ip" ]; then
            echo "$container ansible_host=$ip ansible_user=ubuntu ansible_ssh_private_key_file=..//..//..//jenkins_data/.ssh/id_rsa ansible_ssh_common_args='$ansible_ssh_common_args' ansible_become=$ansible_become" >> "$inventory_file"
        else
            echo "Error: Unable to get IP for container $container"
        fi
    done

    echo "Updated $inventory_file with container IPs and Ansible settings for $environment."
done
