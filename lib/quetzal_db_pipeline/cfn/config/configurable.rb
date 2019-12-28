# frozen_string_literal: true

module QuetzalDbPipeline
  module Cfn
    module Config
      module Configurable
        # @return [Hash]
        def configure!
          module_name = name.demodulize.to_sym
          configuration = Config[module_name]

          raise "No configuration found for #{self}" if configuration.nil?

          configure_module(configuration[:config])
          configure_submodules(configuration[:submodules])
        end

        private

        # @param configuration [Hash]
        # @return [NilClass]
        def configure_module(configuration)
          return if configuration.blank?

          configuration.each do |key, value|
            send("#{key}=", value)
          end
        end

        # @param configuration [Hash]
        # @return [NilClass]
        def configure_submodules(configuration)
          return if configuration.blank?

          configuration.each do |submodule, configurations|
            constant = const_get(submodule)

            configurations.each do |key, value|
              constant.send("#{key}=", value)
            end
          end
        end
      end
    end
  end
end
