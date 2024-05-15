#!/bin/bash
# Define usage function
usage() {
    echo "Usage: $0 -e <environment> -r <role> -a <action>"
    echo "Options:"
    echo "  -e, --environment1  Environment name (e.g., production, staging, development)"
    echo "  -r, --role         Role name (e.g., hybris, certificate_renewal)"
    echo "  -a, --action       Action to perform (e.g., reconfigure, deploy, renew_certificate)"
    exit 1
}

# Initialize variables
ENVIRONMENT=""
ROLE=""
ACTION=""

# Parse command line options
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--environment1)
            ENVIRONMENT="$2"
            shift
            ;;
        -r|--role)
            ROLE="$2"
            shift
            ;;
        -a|--action)
            ACTION="$2"
            shift
            ;;
        *)
            usage
            ;;
    esac
    shift
done

# Check if required options are provided
if [[ -z "$ENVIRONMENT" || -z "$ROLE" || -z "$ACTION" ]]; then
    usage
fi

# Set the current directory as an environment variable
export CURRENT_DIR

# Run Ansible playbook
ansible-playbook -v -i "inventories/$ENVIRONMENT/hosts" -e "environment1=$ENVIRONMENT"  playbooks/$ACTION.yml