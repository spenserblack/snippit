# frozen_string_literal: true

require 'snippit/io'

module Snippit
  class CLI
    # Snippit::CLI::List lists all snippets.
    class List
      include Snippit::Io

      # Starts the list subcommand.
      #
      # @return [Integer] the exit code
      def start
        out = definitions.map { |slug, name| "#{slug}: #{name}" }

        puts 'No snippets found.' if out.empty?

        puts out
        0
      end
    end
  end
end
