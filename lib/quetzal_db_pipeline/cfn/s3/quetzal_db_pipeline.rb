# frozen_string_literal: true

module QuetzalDbPipeline
  module Cfn
    module S3
      module QuetzalDbPipeline
        class << self
          # @return [String]
          attr_accessor :resource_name

          # @return [Hash]
          attr_accessor :life_cycle

          # @return [Proc]
          def generate
            proc do
              bucket = ::QuetzalDbPipeline::Cfn::S3::QuetzalDbPipeline

              Resource bucket.resource_name do
                Type 'AWS::S3::Bucket'
                Property 'PublicAccessBlockConfiguration', RestrictPublicBuckets: true
                Property 'LifecycleConfiguration', bucket.life_cycle
              end
            end
          end
        end
      end
    end
  end
end
