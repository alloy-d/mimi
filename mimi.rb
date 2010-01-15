#!/usr/bin/env ruby
require 'Qt4'
require_relative 'importer.rb'

app = Qt::Application.new(ARGV)

importer = Importer.new('/home/adam/images/backgrounds/non-ifl/cbs_pww')
importer.show()

app.exec()
