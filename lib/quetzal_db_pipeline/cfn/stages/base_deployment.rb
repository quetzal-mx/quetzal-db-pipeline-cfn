# frozen_string_literal: true

module QuetzalDbPipeline
  module Cfn
    module Stages
      class BaseDeployment
        # @return [String]
        attr_accessor :stage_name

        # @return [Array<Hash>]
        attr_writer :actions

        # @return [Integer]
        attr_accessor :order

        # @return [Array<Hash>]
        attr_accessor :stacks

        # @return [Hash]
        attr_accessor :parameter_overrides

        # @param conf [Hash]
        def initialize(conf)
          conf.each do |key, value|
            send("#{key}=", value)
          end
        end

        # @return [Array<Hash>]
        def generate
          {
            Name: stage_name,
            Actions: actions
          }
        end

        private

        # @return [Array<Hash>]
        def actions
          stacks.map do |stack|
            @actions.map do |action_name, conf|
              send("build_#{action_name}_action", conf: conf, stack: stack)
            end
          end.flatten
        end

        # @param stack [String]
        # @param conf [Hash]
        # @return [Hash]
        def build_create_stack_action(stack:, conf:)
          conf.deep_merge(
            Name: "CreateStack#{stack.camelize}",
            Configuration: {
              UserParameters: {
                fileName: 'quetzal-db-create-stack.yml',
                stackName: "#{stack.camelize}Stack"
              }.to_json
            }
          )
        end

        # @param stack [String]
        # @param conf [Hash]
        # @return [Hash]
        def build_create_change_set_action(stack:, conf:)
          conf.deep_merge(
            Name: "CreateChangeSet#{stack.camelize}",
            Configuration: {
              StackName: "#{stack.camelize}Stack",
              ChangeSetName: "#{stack.camelize}ChangeSet",
              RoleArn: {
                'Fn::GetAtt': [
                  ::QuetzalDbPipeline::Cfn::IamRoles::CfnRole.resource_name,
                  'Arn'
                ]
              },
              ParameterOverrides: parameter_overrides.to_json
            }
          )
        end

        # @param stack [String]
        # @param conf [Hash]
        # @return [Hash]
        def build_execute_change_set_action(stack:, conf:)
          conf.deep_merge(
            Name: "ExecuteChangeSet#{stack.camelize}",
            Configuration: {
              StackName: "#{stack.camelize}Stack",
              ChangeSetName: "#{stack.camelize}ChangeSet"
            }
          )
        end

        # @param stack [String]
        # @param conf [Hash]
        # @return [Hash]
        def build_change_set_approval_action(stack:, conf:)
          conf.deep_merge(
            Name: "ApproveChangeSet#{stack.camelize}"
          )
        end
      end
    end
  end
end
