# frozen_string_literal: true

require 'erb'
require 'yaml'
require 'quetzal_db_pipeline/cfn/config/configurable'

module QuetzalDbPipeline
  module Cfn
    module Config
      class << self
        # @param key [Symbol]
        # @return [Object]
        def [](key)
          @config[key]
        end

        private

        # @return [Hash]
        def config!
          return @config unless @config.nil?

          @config = {}

          Dir[File.join(__dir__, 'config', 'configurations', '*.yml')].each do |config_file|
            file = ERB.new(File.read(config_file)).result
            @config.merge!(YAML.safe_load(file, permitted_classes: [:Symbol], aliases: true).deep_symbolize_keys)
          end
        end
      end

      config!
    end
  end
end
