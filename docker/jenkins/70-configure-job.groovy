import jenkins.model.*
import hudson.model.*
import hudson.tasks.Shell

def jenkins = Jenkins.getInstance()
def jobName = 'YourJobName'

def job = jenkins.createProject(FreeStyleProject, jobName)
job.buildersList.add(new Shell('echo "Hello from Jenkins job"'))
job.save()
