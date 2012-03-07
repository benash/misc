require './spreadsheet'

# Read cells in
w, h = gets.split(' ').collect { |x| x.to_i }
spreadsheet = Spreadsheet.new(w, h)

(0...h).each do |y|
  (0...w).each do |x|
    spreadsheet.set(x, y, gets.chomp)
  end
end

# Print cells out
puts "#{spreadsheet.w} #{spreadsheet.h}"
(0...h).each do |y|
  (0...w).each do |x|
    printf("%.5f\n", spreadsheet.get(x, y))
  end
end
