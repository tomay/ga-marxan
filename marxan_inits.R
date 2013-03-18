## Function for cost
cost <- function(ids, pu)
  sum(pu[ids,"cost"])

## Boundary penalty
boundary <- function(ids, bnd) {
  col.1.in.ids <- bnd$id1 %in% ids
  col.2.in.ids <- bnd$id2 %in% ids
  both.1.in.ids <- col.1.in.ids & col.2.in.ids
  sum(bnd$boundary[col.1.in.ids | col.2.in.ids]) -
          sum(bnd$boundary[both.1.in.ids & bnd$id1!=bnd$id2])
}

## Species penalty
species_penalty <- function(ids, puv, species) {
  spp <- species[,"id"]
  
  pu_sub <- puv[pu %in% ids]
  final_sum <- pu_sub[,sum(amount), by=(species)]

  amount <- rep(NA, length(spp))
  amount[final_sum$species] <- final_sum$V1
  spf <- species[spp,"spf"]
  
  target <- spp_sums[spp,2] * species[spp,"prop"]
  failed <- amount / target # failed <- amount < target
  failed[is.na(failed)] <- 0 # failed[is.na(failed)] <- TRUE
  failed[failed > 1] <- 1 
  penalties <- spf * (1 - failed)
  sum(penalties) #sum(spf[failed])
}
