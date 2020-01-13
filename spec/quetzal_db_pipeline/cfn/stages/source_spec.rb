# frozen_string_literal: true

RSpec.describe QuetzalDbPipeline::Cfn::Stages::Source do
  subject(:template) do
    Helpers::Template.new(File.join(__dir__, '..', '..', '..', '..', 'quetzal-db-pipeline-cfn-template.yml'))
  end

  let(:source_stage) { template.pipeline_stages[0] }

  it 'sets the stage name as Source' do
    expect(source_stage['Name']).to eq('Source')
  end

  context 'when adding actions' do
    let(:actions) { source_stage['Actions'] }

    it 'adds one action in the stage' do
      expect(actions.count).to eq(2)
    end

    context 'when creating the QuetzalDBCfnSource action' do
      let(:quetzal_db_cfn_source_action) { actions[0] }
      let(:expected_source_action) do
        {
          'Name' => 'QuetzalDBCfnSource',
          'ActionTypeId' => {
            'Category' => 'Source',
            'Owner' => 'AWS',
            'Provider' => 'S3',
            'Version' => 1
          },
          'Configuration' => {
            'S3Bucket' => {
              'Ref' => 'QuetzalDbDeploymentsBucket'
            },
            'S3ObjectKey' => 'quetzal-db-cfn.zip',
            'PollForSourceChanges' => false
          },
          'OutputArtifacts' => [
            { 'Name' => 'quetzal-db-cfn' }
          ],
          'RunOrder' => 1
        }
      end

      it 'setups the action' do
        expect(quetzal_db_cfn_source_action).to eq(expected_source_action)
      end
    end

    context 'when creating the QuetzalDBConfig action' do
      let(:quetzal_db_config_action) { actions[1] }
      let(:expected_source_action) do
        {
          'Name' => 'QuetzalDBConfig',
          'ActionTypeId' => {
            'Category' => 'Source',
            'Owner' => 'AWS',
            'Provider' => 'S3',
            'Version' => 1
          },
          'Configuration' => {
            'S3Bucket' => {
              'Ref' => 'QuetzalDbDeploymentsBucket'
            },
            'S3ObjectKey' => 'quetzal-db-config.zip',
            'PollForSourceChanges' => false
          },
          'OutputArtifacts' => [
            { 'Name' => 'quetzal-db-config' }
          ],
          'RunOrder' => 1
        }
      end

      it 'setups the action' do
        expect(quetzal_db_config_action).to eq(expected_source_action)
      end
    end
  end
end
