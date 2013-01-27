require 'csv'
#infile = ARGV[0]
#selection = ARGV[1].split(",").map { |s| s.to_i }

# open files
sppf = "inputs/species.csv"
#puvf = "inputs/puvsp_spp_test.csv"
puvf = "inputs/puvsp_feat.csv"
puvfile = File.open(puvf,"r")
sppfile = File.open(sppf,"r")

selection = [1,2,3,4]

puv = {}
spp = {}
spp_sums = {}

# csv object for species.csv
CSV.foreach(sppfile, :headers => true, :header_converters => :symbol, :converters => :all) do |row|
  spp[row.fields[0]] = Hash[row.headers[1..-1].zip(row.fields[1..-1])]
end

# next get total dist of all spp into memory
# during same read of file, build puv hash
sum = 0
spp_init = 1
puvfile.each {|row|
  next if row.strip == "species,pu,amount"
  spec_id = row.strip.split(",")[0].to_i
  pu_id = row.strip.split(",")[1].to_i
  amount = row.strip.split(",")[2].to_f
  if spp_init == spec_id
    sum = sum + amount
  else
    spp_sums[spp_init] = {:total_area => sum} # write out existing sum
    sum = amount # start new sum
    spp_init = spec_id # reset init
  end
  
  h = {}
  if puv[pu_id] == nil
    h = {"species" => [spec_id], "amount" => [amount]}
  else
    h = puv[pu_id] # capture existing values
    h["species"] << spec_id
    h["amount"] << amount 
  end
  puv[pu_id] = h
}
# catch final set
spp_sums[spp_init] = {:total_area => sum}
puvfile.close

# count spp amounts on a selected set of pus
selected = {}
penalty = 0
selection.each {|id|
  (0..puv[id]["species"].count - 1).each {|i| 
    species = puv[id]["species"][i]
    area = puv[id]["amount"][i]
    h = {}
    if selected[species] == nil
      h = {"selected_amount" => area}
    else
      area = area + selected[species]["selected_amount"] # capture existing values
      h["selected_amount"] = area
    end
    selected[species] = h
  }
}

# compare selected amounts to targets 
# requires three files spp, spp_sums and selected
# penalty for three cases:
#   1. Species listed in species.csv but no occurrences in entire planning region (no occurrences in puvsp)
#   2. No occurrences selected
#   3. Not enough occurrences selected
penalty = 0
missed = 0
spp.each {|species|
  #puts species
  sp_id = species[0]
  prop = species[1][:prop]
  spf = species[1][:spf]
  increase_penalty = true
  begin
    unless spp_sums[sp_id].nil? or selected[sp_id].nil? # case 1 or case 2
      total = spp_sums[sp_id][:total_area]
      area = selected[sp_id]["selected_amount"]
      if area > prop * total # case 3
        increase_penalty = false
      end
    end
    if increase_penalty
      penalty = penalty + spf
      missed += 1
    end
  rescue
    puts "Exception on species id: " + sp_id.to_s
  end
}
puts "Missed " + missed.to_s + " of " + spp.count.to_s + " species."
puts "Penalty: " + penalty.to_s

# selection = (0..5000).map{rand(1..1000)}.uniq!

#Exception on species id: 275
#Exception on species id: 289
#Exception on species id: 291
#Exception on species id: 292
#Exception on species id: 295
