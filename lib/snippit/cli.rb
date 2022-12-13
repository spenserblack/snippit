# frozen_string_literal: true

require 'snippit'

module Snippit
  # Snippit::CLI is the command line interface for Snippit.
  class CLI
    def self.start(args)
      new(args).run
    end

    def initialize(args)
      @args = args
    end

    def run
      puts 'Hello, world!'
    end
  end
end
