# frozen_string_literal: true

RSpec.describe QuetzalDbPipeline::Cfn::S3::QuetzalDbPipeline do
  subject(:template) do
    Helpers::Template.new(File.join(__dir__, '..', '..', '..', '..', 'quetzal-db-pipeline-cfn-template.yml'))
  end

  let(:expected_bucket) do
    {
      'Type' => 'AWS::S3::Bucket',
      'Properties' => {
        'PublicAccessBlockConfiguration' => {
          'RestrictPublicBuckets' => true
        },
        'LifecycleConfiguration' => {
          'Rules' => [{
            'ExpirationInDays' => 1,
            'Status' => 'Enabled',
            'NoncurrentVersionExpirationInDays' => 1,
            'AbortIncompleteMultipartUpload' => {
              'DaysAfterInitiation' => 1
            }
          }]
        }
      }
    }
  end

  it 'uses the correct configuration' do
    s3_bucket = template['Resources']['QuetzalDbPipelineS3Artifacts']

    expect(s3_bucket).to eq(expected_bucket)
  end
end
