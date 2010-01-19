#!/usr/bin/env ruby
require 'Qt4'
require_relative '../image_finder.rb'
require_relative 'descriptive_progress_bar.rb'
require_relative 'image_list.rb'

class Importer < Qt::Widget
  slots 'beginFinding()', 'allowImport()', 'doImport()'
  signals 'newImageFile(QString)', 'doneFinding()', 'importReady()'

  attr_accessor :num_images

  def initialize(from_directory, to_directory, parent=nil)
    super(parent)

    @from_directory = from_directory
    @to_directory = to_directory
    @num_images = 0

    @progress_bar = DescriptiveProgressBar.new()
    @progress_bar.setText(tr('Loading...') + " (%m)")
    @progress_bar.setTextVisible(true)
    @progress_bar.setValue(0)
    @progress_bar.setEnabled(false)

    @button = Qt::PushButton.new(tr("Go!"))
    connect(@button, SIGNAL('clicked()'), self, SLOT('doImport()'))
    @button.hide()

    @image_list = ImageList.new
    connect(self, SIGNAL('newImageFile(QString)'),
            @image_list, SLOT('addImage(QString)'))

    main_layout = Qt::VBoxLayout.new()
    main_layout.addWidget(@image_list)

    action_layout = Qt::HBoxLayout.new()
    action_layout.addWidget(@progress_bar)
    action_layout.addWidget(@button)

    main_layout.addLayout(action_layout)
    setLayout(main_layout)

    setWindowTitle('mimi')

    connect(self, SIGNAL('doneFinding()'), self, SLOT('allowImport()'))
    @start_timer = Qt::Timer::singleShot(60, self, SLOT('beginFinding()'))
#    @start_timer.start()
  end

  def beginFinding
    @Finder = ImageFinder.new(@from_directory) do |file|
      STDERR.puts file
      self.emit newImageFile(file)
      self.num_images = self.num_images + 1
      STDERR.puts self.num_images
    end
    emit doneFinding()
  end

  def allowImport
    @progress_bar.setEnabled(true)
    @progress_bar.setText(tr('Ready.'))
    @button.show()
  end

  def setNumVideos(new_num)
  end

  def num_images=(new_num)
    @num_images = new_num
    @progress_bar.setMaximum(new_num)
#    @progress_bar.update()
  end
end
