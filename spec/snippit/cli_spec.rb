# frozen_string_literal: true

require 'snippit/cli'
require 'snippit/version'

RSpec.describe Snippit::CLI do
  context 'when --version is given' do
    let(:args) { %w[--version] }

    it 'prints the version' do
      expect { described_class.new(args).start }.to output("snippit #{Snippit::VERSION}\n").to_stdout
    end

    it 'returns 0' do
      expect(described_class.new(args).start).to eq(0)
    end
  end

  context 'when no arguments are given' do
    let(:args) { [] }

    it 'prints the usage' do
      expect { described_class.new(args).start }.to output(/Usage:\ /).to_stdout
    end

    it 'returns 1' do
      expect(described_class.new(args).start).to eq(1)
    end
  end
end
