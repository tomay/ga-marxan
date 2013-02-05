##
## species penalty
##
#reading puvspr
#puv <- read.table("/home/tomay/r_work/inputs/puvsp_test.csv", header=TRUE, sep=",", 
  na.strings="NA", dec=".", strip.white=TRUE)

puv <- read.table("/home/tomay/r_work/inputs/puvsp_feat.csv", header=TRUE, sep=",", 
  na.strings="NA", dec=".", strip.white=TRUE)

# read species targets
species <- read.table("/home/tomay/r_work/inputs/species.csv", header=TRUE, sep=",", 
  na.strings="NA", dec=".", strip.white=TRUE)

# sum species totals across all pus
spp_sums = aggregate(puv$amount, by=list(species=puv$species), FUN=sum)

# test set of ids
ids <- c(1,5,9,23,33,42,66,87,89,124,145,168,245,456,489,900,1001,1009,2002,4232,4554)

# random sample
ids <- sample.int(1000, size = 7800, replace = TRUE, prob = NULL)


#pu_sub <- subset(puv, v1 %in% ids)
# create empty df to startspe
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
penalty = 0
spp = species[,"id"]
increase_penalty <- FALSE
penalty_sum <- function(species) {
  for (id in spp) {
    # doesn't work # target = species[species$id==id,species$prop] * spp_sums[spp_sums$species==id,2]
    # but want to refer to "prop" not col 2 always
    # ditto spf 3
    spf = species[id,"spf"]
    available = spp_sums[id,2]
    prop = species[species$id==id,"prop"]
    amount = final_sum[id,2]
    if (is.na(amount && available)) {
      #print("is na")
      increase_penalty <- TRUE
    }
    else {
      target = available * prop
      #print("here")
      #cat('SPECIES: ',id,'\n')
      #cat('spf: ',spf,'\n')
      #cat('prop: ',prop,'\n')
      #cat('amount: ',amount,'\n')
      if (amount < target) {
        increase_penalty <- TRUE
      }
    }
    if (increase_penalty) {
      penalty = penalty + spf
      #cat('penalty: ',penalty,'\n')
    }
  } 
  return(penalty)
}

# example
ids <- sample.int(3000, size = 7800, replace = TRUE, prob = NULL)
pu_sub <- subset(puv, pu %in% ids) # slow
final_sum <- aggregate(pu_sub$amount, by=list(species=pu_sub$species), FUN=sum) # this needs to be faster
final = penalty_sum(species)


