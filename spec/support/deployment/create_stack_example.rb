# frozen_string_literal: true

RSpec.shared_examples 'deployment/create_stack' do
  let(:action_type_id) do
    {
      'Category' => 'Invoke',
      'Owner' => 'AWS',
      'Provider' => 'Lambda',
      'Version' => 1
    }
  end

  it 'uses the correct name pattern' do
    names = create_stack_actions.map { |a| a['Name'] }
    expect(names).to all(match(/CreateStack([A-Z]{1}[a-z]*)+$/))
  end

  it 'setups the proper ActionTypeId for all the actions at this step' do
    action_type_ids = create_stack_actions.map { |a| a['ActionTypeId'] }
    expect(action_type_ids).to all(match(action_type_id))
  end

  context 'when setting the function name' do
    let(:function_name) { 'quetzal-infra-functions-dev-createStack' }

    it 'uses the correct FunctionName' do
      function_names = create_stack_actions.map { |a| a['Configuration']['FunctionName'] }
      expect(function_names).to all(match(function_name))
    end
  end

  context 'when setting the user parameters' do
    let(:file_name) { 'quetzal-db-create-stack.yml' }
    let(:stack_name_pattern) { /[A-Z]{1}[a-z]+Stack/ }

    it 'sets the correct filename' do
      file_names = create_stack_actions.map { |a| JSON.parse(a['Configuration']['UserParameters'])['fileName'] }
      expect(file_names).to all(match(file_name))
    end

    it 'uses the correct pattern for the stack name' do
      stack_names = create_stack_actions.map { |a| JSON.parse(a['Configuration']['UserParameters'])['stackName'] }
      expect(stack_names).to all(match(stack_name_pattern))
    end
  end

  context 'when setting up the input artifacts' do
    let(:input_artifacts) do
      [{
        'Name' => 'quetzal-db-cfn'
      }]
    end

    it 'uses the correct parameters' do
      actions_input_artifacts = create_stack_actions.map { |a| a['InputArtifacts'] }
      expect(actions_input_artifacts).to all(match(input_artifacts))
    end
  end
end
