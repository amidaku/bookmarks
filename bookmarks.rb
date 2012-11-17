require 'rubygems'
require 'sinatra'
require 'haml'
require "rexml/document"
include REXML

def xml2view(file)
  File.open(file,"r") do |xmlfile|
    xmldata = Document.new(xmlfile)
  end
  xmltree = Document.new File.new(file)
  @bookmark = []
  xmltree.elements.each('root/bookmark') do |ele|
    @bookmark << {'title' => ele.attributes["title"], 'url' => ele.elements["url"].text.gsub("\n","")}
  end
end

def make_xml(file)
  title = params[:title]
  url = params[:url]
  xmltree = Document.new File.new(file)
  xml_root = xmltree.root
  
  e_bookmark = Element.new("bookmark")
  e_bookmark.attributes["title"] = title
  e_bookmark.add_element("url")
  e_bookmark.elements["url"].text = url
  
  xml_root.add_element(e_bookmark)

  File.open(file,"w") do |xmldata|
    xmltree.write(xmldata, 0)
  end
end

def initfile(file)
  unless File.exist?(file)
    mkfile = File.open(file, "w")
    mkfile.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n</root>")
    mkfile.close
  end
end

datafile = "urldata.xml"

get '/' do
  initfile(datafile)
  xml2view(datafile)
  haml :index
end

post "/" do
  initfile(datafile)
  make_xml(datafile)
  xml2view(datafile)
  haml :index

end

not_found do
  "Not found"
end