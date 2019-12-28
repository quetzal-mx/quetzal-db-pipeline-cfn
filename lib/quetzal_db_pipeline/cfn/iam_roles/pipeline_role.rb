# frozen_string_literal: true

module QuetzalDbPipeline
  module Cfn
    module IamRoles
      module PipelineRole
        class << self
          # @return [String]
          attr_accessor :resource_name

          # @return [Hash]
          attr_accessor :assume_role_policy_document

          # @return [Array<Hash>]
          attr_accessor :policies

          # @return [Array<Hash>]
          attr_accessor :managed_policy_arns

          # @return [Proc]
          def generate
            proc do
              pipeline_role = ::QuetzalDbPipeline::Cfn::IamRoles::PipelineRole
              Resource pipeline_role.resource_name do
                Type 'AWS::IAM::Role'
                Property 'AssumeRolePolicyDocument', pipeline_role.assume_role_policy_document
                Property 'Path', '/'
                Property 'ManagedPolicyArns', pipeline_role.managed_policy_arns
                Property 'Policies', pipeline_role.policies
              end
            end
          end
        end
      end
    end
  end
end
