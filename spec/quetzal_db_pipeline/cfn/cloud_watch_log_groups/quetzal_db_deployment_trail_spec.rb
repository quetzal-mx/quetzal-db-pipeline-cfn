# frozen_string_literal: true

RSpec.describe QuetzalDbPipeline::Cfn::CloudWatchLogGroups::QuetzalDbDeploymentTrail do
  subject(:template) do
    Helpers::Template.new(File.join(__dir__, '..', '..', '..', '..', 'quetzal-db-pipeline-cfn-template.yml'))
  end

  let(:expected_log_group) do
    {
      'Type' => 'AWS::Logs::LogGroup',
      'Properties' => {
        'RetentionInDays' => 3
      }
    }
  end

  it 'creates the log group' do
    log_group = template['Resources']['QuetzalDbDeploymentTrailLogGroup']

    expect(log_group).to eq(expected_log_group)
  end
end
