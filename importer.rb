#!/usr/bin/env ruby
require 'Qt4'
require_relative 'descriptive_progress_bar.rb'
require_relative 'image_list.rb'

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
