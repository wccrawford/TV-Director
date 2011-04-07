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
			if name.endsWith('.'+extension) then
				acceptable = true
			end
		}

		return acceptable
	end
end

