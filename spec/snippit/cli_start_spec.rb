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
                                                   { 'my-snippet' => 'My Snippet' }.to_yaml)
      end
    end

    context 'when --name is given' do
      let(:args) { ['--save', 'My Snippet', '--name', 'My Snippet Name'] }

      before { allow(File).to receive(:exist?).and_return(false) }

      it 'uses the provided name in the definitions file' do
        described_class.new(args).start
        expect(File).to have_received(:write).with(File.expand_path('.snippit/.__definitions__.yml', Dir.home),
                                                   { 'my-snippet' => 'My Snippet Name' }.to_yaml)
      end
    end

    context 'when --slug is given' do
      let(:args) { ['--save', 'My Snippet', '--slug', 'my-snippet-slug'] }

      before { allow(File).to receive(:exist?).and_return(false) }

      it 'uses the provided slug in the definitions file' do
        described_class.new(args).start
        expect(File).to have_received(:write).with(File.expand_path('.snippit/.__definitions__.yml', Dir.home),
                                                   { 'my-snippet-slug' => 'My Snippet' }.to_yaml)
      end
    end

    context 'when the file conflicts with an existing snippet' do
      before do
        allow(File).to receive(:exist?).with(File.expand_path('.snippit/my-snippet', Dir.home)).and_return(true)
        allow(File).to receive(:exist?).with(File.expand_path('.snippit/.__definitions__.yml',
                                                              Dir.home)).and_return(true)
        allow(YAML).to receive(:load_file).with(File.expand_path('.snippit/.__definitions__.yml',
                                                                 Dir.home)).and_return({ 'my-snippet' => 'My Snippet' })
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

  context 'when `--save .__definitions__.yml` is given' do
    let(:args) { ['--save', '.__definitions__.yml'] }

    before do
      allow(File).to receive(:read).with('.__definitions__.yml').and_return('')
    end

    it 'warns the user that the file is reserved' do
      expect { described_class.new(args).start }.to output(/reserved/).to_stderr
    end

    it 'returns 1' do
      expect(described_class.new(args).start).to eq(1)
    end
  end

  context 'when `--delete my-snippet` is given' do
    let(:args) { %w[--delete my-snippet] }

    before do
      allow(File).to receive(:exist?).with(File.expand_path('.snippit/my-snippet', Dir.home)).and_return(true)
      allow(File).to receive(:exist?).with(File.expand_path('.snippit/.__definitions__.yml', Dir.home)).and_return(true)
      allow(File).to receive(:delete)
      allow(File).to receive(:write)
    end

    context 'when my-snippet exists' do
      before do
        allow(YAML).to receive(:load_file).with(File.expand_path('.snippit/.__definitions__.yml',
                                                                 Dir.home)).and_return({ 'my-snippet' => 'My Snippet',
                                                                                         'foo' => 'bar' })
      end

      it 'removes the definition' do
        described_class.new(args).start
        expect(File).to have_received(:write).with(File.expand_path('.snippit/.__definitions__.yml', Dir.home),
                                                   { 'foo' => 'bar' }.to_yaml)
      end

      it 'deletes the file' do
        described_class.new(args).start
        expect(File).to have_received(:delete).with(File.expand_path('.snippit/my-snippet', Dir.home))
      end

      it 'returns 0' do
        expect(described_class.new(args).start).to eq(0)
      end
    end

    context 'when the snippet does not exist' do
      before do
        allow(YAML).to receive(:load_file).with(File.expand_path('.snippit/.__definitions__.yml',
                                                                 Dir.home)).and_return({ 'foo' => 'bar' })
      end

      it 'does not delete the file' do
        described_class.new(args).start
        expect(File).not_to have_received(:delete)
      end

      it 'returns 1' do
        expect(described_class.new(args).start).to eq(1)
      end
    end
  end

  context 'when `--get my-snippet` is given' do
    let(:args) { %w[--get my-snippet] }

    before do
      allow(File).to receive(:exist?).with(File.expand_path('.snippit/my-snippet', Dir.home)).and_return(true)
      allow(File).to receive(:exist?).with(File.expand_path('.snippit/.__definitions__.yml', Dir.home)).and_return(true)
    end

    context 'when my-snippet exists' do
      before do
        allow(YAML).to receive(:load_file).with(File.expand_path('.snippit/.__definitions__.yml',
                                                                 Dir.home)).and_return({ 'my-snippet' => 'My Snippet' })
        allow(File).to receive(:read).with(File.expand_path('.snippit/my-snippet', Dir.home)).and_return('foo')
      end

      it 'prints the snippets contents to STDOUT' do
        expect { described_class.new(args).start }.to output('foo').to_stdout
      end

      it 'returns 0' do
        expect(described_class.new(args).start).to eq(0)
      end
    end

    context 'when the snippet does not exist' do
      before do
        allow(YAML).to receive(:load_file).with(File.expand_path('.snippit/.__definitions__.yml',
                                                                 Dir.home)).and_return({ 'foo' => 'bar' })
      end

      it 'prints a warning to STDERR' do
        expect { described_class.new(args).start }.to output("Snippet 'my-snippet' does not exist.\n").to_stderr
      end

      it 'returns 1' do
        expect(described_class.new(args).start).to eq(1)
      end
    end
  end

  context 'when `--list` is given' do
    let(:args) { ['--list'] }

    before do
      allow(File).to receive(:exist?).with(File.expand_path('.snippit/.__definitions__.yml', Dir.home)).and_return(true)
      allow(YAML).to receive(:load_file).with(File.expand_path('.snippit/.__definitions__.yml',
                                                               Dir.home)).and_return({ 'my-snippet' => 'My Snippet',
                                                                                       'foo' => 'bar' })
    end

    it 'prints the list of snippets' do
      expected = <<~OUTPUT
        my-snippet: My Snippet
        foo: bar
      OUTPUT
      expect { described_class.new(args).start }.to output(expected).to_stdout
    end
  end
end
