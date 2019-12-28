# frozen_string_literal: true

RSpec.describe QuetzalDbPipeline::Cfn::CloudWatchEvents::QuetzalDbDeployment do
  subject(:template) do
    Helpers::Template.new(File.join(__dir__, '..', '..', '..', '..', 'quetzal-db-pipeline-cfn-template.yml'))
  end

  let(:expected_rule) do
    {
      'Type' => 'AWS::Events::Rule',
      'Properties' => {
        'EventPattern' => {
          'source' => ['aws.s3'],
          'detail-type' => [
            'AWS API Call via CloudTrail'
          ],
          'detail' => {
            'eventSource' => [
              's3.amazonaws.com'
            ],
            'eventName' => %w[
              PutObject
              CompleteMultipartUpload
              CopyObject
            ],
            'requestParameters' => {
              'bucketName' => [
                { 'Ref' => 'QuetzalDbDeploymentsBucket' }
              ],
              'key' => [
                'quetzal-db-cfn.zip'
              ]
            }
          }
        },
        'State' => 'ENABLED',
        'Targets' => [{
          'Arn' => {
            'Fn::Join' => [
              '',
              [
                'arn:aws:codepipeline',
                ':',
                { 'Ref' => 'AWS::Region' },
                ':',
                { 'Ref' => 'AWS::AccountId' },
                ':',
                { 'Ref' => 'QuetzalDbPipeline' }
              ]
            ]
          },
          'Id' => 'QuetzalDbPipeline',
          'RoleArn' => {
            'Fn::GetAtt' => %w[
              CloudWatchPipelineRole
              Arn
            ]
          }
        }]
      }
    }
  end

  it 'creates the rule with the correct configuration' do
    rule = template['Resources']['QuetzalDbDeploymentRule']

    expect(rule).to eq(expected_rule)
  end
end
