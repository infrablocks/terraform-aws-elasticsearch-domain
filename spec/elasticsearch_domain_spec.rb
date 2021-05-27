require 'spec_helper'

describe 'elasticsearch domain' do
  include_context :terraform

  let(:elasticsearch_domain_arn) { output_for(:harness, "elasticsearch_domain_arn") }

  subject {
    elasticsearch(elasticsearch_domain_arn)
  }

  it { should exist }
end
