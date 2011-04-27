import "java.io.File"
import "java.io.FilenameFilter"

package tvdirector

class FileExtensionFilter
	implements FilenameFilter
	def initialize extensions:String[]
		@extensions = extensions
	end

	def accept(dir:File, name:String)
		acceptable = false

		@extensions.each { |extension| 
			acceptable = true if name.endsWith('.'+extension)
		}

		return acceptable
	end
end

