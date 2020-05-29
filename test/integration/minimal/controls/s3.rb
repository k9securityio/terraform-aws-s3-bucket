require 'awspec'
require 'awsecrets'
require 'json'

require_relative 'spec_helper'

Awsecrets.load()

expect_env = "testenv"
expect_app = "testapp"
expect_owner = "platform"

actual_s3_id = attribute 'module_under_test-bucket-id', {}
actual_custom_s3_id = attribute 'module_under_test-custom_bucket-id', {}
actual_declarative_s3_id = attribute 'module_under_test-bucket_with_declarative_policy-id', {}
actual_delcarative_s3_arn = "arn:aws:s3:::#{actual_declarative_s3_id}"

all_managed_buckets = [actual_s3_id, actual_custom_s3_id, actual_declarative_s3_id]

#require 'pry'; binding.pry; #uncomment to jump into the debugger

control 's3' do

  describe "common properties for managed s3 buckets" do
    all_managed_buckets.each do | bucket_id |
      describe s3_bucket(bucket_id) do
        it { should exist }

        its('resource.acl.owner.display_name') { should eq 'skuenzli+qm-sandbox' }
        its(:acl_grants_count) { should eq 1 }
        it { should have_acl_grant(grantee: 'skuenzli+qm-sandbox', permission: 'FULL_CONTROL') }

        it { should have_versioning_enabled }

        # upgrade: it { should have_server_side_encryption(algorithm: "aws:kms") }

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

  # it would be nice to verify the correctness of the bucket policy, but
  # awspec's be_allowed_action matcher does not incorporate resource policies
  #
  # c.f. https://github.com/k1LoW/awspec/blob/30d52b8cd0b346ad10daf3a2797ded892b9e4339/lib/awspec/helper/finder/iam.rb#L27
  # 
  #describe "iam user access - ci" do
  #  subject { iam_user('arn:aws:iam::139710491120:user/ci') }
  #
  #  # allowed administer-resource
  #  it { should be_allowed_action('s3:PutBucketPolicy').resource_arn("#{actual_delcarative_s3_arn}") }
  #
  #  # deny read-data
  #  it { should_not be_allowed_action('s3:GetObject').resource_arn("#{actual_delcarative_s3_arn}/*") }
  #
  #  # deny write-data
  #  it { should_not be_allowed_action('s3:PutObject').resource_arn("#{actual_delcarative_s3_arn}/*") }
  #
  #  # deny delete-data
  #  it { should_not be_allowed_action('s3:DeleteObject').resource_arn("#{actual_delcarative_s3_arn}/*") }
  #
  #end

end

