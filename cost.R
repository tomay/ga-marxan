#reading csv
pu2 <- read.table("/home/tomay/r_work/pu_test.csv", header=TRUE, sep=",", 
  na.strings="NA", dec=".", strip.white=TRUE)


#cost: 
#sum(c(pu2[1,2],pu2[3,2],pu2[5,2]))

#x <- c(1, 2, 3, 4, 5)
#x <- 

# Function for cost
cost <- function(ids) {
  totalcost = 0
  for (id in ids) {
    totalcost = totalcost + pu2[id,2]
  }
  print (totalcost)
}


