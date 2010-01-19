#!/usr/bin/env ruby
require 'find'
require 'Qt4'
require_relative 'image_preview.rb'

class ImageList < Qt::GraphicsView
  slots 'addImage(QString)'

  def initialize()
    super
    @images = []
    @row = 0
    @column = -1
    @spacing = 5

    @scene = Qt::GraphicsScene.new()
    @widget = Qt::GraphicsWidget.new()
#    @scene.resize(500,500)
    @layout = Qt::GraphicsGridLayout.new()
    [0,1].each {|c| @layout.setColumnAlignment(c, Qt::AlignCenter)}

    @layout.setRowAlignment(0, Qt::AlignCenter)
    @widget.setLayout(@layout)
    @scene.addItem(@widget)
    @widget.setMinimumSize(500, 250)
    setScene(@scene)
    [@widget].each do |i|
      i.setMinimumSize(200, 250)
      i.setPreferredSize(200, 250)
      i.setMaximumSize(200, 250)
    end
    setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff)
  end

  def addImage(path)
    preview = ImagePreview.new(path)
    if @column == 1
      @row += 1
      @layout.setRowAlignment(@row, Qt::AlignCenter)
      @column = 0
    else
      @column += 1
    end
    @layout.addItem(preview, @row, @column, Qt::AlignCenter)
  end

  def resizeEvent(event)
    @widget.setMinimumSize(event.size.width - 1,
                           (ImagePreview.max_height + @spacing) * @row)
    @widget.setPreferredSize(event.size.width - 1,
                             (ImagePreview.max_height + @spacing) * @row)
    @widget.setMaximumSize(event.size.width - 1,
                           (ImagePreview.max_height + @spacing) * @row)
  end
end
