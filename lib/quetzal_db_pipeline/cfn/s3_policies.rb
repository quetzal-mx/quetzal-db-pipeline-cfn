# frozen_string_literal: true

require 'quetzal_db_pipeline/cfn/s3_policies/quetzal_db_pipeline_deployments_trail_bucket'

module QuetzalDbPipeline
  module Cfn
    module S3Policies
      extend ::QuetzalDbPipeline::Cfn::Config::Configurable

      class << self
        # @return [Proc]
        def generate
          proc do
            ::QuetzalDbPipeline::Cfn::S3Policies.constants.each do |constant|
              constant = ::QuetzalDbPipeline::Cfn::S3Policies.const_get(constant)

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
