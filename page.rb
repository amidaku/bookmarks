class Page
	def Page.paging(now_page, last_page)
	  if now_page < 2
	    paging_html = "#{now_page}"
	  else
	    paging_html = "<a href=\"/page/#{now_page - 1}\">#{now_page - 1}</a> #{now_page}"
	  end
	  if now_page == last_page
	    paging_html << ""
	  else
	    paging_html << " <a href=\"/page/#{now_page + 1}\">#{now_page + 1}</a>"
	  end
	end
end