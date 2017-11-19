require 'awspec'
require 'awsecrets'
require 'json'

require_relative 'spec_helper'

Awsecrets.load()

expect_env = "testenv"
expect_app = "testapp"
expect_owner = "platform"

tf_state_json = json(attribute 'terraform_state', {})
tf_module = get_current_module_from_tf_state_json(tf_state_json)
actual_s3_id = tf_module['outputs']['s3.id']['value']

control 's3' do

  describe "s3 bucket #{actual_s3_id}" do
    subject { s3_bucket(actual_s3_id) }

    it { should exist }
    it { should have_versioning_enabled }
    it { should_not have_mfa_delete_enabled }

    it { should have_logging_enabled(target_prefix: "log/s3/#{actual_s3_id}/") }

    it { should have_tag('Environment').value(expect_env) }
    it { should have_tag('Owner').value(expect_owner) }
    it { should have_tag('Application').value(expect_app) }
    it { should have_tag('ManagedBy').value('Terraform') }

  end

end
