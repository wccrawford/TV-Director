import "java.io.File"
import "java.io.FilenameFilter"

package tvdirector

class FileBaseFilter
	implements FilenameFilter
	def initialize baseName:String
		@baseName = baseName
	end

	def accept(dir:File, name:String)
		return name.startsWith(@baseName)
	end
end

