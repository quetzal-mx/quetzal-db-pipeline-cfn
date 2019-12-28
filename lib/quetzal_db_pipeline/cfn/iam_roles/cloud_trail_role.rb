# frozen_string_literal: true

module QuetzalDbPipeline
  module Cfn
    module IamRoles
      module CloudTrailRole
        class << self
          # @return [String]
          attr_accessor :resource_name

          # @return  [String]
          attr_accessor :assume_role_policy_document

          # @return [Array<Hash>]
          attr_accessor :managed_policy_arns

          # @return [Proc]
          def generate
            proc do
              cloud_trail_role = ::QuetzalDbPipeline::Cfn::IamRoles::CloudTrailRole

              Resource cloud_trail_role.resource_name do
                Type 'AWS::IAM::Role'
                Property 'AssumeRolePolicyDocument', cloud_trail_role.assume_role_policy_document
                Property 'Path', '/'
                Property 'ManagedPolicyArns', cloud_trail_role.managed_policy_arns
              end
            end
          end
        end
      end
    end
  end
end
