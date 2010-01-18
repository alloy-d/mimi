#!/usr/bin/env ruby
require 'exifr'
require 'find'
require_relative 'image.rb'

class ImageFinder
  include Enumerable

  def initialize(directory)
    @images = []

    Find.find(directory) do |file|
      if file.downcase =~ /\.jpg$/
        @images << Image.new(file)
        yield file
      end
    end
  end

  def each
    @images.each do |image|
      yield image
    end
  end
end
