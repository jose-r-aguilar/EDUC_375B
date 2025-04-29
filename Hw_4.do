cd "/Users/joseaguilar/Documents/EDUC_375B"

use pisa2000.dta, clear

keep wleread usa uk germany country 

// Q1 //

regress wleread uk germany

// Q2 //
// convert country codes to catagories

destring country, gen(c_codes)


anova wleread c_codes

oneway wleread c_codes, sidak
