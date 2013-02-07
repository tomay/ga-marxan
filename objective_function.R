# get functions
source("cost.R")
source("boundary.R")
source("species.R")

# read inputs
pu <- read.table("/home/tomay/r_work/inputs/pu.csv", header=TRUE, sep=",", na.strings="NA", dec=".", strip.white=TRUE)
bnd <- read.table("/home/tomay/r_work/inputs/bound.csv", header=TRUE, sep=",", na.strings="NA", dec=".", strip.white=TRUE)
puv <- read.table("/home/tomay/r_work/inputs/puvsp_feat.csv", header=TRUE, sep=",", na.strings="NA", dec=".", strip.white=TRUE)
species <- read.table("/home/tomay/r_work/inputs/species.csv", header=TRUE, sep=",", na.strings="NA", dec=".", strip.white=TRUE)

# sum species total distribution across planning region
# only necessary once per run
spp_sums = aggregate(puv$amount, by=list(species=puv$species), FUN=sum)

# BLM is user defined for entire run
blm = 0.0001 # user defined

#
# Sample run for one sample of pus 
#
##
# get ids (here taking from random sample)
ids <- sample.int(1000, size = 7800, replace = TRUE, prob = NULL)

# construct objective function scores
cost_penalty = cost(ids, pu)
boundary_penalty = boundary(ids, bnd)
species_cost = species_penalty(ids, puv, species)

# calc total objective function score
score = cost_penalty + (blm * boundary_penalty) + species_cost$penalty

# print results
print (score) # total obj func score
print (species_cost$missed) # n species missed
