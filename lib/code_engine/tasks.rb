# frozen_string_literal: true

require_relative "tasks/version"

module CodeEngine
  # Rake tasks
  module Tasks
  end
end

CE_ACCOUNT = ENV.fetch("CE_ACCOUNT")
CE_REGION = ENV.fetch("CE_REGION")
CE_PROJECT = ENV.fetch("CE_PROJECT")
CE_APP = ENV.fetch("CE_APP")
CE_RESOURCE_GROUP = ENV.fetch("CE_RESOURCE_GROUP", "default")

namespace :ce do
  namespace :account do
    desc "Target IBM Cloud account '#{CE_ACCOUNT}'"
    task :target do
      sh "ibmcloud target -g #{CE_RESOURCE_GROUP} -r #{CE_REGION} -c #{CE_ACCOUNT}"
    end
  end

  desc "List regions where CE is available"
  task :regions do
    sh <<~HEREDOC.tr("\n", "").squeeze(" ").strip
      ibmcloud catalog service codeengine --output json
      | jq --raw-output
        ' .[]
          | select(.name == "codeengine")
          | .children
          | select(.[].kind == "plan")
          | .[].children
          | select(.[].kind == "deployment")
          | .[].metadata.deployment.location'
      | sort -u
    HEREDOC
  end

  namespace :project do
    desc "Create CE project '#{CE_PROJECT}'"
    task :create do
      sh "ibmcloud ce project create --name #{CE_PROJECT}"
    end

    desc "Fail if CE project '#{CE_PROJECT}' does not exist"
    task exists: %i[account:target] do
      sh "ibmcloud ce project get --name #{CE_PROJECT}", %i[out err] => "/dev/null"
    rescue StandardError
      abort "Error: The check for CE project #{CE_PROJECT} failed. You can create it with `rake ce:project:create`."
    end
  end

  namespace :app do
    desc "Create CE app '#{CE_APP}' in project '#{CE_PROJECT}'"
    task create: %i[project:exists] do
      sh "ibmcloud ce project target --name #{CE_PROJECT}"
      sh "ibmcloud ce application create --name #{CE_APP} --build-source ."
    end

    desc "Show URL of CE app '#{CE_APP}' in project '#{CE_PROJECT}'"
    task url: %i[app:exists] do
      sh "ibmcloud ce application get --name #{CE_APP} -o json | jq --raw-output .status.url"
    end

    desc "Fail if CE app '#{CE_APP}' does not exist"
    task exists: %i[project:exists] do
      sh "ibmcloud ce application get --name #{CE_APP}", %i[out err] => "/dev/null"
    rescue StandardError
      abort "Error: The check for CE app '#{CE_APP}' failed. You can create it with `rake ce:app:create`."
    end

    desc "Update CE app '#{CE_APP}'"
    task update: %i[app:exists] do
      sh "ibmcloud ce application update --name #{CE_APP} --build-source ."
    end
  end
end

at_exit do
  warn "\nCheck the messages above for errors.\n" if $! && !$!.success?
end
