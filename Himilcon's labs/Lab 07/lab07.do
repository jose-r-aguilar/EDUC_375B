*******************************************************
** Lab 7 Do-file - EDUC 275B                         **
**   Topic 5b:                                       **
**   Interactions betweeen categorical variables     **      	           
*******************************************************

	
** Log file to record all commands and outputs
	log using lab7.log, text	



*************************************************
** Data set-up (High School and Beyond Survey) **
*************************************************

	** Open dataset
		use hsbs1.dta, clear

		* Group variables of interest
		tabulate gender
		tab gender, gen(g)
		rename g1 male
		rename g2 female
		
		tabulate prog //course track
	

**********************************************************
** ANOVA approach & Regression approach (no interaction) *
*********************************************************

	* Is there a difference in mean science achievement between males and females?
	anova sci gender       // can use gender or male
	anova sci male
	regress sci i.gender   // can use i.gender or i.male
	regress sci i.male
	regress sci male       // without "i." in regress, must use dummy variable, male
	
	* Controlling for course track, is there a difference in science achievement between females and males
	anova sci male prog
	margins male#prog
	
	/// note that the difference between males and females is the same across the groups
	display 52.7063 - 49.07559  //3.63071
	/// male-female for general
	
	display 56.8352 -  53.2045  //3.6307
	/// male-female for academic
	
	display 48.43319 - 44.80248  //3.63071
	/// male-female for vocational
	
	* Same result for gender gap when we use the regression approach
	regress sci i.male i.prog
	/// 1.male = male-female controlling for program
	/// academic = academic - general (same for both male and female)
	/// vocation = vocation - general (same for both male and female)
	
	regress, coeflegend  // show names of coefficients for lincom
	lincom 2.prog-3.prog
	/// test if academic-vocation is significantly different from zero
	
	* Draw parallel lines (no interaction)
	predict fitted, xb //fitted value of science
	twoway (line fitted male if prog ==1, sort) ///
		(line fitted male if prog == 2, sort lpat(dash)) ///
		(line fitted male if prog == 3, sort lpat(shortdash)), ///
		legend(order (1 "general" 2 "academic" 3 "vocational")) ///
		xlab(0 "Female" 1 "Male") xtitle (Gender) ytitle(Science achievement)
		
	* with marginsplot
	margins male#prog
	marginsplot
	marginsplot, xdim(prog)
	
	
**************************
** INTERACTION hsb1.dta **
**************************
	
	* Does the difference between gender (gender gap) differ between course tracks?
	anova sci male prog male#prog
	anova sci i.male##i.prog    // can use "i." for clarity, can use "##"
	margins male#prog
	
	/// note that the difference between males and females is no longer the same
	display 54.99143 -  47.476  //7.51543
	/// male-female for general
	
	display  57.09268 - 52.975  //4.11768
	/// male-female for academic
	
	display 46.32708 -  47.15349 //-.82641
	/// male-female for vocational

	* Draw a interaction diagram
	predict yhat, xb
	twoway (line yhat male if prog==1, sort) ///
		(line yhat male if prog == 2, sort lpat(dash)) ///
		(line yhat male if prog == 3, sort lpat(shortdash)), ///
		legend(order (1 "general" 2 "academic" 3 "vocational")) ///
		xlabel(0 "Female" 1 "Male") xtitle (Gender) ytitle(Science achievement)
	
	* Same result from regression approach
	regress sci i.male##i.prog
	testparm male#prog       // F-test for interaction (two coefficients)
	margins male#prog
	marginsplot
	
	* creating the dummies for program and gender
	tabulate prog, generate(pdum)
	rename pdum1 general
	rename pdum2 academic
	rename pdum3 vocation
	
	* creating the interaction terms between gender and program
	gen male_aca = male*academic
	gen male_voc = male*vocation
	
	regress sci male academic vocation male_aca male_voc
	regress sci i.male##i.prog   // same results
	
	
	
	
********************************
** INTERACTION faculty.dta    **
********************************

	** Open faculty dataset
		use faculty.dta, clear   

	** One-way ANOVA with gender 
		regress salary i.gender     // use 'i.' for a categorical (factor) variable		
		anova salary gender         // Not necessary to use 'i.' in anova command
			
	** One-way ANOVA with academic rank		
		regress salary i.rank      // use 'i.' for a categorical (factor) variable		
		anova salary rank          // Not necessary to use 'i.' in anova command
				
	** Two-way ANOVA with gender and academic rank
		anova salary gender##rank  
		regress salary i.gender##i.rank
		testparm gender#rank       // same F-test as ANOVA
		
		anova salary gender rank gender#rank   
		
	** Interaction diagram using margins and marginsplot
		margin rank#gender         // easy to see academic rank effect
		marginsplot
		marginsplot, xdim(gender) // same results but easy to see gender effect
		margins gender#rank  
		marginsplot		
		
	** Interaction diagram "by hand"	
		predict yhat, xb
		twoway (line yhat gender if rank==1, sort) ///
		  (line yhat gender if rank == 2, sort lpat(dash)) ///
		  (line yhat gender if rank == 3, sort lpat(shortdash)), ///
		  legend(order (1 "Assistant" 2 "Associate" 3 "Full")) ///
		  xlabel(1 "Female" 2 "Male")  xtitle (Gender) ytitle(Faculty salary)
	
			
				  
** Finally, closing our logfile for the lab section
		log close
		
*********
** END **
*********
