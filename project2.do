cd "/Users/joseaguilar/Documents/EDUC_375B"

use GMS_cohort5.dta, clear
save GMS_cohort5.dta, replace
 
// Drop Variables not Needed
keep CASEID BL_MARKER FU1_MARKER FU2_MARKER RACE_DB SEX_DB REC_NREC BL_WKHRWEEK BL_TMSSTUDY BL_RSNSTREP BL_AFFOTHST BL_WKWSTDTS BL_DISCIDEA BL_HARDEREX BL_UGREEKS BL_URESHALL BL_UCULTURE BL_GLEADER BL_TMEXTRAC BL_COMDEGRE BL_UNDSOSTU BL_FAMWCOLL BL_COMWCOLL BL_LCGOODLK BL_SEESTMWO BL_SEDOWELL BL_AEHONSTD BL_HIGHDEGR BL_ATTNGRAD BL_OCCUASPI BL_OCCUASPO FU1_ACADEXMR FU1_MAJETCLG FU1_MAJETWRL FU1_GMSLEADR FU1_GMSLDACT FU1_GMSAFFRC FU1_GMSMENTR FU1_WKHRWEEK FU1_JOBRELMA FU1_AFFOTHST FU1_INDUSJ1CODE FU1_INCOMEJ1 FU1_INCOMEJ2 FU1_INCOMEJ3 FU1_INCOMEJ4 FU1_INCOMEJ5 FU1_JOBSATIS FU1_WKWSTDTS FU1_HARDEREX FU1_UGREEKS FU1_GLEADER FU1_NATLEAD FU1_LABLEAD FU1_DESTLEAD FU1_LEADDEF FU1_OTHLEAD FU1_CORRCOLL FU1_CARTEACH FU1_RGRPSSUP FU1_ANALSKL FU1_WRKINDEP FU1_COMMORAL FU1_WRITCLER FU1_ACDEXPRC FU1_LCGOODLK FU1_AENOTWEL FU1_SESATISF FU1_WLCOMPDG  FU1_OCCUASPI FU1_OCCUASPO BL_COLLMAJR BL_INTDMAJR FU1_COLLMAJR FU1_INTDMAJR
	
		

// Keep only baseline and follow-up survery 1

keep if (BL_MARKER == 1 & FU1_MARKER)
drop BL_MARKER FU1_MARKER FU2_MARKER

// Recode Sex, Reference is Hispanic
recode RACE_DB (1 = 1 "African American") (2=2 "American Indian") (3= 3 "Asian/Pacific Islander") (4 = 0 "Hispanic American"), gen(RACE)
//drop RACE_DB

// Recode Sex, Reference is Female
recode SEX_DB (1 = 1 "Male") (2 = 0 "Female"), gen(MALE)
drop SEX_DB


// Rcode Scholar Status
recode REC_NREC (1 = 1 "Scholar") (2 = 0 "Non-recipient"), gen(SCHOLAR)
drop REC_NREC

// Merge BL Major & FU1 Major
generate BL_MAJOR = .
replace BL_MAJOR = BL_COLLMAJR if (BL_COLLMAJR != . & BL_INTDMAJR == .)
replace BL_MAJOR = BL_INTDMAJR if (BL_COLLMAJR == . & BL_INTDMAJR != .)
generate FU1_MAJOR = .
replace FU1_MAJOR = FU1_COLLMAJR if (FU1_COLLMAJR != . & FU1_INTDMAJR == .)
replace FU1_MAJOR = FU1_INTDMAJR if (FU1_COLLMAJR == . & FU1_INTDMAJR != .)

// create change major dichotomus

generate MAJOR_CHANGE = .
replace MAJOR_CHANGE = 1 if (BL_MAJOR != FU1_MAJOR)
replace MAJOR_CHANGE = 0 if (BL_MAJOR == FU1_MAJOR)

//drop  if (FU1_ACADEXMR == . | FU1_MAJETCLG == . | FU1_MAJETWRL == .)
//drop if (BL_DISCIDEA == . | BL_UGREEKS == . |  BL_URESHALL == . | BL_UCULTURE == . |BL_UNDSOSTU == . | FU1_UGREEKS == . | FU1_WKWSTDTS == . | FU1_RGRPSSUP == . | BL_TMEXTRAC == .)
drop if (BL_MAJOR == . | FU1_MAJOR == .)

/*
// Set missing to 0 for ordinal questions 
//Involvement Scores
replace BL_WKWSTDTS = 0 if (BL_WKWSTDTS == .)
replace BL_DISCIDEA = 0 if (BL_DISCIDEA == .)
replace BL_UGREEKS = 0 if (BL_UGREEKS == .)
replace BL_URESHALL = 0 if (BL_URESHALL == .)
replace BL_UCULTURE = 0 if (BL_UCULTURE == .)
replace BL_UNDSOSTU = 0 if (BL_UNDSOSTU == .)
replace FU1_UGREEKS = 0 if (FU1_UGREEKS == .)
replace FU1_WKWSTDTS = 0 if (FU1_WKWSTDTS == .)
replace FU1_RGRPSSUP = 0 if (FU1_RGRPSSUP == .)
replace BL_TMEXTRAC = 0 if (BL_TMEXTRAC == .)
//Elite Score
replace BL_RSNSTREP = 0 if (BL_RSNSTREP == .)
replace BL_COMDEGRE = 0 if (BL_COMDEGRE == .)
replace BL_COMWCOLL = 0 if (BL_COMWCOLL == .)
replace BL_LCGOODLK = 0 if (BL_LCGOODLK == .)
replace BL_SEESTMWO = 0 if (BL_SEESTMWO == .)
replace BL_SEDOWELL = 0 if (BL_SEDOWELL == .)
replace BL_AEHONSTD = 0 if (BL_AEHONSTD == .)
replace FU1_ACDEXPRC = 0 if (FU1_ACDEXPRC == .)
replace FU1_LCGOODLK = 0 if (FU1_LCGOODLK == .)
replace FU1_AENOTWEL = 0 if (FU1_AENOTWEL == .)
/*
// Carrer Prep
replace BL_HIGHDEGR = 0 if (BL_HIGHDEGR == .)
replace BL_ATTNGRAD = 0 if (BL_ATTNGRAD == .)
replace FU1_CARTEACH = 0 if (FU1_CARTEACH == .)
replace FU1_ANALSKL = 0 if (FU1_ANALSKL == .)
replace FU1_WRKINDEP = 0 if (FU1_WRKINDEP == .)
replace FU1_COMMORAL = 0 if (FU1_COMMORAL == .)
replace FU1_WRITCLER = 0 if (FU1_WRITCLER == .)
replace FU1_WLCOMPDG = 0 if (FU1_WLCOMPDG == .)
*/
//Elite Career
//replace FU1_JOBSATIS = 0 if (FU1_JOBSATIS == .)
replace FU1_ACADEXMR = 0 if (FU1_ACADEXMR == .)
replace FU1_MAJETCLG = 0 if (FU1_MAJETCLG == .)
replace FU1_MAJETWRL = 0 if (FU1_MAJETWRL == .)
//Leadership Score
replace FU1_NATLEAD = 0 if (FU1_NATLEAD == .)
replace FU1_LABLEAD = 0 if (FU1_LABLEAD == .)
replace FU1_DESTLEAD = 0 if (FU1_DESTLEAD == .)
replace FU1_LEADDEF = 0 if (FU1_LEADDEF == .)
replace FU1_OTHLEAD = 0 if (FU1_OTHLEAD == .)
*/

// drop missing values 

// Set missing to 0 for ordinal questions 
//Involvement Scores
drop  if (BL_WKWSTDTS == .)
drop  if (BL_DISCIDEA == .)
drop  if (BL_UGREEKS == .)
drop  if (BL_URESHALL == .)
drop  if (BL_UCULTURE == .)
drop  if (BL_UNDSOSTU == .)
drop  if (FU1_UGREEKS == .)
drop  if (FU1_WKWSTDTS == .)
drop  if (BL_TMEXTRAC == .)
//Elite Score
drop  if (BL_RSNSTREP == .)
drop  if (BL_COMDEGRE == .)
drop  if (BL_COMWCOLL == .)
drop  if (BL_LCGOODLK == .)
drop  if (BL_SEESTMWO == .)
drop  if (BL_SEDOWELL == .)
drop  if (BL_AEHONSTD == .)
drop  if (FU1_LCGOODLK == .)
drop  if (FU1_AENOTWEL == .)
// generate ELITE_CAREER_SCORE = (((ACADEXMR_FU1-1)/3)*10 + ((MAJETCLG_FU1-1)/4)*10 +  ((MAJETWRL_FU1-1)/4)*10 + ((FU1_NATLEAD-1)/3)*10 +  ((FU1_LABLEAD-1)/3)*10 + ((FU1_DESTLEAD-1)/3)*10 + ((FU1_LEADDEF-1)/3)*10 + ((FU1_OTHLEAD-1)/3)*10)/8
 //Elite Career Score
drop  if (FU1_ACADEXMR == .)
drop  if (FU1_MAJETCLG == .)
drop  if (FU1_MAJETWRL == .)
drop  if (FU1_NATLEAD == .)
drop  if (FU1_LABLEAD == .)
drop  if (FU1_DESTLEAD == .)
drop  if (FU1_LEADDEF == .)
drop  if (FU1_OTHLEAD == .)



// Switch Ordinal Values toward positive

recode BL_WKWSTDTS (6 = 1 "Less than once a month") (5 = 2 "Once a month") (4 = 3 "Two or three times a month") (3 = 4 "Once a week") (2 = 5 "Two or three times a week") (1 = 6 "Three or more times a week") (0 = 0 "N/A"), gen(WKWSTDTS_BL)
drop BL_WKWSTDTS
//Inconsistancy

recode BL_DISCIDEA (6 = 1 "Less than once a month") (5 = 2 "Once a month") (4 = 3 "Two or three times a month") (3 = 4 "Once a week") (2 = 5 "Two or three times a week") (1 = 6 "Three or more times a week") (0 = 0 "N/A"), gen(DISCIDEA_BL)
drop BL_DISCIDEA

recode BL_UNDSOSTU (4 = 1 "Not at all") (3 = 2 "A little") (2 = 3 "Some") (1 = 4 "A lot") (. = 0 "N/A"), gen(UNDSOSTU_BL)
drop BL_UNDSOSTU

recode FU1_WKWSTDTS (6 = 1 "Less than once a month") (5 = 2 "Once a month") (4 = 3 "Two or three times a month") (3 = 4 "Once a week") (2 = 5 "Two or three times a week") (1 = 6 "Four or more times a week") (0 = 0 "N/A"), gen(WKWSTDTS_FU1)
drop FU1_WKWSTDTS 


// Avg of Involvement Score

//generate INVOL_SCORE =  (WKWSTDTS_BL+DISCIDEA_BL+BL_UGREEKS+BL_URESHALL+BL_UCULTURE+UNDSOSTU_BL+FU1_UGREEKS+WKWSTDTS_FU1+BL_TMEXTRAC)

generate INVOL_SCORE =  (((WKWSTDTS_BL-1)/5)*10 + ((DISCIDEA_BL-1)/5)*10  + ((BL_UGREEKS-1)/4)*10 + ((BL_URESHALL-1)/4)*10  + ((BL_UCULTURE-1)/4)*10 +((UNDSOSTU_BL-1)/3)*10 + ((FU1_UGREEKS-1)/4)*10 + ((WKWSTDTS_FU1-1)/5)*10 + ((BL_TMEXTRAC-0)/9)*10)/9
//10


// Switch Ordinal Values toward positive Elite
recode BL_LCGOODLK (5 = 0 "No Opinion") (4 = -2 "Disagree strongly") (3 = -1 "Disagree") (2 = 1 "Agree") (1 = 2 "Agree strongly") (0 = 0 "N/A"), gen(LCGOODLK_BL)
drop BL_LCGOODLK

recode BL_SEESTMWO (5 = 0 "No Opinion") (4 = -2 "Disagree strongly") (3 = -1 "Disagree") (2 = 1 "Agree") (1 = 2 "Agree strongly") (0 = 0 "N/A"), gen(SEESTMWO_BL)
drop BL_SEESTMWO

recode BL_SEDOWELL (5 = 0 "No Opinion") (4 = -2 "Disagree strongly") (3 = -1 "Disagree") (2 = 1 "Agree") (1 = 2 "Agree strongly") (0 = 0 "N/A"), gen(SEDOWELL_BL)
drop BL_SEDOWELL

recode BL_AEHONSTD (5 = 0 "No Opinion") (4 = -2 "Disagree strongly") (3 = -1 "Disagree") (2 = 1 "Agree") (1 = 2 "Agree strongly") (0 = 0 "N/A"), gen(AEHONSTD_BL)
drop BL_AEHONSTD

recode FU1_LCGOODLK (5 = 0 "No Opinion") (4 = -2 "Disagree strongly") (3 = -1 "Disagree") (2 = 1 "Agree") (1 = 2 "Agree strongly") (0 = 0 "N/A"), gen(LCGOODLK_FU1)
drop FU1_LCGOODLK

recode FU1_AENOTWEL (5 = 0 "No Opinion") (4 = -2 "Disagree strongly") (3 = -1 "Disagree") (2 = 1 "Agree") (1 = 2 "Agree strongly") (0 = 0 "N/A"), gen(AENOTWEL_FU1)
drop FU1_AENOTWEL

//Avg of Exeptionalism Career towards Positive

//generate EXEPT_SCORE =  ((BL_RSNSTREP-1)/2)*10 + ((BL_COMDEGRE-1)/3)*10 + ((BL_COMWCOLL-1)/3)*10 + LCGOODLK_BL + SEESTMWO_BL + SEDOWELL_BL + AEHONSTD_BL +LCGOODLK_FU1 + AENOTWEL_FU1)

generate EXEPT_SCORE =  (((BL_RSNSTREP-1)/2)*10 + ((BL_COMDEGRE-1)/3)*10 + ((BL_COMWCOLL-1)/3)*10 + ((LCGOODLK_BL+2)/4)*10 + ((SEESTMWO_BL+2)/4)*10 + ((SEDOWELL_BL+2)/4)*10 + ((AEHONSTD_BL+2)/4)*10 + ((LCGOODLK_FU1+2)/4)*10 + ((AENOTWEL_FU1+2)/4)*10)/9
//10

/*
// Switch Ordinal Values toward positive Career Prep
recode BL_ATTNGRAD (4 = 1 "Very unlikely") (3 = 2 "Somewhat unlikely") (2 = 3 "Somewhat likely") (1 = 4 "Very likely") (0 = 0 "N/A"), gen(ATTNGRAD_BL)
drop BL_ATTNGRAD

recode FU1_CARTEACH (4 = 1 "Never") (3 = 2 "Sometimes") (2 = 3 "Often") (1 = 4 "Very often") (0 = 0 "N/A"), gen(CARTEACH_FU1)
drop FU1_CARTEACH

recode FU1_ANALSKL (5 = 1 "Not at all") (4 = 2 "Not much") (3 = 3 "Neutral") (2 = 4 "Somewhat") (1 = 5 "A great deal") (0 = 0 "N/A"), gen(ANALSKL_FU1)
drop FU1_ANALSKL

recode FU1_WRKINDEP (5 = 1 "Not at all") (4 = 2 "Not much") (3 = 3 "Neutral") (2 = 4 "Somewhat") (1 = 5 "A great deal") (0 = 0 "N/A"), gen(WRKINDEP_FU1)
drop FU1_WRKINDEP

recode FU1_COMMORAL (5 = 1 "Not at all") (4 = 2 "Not much") (3 = 3 "Neutral") (2 = 4 "Somewhat") (1 = 5 "A great deal") (0 = 0 "N/A"), gen(COMMORAL_FU1)
drop FU1_COMMORAL

recode FU1_WRITCLER (5 = 1 "Not at all") (4 = 2 "Not much") (3 = 3 "Neutral") (2 = 4 "Somewhat") (1 = 5 "A great deal") (0 = 0 "N/A"), gen(WRITCLER_FU1)
drop FU1_WRITCLER

recode FU1_WLCOMPDG (4 = 1 "Very unlikely") (3 = 2 "Somewhat unlikely") (2 = 3 "Somewhat likely") (1 = 4 "Very likely") (0 = 0 "N/A"), gen(WLCOMPDG_FU1)
drop FU1_WLCOMPDG


//Avg of Career Prep towards Positive

generate CAREER_SCORE = (BL_HIGHDEGR + ATTNGRAD_BL + CARTEACH_FU1 + ANALSKL_FU1 + WRKINDEP_FU1 + COMMORAL_FU1 + WRITCLER_FU1 + WLCOMPDG_FU1)/8
//8
*/

// Switch Ordinal Values toward positive Elite Career
//recode FU1_JOBSATIS (5 = 1 "Very dissatisfied") (4 = 2 "Somewhat dissatisfied") (3 = 3 "Neither satisfied or dissatisfied") (2 = 4 "Somewhat satisfied") (1 = 5 "Very satisfied") (0 = 0 "N/A"), gen(JOBSATIS_FU1)
//drop FU1_JOBSATIS

recode FU1_ACADEXMR (4 = 1 "Poor") (3 = 2 "Fair") (2 = 3 "Good") (1 = 4 "Excellent") (0 = 0 "N/A"), gen(ACADEXMR_FU1)
drop FU1_ACADEXMR

recode FU1_MAJETCLG (1 = 5 "Disagree strongly") (2 = 4 "Disagree") (3 = 3 "Neutral") (4 = 2 "Agree") (5 = 1 "Agree strongly") (0 = 0 "N/A"), gen(MAJETCLG_FU1)
drop FU1_MAJETCLG

recode FU1_MAJETWRL (1 = 5 "Disagree strongly") (2 = 4 "Disagree") (3 = 3 "Neutral") (4 = 2 "Agree") (5 = 1 "Agree strongly") (0 = 0 "N/A"), gen(MAJETWRL_FU1)
drop FU1_MAJETWRL

//Avg of Elite Carrer towards Positive

//generate ELITE_CAREER_SCORE = (ACADEXMR_FU1 + MAJETCLG_FU1 +  MAJETWRL_FU1 + FU1_NATLEAD +  FU1_LABLEAD + FU1_DESTLEAD + FU1_LEADDEF + FU1_OTHLEAD)

generate ELITE_CAREER_SCORE = (((ACADEXMR_FU1-1)/3)*10 + ((MAJETCLG_FU1-1)/4)*10 +  ((MAJETWRL_FU1-1)/4)*10 + ((FU1_NATLEAD-1)/3)*10 +  ((FU1_LABLEAD-1)/3)*10 + ((FU1_DESTLEAD-1)/3)*10 + ((FU1_LEADDEF-1)/3)*10 + ((FU1_OTHLEAD-1)/3)*10)/8
//8




// Part 4
// Continous Var (Discriptive):

summarize INVOL_SCORE EXEPT_SCORE ELITE_CAREER_SCORE 


tabulate RACE
tabulate MALE
tabulate SCHOLAR

*create dummy variables for categorical explanatory variables
//Check for races4
tab RACE, gen(races)
rename races1 HISPANIC
rename races2 AFR_AM
rename races3 AM_IND
rename races4 AAPI


//gen INVOL_SCORE_LOG = ln(INVOL_SCORE)
//gen EXEPT_SCORE_LOG = ln(EXEPT_SCORE)

summarize  INVOL_SCORE EXEPT_SCORE ELITE_CAREER_SCORE

regress ELITE_CAREER_SCORE INVOL_SCORE AFR_AM AM_IND AAPI MALE SCHOLAR
predict stdel, rstudent
summarize stdel
histogram stdel, norm
rvfplot

regress ELITE_CAREER_SCORE EXEPT_SCORE AFR_AM AM_IND AAPI MALE SCHOLAR

regress ELITE_CAREER_SCORE INVOL_SCORE i.RACE MALE SCHOLAR

regress ELITE_CAREER_SCORE EXEPT_SCORE i.RACE MALE SCHOLAR

//generate aff_am_invol = AFR_AM*INVOL_SCORE_LOG
//generate am_ind_invol = AM_IND*INVOL_SCORE_LOG
//generate aapi_invol = AAPI*INVOL_SCORE_LOG

//regress ELITE_CAREER_SCORE INVOL_SCORE_LOG i.RACE SEX SCHOLAR aff_am_invol am_ind_invol aapi_invol

//CHARTS To print
// graph box ELITE_CAREER_SCORE
//
// twoway scatter INVOL_SCORE ELITE_CAREER_SCORE
// twoway scatter EXEPT_SCORE ELITE_CAREER_SCORE
// twoway scatter CAREER_SCORE ELITE_CAREER_SCORE
// twoway scatter LEADER_SCORE ELITE_CAREER_SCORE
//
// graph box ELITE_CAREER_SCORE, by(RACE)
// graph box ELITE_CAREER_SCORE, by(MALE)
// graph box ELITE_CAREER_SCORE, by(SCHOLAR)
// graph box ELITE_CAREER_SCORE, by(MAJOR_CHANGE)

// by RACE, sort: summarize INVOL_SCORE_LOG ELITE_CAREER_SCORE


//Do elite carrer score by invovlemnt and elite score
//Forgo carrer invovlment


regress ELITE_CAREER_SCORE INVOL_SCORE AFR_AM AM_IND AAPI MALE SCHOLAR, vce(robust)
avplot INVOL_SCORE 


//Logit

tabulate MAJOR_CHANGE

logit MAJOR_CHANGE INVOL_SCORE i.RACE MALE SCHOLAR, or

logit MAJOR_CHANGE INVOL_SCORE i.RACE MALE SCHOLAR





//part describe how you made staifiaction score
//for race is catgorical and reference var descibe   
// catgories some never happened? - merge catagories 

//drop all the misisng 

//restore
