# get functions
source("cost.R")
source("boundary.R")
source("species.R")

# read inputs
#path = "/small/"
path = "/"
pu <- read.table(paste("/home/tomay/r_work/inputs",path,"pu.csv", sep=""), header=TRUE, sep=",", na.strings="NA", dec=".", strip.white=TRUE)
bnd <- read.table(paste("/home/tomay/r_work/inputs",path,"bound.csv", sep=""), header=TRUE, sep=",", na.strings="NA", dec=".", strip.white=TRUE)
puv <- read.table(paste("/home/tomay/r_work/inputs",path,"puvsp_feat.csv", sep=""), header=TRUE, sep=",", na.strings="NA", dec=".", strip.white=TRUE)
species <- read.table(paste("/home/tomay/r_work/inputs",path,"species.csv", sep=""), header=TRUE, sep=",", na.strings="NA", dec=".", strip.white=TRUE)

# sum species total distribution across planning region
# only necessary once per system
spp_sums = aggregate(puv$amount, by=list(species=puv$species), FUN=sum)

# BLM is user defined for entire run
blm = 0.0001 # user defined

#
# Sample run for one sample of pus 
#
##
# get score (here taking ids from random sample of n size)
score = function(n) {
  ids <- sample.int(7896, size = n, replace = TRUE, prob = NULL)

  # construct objective function scores
  cost_penalty = cost(ids, pu)
  boundary_penalty = boundary(ids, bnd)
  species_cost = species_penalty(ids, puv, species)

  # calc total objective function score  
  score = cost_penalty + (blm * boundary_penalty) + species_cost$penalty

  # print results
  print (score) # total obj func score
  print (species_cost$missed) # n species missed
}

# score()