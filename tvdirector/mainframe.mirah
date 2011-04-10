import "javax.swing.JFrame"
import "javax.swing.JList"
import "javax.swing.DefaultListModel"
import "javax.swing.JScrollPane"
import "javax.swing.JViewport"
import "javax.swing.JLabel"
import "javax.swing.JPanel"
import "javax.swing.JLayeredPane"
import "javax.swing.JRootPane"
import "javax.swing.BoxLayout"
import "java.awt.event.WindowAdapter"
import "java.awt.event.WindowEvent"
import "java.awt.event.KeyAdapter"
import "java.awt.event.KeyEvent"
import "java.io.File"
import "java.io.FileFilter"
import "java.io.FilenameFilter"
import "java.util.ArrayList"

import "javax.swing.SwingConstants"

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

		@prop = java::util::Properties.new

		propFile = File.new(System.getProperty('user.home'), '.tvdirector')
		if propFile.isFile then
			@prop.load(java::io::FileInputStream.new(propFile))
		end

		if @prop.getProperty('videodir') == nil then
			@prop.setProperty('videodir', System.getProperty('user.home'))
			@prop.store(java::io::FileOutputStream.new(propFile), null)
		end

		@locations = ArrayList.new([@prop.getProperty('videodir')])

		setTitle("TV Director")
		setSize(800,600)
		setLocation(100,100)

		addWindowListener(MainFrameListener.new)

		panel = getContentPane
		panel.setLayout(BoxLayout.new(panel, BoxLayout.Y_AXIS))

		@mainLabel = JLabel.new 
		@mainLabel.setHorizontalAlignment SwingConstants.LEFT
		panel.add(@mainLabel)

		@listModel = DefaultListModel.new
		@list = JList.new(@listModel)
		@list.setCellRenderer TVListCellRenderer.new
		@list.addKeyListener(ListKeyListener.new)
		listScroll = JScrollPane.new(@list)
		panel.add(listScroll)


		# No need to create a new class because there's only 1 abstract
		# method for this listener
		@list.addListSelectionListener TVListSelectionListener.new
		
		populateList
	end

	def getProperties
		return @prop
	end

	def getMainLabel
		return @mainLabel
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

		exts = String[2]
		exts[0] = 'mkv'
		exts[1] = 'avi'

		extFilter = FileExtensionFilter.new(exts)

		children = dir.listFiles
		children.each { |file|
			if file.isDirectory then
				if shouldShowDirectory file then
					@listModel.addElement(file)
				end
			elsif file.isFile then
				if extFilter.accept(dir, file.getName) then
					@listModel.addElement(file)
				end
			end
		}

		@list.requestFocus
		@list.setSelectedIndex(0)
		@list.ensureIndexIsVisible(@list.getSelectedIndex)
	end

	def shouldShowDirectory directory:File
		exts = String[2]
		exts[0] = 'mkv'
		exts[1] = 'avi'

		extFilter = FileExtensionFilter.new(exts)
		subdir = File.new(getCurrentLocation, directory.getName)
		filelist = subdir.list extFilter
		if filelist.length > 0 then
			return true
		end

		filelist = subdir.list { |file, name|
			subfile = File.new(file, name)
			return subfile.isDirectory
		}
		if filelist.length > 0 then
			return true
		end

		return false
	end
end

