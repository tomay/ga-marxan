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


#reading bnd
bnd <- read.table("/home/tomay/r_work/inputs/bound.csv", header=TRUE, sep=",", 
  na.strings="NA", dec=".", strip.white=TRUE)

# notes
head(bnd) # first couple lines
bnd[,c('id1','id2')
bnd[566:570,c('id1','id2','boundary')]

# select conditions
bnd[bnd$boundary>9000.0,]
bnd[bnd$id1=1,]
bnd[bnd$id1==1,bnd$id2==1,]

# for a given pu, get the total perimiter
# subset? attach, detach, with, which? 
total_perimeter <- function(id) {
  bnd1 = subset(bnd[bnd$id1==id,3])
  bnd2 = (bnd[bnd$id2==id,3])
  print (sum(bnd1) + sum(bnd2))
  ## TO DO: subtract shared boundaries from set
}

##
## FULL FUNCTION
##
boundary_sum <- function(ids) {
	boundary = 0
	for (id in ids) {
		bnd2 = subset(bnd, id1==id | id2 == id)
		#bnd2 = c(subset(bnd, id1==id),(subset(bnd, id2==id)))
		#psum = sum(bnd2[bnd2$id1==id,3]) + sum(bnd2[bnd2$id2==id,3])
		psum = sum(bnd2[,c(3)])
		shared = unique(c((bnd2[bnd2$id2==id,1]),(bnd2[bnd2$id1==id,2]))) # unique to remove duplicates for edge cells
        for (share in shared) {
        	value = NA
        	if (share %in% ids) {
            	value = match(share,bnd2$id1)
            	if (is.na(value)) {
              		value = match(share,bnd2$id2)
            	}
            	#print (bnd2[value,3])
            	psum = psum - bnd2[value,3]
        	}
        }
		boundary = boundary + psum
		print (boundary)    
    } 
    print ("final " + toString(boundary)) 
}
	



