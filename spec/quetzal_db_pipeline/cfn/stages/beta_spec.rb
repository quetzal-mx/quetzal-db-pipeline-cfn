# frozen_string_literal: true

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'QuetzalDbPipeline::Cfn::Stages::Beta' do
  # rubocop:enable RSpec/DescribeClass

  subject(:template) do
    Helpers::Template.new(File.join(__dir__, '..', '..', '..', '..', 'quetzal-db-pipeline-cfn-template.yml'))
  end

  let(:beta_stage) { template.pipeline_stages[1] }
  let(:actions) { beta_stage['Actions'] }

  it 'sets the stage name as Beta' do
    expect(beta_stage['Name']).to eq('Beta')
  end

  context 'when creating the `CreateStack` action' do
    let(:create_stack_actions) do
      actions.select do |action|
        action['RunOrder'] == 1
      end
    end

    it 'creates one action' do
      expect(create_stack_actions.count).to eq(1)
    end

    it_behaves_like 'deployment/create_stack'
  end

  context 'when creating `CreateChangeSet` action' do
    let(:create_changeset_actions) do
      actions.select do |action|
        action['RunOrder'] == 200
      end
    end

    it 'creates one action' do
      expect(create_changeset_actions.count).to eq(1)
    end

    it 'uses beta for the Stage' do
      stages = create_changeset_actions.map do |a|
        JSON.parse(a['Configuration']['ParameterOverrides'])['Stage']
      end

      expect(stages).to all(match('beta'))
    end

    it_behaves_like 'deployment/create_change_set'
  end

  context 'when creating `Approval` action' do
    let(:approval_actions) do
      actions.select do |action|
        action['RunOrder'] == 210
      end
    end

    it 'creates one action' do
      expect(approval_actions.count).to eq(1)
    end

    it 'uses adds a note in the configuration' do
      notes = approval_actions.map { |a| a['Configuration']['CustomData'] }
      expect(notes).to all(match('anual approval required for changes in stack'))
    end
  end

  context 'when creating `ExecuteChangeSet` action' do
    let(:execute_changeset_actions) do
      actions.select do |action|
        action['RunOrder'] == 300
      end
    end

    it 'creates one action' do
      expect(execute_changeset_actions.count).to eq(1)
    end

    it_behaves_like 'deployment/execute_change_set'
  end
end
