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
import "javax.swing.event.ListSelectionListener"
import "java.io.File"
import "javax.swing.ImageIcon"

package tvdirector

class TVListSelectionListener 
	implements ListSelectionListener
	def valueChanged(event:javax.swing.event.ListSelectionEvent)
		frame = getFrame(event)

		label = frame.getMainLabel

		list = JList(event.getSource)

		if(list.getSelectedValue != nil ) then
			file = File(list.getSelectedValue)

			label.setText file.getName
			label.setIcon nil

			if (file.isFile) then
				baseName = file.toString.substring(0, file.toString.length-4)
				
				iconFile = File.new(baseName+".tbn")

				if iconFile != nil then
					icon = ImageIcon.new(iconFile.toString)
					icon.setImage(icon.getImage.getScaledInstance(-1, 100, java::awt::Image.SCALE_SMOOTH))
					label.setIcon(icon)
				end
			elsif (file.isDirectory) then
				iconFile = File.new(file, "folder.jpg")
				if iconFile != nil then
					icon = ImageIcon.new(iconFile.toString)
					icon.setImage(icon.getImage.getScaledInstance(-1, 100, java::awt::Image.SCALE_SMOOTH))
					label.setIcon(icon)
				end
			end
		end

	end

	def getFrame(event:java.util.EventObject)
		list = JList(event.getSource)
		viewport = JViewport(list.getParent)
		scrollpane = JScrollPane(viewport.getParent)
		panel = JPanel(scrollpane.getParent)
		layeredpane = JLayeredPane(panel.getParent)
		rootpane = JRootPane(layeredpane.getParent)
		return MainFrame(rootpane.getParent)
	end
end
