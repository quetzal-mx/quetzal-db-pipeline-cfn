# frozen_string_literal: true

require 'quetzal_db_pipeline/cfn/s3/quetzal_db_deployments'
require 'quetzal_db_pipeline/cfn/s3/quetzal_db_pipeline'
require 'quetzal_db_pipeline/cfn/s3/quetzal_db_deployments_trail'

module QuetzalDbPipeline
  module Cfn
    module S3
      extend ::QuetzalDbPipeline::Cfn::Config::Configurable

      class << self
        # @return [Proc]
        def generate
          proc do
            ::QuetzalDbPipeline::Cfn::S3.constants.each do |constant|
              constant = ::QuetzalDbPipeline::Cfn::S3.const_get(constant)

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
