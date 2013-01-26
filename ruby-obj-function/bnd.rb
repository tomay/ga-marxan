infile = ARGV[0]
selection = ARGV[1].split(",").map { |s| s.to_i }

bnd = {}
(0..1).each {|x|
  y = (x == 0 ? 1 : 0)
  bnd_file = File.open(infile, "r")
  bnd_file.each {|row|
    next if row.strip == "id1,id2,boundary"
    h = {}
    cells = row.strip.split(",")
    if bnd[cells[x].to_i] == nil
      h = {"ids" => [cells[y].to_i], "bounds" => [cells[2].to_f]}
    else
      h = bnd[cells[x].to_i]
      unless h["ids"].include?(cells[y].to_i)
        h["ids"] << cells[y].to_i 
        h["bounds"] << cells[2].to_f
      end 
    end
    bnd[cells[x].to_i] = h
  }
  bnd_file.close
}

perimeter = 0
selection.each {|i| 
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

# selection = (0..500).map{rand(1..1000)}.uniq!



  



