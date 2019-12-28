# frozen_string_literal: true

module QuetzalDbPipeline
  module Cfn
    module CloudTrails
      module QuetzalDbDeployment
        class << self
          # @return [String]
          attr_accessor :resource_name

          # @return [Boolean]
          attr_accessor :is_logging

          # @return [Hash]
          attr_accessor :data_resource

          # @return [Proc]
          def generate
            proc do
              cloud_trail = ::QuetzalDbPipeline::Cfn::CloudTrails::QuetzalDbDeployment

              Resource cloud_trail.resource_name do
                Type 'AWS::CloudTrail::Trail'
                DependsOn cloud_trail.dependes_on
                Property 'CloudWatchLogsLogGroupArn', cloud_trail.cloud_watch_logs_log_group_arn
                Property 'CloudWatchLogsRoleArn', cloud_trail.cloud_watch_logs_role_arn
                Property 'EventSelectors', cloud_trail.events_selectors
                Property 'IsLogging', cloud_trail.is_logging
                Property 'S3BucketName',
                         Ref: ::QuetzalDbPipeline::Cfn::S3::QuetzalDbDeploymentsTrail.resource_name
              end
            end
          end

          # @return [Array<Hash>]
          def events_selectors
            [{
              DataResources: [
                data_resource.deep_merge(
                  Values: [{
                    'Fn::Join' => [
                      '',
                      [
                        {
                          'Fn::GetAtt' => [
                            ::QuetzalDbPipeline::Cfn::S3::QuetzalDbDeployments.resource_name,
                            'Arn'
                          ]
                        },
                        '/'
                      ]
                    ]
                  }]
                )
              ],
              ReadWriteType: 'WriteOnly'
            }]
          end

          # @return [Hash]
          def cloud_watch_logs_log_group_arn
            {
              'Fn::GetAtt' => [
                ::QuetzalDbPipeline::Cfn::CloudWatchLogGroups::QuetzalDbDeploymentTrail.resource_name,
                'Arn'
              ]
            }
          end

          # @return [Hash]
          def cloud_watch_logs_role_arn
            {
              'Fn::GetAtt' => [
                ::QuetzalDbPipeline::Cfn::IamRoles::CloudTrailRole.resource_name,
                'Arn'
              ]
            }
          end

          # @return [Array<String>]
          def dependes_on
            [
              ::QuetzalDbPipeline::Cfn::S3Policies::QuetzalDbPipelineDeploymentsTrailBucket.resource_name,
              ::QuetzalDbPipeline::Cfn::S3::QuetzalDbDeploymentsTrail.resource_name
            ]
          end
        end
      end
    end
  end
end
