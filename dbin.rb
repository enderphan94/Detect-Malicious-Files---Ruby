require 'optparse'
require 'ostruct'
require 'digest'
require 'mongo'
require 'net/http'
require 'uri'

Mongo::Logger.logger.level = ::Logger::FATAL

client = Mongo::Client.new(['127.0.0.1:27017'], database: 'hashSample')

options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-i', '--unhashed sample', 'The unhashed sample') { |o| options.sample = o }
  opt.on('-a', '--hashed code', 'available hashed') { |o| options.avai = o }
  opt.on('--page', '--page number of virusshare', 'Input from virusshare') { |o| options.page = o }
  opt.on('-s', '--show [use "-s show"]', 'Show the sample in database') { |o| options.show = o }
  opt.on('-h', '--help', 'Displays Help') do
    puts opt
    exit
  end
end.parse!
a = options.avai
p = options.page
i = options.sample
s = options.show
if i
  count = 0
  digest = Digest::MD5.base64digest(File.read(i))
  puts "The file has been hashed is: #{digest}."
  puts '-------------------'

  sample = { hash: digest }

  storage_arr = []

  client[:backdoor].find.each do |a|
    storage_arr.push(a['hash'])
  end

  if storage_arr.include?(digest)
    puts 'The sample is already existed in database!!!'
  else
    client[:backdoor].insert_one sample
    puts 'Samples added successfully!!!'
  end

  client[:backdoor].find.each do |_a|
    count += 1
  end

  puts "There are #{count} sample(s) is(are) available. You can use -s to show the data"
end
if s == 'show'

  puts "\n"
  count = 0
  client[:backdoor].find.each do |_a|
    count += 1
  end
  puts "There are #{count} sample(s) is(are) available. \n"
end

if a
  line_num = 0
  text = File.open(a).read
  storage_data = []
  client[:backdoor].find.each do |av|
    storage_data.push(av['hash'])
  end
  text.each_line do |line|
    line_num += 1
    # print "#{line}"
    sam = { hash: line }
    if storage_data.include?(line)
      puts 'The hashed code has existed'
    else
      client[:backdoor].insert_one sam
    end
  end
end

if p

  storage_data = []
  client[:backdoor].find.each do |av|
    storage_data.push(av['hash'])
  end

  def open(url)
    Net::HTTP.get(URI.parse(url))
  end

  page_content = open('https://virusshare.com/hashes/VirusShare_0000' + p + '.md5')

  storage_line = []
  page_content.each_line do |line|
    next unless line[0] != '#'
    storage_line.push(line)
    on = { hash: line }
    if storage_data.include?(line)
      break
    else
      puts 'Importing....., please wait. Do not turn your computer off!'
      client[:backdoor].insert_one on
    end
  end
  puts 'This page already imported' if storage_data.include?(storage_line[0])
end
client.close
