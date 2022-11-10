# frozen_string_literal: true

require 'spec_helper'

describe 'dns' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:domain_name) do
    var(role: :root, name: 'domain_name')
  end
  let(:private_zone_id) do
    var(role: :root, name: 'private_zone_id')
  end
  let(:public_zone_id) do
    var(role: :root, name: 'public_zone_id')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'does not create a public DNS record' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_route53_record')
                  .with_attribute_value(:zone_id, public_zone_id))
    end

    it 'creates a private DNS record' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, private_zone_id)
              .once)
    end

    it 'uses a name constructed from the component and deployment ' \
       'identifier for the private DNS record' do
      name = "#{component}-#{deployment_identifier}.#{domain_name}"
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, private_zone_id)
              .with_attribute_value(:name, name))
    end

    it 'uses a type of CNAME for the private DNS record' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, private_zone_id)
              .with_attribute_value(:type, 'CNAME'))
    end

    it 'outputs the address' do
      name = "#{component}-#{deployment_identifier}.#{domain_name}"
      expect(@plan)
        .to(include_output_creation(name: 'elasticsearch_domain_address')
              .with_value(name))
    end
  end

  describe 'when include_public_dns_record is "yes"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.include_public_dns_record = 'yes'
      end
    end

    it 'creates a public DNS record' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, public_zone_id)
              .once)
    end

    it 'uses a name constructed from the component and deployment ' \
       'identifier for the public DNS record' do
      name = "#{component}-#{deployment_identifier}.#{domain_name}"
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, public_zone_id)
              .with_attribute_value(:name, name))
    end

    it 'uses a type of CNAME for the public DNS record' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, public_zone_id)
              .with_attribute_value(:type, 'CNAME'))
    end
  end

  describe 'when include_public_dns_record is "no"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.include_public_dns_record = 'no'
      end
    end

    it 'does not creates a public DNS record' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_route53_record')
                  .with_attribute_value(:zone_id, public_zone_id))
    end
  end

  describe 'when include_private_dns_record is "yes"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.include_private_dns_record = 'yes'
      end
    end

    it 'creates a private DNS record' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, private_zone_id)
              .once)
    end

    it 'uses a name constructed from the component and deployment ' \
       'identifier for the private DNS record' do
      name = "#{component}-#{deployment_identifier}.#{domain_name}"
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, private_zone_id)
              .with_attribute_value(:name, name))
    end

    it 'uses a type of CNAME for the private DNS record' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:zone_id, private_zone_id)
              .with_attribute_value(:type, 'CNAME'))
    end
  end

  describe 'when include_private_dns_record is "no"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.include_private_dns_record = 'no'
      end
    end

    it 'does not creates a private DNS record' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_route53_record')
                  .with_attribute_value(:zone_id, private_zone_id))
    end
  end
end
