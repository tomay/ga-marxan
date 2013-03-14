rm(list=ls())
setwd("/home/tomay/r_work/ga-marxan")
## get functions
source("marxan_inits.R")
source("ga/init.R")
library(data.table)

## get marxan inputs data-set
data.path <- "inputs/MarxanData/input"

## small data-set
## data.path <- "small"

pu <- read.csv(file.path(data.path, "pu.dat"),
               header=TRUE, na.strings="NA",
               dec=".", strip.white=TRUE, as.is=TRUE)
bnd <- read.csv(file.path(data.path, "bound.dat"),
                header=TRUE, na.strings="NA",
                dec=".", strip.white=TRUE) 
puv_df <- read.csv(file.path(data.path, "puvspr.dat"),
                header=TRUE, na.strings="NA",
                dec=".", strip.white=TRUE) 
species <- read.csv(file.path(data.path,"spec.dat"),
                header=TRUE, na.strings="NA",
                dec=".", strip.white=TRUE) 

## BLM is user defined for entire run
blm <- 1 # user defined

puv <- data.table(puv_df)
## sum species total distribution across planning region
## only necessary once per system
spp_sums <- aggregate(puv$amount, by=list(species=puv$species), FUN=sum)

model.score <- function(m) {
  m <- which(m)
  ## construct objective function scores
  cost_penalty <- cost(m, pu)
  boundary_penalty <- boundary(m, bnd)
  species_cost <- species_penalty(m, puv, species)
  # debug #print (cost_penalty)
  # debug #print (boundary_penalty)
  # debug #print (species_cost)
  ## calc total objective function score  
  -(cost_penalty + (blm * boundary_penalty) + species_cost)
}

num.total.pu <- nrow(pu)

## key function for running GA
find.model <- function(f) {
  run.ga(n.pu=50, n.pu.tot=num.total.pu,
         N=100, n.gens=50, s=15, p.mutate=0.05,
         p.sex=0.5, p.rec=0.5, fitness=f)
}
result <- find.model(model.score)

## to profile the code:
set.seed(1)
## **************************************************
## ************* to profile simulation **************
## **************************************************
Rprof(filename = "Rprof.out")
set.seed(1)
res <- find.model(model.score)
Rprof(NULL)
summaryRprof("Rprof.out")
## **************************************************
