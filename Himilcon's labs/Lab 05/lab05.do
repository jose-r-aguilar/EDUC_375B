****************************************
** Lab 5 Do-file - EDUC 275B           *
**    Topic 4: Continuous predictors   *
****************************************


** Note: Examples in this file use the file 'faculty.dta'

** Change the working directory to your new folder
	*What command do we use?
	*cd "C:\Users\whatever"
	
** Log file to record all commands and outputs
	log using lab5.log, text	
	


*****************
** Data set-up **
*****************

	** Open today's dataset
		use faculty.dta, clear   

    ** Keep variables: salary, gender, market, yearsdg, rank
        keep salary gender market yearsdg rank
		list in 1/10 
		
	** If there are string variables, convert string variables to numeric variables		
		decode rank, gen(rank_str) 		
		describe  // there is a string variable
		regress salary i.rank_str // string variables may not be used as factor variables
		help(decode)				
		destring rank_str, gen(rank_numeric) // try destring, but only works for strings that look like numbers
		encode rank_str, gen(rank_numeric)   /* use encode if destring doesn't work!
		                                        (Encode string variable to numeric variable) */
		describe
		regress salary i.rank_numeric 	
		drop rank_str rank_numeric

	
	** Generate dummy variables for a categorical explanatory variable
		* for a categorical variable with more than two categories.
		tab rank, missing
		tab rank, gen(d)
		list rank d* in 1/10
		rename d1 Assistant  // Note that you do not need a dummy variable for ref. group
		rename d2 Associate
		rename d3 Full
		list rank Assistant Associate Full in 1/10
				
	** Center a continuous variable using its mean value for meaningful interpretation
	    egen mn_market = mean(market)
		gen marketc = market - mn_market  // mean-centering
		
		regress salary market		
		regress salary marketc  // compare to non-centering results		
		
	
	
	
*****************************************
/* 
   ANCOVA / Multiple Linear Regression with one continuous variable and one 
   categorical variable with more than two categories 
   
   Q1. Does mean faculty salary differ between academic ranks after controlling 
   for marketability of the discipline?
*/
*****************************************
	
	** ANCOVA Command: anova <yvar> <xvar1> c.<xvar2>
		anova salary rank c.marketc  // use 'c.' for continuous variables in ANOVA command (categorical by default)
		anova salary Associate Full c.marketc  // possible but hard to see the effect of one categorical variable 
		
	** ANCOVA using a multiple regression
		regress salary i.rank marketc  // use 'i.' for categorical variables in regressions (continous by default)
		regress salary Associate Full marketc

	** Change a reference group		
		regress salary ib3.rank marketc // Specifies category 3 (Full) as reference group
		regress salary Assistant Associate marketc // use dummy variables for a factor 		
				
	** Get fitted values and plot fitted line
		regress salary i.rank marketc  // Stata automatically uses the lowest category as the reference group
		predict yhat, xb	
		
		* Draw parallel lines
		help symbolstyle
		help linepatternstyle
		twoway (scatter salary marketc if rank == 1, msymbol(oh) color(green)) ///
			   (line yhat marketc if rank == 1, sort lpatt(solid) color(green)) ///
			   (scatter salary marketc if rank == 2, msymbol(o) color(red)) ///
			   (line yhat marketc if rank == 2, sort lpatt(dash) color(red)) ///
			   (scatter salary marketc if rank == 3, msymbol(th) color(purple)) ///		
			   (line yhat marketc if rank == 3, sort lpatt(shortdash) color(purple)), ///			
			   ytitle(Academic salary) xtitle(Mean-centered marketability) ///
			   legend(order(1 "Assistant" 2 "Assistant" 3 "Associate" 4 "Associate" 5 "Full" 6 "Full")) 
			   		 
	** Getting adjusted means (only after regress or anova type of commands)
		* First, run ANCOVA or regression
		regress salary i.rank marketc
		anova salary rank c.marketc
		
		* Then, get adjusted means
		margins rank, at(marketc)     // at mean of continuous variable by default
		margins rank, at(marketc = 1) // at specific value of continuous variable
		 // only works when i.rank is used in the regression command
		
		* Also, calculate them yourself from parameter estimates			
		display _b[_cons]+_b[marketc]*1				//for Assistant	
		display _b[_cons]+_b[2.rank]+_b[marketc]*1	//for Associate
		display _b[_cons]+_b[3.rank]+_b[marketc]*1  //for Full	

		
	
*****************************************
/*
    Multiple Linear Regression with two continuous variables 
	
    Q2. Is there a relationship between mean faculty salary and time since degree 
	after controlling for marketability of discipline?
	
*/
*****************************************	

	** Relationship between salary and time since degree
		regress salary yearsdg 	   
		twoway (scatter salary yearsdg) (lfit salary yearsdg) 
 
	** Relationship between time since degree and marketability 
		summ marketc yearsdg 
		twoway scatter marketc yearsdg 
		correlate marketc yearsdg  
		
	** What if using ANOVA command
		anova salary c.yearsdg c.marketc  /* use 'c.' for continuous variables in 
		                                     ANOVA command (categorical by default) */
		
	** Multiple Linear Regression
		regress salary yearsdg marketc
		regress salary marketc yearsdg   // same results but different order 
	
	** Draw Partial Plots
		avplots  // only works after anova or regress

	** Partial Correlation		
		correlate salary marketc yearsdg   // regular Pearson correlation, order doesn't matter
		pcorr salary yearsdg marketc  // partial correlation, order matters!
		
		* What does partial correlation mean?
		regress salary yearsdg
		predict res_salary, resid    // get "what's left" in salary removing effect of years in degree
		
		regress marketc yearsdg
		predict res_marketc, resid   // get "what's left" in marketc removing effect of years in degree 
		
		correlate res_salary res_marketc	 // correlate "what's left"
		pcorr salary marketc yearsdg // same as above
	
	** Standardized Regression Coefficients
		regress salary marketc yearsdg, beta
	  
	  /* Check pages 17-19 of output PDF for additional interpreation support.
	- in terms of "standard deviations" of both x and y
	- change in the slope by units of SD, can be bigger than 1
	- the estimated number of standard deviations that salary increases, on average,
	  when marketability increases by one standard deviation 
	- This is usually done to answer the question of which of the independent variables 
	  have a greater effect on the dependent variable in a multiple regression analysis, 
	  when the variables are measured in different units of measurement  
	- NOTE: Standardized Regression Coefficients are meaningfull only for continuous variables 
	  */

	  
** Finally, closing our logfile for the lab section
		log close
		
*********
** END **
*********
	  
	  
