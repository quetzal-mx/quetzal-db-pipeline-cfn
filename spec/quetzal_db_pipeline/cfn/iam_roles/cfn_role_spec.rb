# frozen_string_literal: true

RSpec.describe QuetzalDbPipeline::Cfn::IamRoles::CfnRole do
  subject(:template) do
    Helpers::Template.new(File.join(__dir__, '..', '..', '..', '..', 'quetzal-db-pipeline-cfn-template.yml'))
  end

  let(:cfn_role) { template['Resources']['QuetzalDbPipelineCfnRole'] }

  let(:expected_role) do
    {
      'Type' => 'AWS::IAM::Role',
      'Properties' => {
        'AssumeRolePolicyDocument' => {
          'Statement' => [{
            'Action' => ['sts:AssumeRole'],
            'Effect' => 'Allow',
            'Principal' => {
              'Service' => ['cloudformation.amazonaws.com']
            }
          }],
          'Version' => '2012-10-17'
        },
        'Path' => '/',
        'Policies' => [
          {
            'PolicyName' => 'QuetzalDbPipelineCfnPolicy',
            'PolicyDocument' => {
              'Version' => '2012-10-17',
              'Statement' => [
                {
                  'Action' => ['iam:*', 'logs:Delete*'],
                  'Effect' => 'Allow',
                  'Resource' => '*'
                },
                {
                  'Action' => ['ec2:DescribeAccountAttributes', 'rds:CreateDBInstance'],
                  'Effect' => 'Allow',
                  'Resource' => '*'
                }
              ]
            }
          }
        ],
        'ManagedPolicyArns' => [
          'arn:aws:iam::aws:policy/AmazonS3FullAccess',
          'arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator',
          'arn:aws:iam::aws:policy/AWSCloudFormationFullAccess',
          'arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs',
          'arn:aws:iam::aws:policy/AWSLambdaFullAccess',
          'arn:aws:iam::aws:policy/SecretsManagerReadWrite'
        ]
      }
    }
  end

  it 'creates the QuetzalDbPipelineCfnRole' do
    expect(cfn_role).to eq(expected_role)
  end
end
