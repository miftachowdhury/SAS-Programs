OPTIONS 
	LINESIZE = 256
	PAGESIZE = 65
	NOCENTER
	ORIENTATION = LANDSCAPE
	YEARCUTOFF=1935;

%LET PROGMER  = MAC; /* INSERT PROGRAMMER INITIALS HERE */
%LET PROJECT  = [REDACTED PROJECT NAME]; /* INSERT PROJECT NAME HERE */
%LET PURPOSE1 = Parole Officer Follow-Up Questionnaire; /* INSERT PURPOSE OF PROGRAM HERE */

/**********************************************************************************

NOTES: 

Steps: 
1)	Read in data files

2)	Check and QC data

3)	Recode and rename variables as needed for consistency

4) 	Check creation of variables
	
5)	Keep only required variables and save file

(drop all identifying information, keep sampleid, radate, racode, 
and site, plus raw step variables)

                                                                            
**********************************************************************************/

/* DIRECTORIES */
%LET USEDIFQ  = [REDACTED DIRECTORY 1];
%LET USEDIR2  = [REDACTED DIRECTORY 2]; /*for xref*/

/* BELOW LIST THE NAMES OF ALL SAS DATASET YOU WILL CALL IN YOUR PROGRAM*/
%LET USEFILE1  = [REDACTED DATASET NAME]; /*latest xref file*/

/* RAW FILES */
%LET RAWFILE1 = [REDACTED RAW FILE NAME 1];
%LET RAWFILE2 = [REDACTED RAW FILE NAME 2]; *exceptions file;

/* SAVED FILES AND DIRECTORIES HERE */
%LET SAVEDIR   = [REDACTED DIRECTORY];
%LET SAVEFILE = &progname;

/* FORMATS */
%LET FMTDIR   = [REDACTED DIRECTORY]; /* LIST DIRECTORY FOR SAVED SAS FORMATS */
LIBNAME LIBRARY V9 "&FMTDIR"; /* FORMAT LIBRARY STATEMENT */
PROC FORMAT LIBRARY = LIBRARY; /* ASSIGNING FORMAT LIBRARY */

/*  LIBNAMES */
LIBNAME USE1 "&USEDIFQ";
LIBNAME USE2 "&USEDIR2";
LIBNAME SAV "&SAVEDIR";



/**********************************************************************************

STEP 1. Read in data files 
	                                                                              
**********************************************************************************/

	

/******************************FOLLOW-UP QUESTIONNAIRE FILE***********************/
PROC IMPORT

	DATAFILE="&USEDIFQ.&RAWFILE1"
		OUT= Work.FQ
		DBMS=xlsx
		REPLACE;
	sheet="[REDACTED SHEET NAME]";
	getnames=yes;

run;

proc contents data = work.fq;
title1 "PROC CONTENTS of raw follow-up questionnaire data";
run;

proc print data = work.fq;
title1 "PROC PRINT of raw follow-up questionnaire data";
run;


/*********************************CROSS REFERENCE FILE********************************/
data xref;
	set use2.&usefile1;
	keep training_stat po_sampleid po_name resgrp l_code po_flagimp po_original;
run;


data fq1;
	set fq;
	drop is_test -- verify
		 participantID
		 state_agency
		 parts_num;
	po_name = upcase(name);
run;

/*title1 "PROC CONTENTS of follow-up questionnaire file";*/
/**/
/*proc contents data = fq1;*/
/*run;*/
/**/
/**/
/*title2 "PROC PRINT of follow-up questionnaire file";*/
/**/
/*proc print data = fq1;*/
/*run;*/

*FQ1 contains 34 variables and [#] observations;




/**********************************************************************************

STEP 2. Check and QC data
	                                                                              
**********************************************************************************/

/*sort and merge XREF with FQ*/
proc sort data = fq1; by po_name; run;
proc sort data = xref; by po_name; run;

data fqx;
	merge xref (in = X) fq1 (in = FQ);
	by po_name;

	inX = X;
	inFQ = FQ;
run;

/*check the merge*/
proc freq data = fqx;
	tables inX*inFQ / list missing;
	title1 "Checking the merge of raw follow-up data and xref";
run;

proc print data = fqx;
where inX ne inFQ;
var po_name inX inFQ;
title "Checking the merge of raw follow-up data and xref";
run;

/*change names in FQ data to match XREF*/
data fq2;
	set fq1;
	if po_name="[REDACTED PO NAME]" then po_name="[REDACTED PO NAME RECODE]";
	if po_name="[REDACTED PO NAME]" then po_name="[REDACTED PO NAME RECODE]";
	if po_name="[REDACTED PO NAME]" then po_name="[REDACTED PO NAME RECODE]";
	if po_name="[REDACTED PO NAME]" then po_name="[REDACTED PO NAME RECODE]";
run;


/*re-sort and re-merge XREF with FQ*/
proc sort data = fq2; by po_name; run;
proc sort data = xref; by po_name; run;

data fqx2;
	merge xref (in = X) fq2 (in = FQ2);
	by po_name;

	inX = X;
	inFQ2 = FQ2;
run;

/*check the second merge*/
proc freq data = fqx2;
	tables inX*inFQ2 / list missing;
	title1 "Checking the second merge of follow-up data and xref";
run;

proc print data = fqx2;
where inX ne inFQ2;
var po_name inX inFQ2;
title1 "Checking the second merge of follow-up data and xref";
run;	

/*check ICFs*/
proc print data = fqx2;
where ICF_SIGNED = "2";
var po_name ICF_SIGNED;
title1 "Check for observations without ICFs";
run;

/*drop 20 obs not in FQ, and 1 obs with no ICF*/
data fq3;
	set fqx2;
	where inFQ2=1 and ICF_signed = "1";

	*one untrained PO mistakenly answered Part 1 questions;
	if training_stat = 0 then call missing (of P1:);

	drop po_name name inX inFQ2;
run;

proc print data=fq3; 
title1 "PROC PRINT of the final merged and cleaned data set";
run;




/**********************************************************************************

STEP 3. Recode and rename variables as needed for consistency
                                                                            
**********************************************************************************/

data fq4;
	set fq3;


/****** PART 1 QUESTIONS ******/



/*	4 questions
	
	Scaled (1-6): 4 questions
		1:[REDACTED DEFINITION] - 6:[REDACTED DEFINITION]: 1 question (P1Q1)
		1:Strongly Agree - 6:Strongly Disagree: 3 questions (P1Q2 – P1Q4)
*/			

	*recode Part 1 questions. NOTE: one untrained PO mistakenly answered Part 1 questions. This was corrected in QC step 2;

	/****** VIEWS OF TRAINING ******/
	FQ_UseSkills 		= 7 - P1Q1;
	FQ_UseChangedSupv 	= 7 -  P1Q2;
	FQ_UseJobSkills 	= 7 - P1Q3;
	FQ_UseJobHarder 	= P1Q4*1; /* not reverse coded */

	FQ_Training = mean(of FQ_Use:);

		*Create new variables on 0-3 scale;
		FQ_UseSkills_0_3 		= (FQ_UseSkills-1)*(3/5);
		FQ_UseChangedSupv_0_3 	= (FQ_UseChangedSupv-1)*(3/5);
		FQ_UseJobSkills_0_3 	= (FQ_UseJobSkills-1)*(3/5);
		FQ_UseJobHarder_0_3 	= (FQ_UseJobHarder-1)*(3/5); 

		FQ_Training_0_3 = mean(of FQ_UseSkills_0_3 -- FQ_UseJobHarder_0_3);

	label
		FQ_UseSkills 		= 'PART 1 Q1: [Q1 TEXT]'
		FQ_UseChangedSupv 	= 'PART 1 Q2: [Q2 TEXT]'
		FQ_UseJobSkills 	= 'PART 1 Q3: [Q3 TEXT]'
		FQ_UseJobHarder 	= 'PART 1 Q4: [Q4 TEXT]'
		FQ_Training 		= 'Scale: Positive view of [X] training';


/****** PART 2 QUESTIONS ******/

/* 	7 questions
	Scaled (1:Never - 5:Always) */
	
	/****** VIEWS OF COACH******/
	FQCoachEasySched 		= P2Q1*1;
	FQCoachGoodUse 			= P2Q2*1;
	FQCoachUseMeetings 		= P2Q3*1;
	FQCoachUnderstands 		= P2Q4*1;
	FQCoachKnowledgeable 	= P2Q5*1;
	FQCoachComfortable 		= P2Q6*1;
	FQCoachSetGoals 		= P2Q7*1;
	
	FQCoachALL_AVG 		= mean (of FQCoach:);
	FQCoachUseful_AVG 	= mean (FQCoachGoodUse, FQCoachUseMeetings);
	FQCoachExp_AVG 		= mean (FQCoachUnderstands, FQCoachKnowledgeable);
	FQCoachCollab_AVG 	= mean (FQCoachComfortable, FQCoachSetGoals);
			
			*Create new variables on 0-3 scale;
			FQCoachEasySched_0_3 	= (FQCoachEasySched-1)*(3/4);
			FQCoachGoodUse_0_3 		= (FQCoachGoodUse-1)*(3/4);
			FQCoachUseMeetings_0_3 	= (FQCoachUseMeetings-1)*(3/4);
			FQCoachUnderstands_0_3 	= (FQCoachUnderstands-1)*(3/4);
			FQCoachKnowledge_0_3 	= (FQCoachKnowledgeable-1)*(3/4);
			FQCoachComfortable_0_3 	= (FQCoachComfortable-1)*(3/4);
			FQCoachSetGoals_0_3 	= (FQCoachSetGoals-1)*(3/4);
			
			FQCoachALL_AVG_0_3 		= mean (of FQCoachEasySched_0_3 -- FQCoachSetGoals_0_3);
			FQCoachUseful_AVG_0_3 	= mean (FQCoachGoodUse_0_3, FQCoachUseMeetings_0_3);
			FQCoachExp_AVG_0_3 		= mean (FQCoachUnderstands_0_3, FQCoachKnowledge_0_3);
			FQCoachCollab_AVG_0_3 	= mean (FQCoachComfortable_0_3, FQCoachSetGoals_0_3);

	label
		FQCoachEasySched 		= 'PART 2 Q1: [Q1 TEXT]'
		FQCoachGoodUse 			= 'PART 2 Q2: [Q2 TEXT]'
		FQCoachUseMeetings 		= 'PART 2 Q3: [Q3 TEXT]'
		FQCoachUnderstands 		= 'PART 2 Q4: [Q4 TEXT]'
		FQCoachKnowledgeable 	= 'PART 2 Q5: [Q5 TEXT]'
		FQCoachComfortable 		= 'PART 2 Q6: [Q6 TEXT]'
		FQCoachSetGoals 		= 'PART 2 Q7: [Q7 TEXT]'

		FQCoachAll_AVG 		= 'Scale: Overall view of coach'
		FQCoachUseful_AVG 	= 'Scale: Usefulness of coaching sessions'
		FQCoachExp_AVG 		= 'Scale: Coach knowledgeability and experience'
		FQCoachCollab_AVG 	= 'Scale: Collaboration and rapport with coach';



/****** PART 3 QUESTIONS ******/

/*  REDACTED */
	
	
run;	
		
proc contents data = fq4; 
title1 "PROC CONTENTS of follow-up questionnaire data";
run;


/**********************************************************************************

STEP 4. Check creation of variables
                                                                            
**********************************************************************************/

proc freq data = fq4;

	/****** VIEWS OF [X] TRAINING ******/
	tables FQ_UseSkills*P1Q1
		   FQ_UseChangedSupv*P1Q2
		   FQ_UseJobSkills*P1Q3
		   FQ_UseJobHarder*P1Q4

		   FQ_Training*FQ_UseSkills*FQ_UseJobSkills*FQ_UseJobHarder / list missing;

		   title1 "Checking creation of variables - positive view of [X] training";
run;


proc freq data = fq4;

	/****** VIEWS OF COACH******/
	tables FQCoachEasySched*P2Q1
		   FQCoachGoodUse*P2Q2
		   FQCoachUseMeetings*P2Q3
		   FQCoachUnderstands*P2Q4
		   FQCoachKnowledgeable*P2Q5
		   FQCoachComfortable*P2Q6
		   FQCoachSetGoals*P2Q7
	
		   FQCoachALL_AVG*FQCoachUseful_AVG*FQCoachExp_AVG*FQCoachCollab_AVG / list missing;

		 title1 "Checking creation of variables - positive view of coach";
run;



/**********************************************************************************

STEP 5. Keep only required variables and save file
                                                                            
**********************************************************************************/

data tosave;
	set fq4;
	keep po_sampleid po_original po_flagimp training_stat l_code FQ:;
run;

%SHOWDS01 (inputds=tosave, obs=10, cutoff=30);

data sav.&savefile;
	set tosave;
run;



	
/*title "PROC CONTENTS of follow-up questionnaire file";*/
/*proc contents data = fq4;*/
/*run;*/
/**/
/*title "PROC PRINT of follow-up questionnaire file";*/
/*proc print data = fq4;*/
/*run;*/
/**/
/*title "PROC MEANS of follow-up questionnaire file";*/
/*proc means data = fq4;*/
/*run;*/
/**/
/**/




/** BY SITE, [TRAINED] ONLY, COACH ONLY **/

/**/
/*proc freq data = fq4;*/
/*where training_stat = 1 and l_code = "ST1CITY";*/
/*tables FQCoach: / list missing;*/
/*title '[REDACTED STATE 1] coach freqs';*/
/*run;*/
/**/
/*proc freq data = fq4;*/
/*where training_stat = 1 and l_code = "ST2CITY";*/
/*tables FQCoach: / list missing;*/
/*title '[REDACTED STATE 2] coach freqs';*/
/*run;*/
/**/
/*proc freq data = fq4;*/
/*where training_stat = 1 and l_code = "ST3CITY";*/
/*tables FQCoach: / list missing;*/
/*title '[REDACTED STATE 3] coach freqs';*/
/*run;*/
/**/
/*proc print data = fq4;*/
/*where training_stat=1 and l_code = "ST1CITY";*/
/*var po_name fqcoach:;*/
/*title '[REDACTED STATE 1] coach print';*/
/*run;*/
/**/
/*proc print data = fq4;*/
/*where training_stat=1 and l_code = "ST2CITY";*/
/*var po_name fqcoach:;*/
/*title '[REDACTED STATE 2] coach print';*/
/*run;*/
/**/
/*proc print data = fq4;*/
/*where training_stat=1 and l_code = "ST3CITY";*/
/*var po_name fqcoach:;*/
/*title '[REDACTED STATE 3] coach print';*/
/*run;*/

