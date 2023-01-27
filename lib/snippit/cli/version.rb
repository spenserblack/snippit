# frozen_string_literal: true

require 'snippit/version'

module Snippit
  class CLI
    # Snippit::CLI::Version is the version subcommand for Snippit::CLI.
    class Version
      # Starts the version subcommand.
      #
      # @return [Integer] the exit code
      def start
        puts "snippit #{Snippit::VERSION}"
        0
      end
    end
  end
end
