# frozen_string_literal: true

require 'quetzal_db_pipeline/cfn/cloud_trails/quetzal_db_deployment'

module QuetzalDbPipeline
  module Cfn
    module CloudTrails
      extend ::QuetzalDbPipeline::Cfn::Config::Configurable

      class << self
        # @return [Proc]
        def generate
          proc do
            ::QuetzalDbPipeline::Cfn::CloudTrails.constants.each do |constant|
              constant = ::QuetzalDbPipeline::Cfn::CloudTrails.const_get(constant)

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
