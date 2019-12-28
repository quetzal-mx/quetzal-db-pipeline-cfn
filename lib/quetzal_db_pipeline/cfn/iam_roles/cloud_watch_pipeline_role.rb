# frozen_string_literal: true

module QuetzalDbPipeline
  module Cfn
    module IamRoles
      module CloudWatchPipelineRole
        class << self
          # @return [String]
          attr_accessor :resource_name

          # @return [String]
          attr_accessor :assume_role_policy_document

          # @return [Array<String>]
          attr_accessor :managed_policy_arns

          # @return [Proc]
          def generate
            proc do
              role = ::QuetzalDbPipeline::Cfn::IamRoles::CloudWatchPipelineRole

              Resource role.resource_name do
                Type 'AWS::IAM::Role'
                Property 'AssumeRolePolicyDocument', role.assume_role_policy_document
                Property 'ManagedPolicyArns', role.managed_policy_arns
                Property 'Path', '/'
              end
            end
          end
        end
      end
    end
  end
end
