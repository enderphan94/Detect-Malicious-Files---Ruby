require 'mongo'
require 'optparse'
require 'ostruct'
require 'digest'

options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-D', '--Directory Location', 'Location of Directory') {|o| options.dir = o }
  opt.on('-t', '--File_Type FileType', 'Type of file eg. php,python') { |o| options.type = o }
  opt.on('-d', '--Time_Interval Day', 'How many days since now') { |o| options.time = o }

  opt.on('-h', '--help', 'Displays Help') do
		puts opt
		exit
  end
end.parse!

D=options.dir
t=options.type
d=options.time

Mongo::Logger.logger.level = ::Logger::FATAL

@storage_arr = Array.new
#files = Dir.glob(D)
#txt = open(D)
@hash =Array.new

@i=0
def open_folder(file)
	
	Dir.glob("#{file}/*") do |subfiles|
		if File.directory?(subfiles)
			open_folder(subfiles)
				
		elsif File.file?(subfiles)
			open_file(subfiles)	
		end
	end
end

def open_file(file)
	
	of = open("#{file}","r")
	digest = Digest::MD5.base64digest(File.read(of))

	client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'hashSample')

	client[:backdoor].find().each do |a|
		@storage_arr.push(a['hash'])			
	end

	if(@storage_arr.include?(digest))
		puts "Malicious file detected is"+"\t"+"#{file}"
	end
	
	client.close
end

Dir.glob(D+"*") do |file|
	
        if File.directory?(file)
                open_folder(file)
		
		#puts "is dir #{file}"
        end 
	if File.file?(file)
		#puts "is file #{file}"
                open_file(file)
        end
end
