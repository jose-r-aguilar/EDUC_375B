cd "/Users/joseaguilar/Documents/EDUC_375B"

use pisa2000.dta, clear

keep wleread country test_lan

destring country, gen(c_codes)

anova wleread i.c_codes test_lan  i.c_codes#test_lan

**regress wleread i.c_codes test_lan i.c_codes#test_lan

margins i.c_codes#test_lan

marginsplot, xdimension(test_lan) xlabels(0 "Diff Lang" 1 "Same Lang")

*Questions 3

generate uk_code = c_codes
recode uk_code 826=0 276=1 840=1

generate germany_code = c_codes
recode germany_code 826=1 276=0 840=1

generate uk_test_lang = uk_code*test_lan
generate germany_test_lang = germany_code*test_lan

regress wleread c_codes test_lan uk_test_lang germany_test_lang
