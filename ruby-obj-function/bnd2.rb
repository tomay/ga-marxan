infile = ARGV[0]
selection = ARGV[1].split(",").map { |s| s.to_i }
#selection = [1,2,3,4]

bnd = {}
(0..1).each {|x|
  #puts "x: " + x.to_s
  y = (x == 0 ? 1 : 0)
  bnd_file = File.open(infile, "r")
  #puts "y: " + y.to_s

  bnd_file.each {|row|
    next if row == "id1,id2,boundary\n"
    #puts "row: " + row.to_s
    h = {}
    cells = row.strip.split(",")
    #puts "id searching: " + bnd[cells[x].to_i].to_s
    if bnd[cells[x].to_i] == nil
      h = {"ids" => [cells[y].to_i], "bounds" => [cells[2].to_f]}
      #bnd[cells[0].to_i] = {:boundary => [cells[2].to_f]}
    else
      #puts bnd
      #h = {"ids" => bnd[cells[x].to_i]["ids"], "bounds" => bnd[cells[2].to_i]["bounds"]}
      h = bnd[cells[x].to_i]
      unless h["ids"].include?(cells[y].to_i)
        h["ids"] << cells[y].to_i 
        h["bounds"] << cells[2].to_f
      end 
      #bnd[cells[0].to_i]["ids"] << [cells[1].to_i]
      #bnd[cells[0].to_i]["bounds"] << [cells[2].to_f]
    end
    #h = {"ids" => [], "bounds" => []}
    bnd[cells[x].to_i] = h
  }
  #puts "done"
  #puts bnd
  bnd_file.close
}

#selection = [1,2,3,7,8]
perimeter = 0
selection.each {|i| # why iterate over all instead of just the selection?
  #puts i
  sum = bnd[i]["bounds"].inject(:+)
  selection.each {|id|
    next if i == id
    if bnd[i]["ids"].include?(id)
      indx = bnd[i]["ids"].index(id)
      sum = sum - bnd[i]["bounds"][indx]
    end
  }
  perimeter = perimeter + sum
}
puts "Perimeter: " + perimeter.to_s



  



