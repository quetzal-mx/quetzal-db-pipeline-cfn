# frozen_string_literal: true

RSpec.describe QuetzalDbPipeline::Cfn::Pipeline do
  subject(:template) do
    Helpers::Template.new(File.join(__dir__, '..', '..', '..', 'quetzal-db-pipeline-cfn-template.yml'))
  end

  it 'sets `QuetzalDbPipeline` as the name' do
    expect(template.pipeline['Properties']['Name']).to eq('QuetzalDbPipeline')
  end

  it 'sets `QuetzalDbPipelineS3Artifacts` as the artifacts store' do
    expect(template.pipeline['Properties']['ArtifactStore']).to eq(
      'Location' => {
        'Ref' => 'QuetzalDbPipelineS3Artifacts'
      },
      'Type' => 'S3'
    )
  end

  it 'has 2 stages' do
    expect(template.pipeline_stages.count).to eq(2)
  end

  it 'sets `QuetzalDbPipelineRole` as the pipeline role' do
    expect(template.pipeline['Properties']['RoleArn']).to eq(
      'Fn::GetAtt' => %w[QuetzalDbPipelineRole Arn]
    )
  end
end
