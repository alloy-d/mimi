#!/usr/bin/env ruby
require 'date'
require 'exifr'

class Image
  def initialize(path)
    @current_path = path
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
    date_time.to_s + '.' + @extension
  end
end
