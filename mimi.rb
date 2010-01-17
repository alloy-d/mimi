#!/usr/bin/env ruby
require 'Qt4'
require_relative 'importer.rb'

app = Qt::Application.new(ARGV)

base_directory = ARGV[0]
if base_directory.nil?
  STDERR.puts "Please specify a directory."
  exit 1
end

importer = Importer.new(base_directory)
importer.show()

app.exec()
