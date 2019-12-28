# frozen_string_literal: true

RSpec.describe QuetzalDbPipeline::Cfn::IamRoles::CloudTrailRole do
  subject(:template) do
    Helpers::Template.new(File.join(__dir__, '..', '..', '..', '..', 'quetzal-db-pipeline-cfn-template.yml'))
  end

  let(:cloud_trail_role) { template['Resources']['CloudTrailRole'] }

  let(:expected_role) do
    {
      'Type' => 'AWS::IAM::Role',
      'Properties' => {
        'AssumeRolePolicyDocument' => {
          'Statement' => [{
            'Action' => ['sts:AssumeRole'],
            'Effect' => 'Allow',
            'Principal' => {
              'Service' => ['cloudtrail.amazonaws.com']
            }
          }],
          'Version' => '2012-10-17'
        },
        'Path' => '/',
        'ManagedPolicyArns' => [
          'arn:aws:iam::aws:policy/CloudWatchLogsFullAccess'
        ]
      }
    }
  end

  it 'creates the CloudTrailRole' do
    expect(cloud_trail_role).to eq(expected_role)
  end
end
