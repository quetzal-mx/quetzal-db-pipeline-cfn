# frozen_string_literal: true

RSpec.describe QuetzalDbPipeline::Cfn::S3::QuetzalDbDeployments do
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
            },
            'Prefix' => 'quetzal-db-cfn.zip'
          }]
        },
        'VersioningConfiguration' => {
          'Status' => 'Enabled'
        }
      }
    }
  end

  it 'uses the correct configuration' do
    s3_bucket = template['Resources']['QuetzalDbDeploymentsBucket']

    expect(s3_bucket).to eq(expected_bucket)
  end
end
