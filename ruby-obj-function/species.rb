require 'csv'
# open puvsp file
sppf = "inputs/species.csv"

# open spp file
puvf = "puvsp_spp_test.csv"

puvfile = File.open(puvf,"r")
sppfile = File.open(sppf,"r")

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
