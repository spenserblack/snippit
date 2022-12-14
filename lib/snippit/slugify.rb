# frozen_string_literal: true

class Snippit
  # Provides the slugify function
  module Slugify
    # Slugify a string
    #
    # @param [String] str The string to slugify
    # @return [String] The slugified string
    def slugify(str)
      str.strip.downcase.gsub(/ /, '-').gsub(/[^a-z0-9\-_.]/, '')
    end
  end
end
