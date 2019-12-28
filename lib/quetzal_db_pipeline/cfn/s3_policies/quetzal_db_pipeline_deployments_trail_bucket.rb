# frozen_string_literal: true

module QuetzalDbPipeline
  module Cfn
    module S3Policies
      module QuetzalDbPipelineDeploymentsTrailBucket
        class << self
          # @return [String]
          attr_accessor :resource_name

          # @return [Hash]
          attr_writer :bucket_statement

          # @return [Hash]
          attr_writer :object_statement

          # @return [Proc]
          def generate
            proc do
              policy = ::QuetzalDbPipeline::Cfn::S3Policies::QuetzalDbPipelineDeploymentsTrailBucket

              Resource policy.resource_name do
                Type 'AWS::S3::BucketPolicy'
                Property 'Bucket',
                         Ref: ::QuetzalDbPipeline::Cfn::S3::QuetzalDbDeploymentsTrail.resource_name
                Property 'PolicyDocument',
                         Statement: [
                           policy.bucket_statement,
                           policy.object_statement
                         ]
              end
            end
          end

          # @return [Hash]
          def bucket_statement
            @bucket_statement.deep_merge(
              Resource: {
                'Fn::GetAtt' => [
                  ::QuetzalDbPipeline::Cfn::S3::QuetzalDbDeploymentsTrail.resource_name,
                  'Arn'
                ]
              }
            )
          end

          # @return [Hash]
          def object_statement
            @object_statement.deep_merge(
              Resource: {
                'Fn::Join' => [
                  '',
                  [
                    {
                      'Fn::GetAtt' => [
                        ::QuetzalDbPipeline::Cfn::S3::QuetzalDbDeploymentsTrail.resource_name,
                        'Arn'
                      ]
                    },
                    '/',
                    'AWSLogs',
                    '/',
                    {
                      Ref: 'AWS::AccountId'
                    },
                    '/*'
                  ]
                ]
              }
            )
          end
        end
      end
    end
  end
end
