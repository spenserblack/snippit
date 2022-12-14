# frozen_string_literal: true

class Snippit
  # Provides the slugify function
  module Slugify
    # Slugify a string
    def slugify(str)
      str.strip.downcase.gsub(/ /, '-').gsub(/[^a-z0-9\-_.]/, '')
    end
  end
end
