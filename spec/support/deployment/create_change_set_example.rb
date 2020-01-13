# frozen_string_literal: true

RSpec.shared_examples 'deployment/create_change_set' do
  let(:action_type_id) do
    {
      'Category' => 'Deploy',
      'Owner' => 'AWS',
      'Provider' => 'CloudFormation',
      'Version' => 1
    }
  end

  it 'uses the correct name pattern' do
    names = create_changeset_actions.map { |a| a['Name'] }
    expect(names).to all(match(/CreateChangeSet([A-Z]{1}[a-z])*/))
  end

  it 'setups the proper ActionTypeId for all the actions at this step' do
    action_type_ids = create_changeset_actions.map { |a| a['ActionTypeId'] }
    expect(action_type_ids).to all(match(action_type_id))
  end

  context 'when setting up the input artifacts' do
    let(:input_artifacts) do
      [
        { 'Name' => 'quetzal-db-cfn' },
        { 'Name' => 'quetzal-db-config' }
      ]
    end

    it 'uses the correct input artifacts' do
      actions_input_artifacts = create_changeset_actions.map { |a| a['InputArtifacts'] }
      expect(actions_input_artifacts).to all(match(input_artifacts))
    end
  end

  context 'when setting the configurations' do
    let(:configuration) do
      {
        'ActionMode' => 'CHANGE_SET_REPLACE',
        'Capabilities' => 'CAPABILITY_IAM,CAPABILITY_NAMED_IAM',
        'TemplatePath' => 'quetzal-db-cfn::quetzal-db-update-stack.yml',
        'TemplateConfiguration' => 'quetzal-db-config::quetzal-db-config.json',
        'RoleArn' => {
          'Fn::GetAtt' => %w[QuetzalDbPipelineCfnRole Arn]
        }
      }
    end

    it 'uses the correct configuration' do
      configurations = create_changeset_actions.map do |a|
        a['Configuration'].except('StackName', 'ChangeSetName', 'ParameterOverrides')
      end
      expect(configurations).to all(match(configuration))
    end
  end

  context 'when setting the StackName' do
    it 'uses the correct pattern' do
      stack_names = create_changeset_actions.map { |a| a['Configuration']['StackName'] }
      expect(stack_names).to all(match(/[A-Z]{1}[a-z]*Stack/))
    end
  end

  context 'when setting the ChangeSetName' do
    it 'uses the correct pattern' do
      change_set_names = create_changeset_actions.map { |a| a['Configuration']['ChangeSetName'] }
      expect(change_set_names).to all(match(/[A-Z]{1}[a-z]*ChangeSet/))
    end
  end
end
