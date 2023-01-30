# frozen_string_literal: true

require 'snippit/exceptions'
require 'yaml'

module Snippit
  # Provides IO functions for Snippit.
  module IO
    # Reads teh contents of a code snippet.
    #
    # @param [String] slug The name of the snippet.
    # @return [String] The contents of the snippet.
    def read_snippet(slug)
      raise SnippetNotFoundError, slug unless File.exist?(filepath!(slug))

      File.read(filepath!(slug))
    end

    # Writes the contents of a code snippet to a file.
    #
    # @param [String] name The name of the snippet
    # @param [String] slug The name of the file. Relative to the ~/.snippit directory
    # @param [String] contents The contents of the file.
    # @param [TrueClass|FalseClass] force Whether or not to overwrite an existing file.
    def write_snippet(name, slug, contents, force)
      raise ReservedFilenameError, slug if slug == '.__definitions__.yml'

      raise SnippetExistsError, slug if File.exist?(filepath!(slug)) && !force

      File.write(filepath!(slug), contents)
      write_definition(definitions.merge(slug => name))
    end

    # Removes a code snippet.
    #
    # @param [String] slug The name of the file. Relative to the ~/.snippit directory
    def delete_snippet(slug)
      raise ReservedFilenameError, slug if slug == '.__definitions__.yml'

      File.delete(filepath!(slug))
      write_definition(definitions.reject { |k, _v| k == slug })
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

    # Loads the ~/.snippit/.__definitions__.yml file if it exists, or returns an empty hash.
    def definitions
      return {} unless File.exist?(definitions_file)

      @definitions ||= YAML.load_file(definitions_file)
    end

    # Writes the definitions to the ~/.snippit/.__definitions__.yml file.
    def write_definition(definitions)
      File.write(definitions_file, definitions.to_yaml)
    end

    # Returns the path to the ~/.snippit/.__definitions__.yml file.
    def definitions_file
      File.expand_path('.__definitions__.yml', snippit_dir)
    end
  end
end
