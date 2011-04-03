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

		@locations = ['/home/william/downloads/complete/TV']

		setTitle("Hello Mirah")
		setSize(300,200)
		setLocation(20,100)

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
		
		File dir = File.new(getCurrentLocation)

		children = dir.list
		children.each { |filename|
			@listModel.addElement(filename)
		}
	end
end

