# frozen_string_literal: true

RSpec.describe QuetzalDbPipeline::Cfn::CloudTrails::QuetzalDbDeployment do
  subject(:template) do
    Helpers::Template.new(File.join(__dir__, '..', '..', '..', '..', 'quetzal-db-pipeline-cfn-template.yml'))
  end

  let(:cloud_trail) { template['Resources']['QuetzalDbDeploymentTrail'] }

  let(:expected_cloud_trail) do
    {
      'Type' => 'AWS::CloudTrail::Trail',
      'DependsOn' => %w[QuetzalDbPipelineDeploymentsTrailBucketPolicy QuetzalDbDeploymentsTrailBucket],
      'Properties' => {
        'CloudWatchLogsLogGroupArn' => {
          'Fn::GetAtt' => %w[
            QuetzalDbDeploymentTrailLogGroup
            Arn
          ]
        },
        'CloudWatchLogsRoleArn' => {
          'Fn::GetAtt' => %w[
            CloudTrailRole
            Arn
          ]
        },
        'EventSelectors' => [{
          'ReadWriteType' => 'WriteOnly',
          'DataResources' => [{
            'Type' => 'AWS::S3::Object',
            'Values' => [{
              'Fn::Join' => [
                '',
                [
                  {
                    'Fn::GetAtt' => %w[
                      QuetzalDbDeploymentsBucket
                      Arn
                    ]
                  },
                  '/'
                ]
              ]
            }]
          }]
        }],
        'IsLogging' => true,
        'S3BucketName' => {
          'Ref' => 'QuetzalDbDeploymentsTrailBucket'
        }
      }
    }
  end

  it 'sets the correct configuration' do
    expect(expected_cloud_trail).to eq(cloud_trail)
  end
end
