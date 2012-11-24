require 'rubygems'
require 'sinatra'
require 'haml'
require File.dirname(__FILE__) + '/xmldata'
require File.dirname(__FILE__) + '/initialize'

helpers do
  include Rack::Utils; alias_method :h, :escape_html
end

def paging(now_page, last_page)
  #last_page = getpage.count_pages(items_per_page)
  if now_page == 1
    paging_html = "1 <a href=\"/page/2\">2</a>"
  elsif now_page == last_page
    paging_html = "<a href=\"/page/#{last_page - 1}\">#{last_page - 1}</a> #{last_page}"
  else
    paging_html = "<a href=\"/page/#{now_page - 1}\">#{now_page - 1}</a> #{now_page} <a href=\"/page/#{now_page + 1}\">#{now_page + 1}</a>"
  end
end


items_per_page = 5
datafile = "urldata.xml"
now = 1

get '/page/:page' do
  page = params[:page].to_i
  if page < 1
    page = 1
  end
  getpage = XmlData.new
  getpage.file = datafile
  @bookmarks = getpage.xml2view(page, items_per_page)
  @now_rec = getpage.count_records
  @now_page = paging(page, getpage.count_pages(items_per_page))
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
	  @bookmarks = postroot.xml2view(1, items_per_page)
	  @now_rec = postroot.count_records
	  haml :index
  end
end

not_found do
  "Not found"
end