# frozen_string_literal: true

module Snippit
  class Error < RuntimeError
  end

  class SnippetExistsError < Error
  end
end
