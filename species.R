
species_penalty <- function(ids, puv, species) {
# subset to get selected rows
  pu_sub <- subset(puv, pu %in% ids)
  final_sum <- aggregate(pu_sub$amount, by=list(species=pu_sub$species), FUN=sum)

# compare sums to targets to calc penalty
  penalty = 0
  missed = 0
  spp = species[,"id"]
  increase_penalty <- FALSE
  #penalty_sum <- function(species) {
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
      missed = missed + 1
      #cat('penalty: ',penalty,'\n')
    }
  } 
  return_list = list("penalty" = penalty, "missed" = missed)
  return(return_list)
}



