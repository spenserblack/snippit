# frozen_string_literal: true

require 'optparse'
require 'snippit/cli/version'

module Snippit
  # Snippit::CLI is the command line interface for Snippit.
  class CLI
    SUBCOMMANDS = { version: Version }.freeze
    def initialize(args)
      @args = args
      @subcommand = []
    end

    # Starts the CLI.
    #
    # @return [Integer] the exit code
    def start
      parser.parse!(@args)

      return bad_usage unless @subcommand.size == 1

      SUBCOMMANDS[@subcommand.first].new(@args).start
    end

    private

    def parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: snippit|snip [options]'

        opts.on('-v', '--version', 'Print version') do
          @subcommand << :version
        end
      end
    end

    def bad_usage
      puts parser
      1
    end
  end
end
