require 'optparse'
require 'ostruct'
require 'digest'
require 'mongo'

Mongo::Logger.logger.level = ::Logger::FATAL

client = Mongo::Client.new(['127.0.0.1:27017'], :database =>'hashSample')

options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-i', '--sample else', 'The unhashed sample') { |o| options.sample = o }
  opt.on('-s', '--show [use "-s show"]', 'Show the sample in database') { |o| options.show = o}
  opt.on('-h', '--help', 'Displays Help') do
		puts opt
		exit
  end
end.parse!

i=options.sample
s=options.show
if(i)
	digest = Digest::MD5.base64digest(File.read(i))
	puts "The file has been hashed is: #{digest}."
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
end
if(s=="show") 

	puts "The hashed samples in database\n"
        puts "-----------------------------------------"

	client[:backdoor].find().each do |a|
		puts "\n"
		puts "|\t#{a['hash']}\t|"
		puts "-----------------------------------------"
	end
end

client.close
