require "csv"
accepted_formats = [".csv"]
file_name = ARGV[0]
lines = File.open(file_name)
lines_count = lines.readlines.size

if ((lines_count < 1) || (lines_count > 10000) || (!accepted_formats.include? File.extname(file_name)))
  puts "File is wrong,It should be csv file and the number of rows between 1 and 10000"
  exit
end

names = []
duplicate_names_indexes = []
quantity_counts = []
quantity_count = 0 
averages = []
brands = []
hash_file1 = Hash.new
hash_file2 = Hash.new
CSV.foreach(file_name).map do |row|
  names << row[2]
  duplicate_names_indexes =  names.each_index.group_by{|i| names[i]}.values.select{|a| a.length > 1}.flatten
  quantity_counts << row[3]
  brands << row[4]
end
averages = quantity_counts.map{|value| value.to_f / lines_count}
hash_file1 = Hash[names.zip(averages)] 
hash_file2 = Hash[names.zip(brands)] 
 
duplicate_names_indexes.map do |index|
  quantity_count += averages[index].to_f
  hash_file1[names[index]] = quantity_count
  hash_file2[names[index]] = brands.max_by {|i| brands.count(i)}
end
CSV.open("0_" + file_name, "wb") {|csv| hash_file1.to_a.each {|elem| csv << elem} }
CSV.open("1_" + file_name, "wb") {|csv| hash_file2.to_a.each {|elem| csv << elem} }