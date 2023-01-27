# frozen_string_literal: true

require 'snippit/exceptions'
require 'yaml'

module Snippit
  # Provides IO functions for Snippit.
  module Io
    # Writes the contents of a code snippet to a file.
    #
    # @param [String] name The name of the snippet
    # @param [String] slug The name of the file. Relative to the ~/.snippit directory
    # @param [String] contents The contents of the file.
    # @param [TrueClass|FalseClass] force Whether or not to overwrite an existing file.
    def write_snippet(name, slug, contents, force)
      raise SnippetExistsError, slug if File.exist?(filepath!(slug)) && !force

      File.write(filepath!(slug), contents)
      write_definition(definitions.merge(name => slug))
    end

    # Gets the filepath to the snippet.
    #
    # Also creates the ~/.snippit directory if it does not exist.
    #
    # @param [String] slug The name of the snippet.
    def filepath!(slug)
      File.expand_path(slug, snippit_dir!)
    end

    # Creates the ~/.snippit directory if it does not exist, and returns the path to it.
    def snippit_dir!
      FileUtils.mkdir_p(snippit_dir)
      snippit_dir
    end

    # Returns the path to the ~/.snippit directory.
    def snippit_dir
      File.expand_path('.snippit', Dir.home)
    end

    # Loads the ~/.__definitions__.yml file if it exists, or returns an empty hash.
    def definitions
      return {} unless File.exist?(definitions_file)

      YAML.load_file(definitions_file)
    end

    # Writes the definitions to the ~/.__definitions__.yml file.
    def write_definition(definitions)
      File.write(definitions_file, definitions.to_yaml)
    end

    # Returns the path to the ~/.__definitions__.yml file.
    def definitions_file
      File.expand_path('.__definitions__.yml', Dir.home)
    end
  end
end
