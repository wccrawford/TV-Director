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

#			begin
				parseXmlFile nfoFile
#			rescue
#			end
#		elsif file.isDirectory then
		end

		@fileData.put('file', file)
	end
	
	def parseXmlFile file:File
		if(file.isFile) then
			dbFactory = DocumentBuilderFactory.newInstance
			dBuilder = dbFactory.newDocumentBuilder
			doc = dBuilder.parse file
			doc.getDocumentElement.normalize

			root = doc.getDocumentElement

			nodes = root.getChildNodes
			nodes.getLength.times { |index|
				if(nodes.item(index).getNodeType() == Node.ELEMENT_NODE) then
					Element element = Element(nodes.item(index))

					Node valueNode = element.getChildNodes.item(0)
					if(valueNode != null) then
						@fileData.put(element.getTagName, valueNode.getNodeValue)
					end
				end
			}
		end
	end

	def get(name:string)
		return @fileData.get(name)
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
		if (string(get('episode')) != nil)  then
			episodeA = Integer.parseInt(string(get('episode')))
		end
		if (string(df.get('episode')) != nil)  then
			episodeB = Integer.parseInt(string(df.get('episode')))
		end

		if (episodeA < episodeB) then
			return -1
		elsif (episodeA > episodeB) then
			return 1
		end

		return 0
	end

	def compareSeasonTo df:FileData
		int seasonA = 0
		int seasonB = 0
		if (string(get('season')) != nil)  then
			seasonA = Integer.parseInt(string(get('season')))
		end
		if (string(df.get('season')) != nil)  then
			seasonB = Integer.parseInt(string(df.get('season')))
		end

		if (seasonA < seasonB) then
			return -1
		elsif (seasonA > seasonB) then
			return 1
		end

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
