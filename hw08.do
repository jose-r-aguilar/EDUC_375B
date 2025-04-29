cd "/Users/joseaguilar/Documents/EDUC_375B"

use berkeley.dta, clear


table (departme female) (admitted), nototal
table (female) (admitted), nototal

logit admitted i.departme i.female

// create with odds ratio 
logit admitted i.departme i.female, or

//wald test for significance
testparm i.female

// fit test
estat gof, table
