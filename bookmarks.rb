require 'rubygems'
require 'sinatra'
require 'haml'
require File.dirname(__FILE__) + '/xmldata'
require File.dirname(__FILE__) + '/initialize'

helpers do
  include Rack::Utils; alias_method :h, :escape_html
end


items_par_page = 5
datafile = "urldata.xml"
now = 1

get '/page/:page' do
  page = params[:page].to_i
  if page < 1
    page = 1
  end
  getpage = XmlData.new
  getpage.file = datafile
  @bookmarks = getpage.xml2view(page, items_par_page)
  @now = getpage.max_record
  haml :index
end

get '/' do
  Initialize.initfile(datafile)
  redirect '/page/1'
end

post "/" do
  title = params[:title]
  url = params[:url]
  if title.nil? || url.nil?
      redirect '/'
  elsif title == '' || url == ''
      redirect '/'
  else
	  Initialize.initfile(datafile)
	  postroot = XmlData.new
	  postroot.file = datafile
	  postroot.make_xml(params[:title], params[:url])
	  @bookmarks = postroot.xml2view(1, items_par_page)
	  @now = postroot.max_record
	  haml :index
  end
end

not_found do
  "Not found"
end