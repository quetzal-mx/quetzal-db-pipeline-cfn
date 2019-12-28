# frozen_string_literal: true

module QuetzalDbPipeline
  module Cfn
    module CloudWatchEvents
      module QuetzalDbDeployment
        class << self
          # @return [String]
          attr_accessor :resource_name

          # @return [Hash]
          attr_writer :event_pattern

          # @return [String]
          attr_accessor :state

          # @return [Array<Hash>]
          attr_writer :targets

          # @return [Proc]
          def generate
            proc do
              quetzal_db_deployment_rule = ::QuetzalDbPipeline::Cfn::CloudWatchEvents::QuetzalDbDeployment

              Resource quetzal_db_deployment_rule .resource_name do
                Type 'AWS::Events::Rule'
                Property 'EventPattern', quetzal_db_deployment_rule .event_pattern
                Property 'State', quetzal_db_deployment_rule .state
                Property 'Targets', quetzal_db_deployment_rule .targets
              end
            end
          end

          # @return [Array<Hash>]
          def event_pattern
            @event_pattern.deep_merge(
              detail: {
                requestParameters: {
                  bucketName: [
                    { Ref: ::QuetzalDbPipeline::Cfn::S3::QuetzalDbDeployments.resource_name }
                  ]
                }
              }
            )
          end

          # @return [Array<Hash>]
          def targets
            @targets.map do |target, config|
              send(target.to_s.underscore, config)
            end
          end

          # @param config [Hash]
          # @return [Hash]
          def quetzal_db_pipeline(config)
            config.deep_merge(
              Arn: {
                'Fn::Join' => [
                  '',
                  [
                    'arn:aws:codepipeline',
                    ':',
                    { Ref: 'AWS::Region' },
                    ':',
                    { Ref: 'AWS::AccountId' },
                    ':',
                    { Ref: ::QuetzalDbPipeline::Cfn::Pipeline.resource_name }
                  ]
                ]
              },
              RoleArn: {
                'Fn::GetAtt' => [
                  ::QuetzalDbPipeline::Cfn::IamRoles::CloudWatchPipelineRole.resource_name,
                  'Arn'
                ]
              }
            )
          end
        end
      end
    end
  end
end
