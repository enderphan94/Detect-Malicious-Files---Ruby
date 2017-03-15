require 'optparse'
require 'ostruct'
require 'digest'
require 'mongo'

Mongo::Logger.logger.level = ::Logger::FATAL

client = Mongo::Client.new(['127.0.0.1:27017'], database: 'hashSample')

options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-i', '--sample hash', 'The unhashed sample') { |o| options.sample = o }
  opt.on('-a', '--available hashed code', 'available hashed') { |o| options.avai = o }
  opt.on('-s', '--show [use "-s show"]', 'Show the sample in database') { |o| options.show = o }
  opt.on('-h', '--help', 'Displays Help') do
    puts opt
    exit
  end
end.parse!
a = options.avai
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

  puts "The hashed samples in database\n"
  puts '-----------------------------------------'

  client[:backdoor].find.each do |a|
    # puts "\n"
    puts "|\t#{a['hash']}\t|"
    puts '-----------------------------------------'
  end
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
client.close
