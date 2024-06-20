println("Running initialization script to execute startup commands...")

// Define a function to execute shell commands
def executeCommand(command) {
    def process = ['bash', '-c', command].execute()
    def output = new StringBuffer()
    def error = new StringBuffer()
    process.consumeProcessOutput(output, error)
    process.waitFor()
    println("Output: ${output}")
    if (error) {
        println("Error: ${error}")
    }
    return process.exitValue()
}

// Example commands to be executed
def commands = [
    'sudo mkdir -p /run/sshd',
    'sudo chmod 0755 /run/sshd',
    'sudo /usr/sbin/sshd'
]

// Execute each command
commands.each { command ->
    def exitCode = executeCommand(command)
    if (exitCode != 0) {
        println("Command failed with exit code ${exitCode}: ${command}")
    } else {
        println("Successfully executed: ${command}")
    }
}

println("Initialization script execution completed.")
