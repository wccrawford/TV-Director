import "javax.swing.JFrame"
import "javax.swing.JList"
import "javax.swing.DefaultListModel"
import "javax.swing.JScrollPane"
import "javax.swing.JViewport"
import "javax.swing.JPanel"
import "javax.swing.JLayeredPane"
import "javax.swing.JRootPane"
import "javax.swing.JOptionPane"
import "java.awt.event.WindowAdapter"
import "java.awt.event.WindowEvent"
import "java.awt.event.KeyAdapter"
import "java.awt.event.KeyEvent"
import "java.io.File"

package tvdirector

class ListKeyListener < KeyAdapter
	def keyPressed(event)
		frame = getFrame(event)
		list = frame.getList
		currentLocation = frame.getCurrentLocation
		file = File(list.getSelectedValue)

		keycode = event.getKeyCode

#		file = File.new(currentLocation, selectedValue)

		if keycode==10 then
			execute frame, file
		end
		if keycode==39 then
			nextDirectory frame, file
		end
		if keycode==37 then
			previousDirectory frame
		end
		if keycode==8 then
			delete frame, currentLocation, file.getName
		end
	end

	def execute(frame:MainFrame, file:File)
		if file.isFile then
			cmd = String[2]
			cmd[0] = 'xdg-open'
			cmd[1] = file.toString
			Runtime.getRuntime().exec(cmd)
		end
	end

	def nextDirectory(frame:MainFrame, file:File)
		if file.isDirectory then
			list = frame.getList

			frame.addLocation(file.toString)

			frame.populateList
		end	
	end

	def previousDirectory(frame:MainFrame)
		list = frame.getList

		frame.removeLastLocation

		frame.populateList
	end

	def delete(frame:MainFrame, currentLocation:String, selectedValue:String)
		dir = File.new(currentLocation)
		file = File.new(currentLocation, selectedValue)

		if(file.isFile) then
			# Remove extension
			baseName = selectedValue.substring(0, selectedValue.length-4)

			baseFilter = FileBaseFilter.new baseName

			filelist = dir.listFiles baseFilter
			
			filelist.each { |subfile|
				print subfile.toString + "\n"
				cmd = String[2]
				cmd[0] = 'trash'
				cmd[1] = subfile.toString
				Runtime.getRuntime().exec(cmd)
			}

			frame.populateList
		end
	end

	def getFrame(event:KeyEvent)
		list = JList(event.getSource)
		viewport = JViewport(list.getParent)
		scrollpane = JScrollPane(viewport.getParent)
		panel = JPanel(scrollpane.getParent)
		layeredpane = JLayeredPane(panel.getParent)
		rootpane = JRootPane(layeredpane.getParent)
		return MainFrame(rootpane.getParent)
	end
end
