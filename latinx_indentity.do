cd "/Users/joseaguilar/Documents/EDUC_375B"

use GMS_cohort5.dta, clear
save GMS_cohort5.dta, replace
 



// Drop Variables not Needed
keep CASEID BL_MARKER FU1_MARKER FU2_MARKER RACE_DB SEX_DB REC_NREC BL_WKHRWEEK BL_TMSSTUDY BL_COLLMAJR BL_INTDMAJR BL_RSNSTREP BL_AFFOTHST BL_WKWSTDTS BL_DISCIDEA BL_HARDEREX BL_UGREEKS BL_URESHALL BL_UCULTURE BL_GLEADER BL_TMEXTRAC BL_COMDEGRE BL_UNDSOSTU BL_FAMWCOLL BL_COMWCOLL BL_LCGOODLK BL_SEESTMWO BL_SEDOWELL BL_AEHONSTD BL_HIGHDEGR BL_ATTNGRAD BL_OCCUASPI BL_OCCUASPO FU1_ACADEXMR FU1_MAJETCLG FU1_MAJETWRL FU1_GMSLEADR FU1_GMSLDACT FU1_GMSAFFRC FU1_GMSMENTR FU1_WKHRWEEK FU1_JOBRELMA FU1_AFFOTHST FU1_INDUSJ1CODE FU1_INCOMEJ1 FU1_INCOMEJ2 FU1_INCOMEJ3 FU1_INCOMEJ4 FU1_INCOMEJ5 FU1_JOBSATIS FU1_WKWSTDTS FU1_HARDEREX FU1_UGREEKS FU1_GLEADER FU1_NATLEAD FU1_LABLEAD FU1_DESTLEAD FU1_LEADDEF FU1_OTHLEAD FU1_CORRCOLL FU1_CARTEACH FU1_RGRPSSUP FU1_ANALSKL FU1_WRKINDEP FU1_COMMORAL FU1_WRITCLER FU1_LCGOODLK FU1_AENOTWEL FU1_SESATISF FU1_WLCOMPDG  FU1_OCCUASPI FU1_OCCUASPO BL_HSMJRITY FU1_STUDYRG FU1_DATERGRP FU1_PERCCHNG FU1_SOCRACE FU1_ACDDISCR FU1_FACINAPP FU1_FACINAPN FU1_ACDEXPRC FU1_SENSETHI FU1_PERCCHNG FU1_STUDINAC FU1_SOCDISCR FU1_MINRACE FU1_HISPCOUN
	
// Drop not needed

drop BL_RSNSTREP BL_COMDEGRE BL_COMWCOLL BL_LCGOODLK BL_SEESTMWO BL_SEDOWELL BL_AEHONSTD  FU1_LCGOODLK FU1_AENOTWEL

drop BL_HIGHDEGR BL_ATTNGRAD FU1_CARTEACH FU1_ANALSKL FU1_WRKINDEP FU1_COMMORAL FU1_WRITCLER FU1_WLCOMPDG

drop FU1_JOBSATIS FU1_ACADEXMR FU1_MAJETCLG FU1_MAJETWRL

drop FU1_NATLEAD FU1_LABLEAD FU1_DESTLEAD FU1_LEADDEF FU1_OTHLEAD

	

// Keep only baseline and follow-up survery 1

keep if (BL_MARKER == 1 & FU1_MARKER)
drop BL_MARKER FU1_MARKER FU2_MARKER



// Recode Sex, Reference is Hispanic
recode RACE_DB (1 = 1 "African American") (2=2 "American Indian") (3= 3 "Asian/Pacific Islander") (4 = 0 "Hispanic American"), gen(RACE)
drop RACE_DB

//Limit to Latinx
keep if RACE == 0

// Recode Sex, Reference is Female
recode SEX_DB (1 = 1 "Male") (2 = 0 "Female"), gen(SEX)
drop SEX_DB


// Rcode Scholar Status
//recode REC_NREC (1 = 1 "Scholar") (2 = 0 "Non-recipient"), gen(SCHOLAR)
drop REC_NREC

drop  if (FU1_HISPCOUN == . )

// Recode Scholar Status 
recode FU1_HISPCOUN (1 = 0 "Mexican or Chicano") (2 = 1 "Puerto Rican") (3 = 2 "Cuban") (4 = 3 "Other Hispanic"), gen(TYPE_LATINO)


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

//HS
replace BL_HSMJRITY = 0 if (BL_HSMJRITY == .)

//Cross Race Socialization
replace FU1_STUDYRG = 0 if (FU1_STUDYRG == .)
replace FU1_DATERGRP = 0 if (FU1_DATERGRP == .)
replace FU1_PERCCHNG = 0 if (FU1_PERCCHNG == .)
replace FU1_SOCRACE = 0 if (FU1_SOCRACE == .)

// Academic Race 
replace FU1_ACDDISCR = 0 if (FU1_ACDDISCR == .)
replace FU1_FACINAPP = 0 if (FU1_FACINAPP == .)
replace FU1_FACINAPN = 0 if (FU1_FACINAPN == .)
replace FU1_ACDEXPRC = 0 if (FU1_ACDEXPRC == .)

// Race Self Preception
replace FU1_SENSETHI = 0 if (FU1_SENSETHI == .)

// Race Climate
replace FU1_STUDINAC = 0 if (FU1_STUDINAC == .)
replace FU1_SOCDISCR = 0 if (FU1_SOCDISCR == .)
replace FU1_MINRACE = 0 if (FU1_MINRACE == .)



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

generate INVOL_SCORE =  (WKWSTDTS_BL+DISCIDEA_BL+BL_UGREEKS+BL_URESHALL+BL_UCULTURE+UNDSOSTU_BL+FU1_UGREEKS+WKWSTDTS_FU1+FU1_RGRPSSUP+BL_TMEXTRAC)
//10

// Cross Race Social Science Socre:
recode FU1_STUDYRG (1 = 2 "Yes") (2 = 1 "No") (0 = 0 "N/A"), gen (STUDYRG_FU1)
drop FU1_STUDYRG
recode FU1_DATERGRP (1 = 2 "Yes") (2 = 1 "No") (0 = 0 "N/A"), gen (DATERGRP_FU1)
drop FU1_DATERGRP
recode FU1_PERCCHNG (1 = 2 "Yes") (2 = 1 "No") (0 = 0 "N/A"), gen (PERCCHNG_FU1)
drop FU1_PERCCHNG
recode FU1_SOCRACE (5 = 1 "Strongly agree") (4 = 2 "Agree") (3 = 3 "Neutral") (2 = 4 "Disagree") (1 = 5 "Strongly disagree") (0 = 0 "N/A"),  gen (SOCRACE_FU1)
drop FU1_SOCRACE 

generate CROSS_RACE_SCORE = (STUDYRG_FU1 + DATERGRP_FU1 + PERCCHNG_FU1 + STUDYRG_FU1)

// Race Academic (Neg)
recode FU1_ACDDISCR (1 = 4 "Very discriminatory") (2 = 3 "Discriminatory") (3 = 2 "Supportive") (4 = 1 "Very supportive") (0 = 0 "N/A"), gen (ACDDISCR_FU1)
drop FU1_ACDDISCR

recode FU1_FACINAPP (1 = 2 "Yes") (2 = 1 "No") (0 = 0 "N/A"), gen (FACINAPP_FU1)
drop FU1_FACINAPP

generate RACE_ACAD_NEG_SCORE  = ACDDISCR_FU1 + FACINAPP_FU1 + FU1_ACDEXPRC

// Recoce SENSE
recode FU1_SENSETHI (1 = 1 "Strngth") (2 = -1 "Weak") (3 = 0 "Same"), gen (SENSE)
drop FU1_SENSETHI

// Continous Var (Discriptive):

summarize CROSS_RACE_SCORE RACE_ACAD_NEG_SCORE SENSE BL_HSMJRITY


tabulate TYPE_LATINO
tabulate SEX

*create dummy variables for categorical Latinx explanatory variables
tab TYPE_LATINO, gen(nationality)
rename nationality1 PR
rename nationality2 CUBAN
rename nationality3 OTHER


// gen INVOL_SCORE_LOG = ln(INVOL_SCORE)
// gen EXEPT_SCORE_LOG = ln(EXEPT_SCORE)
//
// summarize  INVOL_SCORE_LOG EXEPT_SCORE_LOG ELITE_CAREER_SCORE

regress SENSE CROSS_RACE_SCORE TYPE_LATINO SEX 

regress SENSE CROSS_RACE_SCORE PR CUBAN OTHER SEX 
// predict stdel, rstudent
// summarize stdel
// histogram stdel, norm
// rvfplot

regress SENSE RACE_ACAD_NEG_SCORE PR CUBAN OTHER SEX 

//regress ELITE_CAREER_SCORE INVOL_SCORE_LOG i.RACE SEX SCHOLAR

generate pr_cross = PR*CROSS_RACE_SCORE
generate cuban_cross = CUBAN*CROSS_RACE_SCORE
generate other_cross = OTHER*CROSS_RACE_SCORE

regress SENSE RACE_ACAD_NEG_SCORE i.TYPE_LATINO SEX pr_cross cuban_cross other_cross

 graph box SENSE
//
// twoway scatter INVOL_SCORE ELITE_CAREER_SCORE
// twoway scatter EXEPT_SCORE ELITE_CAREER_SCORE
// twoway scatter CAREER_SCORE ELITE_CAREER_SCORE
// twoway scatter LEADER_SCORE ELITE_CAREER_SCORE
//
// graph box ELITE_CAREER_SCORE, by(RACE)
// graph box ELITE_CAREER_SCORE, by(SEX)
// graph box ELITE_CAREER_SCORE, by(SCHOLAR)
// graph box ELITE_CAREER_SCORE, by(FU1_CORRCOLL)

// by RACE, sort: summarize INVOL_SCORE_LOG ELITE_CAREER_SCORE


//Do elite carrer score by invovlemnt and elite score
//Forgo carrer invovlment


// regress ELITE_CAREER_SCORE INVOL_SCORE_LOG AFR_AM AM_IND AAPI SEX SCHOLAR, vce(robust)
// avplot INVOL_SCORE_LOG 






//part describe how you made staifiaction score
//for race is catgorical and reference var descibe   
// catgories some never happened? - merge catagories 

//drop all the misisng 

//restore
