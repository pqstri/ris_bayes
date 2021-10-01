/* Fetch the file from the web site */
filename db temp;
proc http
 url="https://raw.githubusercontent.com/pqstri/ris_bayes/main/fra_temp_mini.csv"
 method="GET"
 out=db;
run;

/* Tell SAS to allow "nonstandard" names */
options validvarname=any;
 
/* import to a SAS data set */
proc import
  file=db
  out=work.db replace
  dbms=csv;
run;

data Prior;
     input _type_ $ ARM1;
     datalines;
   Var    0.096  
   Mean   -1.45
   ;
   run;

proc phreg data=db;
	class ARM (ref="0") ;
	model TTFR*RELYN(0) = ARM;
	bayes seed=1973 coeffprior=normal(input=Prior);
	hazardratio 'Hazard Ratio ARM' ARM /DIFF=REF; 
run;