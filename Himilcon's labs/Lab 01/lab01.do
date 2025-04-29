
*********************
** Basic Commands  **
*********************
* log /* log allows you to make a full record of your Stata session */
log using lab1

* cd /* cd changes the current working directory to the specified drive and directory */
cd  

* Load Stata-format dataset 
use instruction, clear 

** Reviewing the dataset

	* can look at the data using the data browser
	* GUI: "Data Editor (Browse)" button (grid with magnifying glass)
	* command: browse
	  	browse
	* remember black vs. blue vs. red!
	* red: string / text vs. blue: labeled variables  vs. black: numbers 
	
	* describe /* summary of variables in the dataset */
	* list /* list of values in variables */
		describe
		list in 1/3 			// list of values in variables for cases 1 to 3 
		list mathprep			// list all mathprep values
		set more off         	// prints all output instead of requiring -more-
		list mathprep in 1/10 	// list first 10 mathprep values
    	
** Manipulating data
	
	* to rename a variable using syntax: rename <oldvarname> <newvarname>
		rename girl female
		rename mathkind math_k

	* to add labels using syntax
	* first, define the labels
	* <labname> # "name" # "name2" [etc.]
		tab female
		label define gender 0 "male" 1 "female"
	* then, associate the label with the variable
	* label values <varname> <labname>
		label values female gender
	* to check the labels
		tabulate female
		tabulate female, nol

  	* generate new variables: generate <newvarname> = <expression>
		generate test1 = 0
		generate test2 = female+1

	* Get rid of whole variables you don't need 
	* drop <var1> <var2> [etc.]
		drop test1 test2
 	* keep <var1> <var2> [etc.]
		keep female minority math_k mathgain ses yearstea mathknow housepov ///
		    mathprep classid schoolid childid 
	* can also keep or drop certain observations
		keep if schoolid < 100 	//keeps only students from school 1-99
		drop in 1/10 			//drops the first 10 observations
	* recover data (after throwing some away)
		use instruction, clear
		rename girl female
		rename mathkind math_k
		label define gender 0 "male" 1 "female"
		label values female gender
	

** Descriptives
	* for categorical variables: frequencies and percents
	* tabulate <var1> [<var2>] [, nolabel]
		tabulate female
		tabulate female, nolabel 	//without labels, just see numbers
		tabulate ses 			    //usually unhelpful for continuous variables

	* for continuous variables: means, sds, etc.
	* summarize <var1> [<var2>, etc.]
		summarize ses
		summarize ses yearstea mathknow //works for many variables at once
	* any of the above descriptive commands can be used with if or in restrictions
		summarize ses if female==1
		summarize ses in 1/100
	
	* to get other statistics: use tabstat
	* tabstat <var>, statistics(<look at help file for options>)
		tabstat ses
		help tabstat //to see what stats can be asked for
		tabstat ses, statistics(mean sd min p25 median p75 max)

*************
** Graphs  **
*************
	
	* boxplot: graph box <var> [, over(<var2>)]
		graph box math_k
		graph box math_k, over(female) //to draw parallel boxplots
		graph box math_k, over(minority)
		
	* barplot: graph bar <var 1 var2>, <options>
		tabulate female minority
		graph bar math_k, over(female) over(minority)
		
	* histrogram: histogram <var> [, normal discrete]
		histogram math_k
		histogram ses
		histogram ses, normal
	
	* scatterplots: twoway scatter <yvar> <xvar>
		twoway scatter math_k ses
		twoway (scatter math_k ses if female==0) (scatter math_k ses if female==1)
	* could be confusing as we cannot tell which color represents female
		twoway (scatter math_k ses if female==0) (scatter math_k ses if female==1), ///
		    legend(order( 1 "Male" 2 "Female")) 

						
************
** t-test **
************		
		
    * Two independent sample t-test: to examine the differneces between minority 
	* and non-minority students on mean math scores 		
		ttest math_k, by(minority)
	
	* hypothesis testing
	* 1) Set the null hypothesis
	* 2) Calculate test statistics
	* 3) Find the p-value
	* 4) State a conclusion	
	
	* Excersie: Examine if there are significant differences 
	* between male and female students on mean math scores. 

************************************
** Simple linear regression model **
************************************

	** Regression of mathgain on ses 	
	* command: regress <yvar> <xvar> 
		regress math_k ses

** Finally, closing our logfile for the lab section
		log close
		
** Save the data (not necessary if you keep the do-file(s) that create the data
	save intstruction_0124.dta 
	
** NOTE
	*  Dont' forget to save your work 
    *  Additional Stata resources: https://stats.idre.ucla.edu/stata/ 
	*  Also see labnotes01 for more examples of STATA commands
	*  Start to think about your lab project early!

*********
** END **
*********
