boundary <- function(ids, bnd) {
	boundary = 0
	for (id in ids) {
		bnd2 = subset(bnd, id1==id | id2 == id)
		psum = sum(bnd2[,c(3)])
        	#cat('id:',id,'psum:',psum,'\n')
		s = c((bnd2[bnd2$id2==id,1]),(bnd2[bnd2$id1==id,2])) 
        	shared = s[s != id] # to remove edge cells that match id eg 1,1,bound
       		#cat('shared',shared,'\n')
        for (share in shared) {
        	value = NA
        	if (share %in% ids) {
            		value = match(share,bnd2$id1)
            		if (is.na(value)) {
              			value = match(share,bnd2$id2)
            		}
                	#cat('value',bnd2[value,3],'\n')
            		psum = psum - bnd2[value,3]
        	}
        }
	boundary = boundary + psum
	#print (boundary)    
    } 
    return (boundary)
}


