*****************************************************
** Lab 6 Do-file - EDUC 275B                        *
**  Topic 5a: Interactions  (cont. by cat.)         *
*****************************************************

** Log file to record all commands and outputs
	log using lab6.log, text	



********************************
** Data set-up (faculty data) **
********************************

	** Open today's dataset
		use faculty.dta, clear 
		
		* make a dummy variable for being a male
		tabulate gender, generate(g)
		browse
		rename g1 female
		rename g2 male
		
		label define m 0 "Female" 1 "Male"
		label values male m

		
****************************************
** Interactions (cont. by binary)     **
****************************************

	regress salary male yearsdg  
	
	** Draw parallel lines (no interaction)				
	twoway (function Men = _b[_cons]+_b[male]+_b[yearsdg]*x, range(0 41) lpatt(dash)) ///
		   (function Women = _b[_cons]+_b[yearsdg]*x, range(0 41) lpatt(solid)), ///	
			xtitle(Time since degree (years)) ytitle (Mean salary)
	/// additive model, regardless of the values of the other covariates
	
	* Interaction: effect of one explanatory variable may depend on the value of another
	* (e.g., men receive larger or more frequent increases)
	generate male_years = male*yearsdg
	regress salary male yearsdg male_years
	
	lincom yearsdg + male_years
	/// estimated mean annual increase for males (vs. females)
	/// (effect of time since degree depends on gender - gender is moderator)
	
	lincom male + male_years*10
	/// estimated male-female gap when years after degree = 10
	/// (effect of gender depends on time since degree - time since degree is moderator) 

	twoway (function Men = _b[_cons]+_b[male]+(_b[yearsdg]+_b[male_years])*x, ///
	            range(0 41) lpatt(solid)) ///
		   (function Women = _b[_cons]+_b[yearsdg]*x, range(0 41) lpatt(dash)), ///	
		   xtitle(Time since degree (years)) ytitle (Mean salary)

	** Factor notations for regression
	regress salary male yearsdg i.male#c.yearsdg
	regress, coeflegend    // find out how to refer to terms in lincom
	
	lincom yearsdg + 1.male#c.yearsdg
	/// estimated mean annual increase for males
	
	lincom male + 1.male#c.yearsdg*10
	/// estimated male-female gap when years after degree = 10
	
	display _b[male] + _b[1.male#c.yearsdg]*10

	* each term plus their interaction:
	regress salary i.male##c.yearsdg
	
	* Margins to get predicted means for continuous expl. variable
	margins male, at(yearsdg = 10)         // at specific value of continuous variable
	margins male, at(yearsdg = (0(2)10))   // at values 0,2,4,6,8,10 of continuous variable
	marginsplot
	
		

*******************************************************
** Interactions (cont. by categorical with > 2 cat.) **
*******************************************************

    
    * anova
    anova salary i.rank##c.yearsrank  // "years in rank"
		
    * regress
    regress salary i.rank##c.yearsrank 
    testparm rank#c.yearsrank  // same F-test as anova
		
	regress, coeflegend     // find out how to refer to terms in lincom
	
	lincom 3.rank + 3.rank#c.yearsrank*4 
	/// difference in mean salary between Full and Assistant after 4 years in rank##c
	
	lincom 3.rank#c.yearsrank-2.rank#c.yearsrank
	/// difference in slope of yearsrank between full and associate professors

	twoway (function Full = _b[_cons] + _b[3.rank] + _b[c.yearsrank]+_b[3.rank#c.yearsrank]*x, range(yearsrank)) ///
	(function Associate = _b[_cons] + _b[2.rank] + _b[c.yearsrank]+_b[2.rank#c.yearsrank]*x, range(yearsrank)) 
	* exercise: add other lines to same graph
	   
	* margins with continuous expl. variable:
	margins rank, at(yearsrank=(0(2)10))
	marginsplot
	
	/*use your own dummy variables for rank: same as above
	
	tabulate rank, gen(d)
	rename d1 Assistant
	rename d2 Associate
	rename d3 Full
	list rank Assistant Associate Full in 1/10
	
	* make interaction variables
	generate Assoc_yearsrank = Associate*yearsrank
	generate Full_yearsrank = Full*yearsrank
	
	regress salary Associate Full yearsrank Assoc_yearsrank Full_yearsrank
    regress salary i.rank##c.yearsrank*/
	
	
	
**** close log file

log close
	
*********
** END **
*********

