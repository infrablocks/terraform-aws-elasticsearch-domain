# frozen_string_literal: true

require 'spec_helper'

describe 'full' do
  before(:context) do
    apply(role: :full)
  end

  after(:context) do
    destroy(
      role: :full,
      only_if: -> { !ENV['FORCE_DESTROY'].nil? || ENV['SEED'].nil? }
    )
  end

  describe 'elasticsearch domain' do
    subject do
      elasticsearch(elasticsearch_domain_name)
    end

    let(:elasticsearch_domain_name) do
      output(role: :full, name: 'elasticsearch_domain_name')
    end

    it { is_expected.to exist }
  end
end
