# frozen_string_literal: true

require 'snippit/io'

module Snippit
  class CLI
    # Snippit::CLI::Delete deletes a snippet.
    class Delete
      include Snippit::IO

      def initialize(slug)
        @slug = slug
      end

      # Starts the delete subcommand.
      #
      # @return [Integer] the exit code
      def start
        return 1 unless definitions.key?(@slug)

        delete_snippet(@slug)
        0
      end
    end
  end
end
