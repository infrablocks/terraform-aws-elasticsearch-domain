# frozen_string_literal: true

require 'spec_helper'

describe 'elasticsearch domain' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:domain_name) do
    var(role: :root, name: 'domain_name')
  end
  let(:elasticsearch_domain_name) do
    var(role: :root, name: 'elasticsearch_domain_name')
  end
  let(:certificate_arn) do
    output(role: :prerequisites, name: 'certificate_arn')
  end
  let(:subnet_ids) do
    output(role: :prerequisites, name: 'private_subnet_ids')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
      end
    end

    it 'creates an elasticsearch domain' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .once)
    end

    it 'uses the provided elasticsearch domain name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(:domain_name, elasticsearch_domain_name))
    end

    it 'uses an elasticsearch version of 6.3' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                :elasticsearch_version, '6.3'
              ))
    end

    it 'uses an elasticsearch instance type of "t3.small.elasticsearch"' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:cluster_config, 0, :instance_type],
                't3.small.elasticsearch'
              ))
    end

    it 'uses an elasticsearch instance count of 3' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:cluster_config, 0, :instance_count],
                3
              ))
    end

    it 'does not enable dedicated master nodes' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:cluster_config, 0, :dedicated_master_enabled],
                false
              ))
    end

    it 'enables zone awareness' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:cluster_config, 0, :zone_awareness_enabled],
                true
              ))
    end

    it 'uses the count of provided subnet IDs as the availability ' \
       'zone count for zone awareness' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:cluster_config, 0,
                 :zone_awareness_config, 0,
                 :availability_zone_count],
                subnet_ids.length
              ))
    end

    it 'uses the provided subnet IDs in the VPC options' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:vpc_options, 0, :subnet_ids], contain_exactly(*subnet_ids)
              ))
    end

    it 'has no advanced options' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(:advanced_options, a_nil_value))
    end

    it 'enables EBS' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value([:ebs_options, 0, :ebs_enabled], true))
    end

    it 'uses an EBS volume size of 20GB' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value([:ebs_options, 0, :volume_size], 20))
    end

    it 'uses an EBS volume type of gp2' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value([:ebs_options, 0, :volume_type], 'gp2'))
    end

    it 'enables encryption at rest' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value([:encrypt_at_rest, 0, :enabled], true))
    end

    it 'enables the custom endpoint' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:domain_endpoint_options, 0, :custom_endpoint_enabled],
                true
              ))
    end

    it 'constructs the custom endpoint address from the component, ' \
       'deployment identifier and provided domain name' do
      address = "#{component}-#{deployment_identifier}.#{domain_name}"
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:domain_endpoint_options, 0, :custom_endpoint],
                address
              ))
    end

    it 'uses the provided certificate as a custom certificate' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:domain_endpoint_options, 0, :custom_endpoint_certificate_arn],
                certificate_arn
              ))
    end

    it 'enforces HTTPS' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:domain_endpoint_options, 0, :enforce_https],
                true
              ))
    end

    it 'uses a TLS security policy of "Policy-Min-TLS-1-2-2019-07"' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:domain_endpoint_options, 0, :tls_security_policy],
                'Policy-Min-TLS-1-2-2019-07'
              ))
    end

    it 'configures automated snapshots starting at 11 at night UTC' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:snapshot_options, 0, :automated_snapshot_start_hour],
                23
              ))
    end

    it 'adds a domain tag including the elasticsearch domain name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                :tags,
                a_hash_including(Domain: elasticsearch_domain_name)
              ))
    end

    it 'allows the IAM root user to access the domain' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                :access_policies,
                a_policy_with_statement(
                  Effect: 'Allow',
                  Action: 'es:*',
                  Principal: { AWS: 'arn:aws:iam::325795806661:root' }
                )
              ))
    end

    it 'allows all AWS users to access the domain' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                :access_policies,
                a_policy_with_statement(
                  Effect: 'Allow',
                  Action: 'es:*',
                  Principal: { AWS: '*' }
                )
              ))
    end
  end

  describe 'when elasticsearch version provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.elasticsearch_version = '7.10'
      end
    end

    it 'uses the provided elasticsearch version' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                :elasticsearch_version, '7.10'
              ))
    end
  end

  describe 'when elasticsearch instance type provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.elasticsearch_instance_type = 't3.medium.elasticsearch'
      end
    end

    it 'uses the provided elasticsearch instance type' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:cluster_config, 0, :instance_type],
                't3.medium.elasticsearch'
              ))
    end
  end

  describe 'when elasticsearch instance count provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.elasticsearch_instance_count = 5
      end
    end

    it 'uses the provided elasticsearch instance count' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:cluster_config, 0, :instance_count],
                5
              ))
    end
  end

  describe 'when enable_dedicated_master_nodes is "yes"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.enable_dedicated_master_nodes = 'yes'
      end
    end

    it 'enables dedicated master nodes' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:cluster_config, 0, :dedicated_master_enabled],
                true
              ))
    end
  end

  describe 'when enable_dedicated_master_nodes is "no"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.enable_dedicated_master_nodes = 'no'
      end
    end

    it 'does not enable dedicated master nodes' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:cluster_config, 0, :dedicated_master_enabled],
                false
              ))
    end
  end

  describe 'when enable_zone_awareness is "yes"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.enable_zone_awareness = 'yes'
      end
    end

    it 'enables zone awareness' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:cluster_config, 0, :zone_awareness_enabled],
                true
              ))
    end
  end

  describe 'when enable_zone_awareness is "no"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.enable_zone_awareness = 'no'
      end
    end

    it 'does not enable zone awareness' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:cluster_config, 0, :zone_awareness_enabled],
                false
              ))
    end
  end

  describe 'when elasticsearch volume size is provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.elasticsearch_volume_size = 40
      end
    end

    it 'uses the provided volume size' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:ebs_options, 0, :volume_size], 40
              ))
    end
  end

  describe 'when elasticsearch volume type is provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.elasticsearch_volume_type = 'io1'
      end
    end

    it 'uses the provided volume type' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:ebs_options, 0, :volume_type], 'io1'
              ))
    end
  end

  describe 'when elasticsearch advanced options are provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.elasticsearch_advanced_options = { 'advanced' => 'option' }
      end
    end

    it 'uses the provided advanced options' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                :advanced_options, { 'advanced' => 'option' }
              ))
    end
  end

  describe 'when enable_encryption_at_rest is "yes"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.enable_encryption_at_rest = 'yes'
      end
    end

    it 'enables encryption at rest' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:encrypt_at_rest, 0, :enabled], true
              ))
    end
  end

  describe 'when enable_encryption_at_rest is "no"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.enable_encryption_at_rest = 'no'
      end
    end

    it 'does not enable encryption at rest' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:encrypt_at_rest, 0, :enabled], false
              ))
    end
  end

  describe 'when use_custom_certificate is "yes"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.use_custom_certificate = 'yes'
      end
    end

    it 'enables the custom endpoint' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:domain_endpoint_options, 0, :custom_endpoint_enabled],
                true
              ))
    end

    it 'constructs the custom endpoint address from the component, ' \
       'deployment identifier and provided domain name' do
      address = "#{component}-#{deployment_identifier}.#{domain_name}"
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:domain_endpoint_options, 0, :custom_endpoint],
                address
              ))
    end

    it 'uses the provided certificate as a custom certificate' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:domain_endpoint_options, 0, :custom_endpoint_certificate_arn],
                certificate_arn
              ))
    end

    it 'enforces HTTPS' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:domain_endpoint_options, 0, :enforce_https],
                true
              ))
    end

    it 'uses a TLS security policy of "Policy-Min-TLS-1-2-2019-07"' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:domain_endpoint_options, 0, :tls_security_policy],
                'Policy-Min-TLS-1-2-2019-07'
              ))
    end
  end

  describe 'when use_custom_certificate is "no"' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.use_custom_certificate = 'no'
      end
    end

    it 'does not enable the custom endpoint' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(:domain_endpoint_options, a_nil_value))
    end
  end

  describe 'when enforce_https is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.enforce_https = true
      end
    end

    it 'enforces HTTPS on the custom endpoint' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:domain_endpoint_options, 0, :enforce_https],
                true
              ))
    end
  end

  describe 'when enforce_https is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.enforce_https = false
      end
    end

    it 'does not enforce HTTPS on the custom endpoint' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:domain_endpoint_options, 0, :enforce_https],
                false
              ))
    end
  end

  describe 'when tls_security_policy is provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.certificate_arn =
          output(role: :prerequisites, name: 'certificate_arn')
        vars.tls_security_policy = 'Policy-Min-TLS-1-0-2019-07'
      end
    end

    it 'uses the provided TLS security policy' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_elasticsearch_domain')
              .with_attribute_value(
                [:domain_endpoint_options, 0, :tls_security_policy],
                'Policy-Min-TLS-1-0-2019-07'
              ))
    end
  end
end
