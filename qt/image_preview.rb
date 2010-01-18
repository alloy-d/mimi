#!/usr/bin/env ruby
require 'Qt4'

class ImagePreview < Qt::Widget
  def initialize(path, parent=nil)
    super(parent)

    image = Qt::Image.new(path)
    preview = image.scaled(300, 300, Qt::KeepAspectRatio,
                           Qt::SmoothTransformation)
    @pixmap = Qt::Pixmap.fromImage(preview)
  end

  def paintEvent(event)
    painter = Qt::Painter.new(self)
    pixmap = @pixmap.scaled(size(), Qt::KeepAspectRatio,
                            Qt::SmoothTransformation)

    left_offset = (width() - pixmap.width()) / 2
    top_offset = (height() - pixmap.height()) / 2

    painter.drawPixmap(left_offset, top_offset, pixmap)
  end
end


