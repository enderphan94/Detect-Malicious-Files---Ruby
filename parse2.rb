require 'optparse'
require 'ostruct'
require 'digest'

options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-f', '--first_name FIRSTNAME', 'The first name') { |o| options.first_name = o }
  opt.on('-l', '--last_name LASTNAME', 'The last name') { |o| options.last_name = o }
end.parse!

d=options.first_name
l=options.last_name

digest = Digest::MD5.base64digest(File.read( d ))
puts "The MD5 digest base64 encoded MD5 is #{digest}."

