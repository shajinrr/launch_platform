import yaml
import time

# Function to read container names and IPs from ips.txt
def read_ips_file(filename):
    containers = []
    try:
        with open(filename, 'r') as file:
            for line in file:
                parts = line.strip().split()
                if len(parts) == 2:
                    containers.append({'name': parts[0], 'ip': parts[1]})
    except FileNotFoundError:
        print(f"Error: File {filename} not found.")
    return containers

# Function to update Jenkins YAML file
def update_jenkins_yaml(ips_filename):
    # Read container names and IPs from ips.txt
    containers = read_ips_file(ips_filename)

    if not containers:
        print("No containers found in ips.txt. Exiting.")
        return

    # Load existing Jenkins YAML configuration
    with open('jenkins_config.yaml', 'r') as file:
        config = yaml.safe_load(file)

    # Ensure 'jenkins' key exists and is a dictionary
    if 'jenkins' not in config:
        config['jenkins'] = {}

    # Ensure 'labelAtoms' section exists and is a list under 'jenkins'
    if 'labelAtoms' not in config['jenkins']:
        config['jenkins']['labelAtoms'] = []

    # Initialize 'nodes' as an empty list if it doesn't exist or is None
    if 'nodes' not in config['jenkins'] or config['jenkins']['nodes'] is None:
        config['jenkins']['nodes'] = []

    for container in containers:
        name = container['name']
        ip = container['ip']

        # Check if container name already exists in Jenkins config
        if any(node.get('permanent', {}).get('name') == name for node in config['jenkins']['nodes']):
            print(f"Skipping duplicate node entry for container '{name}'.")
            continue
        
        # Check if label already exists in Jenkins config
        if any(label.get('name') == name for label in config['jenkins']['labelAtoms']):
            print(f"Skipping duplicate label entry for '{name}'.")
        else:
            # Add new label to 'labelAtoms'
            config['jenkins']['labelAtoms'].append({'name': name})

        # Construct new node entry
        entry = {
            'permanent': {
                'launcher': {
                    'ssh': {
                        'credentialsId': 'shajin-ssh-creds',
                        'host': ip,  # Assign fetched IP here
                        'port': 22,
                        'sshHostKeyVerificationStrategy': 'nonVerifyingKeyVerificationStrategy'
                    }
                },
                'name': name,
                'remoteFS': '/home/centos/jenkins_workdir',
                'retentionStrategy': 'always'
            }
        }
        # Add the new node entry to the config
        config['jenkins']['nodes'].append(entry)
        print(f"Added node '{name}' with IP '{ip}'.")

    # Write the updated YAML back to file
    with open('jenkins_config_updated.yaml', 'w') as file:
        yaml.dump(config, file, default_flow_style=False, sort_keys=False)

# Execute the update function with ips.txt filename
if __name__ == "__main__":
    ips_filename = 'ips.txt'  # Adjust the filename as per your actual path
    update_jenkins_yaml(ips_filename)
