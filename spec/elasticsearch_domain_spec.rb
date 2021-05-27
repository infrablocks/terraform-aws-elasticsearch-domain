require 'spec_helper'

describe 'elasticsearch domain' do
  include_context :terraform

  let(:elasticsearch_domain_name) { output_for(:harness, "elasticsearch_domain_name") }

  subject {
    elasticsearch(elasticsearch_domain_name)
  }

  it { should exist }
end
