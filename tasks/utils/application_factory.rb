# frozen_string_literal: true

require 'open3'
require 'yaml'

require_relative 'application'
require_relative 'applications_helper'

class ApplicationFactory
  def self.find(application, environment)
    configuration_metadata_for(application, environment).map do |spec|
      Application.new(spec)
    end
  end

  def self.configuration_metadata_for(application, environment)
    res = load_configuration_metadata.filter do |spec|
      spec['application'] == application &&
        spec['environment'] == environment
    end

    res.map do |spec|
      spec.keys.each do |k|
        spec[k.to_sym] = spec.delete(k)
      end
      spec[:name] = spec.delete(:application)
      spec
    end
  end

  def self.load_configuration_metadata
    YAML.safe_load(File.read(ApplicationsHelper.instance.configuration_metadata))
  end

  private_class_method :configuration_metadata_for, :load_configuration_metadata
end
