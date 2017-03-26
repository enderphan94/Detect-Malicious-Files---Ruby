i=0

numbers = []

while i <6 
	puts "at the top i is #{i}"
	numbers.push(i)

	i += 1
	puts "Numbers now:", numbers
	puts "at the bottom i is #{i}"
end

puts "the numbers: "

numbers.each{|num| puts num}
