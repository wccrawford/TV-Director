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

package tvdirector

class ListKeyListener < KeyAdapter
	def keyPressed(event)
		frame = getFrame(event)
		list = frame.getList
		currentLocation = frame.getCurrentLocation
		selectedValue =  list.getSelectedValue.toString

		keycode = event.getKeyCode
		print keycode

		if (keycode == 10) then
			file = File.new(currentLocation, selectedValue)

			if file.isDirectory then
				frame.addLocation(file.toString)

				frame.populateList
			end
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
