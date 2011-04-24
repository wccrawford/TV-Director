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
	end
	
	def parseXmlFile file:File
		dbFactory = DocumentBuilderFactory.newInstance
		dBuilder = dbFactory.newDocumentBuilder
		doc = dBuilder.parse file
		doc.getDocumentElement.normalize

		root = doc.getDocumentElement

		nodes = root.getChildNodes
#		print nodes.getLength
		nodes.getLength.times { |index|
#		for (index = 0, index < nodes.length, index+=1) {
			if(nodes.item(index).getNodeType() == Node.ELEMENT_NODE) then
				Element element = Element(nodes.item(index))

#				print Integer.toString(index) + "\n"
#				print element.toString + "\n"
#				print element.getNodeValue + "\n"
#				print element.getTagName + "\n"
				Node valueNode = element.getChildNodes.item(0)
				if(valueNode != null) then
#					print valueNode.getNodeValue + "\n"
					@fileData.put(element.getTagName, valueNode.getNodeValue)
				end
			end
		}

		@fileData.put('file', file);
	end
end
