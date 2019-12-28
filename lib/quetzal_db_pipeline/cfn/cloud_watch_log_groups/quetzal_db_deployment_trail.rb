# frozen_string_literal: true

module QuetzalDbPipeline
  module Cfn
    module CloudWatchLogGroups
      module QuetzalDbDeploymentTrail
        class << self
          # @return [String]
          attr_accessor :resource_name

          # @return [Integer]
          attr_accessor :retention_days
          # @return [Proc]
          def generate
            log_group = ::QuetzalDbPipeline::Cfn::CloudWatchLogGroups::QuetzalDbDeploymentTrail
            proc do
              Resource log_group.resource_name do
                Type 'AWS::Logs::LogGroup'
                Property 'RetentionInDays', log_group.retention_days
              end
            end
          end
        end
      end
    end
  end
end
