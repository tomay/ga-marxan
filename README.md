ga-marxan
=========
Testing R functions for reproducing Marxan-like optimization using genetic algorithms

Marxan cost functions
---------------------
The main contribution so far is r-functions for calculating Marxan costs for a given set of planning units (e.g. the marxan objective function). These are included in the file named "marxan_inits.R" and should be fairly self explanatory. Each function requires a vector of planning unit ids (ids) and a data frame each for the planning units (pu), species file (species), and puvspr file (puv).  

Genetic algorithm
-----------------
The genetic algorithm is not yet included here pending publication by collaborators, but contact me if you would like more information. Initial tests show we can get comparable results, though not as quickly. What's particularly appealing about this approach is the potential to use any objective function to define what makes a reserve network valuable, not only the one that ships with Marxan. 

For more about Marxan:
http://www.uq.edu.au/marxan/

sample inputs here:
https://dl.dropbox.com/u/28839629/inputs_small.zip
