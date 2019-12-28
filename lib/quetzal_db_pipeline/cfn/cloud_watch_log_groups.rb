# frozen_string_literal: true

require 'quetzal_db_pipeline/cfn/cloud_watch_log_groups/quetzal_db_deployment_trail'

module QuetzalDbPipeline
  module Cfn
    module CloudWatchLogGroups
      extend ::QuetzalDbPipeline::Cfn::Config::Configurable

      class << self
        # @return [Proc]
        def generate
          proc do
            ::QuetzalDbPipeline::Cfn::CloudWatchLogGroups.constants.each do |constant|
              constant = ::QuetzalDbPipeline::Cfn::CloudWatchLogGroups.const_get(constant)
              unless constant.respond_to?(:generate)
                raise ArgumentError, "Module #{constant} doesn't respond to `generate`"
              end

              instance_eval(&constant.generate)
            end
          end
        end
      end

      configure!
    end
  end
end
