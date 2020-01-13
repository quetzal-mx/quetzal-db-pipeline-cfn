# frozen_string_literal: true

module QuetzalDbPipeline
  module Cfn
    module Stages
      class Source
        # @return [String]
        attr_accessor :stage_name

        # @return [Array<Hash>]
        attr_accessor :actions

        # @return [Integer]
        attr_accessor :order

        # @param conf [Hash]
        def initialize(conf)
          conf.each do |key, value|
            send("#{key}=", value)
          end
        end

        # @return [Hash]
        def generate
          {
            Name: stage_name,
            Actions: actions.map { |action, config| send(action.to_s.underscore, config) }
          }
        end

        private

        # @param config [Hash]
        # @return [Hash]
        def quetzal_db_cfn_source(config)
          config.deep_merge(
            Configuration: {
              S3Bucket: {
                'Ref' => ::QuetzalDbPipeline::Cfn::S3::QuetzalDbDeployments.resource_name
              }
            }
          )
        end

        # @param config [Hash]
        # @return [Hash]
        def quetzal_db_config(config)
          config.deep_merge(
            Configuration: {
              S3Bucket: {
                'Ref' => ::QuetzalDbPipeline::Cfn::S3::QuetzalDbDeployments.resource_name
              }
            }
          )
        end
      end
    end
  end
end
