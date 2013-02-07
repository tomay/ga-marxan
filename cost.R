# Function for cost using aggregate
cost <- function(ids, pu) {
  totalcost = 0
  for (id in ids) {
    totalcost = totalcost + pu[id,"cost"]
  }
  return (totalcost)
}
