*****************************************
** Lab 4 Do-file - EDUC 275B           **
*****************************************

** Note: Examples in this file use the file 'faculty.dta'

** Change the working directory to your new folder
	*What command do we use?
	*cd "C:\Users\whatever"
	
** Log file to record all commands and outputs
	log using lab4.log, text	



**********************************
** Data set-up for ANOVA       **
**********************************

	** Open today's dataset
		use faculty.dta, clear 
		

    ** Keep variables: salary, male, market, yearsdg, rank
        keep salary male market yearsdg rank gender
		list in 1/10 

	
		
	* for a categorical variable with more than two categories.
		tab rank, missing
		tab rank
		tab rank, gen(d)
		list rank d* in 1/10
		rename d1 Assistant
		rename d2 Associate
		rename d3 Full
		list rank Assistant Associate Full in 1/10
		
						
	
************************************************
** one-way ANOVA / Multiple Linear Regression ** (with a factor/several dummies)
************************************************
//RQ: Whats the predicted mean salary difference between academic ranks?

	
	** Multiple linear regression model with a factor or several dummy variables
		regress salary Associate Full // use dummy variables for a factor 
		regress salary i.rank         // use 'i.' for a categorical (factor) variable 
		
		
	    *Comparing associate with full
		regress salary Associate Full
		lincom Full-Associate
		
		* or 
		regress salary i.rank, coeflegend /* coeflegend displays the legend that reveals how to specify 
		                                   estimated coefficients in b[] notation, which you are sometimes
										   required to use when specifying postestimation commands. */
		lincom 3.rank-2.rank
		

		*changing the reference group
		regress salary ib2.rank // Associate is reference
		regress salary ib3.rank // Full is reference

		
		* What if omitting "i." for a categorical (factor) variable in the regression
		regress salary rank    // Don't do this: regress treats expl. variable as continuous data by default
		tab rank, nolabel
		anova salary rank      // ANOVA treats the expl. variables as categorical by default				
	
	** One-way ANOVA with a categorical (factor) variable with more than two categories 
		help anova
		tab rank
		anova salary rank  
		
	* make all pairwise comparisons of salary by rank, correcting for multiple-comparison testing using the Sidak method
		oneway salary rank, sidak
		
		
	** ANOVA works for a categorical variable with two categories 
		ttest salary, by(male)   // using t-test
		anova salary male 	     // using ANOVA, will have the same results
		regress salary male      // the same result with ANOVA		
		regress salary i.gender  // use 'i.' for a categorical (factor) variable
		
	**Destring Variables
	 //destring variablename, replace /* Convert string variables to numeric variables and vice versa */

** Finally, closing our logfile for the lab section
		log close
		
** NOTE
	*  Dont' forget to save or email your works! 
	*  Start to think about your lab project early!		
		
*********
** END **
*********
