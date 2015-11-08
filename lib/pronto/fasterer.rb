require 'pronto'
require 'fasterer'
require 'yaml'

module Pronto
  class Fasterer < Runner
    CONFIG_FILE_NAME = '.fasterer.yml'
    SPEEDUPS_KEY = 'speedups'
    EXCLUDE_PATHS_KEY = 'exclude_paths'

    def initialize
    end

    def run(patches, _)
      return [] unless patches

      valid_patches = patches.select do |patch|
        patch.additions > 0 &&
        ruby_file?(patch.new_file_full_path) &&
        !ignored_files.include?(patch.delta.new_file[:path])
      end

      valid_patches.map { |patch| inspect(patch) }.flatten.compact
    end

    def inspect(patch)
      analyzer = ::Fasterer::Analyzer.new(patch.new_file_full_path)
      analyzer.scan

      errors = []
      analyzer.errors.each { |error| errors << error }

      errors
        .select { |error| !ignored_speedups.include?(error.name) }
        .flat_map do |error|
        patch.added_lines
          .select { |line| line.new_lineno == error.line }
          .map { |line| new_message(error, line) }
      end
    end

    def new_message(error, line)
      path = line.patch.delta.new_file[:path]
      Message.new(path, line, :warning, error.explanation)
    end

    def ignored_speedups
      @ignored_speedups ||= config[SPEEDUPS_KEY].select do |_, value|
        value == false
      end.keys.map(&:to_sym)
    end

    def ignored_files
      @ignored_files ||= config[EXCLUDE_PATHS_KEY].flat_map { |path| Dir[path] }
    end

    def config
      @config ||=
        if File.exist?(CONFIG_FILE_NAME)
          nil_config_file.merge(YAML.load_file(CONFIG_FILE_NAME))
        else
          nil_config_file
        end
    end

    def nil_config_file
      { SPEEDUPS_KEY => {}, EXCLUDE_PATHS_KEY => [] }
    end
  end
end
