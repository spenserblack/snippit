# frozen_string_literal: true

require 'snippit/cli'
require 'snippit/version'
require 'yaml'

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
      allow(File).to receive(:read).with('My Snippet').and_return('foo')
    end

    context 'when the .snippit directory does not exist' do
      before { allow(File).to receive(:exist?).and_return(false) }

      it 'creates the ~/.snippit directory' do
        described_class.new(args).start
        expect(FileUtils).to have_received(:mkdir_p).with(File.expand_path('.snippit', Dir.home)).at_least(:once)
      end

      it 'writes the snippet to the ~/.snippit directory' do
        described_class.new(args).start
        expect(File).to have_received(:write).with(File.expand_path('.snippit/my-snippet', Dir.home), 'foo')
      end

      it 'writes the definitions file' do
        described_class.new(args).start
        expect(File).to have_received(:write).with(File.expand_path('.snippit/.__definitions__.yml', Dir.home),
                                                   { 'My Snippet' => 'my-snippet' }.to_yaml)
      end
    end

    context 'when the file conflicts with an existing snippet' do
      before do
        allow(File).to receive(:exist?).with(File.expand_path('.snippit/my-snippet', Dir.home)).and_return(true)
        allow(File).to receive(:exist?).with(File.expand_path('.snippit/.__definitions__.yml',
                                                              Dir.home)).and_return(true)
      end

      it 'does not overwrite if --force is not given' do
        described_class.new(args).start
        expect(File).not_to have_received(:write)
      end

      it 'overwrites if --force is given' do
        described_class.new(args + ['--force']).start
        expect(File).to have_received(:write).with(File.expand_path('.snippit/my-snippet', Dir.home), 'foo')
      end

      it 'warns the user to use --force' do
        expect { described_class.new(args).start }.to output(/Use\ --force/).to_stderr
      end

      it 'returns 1' do
        expect(described_class.new(args).start).to eq(1)
      end
    end
  end
end
