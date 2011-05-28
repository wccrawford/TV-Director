import "java.io.File"
import "javax.xml.parsers.DocumentBuilderFactory"
import "javax.xml.parsers.DocumentBuilder"
import "org.w3c.dom.Document"
import "org.w3c.dom.NodeList"
import "org.w3c.dom.Node"
import "org.w3c.dom.Element"
import "java.util.Collections"
import "java.util.HashMap"

package tvdirector

class FileData
	implements Comparable
	def initialize
		@fileData = Collections.synchronizedMap HashMap.new
	end

	def initialize file:File
		@fileData = Collections.synchronizedMap HashMap.new
		self.parseFile file
	end

	def parseFile file:File
		if file.isFile then
			baseName = file.toString.substring(0, file.toString.length-4)
				
			nfoFile = File.new(baseName+".nfo")

			begin
				parseXmlFile nfoFile
			rescue
			end

#		elsif file.isDirectory then
		end

		put('deleted', 'false')
		put('file', file)
	end
	
	def parseXmlFile file:File
		if(file.isFile) then
			dbFactory = DocumentBuilderFactory.newInstance
			dBuilder = dbFactory.newDocumentBuilder
			doc = dBuilder.parse file
			doc.getDocumentElement.normalize

			root = doc.getDocumentElement

			if(root.getTagName == 'episodedetails') then
				parseXmlEpisodeDetailsElement root
			else
				parseXmlXbmcMultiEpisodeElement root
			end

		end
	end

	def parseXmlXbmcMultiEpisodeElement element:Element
		nodes = element.getChildNodes
		nodes.getLength.times { |index|
			if(nodes.item(index).getNodeType() == Node.ELEMENT_NODE) then
				Element child = Element(nodes.item(index))

				return parseXmlEpisodeDetailsElement child if (child.getTagName == 'episodedetails')
			end
		}
	end

	def parseXmlEpisodeDetailsElement element:Element
		nodes = element.getChildNodes
		nodes.getLength.times { |index|
			if(nodes.item(index).getNodeType() == Node.ELEMENT_NODE) then
				Element element = Element(nodes.item(index))

				Node valueNode = element.getChildNodes.item(0)
				@fileData.put(element.getTagName, valueNode.getNodeValue) if(valueNode != null)
			end
		}
	end

	def get(name:String)
		return @fileData.get(name)
	end

	def put(name:String, value:Object)
		@fileData.put(name, value)
	end

	def compareTo object:Object
		begin
			return compareTo FileData(object)
		rescue
			return 0
		end
	end

	def compareTo df:FileData
		season = compareSeasonTo df
		return season if(season != 0)

		episode = compareEpisodeTo df
		return episode if(episode != 0)

		return compareNameTo(df)
	end

	def compareEpisodeTo df:FileData
		int episodeA = 0
		int episodeB = 0

		episodeA = Integer.parseInt(string(get('episode'))) if (string(get('episode')) != nil)
		episodeB = Integer.parseInt(string(df.get('episode'))) if (string(df.get('episode')) != nil)

		return -1 if (episodeA < episodeB)
		return 1 if (episodeA > episodeB)

		return 0
	end

	def compareSeasonTo df:FileData
		int seasonA = 0
		int seasonB = 0

		seasonA = Integer.parseInt(string(get('season'))) if (string(get('season')) != nil)
		seasonB = Integer.parseInt(string(df.get('season'))) if (string(df.get('season')) != nil)

		return -1 if (seasonA < seasonB)
		return 1 if (seasonA > seasonB)

		return 0
	end


	def compareNameTo df:FileData
		fileA = File(get('file'))
		fileB = File(df.get('file'))

		String nameA = fileA.getName
		String nameB = fileB.getName

		return nameA.compareTo(nameB)
	end
end
