# frozen_string_literal: true

require 'quetzal_db_pipeline/cfn/stages'

module QuetzalDbPipeline
  module Cfn
    module Pipeline
      extend Cfn::Config::Configurable

      class << self
        # @return [String]
        attr_accessor :resource_name

        # @return [Proc]
        def generate
          proc do
            pipeline = ::QuetzalDbPipeline::Cfn::Pipeline

            Resource pipeline.resource_name do
              Type 'AWS::CodePipeline::Pipeline'
              Property 'Name', pipeline.resource_name
              Property 'RoleArn', 'Fn::GetAtt' => [
                ::QuetzalDbPipeline::Cfn::IamRoles::PipelineRole.resource_name,
                'Arn'
              ]
              Property 'ArtifactStore',
                       Location: {
                         Ref: ::QuetzalDbPipeline::Cfn::S3::QuetzalDbPipeline.resource_name
                       },
                       Type: :S3
              Property 'Stages', ::QuetzalDbPipeline::Cfn::Stages.generate_stages
            end
          end
        end
      end

      configure!
    end
  end
end
