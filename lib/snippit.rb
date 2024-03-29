# frozen_string_literal: true

require 'snippit/version'

# Snippit manages code snippets.
class Snippit
  # Snippit::DEFINITIONS is a reserved filename for the snippet definitions.
  DEFINITIONS = '__definitions__.yml'

  attr_reader :snippit_dir

  def initialize(snippit_dir)
    @snippit_dir = snippit_dir
  end

  def definitions_filename
    File.join(snippit_dir, DEFINITIONS)
  end
end
