# frozen_string_literal: true

require_relative "lib/code_engine/tasks/version"

Gem::Specification.new do |spec|
  spec.name = "code-engine-tasks"
  spec.version = CodeEngine::Tasks::VERSION
  spec.authors = ["Steffen Uhlig"]
  spec.email = ["Steffen.Uhlig@de.ibm.com"]

  spec.summary = "Rake tasks for working with IBM Cloud Code Engine"
  spec.description = "A collection of Rake tasks for working with IBM Cloud Code Engine projects."
  spec.homepage = "https://github.com/suhlig/code-engine-tasks"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
