# frozen_string_literal: true

require 'snippit/io'

module Snippit
  class CLI
    # Snippit::CLI::Get gets a snippet's contents.
    class Get
      include Snippit::IO

      def initialize(slug)
        @slug = slug
      end

      # Starts the get subcommand.
      #
      # @return [Integer] the exit code
      def start
        unless definitions.key?(@slug)
          warn "Snippet '#{@slug}' does not exist."
          return 1
        end

        print read_snippet(@slug)
        0
      end
    end
  end
end
