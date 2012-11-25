# -*- encoding: utf-8 -*-

require 'rubygems'
require 'sinatra'
require 'haml'
require File.dirname(__FILE__) + '/xmldata'
require File.dirname(__FILE__) + '/initialize'
require File.dirname(__FILE__) + '/page'

helpers do
	include Rack::Utils; alias_method :h, :escape_html
end

items_per_page = 10
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
	@paging = Page.paging(page, getpage.count_pages(items_per_page))
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
		@now_rec = postroot.count_records
		last_page = postroot.count_pages(items_per_page)
		@bookmarks = postroot.xml2view(last_page, items_per_page)
		@paging = Page.paging(last_page, last_page)
		haml :index
	end
end

not_found do
	"Not found"
end