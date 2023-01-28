# frozen_string_literal: true

require 'snippit/exceptions'
require 'snippit/io'
require 'snippit/slugify'

module Snippit
  class CLI
    # Snippit::CLI::Save saves a new snippet, or overwrites an existing one.
    class Save
      include Snippit::IO
      include Snippit::Slugify

      # Initializes a new Save subcommand.
      #
      # @param [String] path The path to the snippet to save
      # @param [TrueClass|FalseClass] force
      def initialize(path, force: false, name: nil, slug: nil)
        @force = force
        @path = path
        @name = name
        @slug = slug
      end

      # Starts the save subcommand.
      #
      # @return [Integer] the exit code
      def start
        base_name = File.basename(@path)
        slug = @slug || slugify(base_name)

        handle(slug) { write_snippet(@name || base_name, slug, File.read(@path), @force) }
      end

      private

      # Executes a provided block, handling errors.
      def handle(slug)
        begin
          yield
        rescue Snippit::SnippetExistsError
          warn "Snippet #{slug} already exists. Use --force to overwrite."
          return 1
        rescue Snippit::ReservedFilenameError
          warn "#{slug} is a reserved filename. Please choose another."
          return 1
        end

        0
      end
    end
  end
end
