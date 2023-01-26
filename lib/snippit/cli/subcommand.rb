# frozen_string_literal: true

module Snippit
  class CLI
    # Snippit::CLI::Subcommand is the base class for subcommands of Snippit::CLI.
    class Subcommand
      def initialize(args)
        @args = args
      end
    end
  end
end
