class XmlData
    require "rexml/document"
    include REXML
    
    def initialize
      @file = ''
    end
    attr_accessor :file
  
    def xml2view(page, items)
	  File.open(@file,"r") do |xmlfile|
	    xmldata = Document.new(xmlfile)
	  end
	  xmltree = Document.new File.new(@file)
	  
	  start_record_atpage = (page - 1) * items + 1
	  bookmarks = []
	  for i in start_record_atpage .. start_record_atpage + items - 1
	    bookmarks << {'title' => xmltree.elements["root/bookmark[#{i}]"].attributes['title'],
	     'url' => xmltree.elements["root/bookmark[#{i}]/url"].text.gsub("\n","")}
	  end
	  return bookmarks  
	end
	
	def make_xml(title, url)
	  xmltree = Document.new File.new(@file)
	  xml_root = xmltree.root
	  
	  e_bookmark = Element.new("bookmark")
	  e_bookmark.attributes["title"] = title
	  e_bookmark.add_element("url")
	  e_bookmark.elements["url"].text = url
	  
	  xml_root.add_element(e_bookmark)
	
	  File.open(@file,"w") do |xmldata|
	    xmltree.write(xmldata, 0)
	  end
	end




end