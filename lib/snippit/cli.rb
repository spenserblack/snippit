# frozen_string_literal: true

require 'optparse'
require 'snippit/cli/save'
require 'snippit/cli/version'

module Snippit
  # Snippit::CLI is the command line interface for Snippit.
  class CLI
    def initialize(args)
      @args = args
      @opts = {}
    end

    # Starts the CLI.
    #
    # @return [Integer] the exit code
    def start
      parser.parse!(@args)

      return Version.new.start if @opts[:version]

      return Save.new(@opts[:save], @opts[:force]).start if @opts.key?(:save)

      bad_usage
    end

    private

    def parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: snippit|snip [options]'

        opts.on('-s', '-a', '--save PATH', '--add PATH', 'Save a new snippet') do |path|
          @opts[:save] = path
        end
        opts.on('-f', '--force', 'Used with --save to overwrite existing snippets') do
          @opts[:force] = true
        end
        opts.on('-v', '--version', 'Print version') do
          @opts[:version] = true
        end
      end
    end

    def bad_usage
      puts parser
      1
    end
  end
end
