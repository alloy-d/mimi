#!/usr/bin/env ruby
require 'find'
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

class ImageList < Qt::ScrollArea
  include Enumerable
  signals 'imageAdded()', 'newNumImages(int)', 'doneLoading()', 'newImage(QString)'
  slots 'addImage(QString)'

  def initialize(directory, parent=nil)
    super(parent)
    @images = []
    @row = 0
    @column = -1

    @layout = Qt::GridLayout.new
    setLayout(@layout)

    @update_timer = Qt::Timer.new(self)
    connect(self, SIGNAL('newImage(QString)'),
            self, SLOT('addImage(QString)'))
    connect(self, SIGNAL('imageAdded()'),
            self, SLOT('update()'))

    @thread = Thread.new(directory) do |dir|
      Find.find(directory) do |file|
        emit newImage(file) if file.downcase =~ /.jpg$/
        puts file
      end

      emit doneLoading()
    end
  end

  def addImage(path)
    preview = Qt::Label.new
    preview.setPixmap(Qt::Pixmap.new(path))
    preview.setScaledContents(true)

    if @column == 2
      @row += 1
      @column = 0
    else
      @column += 1
    end

    @layout.addWidget(preview, @row, @column)
    preview.adjustSize()
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

class Importer < Qt::Widget
  slots 'allowImport()', 'setNumImages(int)', 'setNumVideos(int)'

  def initialize(directory, parent=nil)
    super(parent)

    @progress_bar = DescriptiveProgressBar.new()
    @progress_bar.setText(tr('Loading...') + " (%m)")
    @progress_bar.setTextVisible(true)
    @progress_bar.setValue(0)
    @progress_bar.setEnabled(false)

    @button = Qt::PushButton.new(tr("Go!"))
    #connect(button, SIGNAL('clicked()'), self, SLOT('allowImport()'))
    @button.hide()

    @image_list = ImageList.new(directory)
    connect(@image_list, SIGNAL('doneLoading()'),
            self, SLOT('allowImport()'))
    connect(@image_list, SIGNAL('newNumImages(int)'),
            self, SLOT('setNumImages(int)'))
    connect(@image_list, SIGNAL('imageAdded()'),
            self, SLOT('repaint()'))

    main_layout = Qt::VBoxLayout.new()
    main_layout.addWidget(@image_list)

    action_layout = Qt::HBoxLayout.new()
    action_layout.addWidget(@progress_bar)
    action_layout.addWidget(@button)

    main_layout.addLayout(action_layout)
    setLayout(main_layout)

    setWindowTitle('mimi')
  end

  def allowImport
    @progress_bar.setEnabled(true)
    @progress_bar.setText(tr('Ready.'))
    @button.show()
  end

  def setNumImages(new_num)
    @progress_bar.setMaximum(new_num)
    @progress_bar.update()
  end

  def setNumVideos(new_num)
  end
end


app = Qt::Application.new(ARGV)

importer = Importer.new('/home/adam/images/backgrounds/non-ifl/cbs_pww')
importer.show()

app.exec()
