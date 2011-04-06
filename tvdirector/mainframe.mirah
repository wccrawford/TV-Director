import "javax.swing.JFrame"
import "javax.swing.JList"
import "javax.swing.DefaultListModel"
import "javax.swing.JScrollPane"
import "javax.swing.JViewport"
import "javax.swing.JPanel"
import "javax.swing.JLayeredPane"
import "javax.swing.JRootPane"
import "java.awt.event.WindowAdapter"
import "java.awt.event.WindowEvent"
import "java.awt.event.KeyAdapter"
import "java.awt.event.KeyEvent"
import "java.io.File"
import "java.io.FilenameFilter"
import "java.util.ArrayList"

import "tvdirector.ListKeyListener"
import "tvdirector.MainFrameListener"

package tvdirector

class MainFrame < JFrame 
	def getList
		return @list
	end

	def getLocations
		return @locations
	end

	def initialize
		super

		@locations = ArrayList.new(['/home/william/downloads/complete/TV'])

		setTitle("Hello Mirah")
		setSize(800,600)
		setLocation(100,100)

		addWindowListener(MainFrameListener.new)

		panel = getContentPane
		@listModel = DefaultListModel.new
		@list = JList.new(@listModel)
		listScroll = JScrollPane.new(@list)
		panel.add(listScroll)
		@list.addKeyListener(ListKeyListener.new)
		
		populateList
	end

	def getCurrentLocation
		return @locations.get(@locations.size-1).toString
	end

	def addLocation(location:String)
		@locations.add(location)
	end

	def removeLastLocation()
		if @locations.size > 1 then
			@locations.remove(@locations.size - 1)
		end
	end

	def populateList
		@listModel.clear
		
		dir = File.new(getCurrentLocation)

		extFilter = FileExtensionFilter.new('mkv')

		children = dir.listFiles
		children.each { |file|
			if file.isDirectory then
				subdir = File.new(getCurrentLocation, file.getName)
				filelist = subdir.list extFilter
				if filelist.length > 0 then
					@listModel.addElement(file.getName)
				end
			elsif file.isFile then
				if extFilter.accept(dir, file.getName) then
					@listModel.addElement(file.getName)
				end
			end
		}

		@list.requestFocus
		@list.setSelectedIndex(0)
		@list.ensureIndexIsVisible(@list.getSelectedIndex)
	end
end

