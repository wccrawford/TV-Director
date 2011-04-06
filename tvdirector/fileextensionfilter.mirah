import "java.io.File"
import "java.io.FilenameFilter"

package tvdirector

class FileExtensionFilter
	implements FilenameFilter
	def initialize extension:String
		@extension = extension
	end

	def accept(dir:File, name:String)
		return name.endsWith('.'+@extension)
	end
end

