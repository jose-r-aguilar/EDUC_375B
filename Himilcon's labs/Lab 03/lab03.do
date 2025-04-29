****************************************
** Lab 3 Do-file - EDUC 275B          **	                   
****************************************

** Log file to record all commands and outputs
	log using lab3.log, text	


*****************************************************
** Load various datasets (Excel, Text, SPSS, ... ) **
*****************************************************
	
	** Opening a Stata datafile	
		* use "C:\Users\myname\faculty.dta", clear
		use faculty.dta, clear
		
		* look at the data
		browse
		describe
		codebook
		
		* The following two commands export the dataset to other formats to use 
		* as examples for opening non-stata files.
		export excel using "faculty.xls", firstrow(variables) /* Export to excel*/
		outsheet using "faculty.csv", comma replace /* Export to CSV */

		/* Stata allows you to export and import other formats (e.g. Excel).  
			File > Import > Excel
			File > Export > Excel

			. */
			
			
	** Opening a non-Stata datafile			
		help import
		help insheet
		 
		import excel "faculty.xls", sheet("Sheet1") firstrow clear /* firstrow: treat 
		                                           first row of Excel data as variable names */
		insheet using "faculty.csv", comma clear
		* usespss using "faculty.sav", clear   // When you have SPSS datasets.		

		
**********************************
** Data set-up for ANCOVA       **
**********************************

	** Open today's dataset
		use faculty.dta, clear //refer to Faculty.pdf the data information

    ** Keep variables: salary, gender, market, yearsdg, rank
        keep salary gender market yearsdg rank
		list in 1/10 

	** Generate dummy variables for a categorical explanatory variable
		* for a categorical variable with two categories.
		tabulate gender, missing
		tabulate gender, nolabel
		generate male = 1 if gender == 2  // 1 for women and 2 for men
		replace male = 0 if gender == 1   // Also try to use "recode"
		recode gender (2=0) (1=1), generate(female)
		tabulate gender male 		     // check that it was done correctly
		tabulate gender female
	
				
				
***************************************
** t-test / Simple linear regression ** (with a dummy)
***************************************

    ** Two independent samples t-test
		* to examine the differnces between male and female faculties on mean salary 		
		ttest salary, by(gender)	// no need to use a dummy variable		
							
	** Simple linear regression model with a dummy variable
		* Regression of salary on male (dummy variable) 
		regress salary male
		twoway (scatter salary male) (lfit salary male)		
		
		
	
*****************************************
** ANCOVA / Multiple Linear Regression ** with a covariate and a factor/several dummies)
*****************************************
	
	** Relationship between salary and marketability
		regress salary market 
	   
	   /* the estimated intercept is $18,097. 
	      It means the estimated population mean salary 
	      when marketability (ratio value) is zero, 
	      a value that does not occur in this sample and is meaningless.
	      Therefore, we refit the model after mean-centering market*/
	    
		* Center a continuous variable using its mean value
	    egen mn_market = mean(market)
		gen marketc = market - mn_market
		regress salary marketc

	** Relationship between gender and marketability 
		tabstat marketc, by(male) statistics(mean sd)
		twoway scatter marketc male		
	
	** ANCOVA Command: anova <yvar> <xvar1> c.<xvar2>
		anova salary male marketc   // doesn't work because ANOVA treatd expl. variables as categorical 		
		anova salary male c.marketc // use 'c.' to treat them as continuous in ANOVA command		
		
	** ANCOVA using a multiple regression // go to the slides
		regress salary male marketc  // Regression treats expl. variables as continous by default		
		regress salary male c.marketc  // Not necessary to use 'c.' for continous variables		

	** Get fitted values and plot fitted line
		regress salary i.male marketc
		predict yhat, xb	
		twoway (scatter salary marketc if male == 1, msymbol(o)) (scatter salary marketc if male == 0, msymbol(oh)) (line yhat marketc if male == 1, sort lpatt(solid)) (line yhat marketc if male == 0, sort lpatt(dash)), ytitle(Academic salary) xtitle(Mean-centered marketability) legend(order(1 "male" 2 "female" 3 "male" 4 "female")) 
		/// note that lines are parallel
		 * help symbolstyle
		 
	** Getting adjusted means (only after regress or anova type of commands)
		* First, run ANCOVA or regression
		regress salary i.male marketc
		anova salary male c.marketc
		
		* predicted values
		margins male, at(marketc = 1) //at specific value of continuous variable
		///  only works when factor notation is used in the regression command
		display _b[_cons]+_b[1.male]+_b[marketc]*1	//for male
		display _b[_cons]+_b[marketc]*1				//for female
		margins male, at(marketc)
		/// at mean of continuous variable - these are "adjusted" means	 

		
** Finally, closing our logfile for the lab section
		log close
		
** NOTE
	*  Dont' forget to save your works
    *  Additional Stata resources: https://stats.idre.ucla.edu/stata/ 
	*  Also see labnotes3 for more examples of STATA commands
	*  Start to think about your lab project early!		
		
*********
** END **
*********
