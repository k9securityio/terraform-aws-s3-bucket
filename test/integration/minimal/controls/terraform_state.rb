require 'json'
require 'rspec/expectations'

require_relative 'spec_helper'

tf_state_json = json(attribute 'terraform_state', {})

logical_name = "testbucket"
env = "testenv"
app = "testapp"
org = "qm"
owner = "platform"
region = "us-east-1"

expected_bucket_name = "#{org}-#{env}-#{logical_name}"

control 'terraform_state' do
  describe 'the Terraform state file' do
    subject { tf_state_json.terraform_version }

    it('is accessible') { is_expected.to match(/\d+\.\d+\.\d+/) }
  end

  
  describe 'the Terraform state file' do
    #require 'pry'; binding.pry; #uncomment to jump into the debugger

    tf_module = get_current_module_from_tf_state_json(tf_state_json)
    outputs = tf_module['outputs']
    resources = tf_module['resources']

    # describe outputs
    describe 'outputs' do
      describe('s3 bucket') do
        describe('id') do
          subject { outputs['s3.id']['value'] }
          it { is_expected.to eq(expected_bucket_name) }
        end
        describe('arn') do
          subject { outputs['s3.arn']['value'] }
          it { is_expected.to eq("arn:aws:s3:::#{expected_bucket_name}") }
        end
        describe('bucket_domain_name') do
          subject { outputs['s3.bucket_domain_name']['value'] }
          it { is_expected.to match(/#{expected_bucket_name}\.s3\.amazonaws\.com/) }
        end
      end
    end

    describe 'resources' do
      describe('s3 bucket') do
        bucket = resources['aws_s3_bucket.bucket']['primary']
        bucket_attributes = bucket['attributes']

        describe('id') do
          subject { bucket['id'] }
          it { is_expected.to eq(outputs['s3.id']['value']) }
        end

        describe('bucket') do
          subject { bucket_attributes['bucket'] }
          it { is_expected.to eq(expected_bucket_name) }
        end

        describe('region') do
          subject { bucket_attributes['region'] }
          it { is_expected.to eq(region) }
        end

        describe('acl') do
          subject { bucket_attributes['acl'] }
          it { is_expected.to eq("private") }
        end

        describe('Tag: Owner') do
          subject { bucket_attributes['tags.Owner'] }
          it { is_expected.to eq(owner) }
        end

        describe('Tag: Environment') do
          subject { bucket_attributes['tags.Environment'] }
          it { is_expected.to eq(env) }
        end

        describe('Tag: Application') do
          subject { bucket_attributes['tags.Application'] }
          it { is_expected.to eq(app) }
        end

        describe('Tag: ManagedBy') do
          subject { bucket_attributes['tags.ManagedBy'] }
          it { is_expected.to eq("Terraform") }
        end

        describe('Versioning: Enabled') do
          subject { bucket_attributes['versioning.0.enabled'] }
          it { is_expected.to eq("true") }
        end

        describe('Versioning: MFA Delete') do
          subject { bucket_attributes['versioning.0.mfa_delete'] }
          it { is_expected.to eq("false") }
        end

      end
    end

  end

end
