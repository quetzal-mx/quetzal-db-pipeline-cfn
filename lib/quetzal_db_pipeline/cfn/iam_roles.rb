# frozen_string_literal: true

require 'quetzal_db_pipeline/cfn/iam_roles/pipeline_role'
require 'quetzal_db_pipeline/cfn/iam_roles/cfn_role'
require 'quetzal_db_pipeline/cfn/iam_roles/cloud_trail_role'
require 'quetzal_db_pipeline/cfn/iam_roles/cloud_watch_pipeline_role'

module QuetzalDbPipeline
  module Cfn
    module IamRoles
      extend ::QuetzalDbPipeline::Cfn::Config::Configurable

      class << self
        # @return [Proc]
        def generate
          proc do
            ::QuetzalDbPipeline::Cfn::IamRoles.constants.each do |constant|
              constant = ::QuetzalDbPipeline::Cfn::IamRoles.const_get(constant)
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
