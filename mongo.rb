require 'mongo'
require 'optparse'
require 'ostruct'
require 'digest'

options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-D', '--Directory Location', 'Location of Directory') {|o| options.dir = o }
  opt.on('-t', '--File_Type FileType', 'Type of file eg. php,python') { |o| options.type = o }
  opt.on('-d', '--Time_Interval Day', 'How many days since now') { |o| options.time = o }

end.parse!

D=options.dir
t=options.type
d=options.time

Mongo::Logger.logger.level = ::Logger::FATAL

txt = open(D)

digest = Digest::MD5.base64digest(File.read(txt))
puts "hashed file: #{digest}"

client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'hashSample')
client[:backdoor].find().each do |a|
	puts a['hash']
	if(a['hash'].match(digest))
		puts "it matches"
	else
		puts "it doesn't match"
	end	
	
end


client.close
