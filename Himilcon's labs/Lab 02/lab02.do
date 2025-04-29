****************************************
** Lab 2 Notes - EDUC 275B Spring 2022 *
****************************************

********************************

** Note: Most examples in this file use the file 'instruction.dta'

** Change the working directory to your new folder
	*What command do we use?
	cd "C:\Users\xingy\OneDrive\2023 Spring\GSI for Data II\Lab 02_013122"
	
** Log file to record all commands and outputs
	log using lab2.log, text	


************************************
** Practice Basics: Data Cleaning **
************************************
	
	** Please open today's dataset
		use instruction.dta, clear
		
	** List of values in variable 'mathprep' for cases 1 to 10 
		list mathprep in 1/10 
	
	** Create a dummy variable for new teachers
		* using 'generate' and 'replace'
		tabulate yearstea, missing              //to check missing values 
		generate newteach = yearstea            //replicate the orig var
		replace newteach = 1 if yearstea < 5    //code for new teachers
		replace newteach = 0 if yearstea >= 5   //code the rest 
		* Important, if there are missing values, add "& !missing(yearstea)"
		tabulate newteach 
		tabulate yearstea newteach                  //check if it works
		
	** Change the variable name of girl into female
		rename girl female
 	
 	** Define value label and Assign it to a variable	
 		label define gender 0 "male" 1 "female"
		label values female gender
		tabulate female
	
	** Make dummy variables from a categorical (factor) variable
		tabulate female, generate(d)
		list female d* in 1/10
		rename d1 boy
		rename d2 girl
		list female boy girl in 1/10
		drop boy girl
		
	** Label a variable: label variable varname ["label"]
		label variable mathkind "Math score in kindergarten"
		describe
		
	** Select only the cases where schoolid = 11
		keep if schoolid==11   // use keep
		drop if schoolid!=11   // use drop
	
	** save this new dataset as school11.dta	
		count                  //Count observations
		save school11, replace 				

******************************************
** Descriptive Statistics with Graphics **
******************************************

	** Descriptives
		* tabulate for categorical variables: frequencies and percents		
			tabulate female minority
			tabulate female minority, summarize(ses)

		* summaraize for continuous variables: means, sds, etc.		
			summarize ses yearstea mathknow
		
		* tabstat for summary statistics	
			tabstat ses mathkind, statistics(mean sd median)
			tabstat ses mathkind, statistics(mean sd median) by(female) 
		
		* table is a more flexible command that produces one-, two-, and n-way 
		* tables of summary statistics, but the syntax changed in version 17!!
			table female
			
			* Stata prior to version 17
			table female, contents(mean ses)
			table female minority, contents(mean ses mean mathgain)
			table classid, contents(n ses mean ses sd ses mean mathgain sd mathgain)
			
			* Stata 17
			table female, statistic(mean ses) nototal
            table female minority, statistic(mean ses) statistic(mean mathgain) nototal
            table classid, statistic(n ses) statistic(mean ses) statistic(sd ses) ///
			   statistic(mean mathgain) statistic(sd mathgain)
		
		* any of the above descriptive commands can be used with if or in restrictions
			summarize ses if female==1
			tabstat ses mathkind if yearstea<5, stat(mean sd n) by(classid)

	** Graphs
		* barplot: graph bar (stat) <var> [, over(<var2: usually categorical>)]				
			graph bar, over(female)         //percent is the default for categorical variables	
			graph bar (count), over(female) 
			graph bar mathkind              //mean is the default for continuous variable			
			graph bar mathkind, over(female)			
		
		* boxplot: graph box <var> [, over(<var2>)]
			graph box mathkind, over(female)                //to draw parallel boxplots
			graph box mathkind, over(female) over(minority)
			graph box mathkind, over(female) by(minority)   
		
		* histrogram: histogram <var> [, normal discrete]
			histogram ses, bin(10) // 'bin': set number of bins
			histogram ses, normal  // 'normal': add a normal density to the graph
			histogram ses, freq	   // 'freq': draw as frequencies	
			histogram ses, normal freq 			

 		** scatterplots: twoway scatter <yvar> <xvar>
			twoway scatter mathkind ses
			twoway (scatter mathkind ses if female==0) (scatter mathkind ses if female==1)			
			twoway (scatter mathkind ses if female==0, msymbol(Oh)) ///
				   (scatter mathkind ses if female==1, msymbol(t)), ///
					legend(order( 1 "Male" 2 "Female")) 
		
		** fitted line
			twoway lfit mathkind ses
			twoway (scatter mathkind ses) (lfit mathkind ses)
	
		** twoway function: twoway function y = f(x), options
			twoway function y = 10 + 0.5 * x 
			twoway function math = x*2 +3, range(-10 10)
			twoway (function a = 10+0.5*x, range(0 10)) (function b=16-2*x, range(0 10))
			twoway (function a = 10+0.5*x, range(0 10)) (function b=16-2*x, range(0 10) ///
			   lpattern(dash)), legend(order(1 "line a" 2 "line b"))
			* help twoway -> line -> connect_options to see different choices for lpattern()
											 		
			
************************************
** Simple linear regression model **
************************************

	** Please open the saved dataset for a subset of school 11
		use school11.dta, clear
		
	** First example: Regression of mathgain on mathkind for school 11
		* command: regress <yvar> <xvar> 
			regress mathgain mathkind
			regress mathgain mathkind if schoolid==11 // if the whole dataset had been used			
			
		* plot the data used in the regression
			twoway (scatter mathgain mathkind) (lfit mathgain mathkind)  // least squares line 
			twoway (scatter mathgain mathkind) (lfitci mathgain mathkind)  // linear prediction plots with CIs
	
		* Get fitted values and residuals using predict command:  
		* Obtain predictions, residuals, etc., after estimation				
			predict mathgainhat, xb  // 'xb' is the option to calculate linear prediction
			predict resid, residual			
			generate resid2 = mathgain - mathgainhat // alternatively, calculate residuals
			
		* standardized coefficents	
			regress mathgain mathkind, beta	 // standardized coefficients meaningful only for continuous predictors 
			corr mathgain mathkind  // same as standardized coefficient for simple regression
					
	** Check the assumptions in linear regression 

		* (1) Checking the assumption of linearity
		* twoway scatter y x
		* twoway (scatter y x) (lfit y x)
		twoway scatter mathgain mathkind
		twoway (scatter mathgain mathkind) (lfit mathgain mathkind)
		* Note: the second command produces a scatterplot with least squares line superimposed

		* (2) Checking the assumption of normal residuals		
		histogram resid, normal
		qnorm resid
		graph box resid  // It works but hard to check normarilty 

		* (3) Checking the assumption of constant variance of residuals
		*  a) twoway (scatter resid x)
		twoway scatter resid mathkind
		// assess if there is a constant sread around horizontal line at y=0
		*  b) twoway (scatter resid yhat)
		twoway scatter resid mathgainhat
		/* Note: b) can be more useful in multiple regression since there are several X variables. 
		In simple regression, the two graphs will look the same apart from a different scaling of the X-axis. */
	
	
	** Second example: Regression of mathgain on ses for school 11		
		regress mathgain ses
		twoway (scatter mathgain ses) (lfit mathgain ses)
			
				
	** Third example: Regression of mathgain on female for school 11
		regress mathgain female
		twoway (scatter mathgain female) (lfit mathgain female)


************
** t-test **
************

	** Please open today's original dataset without subsetting school 11
		use instruction.dta, clear
		
    ** Two independent sample t-test
		* to examine the differnces between minority and non-minority students on mean math scores 		
		ttest mathkind, by(minority)			
							
	** Simple linear regression model with a dummy variable
		* Regression of math achievement scores on minority (dummy variable) 
		regress mathkind minority
		twoway (scatter mathkind minority) (lfit mathkind minority)
			
	* hypothesis testing
	* 1) Set the null hypothesis
	* 2) Calculate test statistics
	* 3) Find the p-value
	* 4) State a conclusion	
	
	*Excersie: With your partners, examine if there are significant differences between male and female students on mean math scores for school 11. 
		ttest mathkind if schoolid==11, by(girl)
		regress mathkind girl if schoolid==11	
		
	
** Finally, closing our logfile for the lab section
		log close

		
** NOTE
	*  Dont' forget to save your work 
    *  Additional Stata resources: https://stats.idre.ucla.edu/stata/ 
	*  Also see labnotes02 for more examples of Stata commands
	*  Start to think about your lab project early!		
		
*********
** END **
*********
