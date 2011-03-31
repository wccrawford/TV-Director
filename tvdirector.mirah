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

class TVDirectorFrameListener < WindowAdapter
	def windowClosing(event)
		System.exit(0)
	end

	def windowOpened(event)
		# Retrieve the frame from the event, and cast it so the methods are available to us.
		frame = TVDirectorFrame(event.getWindow)
		list = frame.getList
		list.requestFocus
		list.setSelectedIndex(0)
		list.ensureIndexIsVisible(list.getSelectedIndex)
	end
end

class TVDirectorListEventListener < KeyAdapter
	def keyPressed(event)
		frame = getFrame(event)
		print frame.getCurrentLocation
		list = frame.getList
		print list.getSelectedValue
	end

	def getFrame(event:KeyEvent)
		list = JList(event.getSource)
		viewport = JViewport(list.getParent)
		scrollpane = JScrollPane(viewport.getParent)
		panel = JPanel(scrollpane.getParent)
		layeredpane = JLayeredPane(panel.getParent)
		rootpane = JRootPane(layeredpane.getParent)
		return TVDirectorFrame(rootpane.getParent)
	end
end

class TVDirectorFrame < JFrame 
	def getList
		return @list
	end

	def getLocations
		return @locations
	end

	def initialize
		super

		@locations = ['/home/william/downloads/complete/TV']

		setTitle("Hello Mirah")
		setSize(300,200)
		setLocation(20,100)

		addWindowListener(TVDirectorFrameListener.new)

		panel = getContentPane
		@listModel = DefaultListModel.new
		@list = JList.new(@listModel)
		listScroll = JScrollPane.new(@list)
		panel.add(listScroll)
		@list.addKeyListener(TVDirectorListEventListener.new)
		
		populateList
	end

	def getCurrentLocation
		return @locations.get(@locations.size-1).toString
	end

	def populateList
		@listModel.clear
		
		File dir = File.new(getCurrentLocation)

		children = dir.list
		children.each { |filename|
			@listModel.addElement(filename)
		}
	end
end

frame = TVDirectorFrame.new
frame.show

