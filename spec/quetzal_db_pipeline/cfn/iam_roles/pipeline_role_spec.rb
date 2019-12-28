# frozen_string_literal: true

RSpec.describe QuetzalDbPipeline::Cfn::IamRoles::PipelineRole do
  subject(:template) do
    Helpers::Template.new(File.join(__dir__, '..', '..', '..', '..', 'quetzal-db-pipeline-cfn-template.yml'))
  end

  let(:quetzal_pipeline_role) { template['Resources']['QuetzalDbPipelineRole'] }

  let(:expected_role) do
    {
      'Type' => 'AWS::IAM::Role',
      'Properties' => {
        'AssumeRolePolicyDocument' => {
          'Statement' => [{
            'Action' => ['sts:AssumeRole'],
            'Effect' => 'Allow',
            'Principal' => {
              'Service' => ['codepipeline.amazonaws.com']
            }
          }],
          'Version' => '2012-10-17'
        },
        'Path' => '/',
        'ManagedPolicyArns' => [
          'arn:aws:iam::aws:policy/AmazonS3FullAccess',
          'arn:aws:iam::aws:policy/AWSCloudFormationFullAccess',
          'arn:aws:iam::aws:policy/service-role/AWSLambdaRole'
        ],
        'Policies' => [
          {
            'PolicyName' => 'CodePipelineAccess',
            'PolicyDocument' => {
              'Version' => '2012-10-17',
              'Statement' => [
                {
                  'Action' => %w[
                    iam:PassRole
                    sns:Publish
                  ],
                  'Effect' => 'Allow',
                  'Resource' => '*'
                }
              ]
            }
          }
        ]
      }
    }
  end

  it 'creates the QuetzalDbPipelineRole' do
    expect(quetzal_pipeline_role).to eq(expected_role)
  end
end
