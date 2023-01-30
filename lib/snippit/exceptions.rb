# frozen_string_literal: true

module Snippit
  class Error < RuntimeError
  end

  class SnippetExistsError < Error
  end

  class SnippetNotFoundError < Error
  end

  class ReservedFilenameError < Error
  end
end
