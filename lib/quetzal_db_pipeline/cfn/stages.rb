# frozen_string_literal: true

require 'quetzal_db_pipeline/cfn/stages/source'
require 'quetzal_db_pipeline/cfn/stages/base_deployment'

module QuetzalDbPipeline
  module Cfn
    module Stages
      extend QuetzalDbPipeline::Cfn::Config::Configurable

      class << self
        # @return [Hash]
        attr_writer :stages

        # @return [Array<Hash>]
        def generate_stages
          stages = @stages.map do |stage, conf|
            stage_class = const_get(conf.delete(:class) || stage)

            stage_class.new(conf)
          end

          stages.sort { |a, b| a.order <=> b.order }.map(&:generate)
        end
      end

      configure!
    end
  end
end
