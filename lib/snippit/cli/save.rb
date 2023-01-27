# frozen_string_literal: true

require 'snippit/exceptions'
require 'snippit/io'
require 'snippit/slugify'

module Snippit
  class CLI
    # Snippit::CLI::Save saves a new snippet, or overwrites an existing one.
    class Save
      include Snippit::Io
      include Snippit::Slugify

      # Initializes a new Save subcommand.
      #
      # @param [String] path The path to the snippet to save
      # @param [TrueClass|FalseClass] force
      def initialize(path, force)
        @force = force
        @path = path
      end

      # Starts the save subcommand.
      #
      # @return [Integer] the exit code
      def start
        # TODO: Refuse if filename would be .__definitions__.yml
        base_name = File.basename(@path)
        slug = slugify(base_name)

        begin
          write_snippet(base_name, slug, File.read(@path), @force)
        rescue Snippit::SnippetExistsError
          warn "Snippet #{slug} already exists. Use --force to overwrite."
          return 1
        end

        0
      end
    end
  end
end
