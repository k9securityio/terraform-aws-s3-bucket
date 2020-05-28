require 'awspec'
require 'awsecrets'
require 'json'

require_relative 'spec_helper'

Awsecrets.load()

expect_env = "testenv"
expect_app = "testapp"
expect_owner = "platform"

actual_s3_id = attribute 'module_under_test.bucket.id', {}
actual_custom_s3_id = attribute 'module_under_test.custom_bucket.id', {}
actual_declarative_s3_id = attribute 'module_under_test.bucket_with_declarative_policy.id', {}

all_managed_buckets = [actual_custom_s3_id, actual_custom_s3_id, actual_declarative_s3_id]
custom_bucket_policy = attribute 'module_under_test.custom_bucket.policy', {}

#require 'pry'; binding.pry; #uncomment to jump into the debugger

control 's3' do

  describe "common properties for managed s3 buckets" do
    all_managed_buckets.each do | bucket_id |
      describe s3_bucket(bucket_id) do
        it { should exist }
        it { should have_versioning_enabled }
        it { should_not have_mfa_delete_enabled }

        it { should have_logging_enabled(target_prefix: "log/s3/#{bucket_id}/") }

        it { should have_tag('Environment').value(expect_env) }
        it { should have_tag('Owner').value(expect_owner) }
        it { should have_tag('Application').value(expect_app) }
        it { should have_tag('ManagedBy').value('Terraform') }
      end
    end
  end

  describe "s3 bucket #{actual_custom_s3_id}" do
    subject { s3_bucket(actual_custom_s3_id) }

    its('policy.policy.read') { 
      should match /CustomDenyInsecureCommunications/
      should match /CustomDenyIncorrectEncryptionHeader/
      should match /CustomDenyUnencryptedObjectUploads/
      should match /AllowReadsFromEntireAccount/
    }
  end

  describe "s3 bucket #{actual_declarative_s3_id}" do
    subject { s3_bucket(actual_declarative_s3_id) }

    its('policy.policy.read') {
      should match /AllowRestrictedAdministerResource/
      should match /AllowRestrictedReadData/
      should match /AllowRestrictedWriteData/
      should match /AllowRestrictedDeleteData/
      should match /DenyEveryoneElse/
    }
  end

end

