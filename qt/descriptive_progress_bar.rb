#!/usr/bin/env ruby
require 'Qt4'

class DescriptiveProgressBar < Qt::ProgressBar
  def initialize(parent=nil)
    super
  end

  def setText(new_text)
    setFormat("#{new_text}")
  end

  def resetText
    setFormat("%v / %m")
  end
end
