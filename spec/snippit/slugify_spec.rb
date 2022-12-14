# frozen_string_literal: true

require 'snippit/slugify'

RSpec.describe Snippit::Slugify do
  let(:klass) { Class.new { include Snippit::Slugify } }

  it 'converts letters to lowercase' do
    expect(klass.new.slugify('MySnippet')).to eq('mysnippet')
  end

  it 'converts spaces to hyphens' do
    expect(klass.new.slugify('my snippet')).to eq('my-snippet')
  end

  it 'permits underscodes and periods' do
    expect(klass.new.slugify('hello_world.rb')).to eq('hello_world.rb')
  end

  it 'removes special characters' do
    expect(klass.new.slugify('My Snippet! (JS)')).to eq('my-snippet-js')
  end

  it 'trims whitespace' do
    expect(klass.new.slugify('  snippet  ')).to eq('snippet')
  end
end
