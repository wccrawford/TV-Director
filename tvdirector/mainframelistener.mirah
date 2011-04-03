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

class MainFrameListener < WindowAdapter
	def windowClosing(event)
		System.exit(0)
	end

	def windowOpened(event)
		# Retrieve the frame from the event, and cast it so the methods are available to us.
		frame = MainFrame(event.getWindow)
		list = frame.getList
		list.requestFocus
		list.setSelectedIndex(0)
		list.ensureIndexIsVisible(list.getSelectedIndex)
	end
end

