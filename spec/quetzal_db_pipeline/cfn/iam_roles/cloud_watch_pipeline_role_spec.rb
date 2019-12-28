# frozen_string_literal: true

RSpec.describe QuetzalDbPipeline::Cfn::IamRoles::CloudWatchPipelineRole do
  subject(:template) do
    Helpers::Template.new(File.join(__dir__, '..', '..', '..', '..', 'quetzal-db-pipeline-cfn-template.yml'))
  end

  let(:expected_role) do
    {
      'Type' => 'AWS::IAM::Role',
      'Properties' => {
        'AssumeRolePolicyDocument' => {
          'Statement' => [{
            'Action' => ['sts:AssumeRole'],
            'Effect' => 'Allow',
            'Principal' => {
              'Service' => ['events.amazonaws.com']
            }
          }],
          'Version' => '2012-10-17'
        },
        'Path' => '/',
        'ManagedPolicyArns' => [
          'arn:aws:iam::aws:policy/AWSCodePipelineFullAccess'
        ]
      }
    }
  end

  it 'creates the role' do
    role = template['Resources']['CloudWatchPipelineRole']

    expect(role).to eq(expected_role)
  end
end
