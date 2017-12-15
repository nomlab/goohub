require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

namespace :docker do
  tag = "nomlab/goohub"

  desc "Build Dokcer image from Dockerfile"
  task :build do
    version = Goohub::VERSION
    system "docker build --build-arg GOOHUB_VERSION=#{version} -t #{tag} ."
  end

  desc "Push current Docker image to Docker Hub"
  task :push do
    system "docker push #{tag}"
  end
end

task :default => :spec
