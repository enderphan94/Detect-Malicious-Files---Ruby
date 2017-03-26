input_file = ARGV.first

def print_all(f)
	puts f.read

end

def rewind(f)

	f.seek(0)

end

def print_line(line_count, f)
	puts "#{line_count}, #{f.gets.chomp}"

end

current_file = open(input_file)

puts " first let's print the whole file: \n"

print_all(current_file)

puts "Now you rewind the file: \n"

rewind(current_file)

puts "print the lines: \n"

current_line =1
print_line(current_line, current_file)

current_line = current_line + 1
print_line(current_line, current_file)
