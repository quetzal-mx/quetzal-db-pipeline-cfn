# frozen_string_literal: true

module QuetzalDbPipeline
  module Cfn
    module S3
      module QuetzalDbDeployments
        class << self
          # @return [String]
          attr_accessor :resource_name

          # @return [String]
          attr_accessor :life_cycle

          # @return [String]
          attr_accessor :versioning

          # @return [Proc]
          def generate
            proc do
              bucket = ::QuetzalDbPipeline::Cfn::S3::QuetzalDbDeployments

              Resource bucket.resource_name do
                Type 'AWS::S3::Bucket'
                Property 'PublicAccessBlockConfiguration', RestrictPublicBuckets: true
                Property 'LifecycleConfiguration', bucket.life_cycle
                Property 'VersioningConfiguration', bucket.versioning
              end
            end
          end
        end
      end
    end
  end
end
