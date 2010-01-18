#!/usr/bin/env ruby
require 'find'
require 'Qt4'
require_relative 'image_preview.rb'

class ImageList < Qt::Widget
  include Enumerable
  signals 'imageAdded()', 'newNumImages(int)', 'doneLoading()', 'newImage(QString)'
  slots 'addImage(QString)'

  def initialize(directory, parent=nil)
    super(parent)
    @images = []
    @row = 0
    @column = -1

    resize(500,500)
    @layout = Qt::GridLayout.new()
    setLayout(@layout)

    @update_timer = Qt::Timer.new(self)
    connect(self, SIGNAL('newImage(QString)'),
            self, SLOT('addImage(QString)'))
    connect(self, SIGNAL('imageAdded()'),
            self, SLOT('update()'))

    @thread = Thread.new(directory) do |directory|
      Find.find(directory) do |file|
        emit newImage(file) if file.downcase =~ /.jpg$/
        puts file
      end

      emit doneLoading()
    end
  end

  def addImage(path)
    preview = ImagePreview.new(path)
    if @column == 2
      @row += 1
      @column = 0
    else
      @column += 1
    end
    @layout.addWidget(preview, @row, @column)

    @images << path

    emit imageAdded()
    emit newNumImages(@images.count)
  end

  def each
    @images.each do |image|
      yield image
    end
  end
end
