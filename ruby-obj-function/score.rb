
# open pu
# open bound
# open species
# open puvsp

require 'csv'
require './ruby-obj-function/scores'
#include Scores

# Marxan input files
pufile = File.open("inputs/pu.csv","r")
bndfile = File.open("inputs/bound.csv","r")
sppfile = File.open("inputs/species.csv","r")
puvfile = File.open("inputs/puvsp_feat.csv","r")

# Hashes to hold input data
pus = {}
bnd = {}
puv = {}
spp = {}
spp_sums = {}

# random test selection set and other variables set by user
selection = (0..500).map{rand(1..1000)}.uniq!
blm = 0.01

#
# Read planning units file
#
##
CSV.foreach(pufile, :headers => true, :header_converters => :symbol, :converters => :all) do |row|
  pus[row.fields[0]] = Hash[row.headers[1..-1].zip(row.fields[1..-1])]
end

#
# Read boundary file
#
##
(0..1).each {|x|
  y = (x == 0 ? 1 : 0)
  bnd_file = File.open(bndfile, "r")
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

#
# csv object for species.csv
#
##
CSV.foreach(sppfile, :headers => true, :header_converters => :symbol, :converters => :all) do |row|
  spp[row.fields[0]] = Hash[row.headers[1..-1].zip(row.fields[1..-1])]
end

#
# next get total dist of all spp into memory
# during same read of file, build puv hash
##
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

#
# Calculate penalties for a given selection
##
cost = Scores.cost(pus, selection)
boundary = Scores.boundary_penalty(bnd, selection)
selected = Scores.sum_selected(puv, selection)
species = Scores.species_penalty(spp, spp_sums, selected)

score = cost + (blm * boundary) + species[1]