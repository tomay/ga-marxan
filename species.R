##
## species penalty
##
#reading puvspr
puv <- read.table("/home/tomay/r_work/inputs/puvsp_test.csv", header=TRUE, sep=",", 
  na.strings="NA", dec=".", strip.white=TRUE)

# read species targets
species <- read.table("/home/tomay/r_work/inputs/species.csv", header=TRUE, sep=",", 
  na.strings="NA", dec=".", strip.white=TRUE)

# sum species totals across all pus
spp_sums = aggregate(puv$amount, by=list(species=puv$species), FUN=sum)

# test set of ids
ids <- c(1,5,9)

#pu_sub <- subset(puv, v1 %in% ids)
# create empty df to start
#final_sum <- data.frame(species=integer(), pu=integer(), amount=numeric()) 

# calc species amounts found in selected set 
#selected_species_sum <- function(ids) {
  #pu_sub <- subset(puv, pu %in% ids)
  #final_sum <- rbind(final_sum,pu_sub) # note loses decimals
  #final_sum <- aggregate(pu_sub$amount, by=list(species=puv$species), FUN=sum)
#}

# subset to get selected rows
pu_sub <- subset(puv, pu %in% ids)
final_sum <- aggregate(pu_sub$amount, by=list(species=pu_sub$species), FUN=sum)

# compare sums to targets to calc penalty

