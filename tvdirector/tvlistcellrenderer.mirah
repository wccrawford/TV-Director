import "javax.swing.JList"
import "javax.swing.JLabel"
import "javax.swing.ImageIcon"
import "javax.swing.ListCellRenderer"
import "javax.swing.DefaultListCellRenderer"
import "java.io.File"
import "java.awt.Color"

package tvdirector

class TVListCellRenderer < DefaultListCellRenderer
#	def initialize
#		@icon = ImageIcon.new
#	end

	def getListCellRendererComponent(list:JList, value:Object, index:int, isSelected:boolean, cellHasFocus:boolean)
		file = File(value)

		setIcon(nil)

#		if (file.isFile) then
#			baseName = file.toString.substring(0, file.toString.length-4)
#			
#			iconFile = File.new(baseName+".tbn")
#
#			if iconFile != nil then
#				icon = ImageIcon.new(iconFile.toString)
#				icon.setImage(icon.getImage.getScaledInstance(-1, 100, java::awt::Image.SCALE_SMOOTH))
#				setIcon(icon)
#			end
#		elsif (file.isDirectory) then
#			iconFile = File.new(file, "folder.jpg")
#			if iconFile != nil then
#				icon = ImageIcon.new(iconFile.toString)
#				icon.setImage(icon.getImage.getScaledInstance(-1, 100, java::awt::Image.SCALE_SMOOTH))
#				setIcon(icon)
#			end
#		end

		setText(file.getName)

		setBackground(isSelected ? Color.cyan : Color.white)

		return self
	end
end