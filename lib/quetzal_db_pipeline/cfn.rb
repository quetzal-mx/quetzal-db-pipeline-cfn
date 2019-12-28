# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'

require 'quetzal_db_pipeline/cfn/config'
require 'quetzal_db_pipeline/cfn/iam_roles'
require 'quetzal_db_pipeline/cfn/pipeline'
require 'quetzal_db_pipeline/cfn/s3'
require 'quetzal_db_pipeline/cfn/cloud_trails'
require 'quetzal_db_pipeline/cfn/cloud_watch_events'
require 'quetzal_db_pipeline/cfn/cloud_watch_log_groups'
require 'quetzal_db_pipeline/cfn/s3_policies'

module QuetzalDbPipeline
  module Cfn
    class << self
      require 'cfndsl'

      # @return [NilClass]
      def generate_template
        CloudFormation do
          Description 'Quetzal DB Pipeline cfn template'
          ::QuetzalDbPipeline::Cfn.constants.each do |constant|
            constant = ::QuetzalDbPipeline::Cfn.const_get(constant)
            instance_eval(&constant.generate) if constant.respond_to?(:generate)
          end
        end
      end
    end
  end
end

QuetzalDbPipeline::Cfn.generate_template
