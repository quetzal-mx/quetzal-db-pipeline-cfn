# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'cfndsl/rake_task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: :deploy

task test: ['test:spec', 'rubocop']

task deploy: ['template:prod:compile', 'template:prod:zip', 'template:prod:upload']

RuboCop::RakeTask.new

namespace :template do
  namespace :prod do
    task :zip do
      sh 'zip quetzal-db-pipeline-cfn.zip quetzal-db-pipeline-cfn-template.yml'
    end

    task :upload do
      sh 'aws s3 cp quetzal-db-pipeline-cfn.zip s3://quetzal-deployments/quetzal-db/quetzal-db-pipeline-cfn.zip'
    end

    CfnDsl::RakeTask.new(:compile) do |t|
      t.cfndsl_opts = {
        files: [{
          filename: "#{File.dirname(__FILE__)}/lib/quetzal_db_pipeline/cfn.rb",
          output: 'quetzal-db-pipeline-cfn-template.yml'
        }],
        outformat: 'yaml'
      }
    end
  end
end

namespace :test do
  RSpec::Core::RakeTask.new(:spec, [] => ['template:prod:compile'])
end
