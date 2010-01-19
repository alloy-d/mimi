#!/usr/bin/env ruby
require 'Qt4'
require_relative 'qt/importer.rb'
require_relative 'image_finder.rb'
require_relative 'image_importer.rb'

ui = ARGV.shift
if ui == 'qt'
  app = Qt::Application.new(ARGV)
end

from_directory = ARGV[0]
if from_directory.nil?
  STDERR.puts "Please specify a directory from which to import."
  exit 1
end
to_directory = ARGV[1]
if to_directory.nil?
  STDERR.puts "Please specify a destination directory."
  exit 2
end

if ui == 'qt'
  importer = Importer.new(from_directory, to_directory)
  importer.show()

  app.exec()
else
  finder = ImageFinder.new(from_directory) {|file| puts "Found #{file}"}

  importer = ImageImporter.new(finder, to_directory, true)
  importer.go(true) {|old, new| puts "#{old} -> #{new}"}
end
