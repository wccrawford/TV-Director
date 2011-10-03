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
import "java.util.Arrays"
import "java.util.Collections"
import "java.util.HashMap"

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

		loadPropFile
		
		@locations = ArrayList.new([getProperty('videodir', System.getProperty('user.home'))])

		@fileData = Collections.synchronizedMap HashMap.new

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

		@list.addListSelectionListener TVListSelectionListener.new

		populateList
	end

	def loadPropFile
		# Set up properties file
		@prop = java::util::Properties.new

		propFile = File.new(System.getProperty('user.home'), '.tvdirector')
		@prop.load(java::io::FileInputStream.new(propFile)) if propFile.isFile

		if @prop.getProperty('videodir') == nil then
			@prop.setProperty('videodir', System.getProperty('user.home'))
			@prop.store(java::io::FileOutputStream.new(propFile), null)
		end

		if @prop.getProperty('removeSceneTags') == nil then
			@prop.setProperty('removeSceneTags', 'false')
			@prop.store(java::io::FileOutputStream.new(propFile), null)
		end
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
		@locations.add location
	end

	def removeLastLocation
		@locations.remove(@locations.size - 1) if @locations.size > 1
	end

	def populateList selectedIndex=0
		@listModel.clear
		
		dir = File.new getCurrentLocation

		extFilter = FileExtensionFilter.new allowedFileExtensions
		children = dir.listFiles
		children.each { |file|
			if file.isDirectory then
				@listModel.addElement(getFileMetadata file)	if shouldShowDirectory file
			elsif file.isFile then
				metadata = FileData(getFileMetadata(file))
				unless metadata.get('deleted') == 'true' then
					@listModel.addElement(getFileMetadata file) if extFilter.accept(dir, file.getName)
				end
			end
		}

		lmArray = @listModel.toArray
		Arrays.sort lmArray, FilenameComparator.new( @prop.getProperty('removeSceneTags').equals('true') )

		@listModel.clear
		lmArray.each { |object|
			@listModel.addElement(object)
		}

		@list.requestFocus
		listSize = @listModel.getSize
		selectedIndex = listSize if selectedIndex > listSize
		@list.setSelectedIndex(selectedIndex)
		@list.ensureIndexIsVisible(@list.getSelectedIndex)
	end

	def shouldShowDirectory directory:File
		extFilter = FileExtensionFilter.new(allowedFileExtensions)
		subdir = File.new(getCurrentLocation, directory.getName)
		filelist = subdir.list extFilter
		return true	if filelist.length > 0

		filelist = subdir.list { |file, name|
			subfile = File.new(file, name)
			return subfile.isDirectory
		}

		return true if filelist.length > 0
		return false
	end

	def getFileMetadata file:File
		fileData = @fileData.get(file.getPath)
		if(fileData == nil) then
			fileData = FileData.new(file)
			@fileData.put(file.getPath, fileData)
		end

		return fileData
	end

	def allowedFileExtensions
		extensions = getProperty('extensions', 'avi|mkv')

		return extensions.split '\\|'
	end

	def getProperty name:String, default:String
		prop = @prop.getProperty(name)
		if prop == nil then
			@prop.setProperty(name, default)
			propFile = File.new(System.getProperty('user.home'), '.tvdirector')
			@prop.store(java::io::FileOutputStream.new(propFile), null)
			prop = default
		end

		return prop
	end
end

