require 'csv'
bnd = {}

tst = {}
CSV.foreach("inputs/bound.csv", :headers => true, :header_converters => :symbol, :converters => :all) do |row|
  tst[row.fields[0]] = Hash[row.headers[1..-1].zip(row.fields[1..-1])]
end

## wtf is fields? above
# don't work below

CSV.foreach("bnd_test.csv", :headers => true, :header_converters => :symbol, :converters => :all) do |row|
  if bnd[row.fields[0]] == nil
    bnd[row.fields[0]][:id2] = [row.fields[1]]
    bnd[row.fields[0]][:boundary] = [row.fields[2]]
  else
    bnd[row.fields[0]][:id2] << [row.fields[1]]
    bnd[row.fields[0]][:boundary] << [row.fields[2]]
  end
end

a = CSV.read("bnd_test.csv", :headers => true, :header_converters => :symbol, :converters => :all)

################

bnd = {}
(0..1).each {|x|
  puts "x: " + x.to_s
  y = (x == 0 ? 1 : 0)
  bnd_file = File.open("bnd_test2.csv", "r")
  puts "y: " + y.to_s

  bnd_file.each {|row|
    puts "row: " + row.to_s
    next if row == "id1,id2,boundary\n"
    h = {}
    cells = row.strip.split(",")
    if bnd[cells[x].to_i] == nil
      h = {"ids" => [cells[y].to_i], "bounds" => [cells[2].to_f]}
      #bnd[cells[0].to_i] = {:boundary => [cells[2].to_f]}
    else
      puts bnd
      #h = {"ids" => bnd[cells[x].to_i]["ids"], "bounds" => bnd[cells[2].to_i]["bounds"]}
      h = bnd[cells[x].to_i]
      h["ids"] << cells[x].to_i
      h["bounds"] << cells[2].to_f
      #bnd[cells[0].to_i]["ids"] << [cells[1].to_i]
      #bnd[cells[0].to_i]["bounds"] << [cells[2].to_f]
    end
    #h = {"ids" => [], "bounds" => []}
    bnd[cells[0].to_i] = h
  }
  puts "done"
  bnd_file.close
}

# second pass





  



