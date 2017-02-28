require 'optparse'
require 'ostruct'
require 'digest'
require 'mongo'

Mongo::Logger.logger.level = ::Logger::FATAL

client = Mongo::Client.new(['127.0.0.1:27017'], :database =>'hashSample')

options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-s', '--sample SAMPLE', 'The sample') { |o| options.first_name = o }
end.parse!

s=options.first_name

digest = Digest::MD5.base64digest(File.read( s ))
puts "The file hashed is: #{digest}."
puts "-------------------"
sample = {:hash => digest}

storage_arr = Array.new

client[:backdoor].find().each do |a|
	
	storage_arr.push(a['hash'])
end

if(storage_arr.include?(digest))
	puts "The sample is already existed in database!!!"
else
	client[:backdoor].insert_one sample
	puts "Sampled added successfully!!!"
end
client.close
