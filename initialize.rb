class Initialize
	def Initialize.initfile(file)
	  unless File.exist?(file)
	    mkfile = File.open(file, "w")
	    mkfile.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n</root>")
	    mkfile.close
	  end
	end
end