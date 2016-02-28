require 'pronto'
require 'fasterer'
require 'fasterer/config'

module Pronto
  class Fasterer < Runner
    def initialize
      @config = ::Fasterer::Config.new
    end

    def run(patches, _)
      return [] unless patches

      valid_patches = patches.select do |patch|
        patch.additions > 0 &&
          ruby_file?(patch.new_file_full_path) &&
          !@config.ignored_files.include?(patch.delta.new_file[:path])
      end

      valid_patches.map { |patch| inspect(patch) }.flatten.compact
    end

    def inspect(patch)
      analyzer = ::Fasterer::Analyzer.new(patch.new_file_full_path)
      analyzer.scan

      errors = []
      analyzer.errors.each { |error| errors << error }

      errors
        .select { |error| !@config.ignored_speedups.include?(error.name) }
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
  end
end
