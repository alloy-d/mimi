#!/usr/bin/env ruby
require 'fileutils'
require 'pathname'
require_relative 'image.rb'

class ImageImporter
  def initialize(image_list, destination, verbose=false)
    @image_list = image_list
    @destination = Pathname.new(destination)
    @copy_paths = []
    @already_copied = []

    check_overlap(verbose)
  end

  def check_overlap(verbose=false)
    @image_list.each do |image|
      new_file = @destination + image.name_from_date_time
      if new_file.exist?
        printf("'%s' already exists in '%s'.\n",
               image.name_from_date_time,
               @destination) if verbose
        @already_copied << image
      else
        @copy_paths << [image.current_path, new_file]
      end
    end
  end

  def go(verbose=false)
    @copy_paths.each do |pair|
      printf("'%s' -> '%s'\n", pair[0], pair[1]) if verbose
      FileUtils.cp(pair[0], pair[1])
      yield pair[0], pair[1]
    end
  end
end
