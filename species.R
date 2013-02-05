##
## species penalty
##
#reading puvspr
puv <- read.table("/home/tomay/r_work/inputs/puvsp_test.csv", header=TRUE, sep=",", 
  na.strings="NA", dec=".", strip.white=TRUE)

# read species targets
species <- read.table("/home/tomay/r_work/inputs/species.csv", header=TRUE, sep=",", 
  na.strings="NA", dec=".", strip.white=TRUE)


