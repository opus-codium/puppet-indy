# DO NOT EDIT THIS FILE!
# This file is managed by ModuleSync.

# Attempt to load voxupuli-test (which pulls in puppetlabs_spec_helper),
# otherwise attempt to load it directly.
begin
  require 'voxpupuli/test/rake'

  task default: :rubocop
rescue LoadError
  require 'puppetlabs_spec_helper/rake_tasks'
end

# Attempt to load cucumber
begin
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:features)

  task default: :features
rescue LoadError
end

# load optional tasks for releases
# only available if gem group releases is installed
begin
  require 'voxpupuli/release/rake_tasks'
rescue LoadError
end

desc 'Generate REFERENCE.md'
task :reference, [:debug, :backtrace] do |t, args|
  patterns = ''
  Rake::Task['strings:generate:reference'].invoke(patterns, args[:debug], args[:backtrace])
end

begin
  require 'github_changelog_generator/task'
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.future_release = Blacksmith::Modulefile.new.version
    config.header = <<~HEADER.chomp
      # Changelog

      All notable changes to this project will be documented in this file.

      The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
      and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
      HEADER
    config.exclude_labels = %w{duplicate question invalid wontfix wont-fix modulesync skip-changelog ignore}
    config.user = 'opus-codium'
    config.since_tag = '1.0.0'
    metadata_json = File.join(File.dirname(__FILE__), 'metadata.json')
    metadata = JSON.load(File.read(metadata_json))
    config.project = "puppet-#{metadata['name'].split('-').last}"
  end

  require 'puppet_blacksmith'
  Blacksmith::RakeTask.new do |t|
    t.tag_pattern = '%s'
    t.commit_message_pattern = 'Bump version to %s'
  end

  # Workaround for https://github.com/github-changelog-generator/github-changelog-generator/issues/715
  require 'rbconfig'
  if RbConfig::CONFIG['host_os'] =~ /linux/
    task :changelog do
      puts 'Fixing line endings...'
      changelog_file = File.join(__dir__, 'CHANGELOG.md')
      changelog_txt = File.read(changelog_file)
      new_contents = changelog_txt.gsub(%r{\r\n}, "\n")
      File.open(changelog_file, "w") {|file| file.puts new_contents }
    end
  end

rescue LoadError
end
# vim: syntax=ruby
