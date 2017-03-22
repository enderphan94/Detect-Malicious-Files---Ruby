require 'net/http'
require 'uri'
require 'optparse'
require 'ostruct'
require 'digest'
options = OpenStruct.new
OptionParser.new do |opt|
	opt.on('--page', '--unhashed sample', 'The unhashed sample') { |o| options.sample = o }
end.parse!
p = options.sample

if(p)
	def open(url)
		  Net::HTTP.get(URI.parse(url))
	end

	page_content = open('https://virusshare.com/hashes/VirusShare_0000'+p+'.md5')
	#puts lines.each_line.reject{|line| line.start_with?('#') }.take(10)
	storage_data= []
	page_content.each_line do |line|	
		if line[0] != "#"
			storage_data.push(line)
		end
	end
	puts storage_data[0]
end
