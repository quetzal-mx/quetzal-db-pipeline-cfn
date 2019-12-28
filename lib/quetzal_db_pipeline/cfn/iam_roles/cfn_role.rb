# frozen_string_literal: true

module QuetzalDbPipeline
  module Cfn
    module IamRoles
      module CfnRole
        class << self
          # @return [String]
          attr_accessor :resource_name

          # @return [String]
          attr_accessor :assume_role_policy_document

          # @return [Array<Hash>]
          attr_accessor :policies

          # @return [Array<String>]
          attr_accessor :managed_policy_arns

          # @return [Proc]
          def generate
            proc do
              cfn_role = ::QuetzalDbPipeline::Cfn::IamRoles::CfnRole

              Resource cfn_role.resource_name do
                Type 'AWS::IAM::Role'
                Property 'AssumeRolePolicyDocument', cfn_role.assume_role_policy_document
                Property 'Path', '/'
                Property 'ManagedPolicyArns', cfn_role.managed_policy_arns
                Property 'Policies', cfn_role.policies
              end
            end
          end
        end
      end
    end
  end
end
