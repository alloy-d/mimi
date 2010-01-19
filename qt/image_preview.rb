#!/usr/bin/env ruby
require 'Qt4'

class ImagePreview < Qt::GraphicsWidget
  @@max_width = 200

  def initialize(path)
    super()

    @bg_color = Qt::Color.new(rand(255), rand(255), rand(255))
    image = Qt::Image.new(path)
    @preview = image.scaled(@@max_width,
                           @@max_width * 3/4,
                           Qt::KeepAspectRatio,
                           Qt::SmoothTransformation)
    self.setPreferredSize(@@max_width, @@max_width * 3/4)
  end

  def self.max_width
    @@max_width
  end

  def self.max_width=(new_max)
    @@max_width = new_max
  end

  def self.max_height
    @@max_width * 3/4
  end

  def self.max_height=(new_max)
    @@max_width = new_max * 4/3
  end

  def paint(painter, option, widget)
    painter.fillRect(self.contentsRect(),
                     @bg_color)

    preview_image = @preview
    if ((self.contentsRect.width() < preview_image.width()) or
        (self.contentsRect.height() < preview_image.height()))
      preview_image = preview_image.scaled(self.contentsRect.width(),
                                           self.contentsRect.height(),
                                           Qt::KeepAspectRatio,
                                           Qt::SmoothTransformation)
    end
    painter.drawPixmap((self.contentsRect.width() - preview_image.width())/2,
                       (self.contentsRect.height() - preview_image.height())/2,
                       Qt::Pixmap.fromImage(preview_image))
  end
end


