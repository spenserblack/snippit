# frozen_string_literal: true

require 'snippit/cli'
require 'snippit/version'

RSpec.describe Snippit::CLI, '#start' do
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

  context 'when `--save "My Snippet"` is given' do
    let(:args) { ['--save', 'My Snippet'] }

    before do
      allow(File).to receive(:write)
      allow(FileUtils).to receive(:mkdir_p)
    end

    context 'when the .snippit directory does not exist' do
      before do
        allow(File).to receive(:exist?).and_return(false)
        allow(File).to receive(:read).with('My Snippet').and_return('foo')
      end

      it 'creates the ~/.snippit directory' do
        described_class.new(args).start
        expect(FileUtils).to have_received(:mkdir_p).with(File.expand_path('.snippit', Dir.home)).at_least(:once)
      end

      it 'writes the snippet to the ~/.snippit directory' do
        described_class.new(args).start
        expect(File).to have_received(:write).with(File.expand_path('.snippit/my-snippet', Dir.home), 'foo')
      end
    end
  end
end
