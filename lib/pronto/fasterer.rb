require 'pronto'
require 'fasterer'
require 'fasterer/config'

module Pronto
  class Fasterer < Runner
    def run
      valid_patches = ruby_patches.reject do |patch|
        config.ignored_files.include?(patch.delta.new_file[:path])
      end

      valid_patches.map { |patch| inspect(patch) }.flatten.compact
    end

    def inspect(patch)
      analyzer = ::Fasterer::Analyzer.new(patch.new_file_full_path)
      analyzer.scan

      errors = []
      analyzer.errors.each { |error| errors << error }

      errors
        .select { |error| !config.ignored_speedups.include?(error.name) }
        .flat_map do |error|
        patch.added_lines
          .select { |line| line.new_lineno == error.line }
          .map { |line| new_message(error, line) }
      end
    end

    def new_message(error, line)
      path = line.patch.delta.new_file[:path]
      Message.new(path, line, :warning, error.explanation, nil, self.class)
    end

    def config
      @fasterer_config ||= ::Fasterer::Config.new
    end
  end
end
