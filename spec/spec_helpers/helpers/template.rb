# frozen_string_literal: true

require 'yaml'

module Helpers
  class Template
    def initialize(path, pipeline_name = 'QuetzalDbPipeline')
      @template = YAML.load_file(path)
      @pipeline_name = pipeline_name
    end

    def pipeline
      @template['Resources'][@pipeline_name]
    end

    def pipeline_stages
      pipeline['Properties']['Stages']
    end

    def [](key)
      @template[key]
    end
  end
end
