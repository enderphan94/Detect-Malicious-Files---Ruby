require 'mongo'
require 'optparse'
require 'ostruct'
require 'digest'
require 'etc'
require 'date'

options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-D', '--Directory Location', 'Location of Directory') { |o| options.dir = o }
  opt.on('-t', '--File_Type FileType', 'Type of file eg. php,python') { |o| options.type = o }
  opt.on('-d', '--Time_Interval Day', 'How many days since now') { |o| options.time = o }
  opt.on('-h', '--help', 'Displays Help') do
    puts opt
    exit
  end
end.parse!

D = options.dir
t = options.type
@d = options.time

Mongo::Logger.logger.level = ::Logger::FATAL

@storage_arr = []
# files = Dir.glob(D)txt = open(D)
@hash = []

@i = 0
def open_folder(file)
  if t
    Dir.glob("#{file}/*" + t) do |subfiles|
      if File.directory?(subfiles)
        open_folder(subfiles)

      elsif File.file?(subfiles)
        open_file(subfiles)
      end
    end
  else
    Dir.glob("#{file}/*") do |subfiles|
      if File.directory?(subfiles)
        open_folder(subfiles)

      elsif File.file?(subfiles)
        open_file(subfiles)
      end
    end
    end
  end

def open_file(file)
  of = open(file.to_s, 'r')
  digest = Digest::MD5.base64digest(File.read(of))

  client = Mongo::Client.new(['127.0.0.1:27017'], database: 'hashSample')

  client[:backdoor].find.each do |a|
    @storage_arr.push(a['hash'])
  end

  if @storage_arr.include?(digest)
    uid = File.stat(file).uid
    perm = File.stat(file)
    time = File.mtime(file)
    contime = time.strftime('%m/%d/%y')

    if @d
      today = Date.today
      file_time = File.mtime(file).to_date
      condtime = file_time.strftime('%m/%d/%y')
      sub = (today - file_time).to_i
      if sub < @d.to_i
        puts '%o' % perm.mode + "\t" + Etc.getpwuid(uid).name + "\t" + file.to_s + "\t" + condtime.to_s
        end
    else
      puts '%o' % perm.mode + "\t" + Etc.getpwuid(uid).name + "\t" + file.to_s + "\t" + contime.to_s
      end
    end

  client.close
  end

puts "\n"
if t
  Dir.glob(D + '*' + t) do |file|
    open_folder(file) if File.directory?(file)
    open_file(file) if File.file?(file)
  end
else
  Dir.glob(D + '*') do |file|
    open_folder(file) if File.directory?(file)
    open_file(file) if File.file?(file)
  end
  end
