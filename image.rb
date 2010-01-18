#!/usr/bin/env ruby
require 'date'
require 'pathname'

require 'exifr'

class Image
  attr_accessor :current_path

  def initialize(path)
    @current_path = Pathname.new(path)
    @exif_info = nil
    @extension = nil
    case path.downcase
    when /\.jpg$/
      @exif_info = EXIFR::JPEG.new(path)
      @extension = "jpg"
    else
      STDERR.printf("Unimplemented file type for '%s'\n", path)
    end
  end

  def name_from_date_time
    exif_date_time = @exif_info.date_time.to_s
    date_time = DateTime::parse(exif_date_time)
    Pathname.new(date_time.to_s + '.' + @extension)
  end

  def current_name
    @current_path.basename
  end
end
