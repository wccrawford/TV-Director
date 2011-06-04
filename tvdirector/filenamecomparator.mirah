import java.util.Comparator
import java.lang.reflect.Method

package tvdirector

class FilenameComparator
	implements Comparator

	def initialize
		@removeSceneTags = false
	end

	def initialize(removeSceneTags:boolean)
		@removeSceneTags = removeSceneTags
	end

	def compare (object1:String, object2:String)
		o1 = String(object1)
		o2 = String(object2)

		if(@removeSceneTags) then
			o1 = removeSceneTag o1
			o2 = removeSceneTag o2
		end

		o1.compareTo(o2)
	end

	def removeSceneTag(filename:String)
		trimmedFilename = filename.replaceAll('^(/.*/)?[\[(][^\])]*[\])][ _]*', '');
	end

	def compare(object1:FileData, object2:FileData)
		compare(object1.get('file').toString, object2.get('file').toString)
	end

	def compare(object1:Object, object2:Object)
		compare(FileData(object1), FileData(object2))
	end
end
