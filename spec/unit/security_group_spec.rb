# frozen_string_literal: true

require 'spec_helper'

describe 'security group' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:elasticsearch_domain_name) do
    var(role: :root, name: 'elasticsearch_domain_name')
  end
  let(:allowed_cidrs) do
    var(role: :root, name: 'allowed_cidrs')
  end
  let(:vpc_id) do
    output(role: :prerequisites, name: 'vpc_id')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'creates a security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .once)
    end

    it 'includes the component in the security group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:name, including(component)))
    end

    it 'includes the deployment identifier in the security group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:name, including(deployment_identifier)))
    end

    it 'uses the provided VPC ID' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:vpc_id, vpc_id))
    end

    it 'includes the component in the security group description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:description, including(component)))
    end

    it 'includes the deployment identifier in the security group description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                :description, including(deployment_identifier)
              ))
    end

    it 'includes the elasticsearch domain name in the security group ' \
       'description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                :description, including(elasticsearch_domain_name)
              ))
    end

    it 'allows ingress on any port and protocol from the provided ' \
       'allowed CIDRs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                [:ingress, 0],
                a_hash_including(
                  from_port: 0,
                  to_port: 0,
                  protocol: '-1',
                  cidr_blocks: allowed_cidrs
                )
              ))
    end
  end

  describe 'when egress_cidrs provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.egress_cidrs = ['10.1.0.0/16']
      end
    end

    it 'allows egress on any port and protocol to the provided ' \
       'egress CIDRs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                [:egress, 0],
                a_hash_including(
                  from_port: 0,
                  to_port: 0,
                  protocol: '-1',
                  cidr_blocks: ['10.1.0.0/16']
                )
              ))
    end
  end
end
