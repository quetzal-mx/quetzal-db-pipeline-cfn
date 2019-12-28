# frozen_string_literal: true

RSpec.describe QuetzalDbPipeline::Cfn::S3Policies::QuetzalDbPipelineDeploymentsTrailBucket do
  subject(:template) do
    Helpers::Template.new(File.join(__dir__, '..', '..', '..', '..', 'quetzal-db-pipeline-cfn-template.yml'))
  end

  let(:expected_policy) do
    {
      'Type' => 'AWS::S3::BucketPolicy',
      'Properties' => {
        'Bucket' => {
          'Ref' => 'QuetzalDbDeploymentsTrailBucket'
        },
        'PolicyDocument' => {
          'Statement' => [
            {
              'Effect' => 'Allow',
              'Principal' => {
                'Service' => 'cloudtrail.amazonaws.com'
              },
              'Action' => 's3:GetBucketAcl',
              'Resource' => {
                'Fn::GetAtt' => %w[
                  QuetzalDbDeploymentsTrailBucket
                  Arn
                ]
              }
            },
            {
              'Effect' => 'Allow',
              'Principal' => {
                'Service' => 'cloudtrail.amazonaws.com'
              },
              'Action' => 's3:PutObject',
              'Resource' => {
                'Fn::Join' => [
                  '',
                  [
                    {
                      'Fn::GetAtt' => %w[
                        QuetzalDbDeploymentsTrailBucket
                        Arn
                      ]
                    },
                    '/',
                    'AWSLogs',
                    '/',
                    {
                      'Ref' => 'AWS::AccountId'
                    },
                    '/*'
                  ]
                ]
              }
            }
          ]
        }
      }
    }
  end

  it 'creates the policy' do
    policy = template['Resources']['QuetzalDbPipelineDeploymentsTrailBucketPolicy']

    expect(policy).to eq(expected_policy)
  end
end
