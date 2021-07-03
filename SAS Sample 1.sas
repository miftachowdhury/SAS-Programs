OPTIONS
PS=100
LS=100
NOCENTER
NOMPRINT; 

/* DOC BLOCK */

%LET PROGMER  = Mifta Chowdhury; /* INSERT PROGRAMMER NAME HERE */ 
%LET PROJECT  = [REDACTED PROJECT NAME];

%LET SELECT   = bl_quest; /* USE PROGRAMMING LANGUAGE TO DEFINE SAMPLE HERE*/
%LET SELDESC  = Participant Baseline Questionnaire; /* USE WORDS TO DESCRIBE SAMPLE HERE*/

/* BELOW LIST ALL SUBDIRECTORIES FOR WHICH YOU WILL NEED LIBNAME STATEMENT*/

%LET USEDIR0 = [REDACTED DIRECTORY 1]; /* Directory for the baseline file with participant questionnaire responses */
%LET USEDIR1 = [REDACTED DIRECTORY 2]; /* Directory for the MIS data file */

/*DIRECTORY AND NAME OF ANY PERMANENT SAS DATASET SAVED IN THIS PROGRAM*/
%LET SAVDIR    = [REDACTED DIRECTORY 3]; /* This is the directory that you will save the file to */
%LET SAVEFILE  = &PROGNAME; /* This is the name of the file you will save - the &progname macro variable will automatically update to the name of the program when you run the entire program*/

/* BELOW GIVE A BRIEF DISCRIPTION OF OVERALL POINT OF THIS PROGRAM */
%LET PURPOS1  = Match participant questionnaire to MIS via [CBO] ID;

/* These are "nicknames" for the directories */
LIBNAME USE0 "&USEDIR0" ;  /* baseline directory */
LIBNAME USE1 "&USEDIR1" ;  /* MIS directory */
LIBNAME SAV  "&SAVDIR"  ;  /* directory for final saved file */

/**********************************************************************************
 03/29/16 MAC: Updated recoding two [CBO] IDs based on information from [CBO]                                                       
**********************************************************************************/


/**********************************************************************************
 Read initial MIS file                                                          
**********************************************************************************/

PROC IMPORT /*Read MIS file*/
DATAFILE = "[REDACTED FILE PATH].csv"
OUT 	 = MIS;
RUN;

*(1) Metadata and print of initial MIS data set;

/*PROC CONTENTS */
/*DATA = MIS;*/
/*TITLE 'PROC CONTENTS of initial MIS data set';*/
/*RUN;*/

/*PROC PRINT */
/*DATA = MIS;*/
/*TITLE 'PROC PRINT of initial MIS data set';*/
/*RUN;*/

*Initial MIS data set contains [REDACTED #] observations and 34 variables;



/**********************************************************************************
 Create a new MIS data set
**********************************************************************************/
DATA MIS_1;
SET MIS;
WHERE [CBO]_ID NE .; *drop [#] observations with no [CBO] IDs;

/*Convert [CBO] ID from numeric to character type*/
	New[CBO]_ID = put([CBO]_ID, $5.);
	FORMAT new[CBO]_ID $5.;
	LABEL new[CBO]_ID = '[CBO] ID';
	DROP [CBO]_ID;
	RENAME new[CBO]_ID = [CBO]_ID;

/*Drop variables not needed in the data set*/
DROP 	
	[Dropped variable 1]
	[Dropped variable 2]
	[Dropped variable 3]
	[Dropped variable 4]
	[Dropped variable 5]
	[Dropped variable 6]
	[Dropped variable 7]
	[Dropped variable 8]
	[Dropped variable 9]
	[Dropped variable 10]
	[Dropped variable 11]
	[Dropped variable 12]
	[Dropped variable 13]
	[Dropped variable 14]
	[Dropped variable 15]
	[Dropped variable 16]
	[Dropped variable 17]
	[Dropped variable 18]
	[Dropped variable 19]
	[Dropped variable 20]
	[Dropped variable 21];

/*Remove time from date variables; retain only date part*/
	Last_Enrollment_Date1 = datepart(Last_Enrollment_Date);
	LABEL Last_Enrollment_Date1 = 'Date of last enrollment';
	FORMAT Last_Enrollment_Date1 mmddyy10.;

	/*REDACTED CLEANING OF ADDITIONAL DATE VARIABLES*/
					
/*Label MIS variables*/
LABEL 	 
	Age_At_Enrollment 		= 'Age at enrollment in [CBO]'
	[CBO]_ID				= '[CBO] ID'
	Gender				= 'Gender'
	[REDACTED]				= '[REDACTED]: Yes/No'
	Last_Enrollment_Date		= 'Date of last enrollment'
	[REDACTED]				= 'Date of [REDACTED] completion'
	[REDACTED]				= 'Date of [REDACTED]'
	[REDACTED]				= 'Date of [REDACTED]'
	Status_Category			= 'Status category'
	Status_Detail			= 'Status detail'
	Status_Sub_Category		= 'Status subcategtory'
	[REDACTED]				= 'Number of [REDACTED]'

/*Rename variables created when removing time part from date variables*/
DROP 	
	[Dropped variable A]
	[Dropped variable B]
	[Dropped variable C]
	[Dropped variable D];	

RENAME 
	[Dropped variable A]1 = [Dropped variable A]
	[Dropped variable B]1 = [Dropped variable B]
	[Dropped variable C]1 = [Dropped variable C]
	[Dropped variable D]1 = [Dropped variable D];

FORMAT [CBO]_ID $5.;

RUN;

*(2) Metadata and print of new MIS data set;

/*PROC CONTENTS*/
/*DATA = MIS_1;*/
/*TITLE 'PROC CONTENTS of new MIS data set';*/
/*RUN;*/
/**/
/*PROC PRINT*/
/*DATA = MIS_1;*/
/*TITLE 'PROC PRINT of new MIS data set';*/
/*RUN;*/

*New MIS data set contains [#] observations and 12 variables;



/**********************************************************************************
Sort new MIS data set and check for duplicates                                                       
**********************************************************************************/

PROC SORT DATA = MIS_1 OUT = MIS_s NODUPKEY DUPOUT = MIS_dups;
	BY [CBO]_ID;
	TITLE 'Sort MIS data set by [CBO] ID';
RUN;

PROC PRINT DATA = MIS_dups;
	TITLE 'Print duplicates found in MIS data set';
RUN;

*(3) Metadata and print of sorted and de-duped final MIS data set for merging;

/*PROC CONTENTS*/
/*DATA = MIS_s;*/
/*TITLE 'PROC CONTENTS of sorted and de-duped MIS data set';*/
/*RUN;*/
/**/
/*PROC PRINT*/
/*DATA = MIS_s;*/
/*TITLE 'PROC PRINT of sorted and de-duped MIS data set';*/
/*RUN;*/

*[#] duplicate records found:
*Sorted and de-duped MIS data set contains [#] observations and 13 variables;



/**********************************************************************************
 Read initial baseline questionnaire file                                                          
**********************************************************************************/

PROC IMPORT /* Read baseline questionnaire file*/
DATAFILE = "[REDACTED FILE PATH].csv"
OUT 	 = QST_new;
RUN;

PROC CONTENTS
DATA = QST_new;
TITLE 'PROC CONTENTS of initial baseline questionnaire data set';
RUN;

PROC PRINT
DATA = QST_new;
TITLE 'PROC PRINT of initial baseline questionnaire data set';
RUN;

*(4) Metadata and print of initial baseline questionnaire data set;

/*PROC CONTENTS */
/*DATA = QST_new;*/
/*TITLE 'PROC CONTENTS of initial baseline questionnaire data set';*/
/*RUN;*/
/**/
/*PROC PRINT */
/*DATA = QST_new;*/
/*TITLE 'PROC PRINT of initial baseline questionnaire data set';*/
/*RUN;*/

*Initial baseline questionnaire data set contains 71 observations and 52 variables;



/**********************************************************************************
 Create a new baseline questionnaire data set 
**********************************************************************************/
DATA QST_1;
SET QST_new;

/*Drop variables not needed in the data set*/	
DROP 	
	[Dropped variable 1]
	[Dropped variable 2]
	[Dropped variable 3]
	[Dropped variable 4]
	[Dropped variable 5]
	[Dropped variable 6]
	[Dropped variable 7]
	[Dropped variable 8]
	[Dropped variable 9]
	[Dropped variable 10]
	[Dropped variable 11]
	[Dropped variable 12]
	[Dropped variable 13]
	[Dropped variable 14]
	[Dropped variable 15]
	[Dropped variable 16]
	[Dropped variable 17]
	[Dropped variable 18]
	[Dropped variable 19]
	[Dropped variable 20]
	[Dropped variable 21]
	[Dropped variable 22]
	[Dropped variable 23]
	[Dropped variable 24]
	[Dropped variable 25];

/*Convert [CBO] ID to character type*/
	new[CBO]_ID = put([CBO]_ID, $5.);
	FORMAT new[CBO]_ID $5.;
	LABEL new[CBO]_ID = '[CBO] ID';
	DROP [CBO]_ID;
	RENAME new[CBO]_ID = [CBO]_ID;

/*Recode [CBO] IDs for 3 participants whose [CBO] IDs later changed (the new IDs used in later data files)*/
IF [CBO]_ID = 11111 THEN DO; 
		[CBO]_ID_old = '11111';
		new[CBO]_ID = 22222;
	END;

IF [CBO]_ID = 33333 THEN DO; 
		[CBO]_ID_old = '33333';
		new[CBO]_ID = 44444;
	END;

IF [CBO]_ID = 55555 THEN DO; 
		[CBO]_ID_old = '55555';
		new[CBO]_ID = 66666;
	END;

/*Recode [CBO] IDs for 1 participants whose [CBO] ID was recording incorrectly on the baseline questionnaire form*/

IF [CBO]_ID = 12345 THEN DO; 
		[CBO]_ID_old = '12345';
		new[CBO]_ID = 67890;
	END;

DROP [CBO]_ID;
RENAME new[CBO]_ID = [CBO]_ID;


/*Create questionnaire date value using batch number*/ 
IF BatchNumber = 'NYC001C' THEN qst_date = '23OCT2015'd;
	ELSE IF BatchNumber = 'NYC002C' THEN qst_date = '30OCT2015'd;
	ELSE IF BatchNumber = 'NYC003C' THEN qst_date = '06NOV2015'd;
	ELSE IF BatchNumber = 'NYC004P' THEN qst_date = '13NOV2015'd;
	ELSE IF BatchNumber = 'NYC005P' THEN qst_date = '20NOV2015'd;
	ELSE IF BatchNumber = 'NYC006P' THEN qst_date = '04DEC2015'd;
	ELSE qst_date = .;
FORMAT qst_date mmddyy10.;
LABEL qst_date = 'Date of questionnaire completion';


/*Convert question variables read as character to numeric*/
	NEWQ2 = input(Q2, 1.);
	FORMAT NEWQ2 BEST12.;
	LABEL NEWQ2 = 'Q2: [Q2 TEXT]';
	DROP Q2;
	RENAME NEWQ2 = Q2;

	NEWQ7 = input(Q7, 1.);
	FORMAT NEWQ7 BEST12.;
	LABEL NEWQ7 = 'Q7: [Q7 TEXT]';
	DROP Q7;
	RENAME NEWQ7 = Q7;

	NEWQ13 = input(Q13, 1.);
	FORMAT NEWQ13 BEST12.;
	LABEL NEWQ13		= 'Q13: [Q13 TEXT]';
	DROP Q13;
	RENAME NEWQ13 = Q13;

	NEWQ14 = input(Q14, 1.);
	FORMAT NEWQ14 BEST12.;
	LABEL NEWQ14		= 'Q14: [Q14 TEXT]';
	DROP Q14;
	RENAME NEWQ14 = Q14;

	NEWQ15 = input(Q15, 1.);
	FORMAT NEWQ15 BEST12.;
	LABEL NEWQ15			= 'Q15: [Q15 TEXT]';
	DROP Q15;
	RENAME NEWQ15 = Q15;

	NEWQ16 = input(Q16, 1.);
	FORMAT NEWQ16 BEST12.;
	LABEL NEWQ16			= 'Q16: [Q16 TEXT]';
	DROP Q16;
	RENAME NEWQ16 = Q16;

	NEWQ17 = input(Q17, 1.);
	FORMAT NEWQ17 BEST12.;
	LABEL NEWQ17			= 'Q17: [Q17 TEXT]';
	DROP Q17;
	RENAME NEWQ17 = Q17;

	NEWQ18 = input(Q18, 1.);
	FORMAT NEWQ18 BEST12.;
	LABEL NEWQ18			= 'Q18: [Q18 TEXT]';
	DROP Q18;
	RENAME NEWQ18 = Q18;

	NEWQ19 = input(Q19, 1.);
	FORMAT NEWQ19 BEST12.;
	LABEL NEWQ19			= 'Q19: [Q19 TEXT]';
	DROP Q19;
	RENAME NEWQ19 = Q19;

	NEWQ20 = input(Q20, 1.);
	FORMAT NEWQ20 BEST12.;
	LABEL NEWQ20			= 'Q20: [Q20 TEXT]';
	DROP Q20;
	RENAME NEWQ20 = Q20;

	NEWQ21 = input(Q21, 1.);
	FORMAT NEWQ21 BEST12.;
	LABEL NEWQ21			= 'Q21: [Q21 TEXT]';
	DROP Q21;
	RENAME NEWQ21 = Q21;


/*Recode Q2 for [CBO] ID 98765 from missing to 3.5 (participant circled 3 and 4)*/ 
IF [CBO]_ID = '98765' THEN NEWQ2 = 3.5;

/*Scale definitions: 

	Sections A and B: 
		0 = "Strongly Disagree"
		1 = "Disagree" 
		2 = "Undecided"
		3 = "Agree"
		4 = "Strongly Agree"

	Section C: 
		0 = "Not At All"
		1 = "Little"
		2 = "Somewhat"
		3 = "Much"
		4 = "A Great Deal" 
*/	

RUN;


DATA QST_2;
	SET QST_1;
	
/*Create dummy variables for question variables*/
ARRAY Qvars{21} Q1-Q21;
ARRAY Qdummys{21} dummy_Q1-dummy_Q21;

DO i=1 to 21;
	IF Qvars{i} NE . THEN DO;
		IF 3 LE Qvars{i} LE 4 THEN Qdummys{i} = 100;
			ELSE IF 0 LE Qvars{i} LE 2 THEN Qdummys{i} = 0;
			ELSE Qdummys{i} = .;
	END;	
END;


/*Format dummy variables*/
FORMAT 	dummy_Q1-dummy_Q21 BEST12.
		[CBO]_ID $5.;

/*Label baseline questionnaire variables*/
LABEL	
		BatchNumber	= 'Batch number'
		[CBO]_ID		= '[CBO] ID'
		[CBO]_ID_old	= 'Old [CBO] ID'
		ICF_Received	= 'ICF received:0/1'
		InvalidInfo 	= 'Invalid information'
		PARTIC_GROUP	= 'Participant group: C/P'
		ParticipantID	= 'Participant ID'
		Q1 			= 'Q1: [Q1 TEXT]'
		Q2			= 'Q2: [Q2 TEXT]'
		Q3			= 'Q3: [Q3 TEXT]'
		Q4			= 'Q4: [Q4 TEXT]'
		Q5			= 'Q5: [Q5 TEXT]'
		Q6			= 'Q6: [Q6 TEXT]'
		Q7			= 'Q7: [Q7 TEXT]'
		Q8			= 'Q8: [Q8 TEXT]'
		Q9			= 'Q9: [Q9 TEXT]'
		Q10			= 'Q10: [Q10 TEXT]'
		Q11			= 'Q11: [Q11 TEXT]'
		Q12			= 'Q12: [Q12 TEXT]'
		Q13			= 'Q13: [Q13 TEXT]'
		Q14			= 'Q14: [Q14 TEXT]'
		Q15			= 'Q15: [Q15 TEXT]'
		Q16			= 'Q16: [Q16 TEXT]'
		Q17			= 'Q17: [Q17 TEXT]'	
		Q18			= 'Q18: [Q18 TEXT]'
		Q19			= 'Q19: [Q19 TEXT]'
		Q20			= 'Q20: [Q20 TEXT]'
		Q21			= 'Q21: [Q21 TEXT]'
		dummy_Q1 	= 'Q1:0/100: [Dummy Q1 TEXT]'
		dummy_Q2	= 'Q2:0/100: [Dummy Q2 TEXT]'
		dummy_Q3 	= 'Q3:0/100: [Dummy Q3 TEXT]'
		dummy_Q4 	= 'Q4:0/100: [Dummy Q4 TEXT]'
		dummy_Q5 	= 'Q5:0/100: [Dummy Q5 TEXT]'
		dummy_Q6 	= 'Q6:0/100: [Dummy Q6 TEXT]'
		dummy_Q7 	= 'Q7:0/100: [Dummy Q7 TEXT]'
		dummy_Q8 	= 'Q8:0/100: [Dummy Q8 TEXT]'
		dummy_Q9 	= 'Q9:0/100: [Dummy Q9 TEXT]'
		dummy_Q10 	= 'Q10:0/100: [Dummy Q10 TEXT]'
		dummy_Q11 	= 'Q11:0/100: [Dummy Q11 TEXT]'
		dummy_Q12 	= 'Q12:0/100: [Dummy Q12 TEXT]'
		dummy_Q13 	= 'Q13:0/100: [Dummy Q13 TEXT]'
		dummy_Q14 	= 'Q14:0/100: [Dummy Q14 TEXT]'
		dummy_Q15 	= 'Q15:0/100: [Dummy Q15 TEXT]'
		dummy_Q16 	= 'Q16:0/100: [Dummy Q16 TEXT]'
		dummy_Q17 	= 'Q17:0/100: [Dummy Q17 TEXT]'
		dummy_Q18 	= 'Q18:0/100: [Dummy Q18 TEXT]'
		dummy_Q19 	= 'Q19:0/100: [Dummy Q19 TEXT]'
		dummy_Q20 	= 'Q20:0/100: [Dummy Q20 TEXT]'
		dummy_Q21 	= 'Q21:0/100: [Dummy Q21 TEXT]';
RUN;

*(5) Metadata and print of new baseline questionnaire data set;

/*PROC CONTENTS*/
/*DATA = QST_2;*/
/*TITLE 'PROC CONTENTS of new baseline questionnaire data set';*/
/*RUN;*/
/**/
/**/
/*PROC PRINT*/
/*DATA = QST_2;*/
/*TITLE 'PROC PRINT of new baseline questionnaire data set';*/
/*RUN;*/
/*	*/
*New baseline questionnaire data set contains 71 observations and 50 variables, including 21 question variables and 21 dummy question variables;



/**********************************************************************************
Sort new QST data set and check for duplicates                                                       
**********************************************************************************/

PROC SORT DATA = QST_2 OUT = QST_s NODUPKEY DUPOUT = QST_dups;
	BY [CBO]_ID;
	TITLE 'Sort baseline questionnaire set by [CBO] ID';
RUN;

PROC PRINT DATA = QST_dups;
	TITLE 'Print duplicates found in baseline questionnaire data set';
RUN;

*(6) Metadata and print of sorted and de-duped baseline questionnaire data set;

/*PROC CONTENTS*/
/*DATA = QST_s;*/
/*TITLE 'PROC CONTENTS of sorted and de-duped baseline questionnaire data set';*/
/*RUN;*/
/**/
/**/
/*PROC PRINT*/
/*DATA = QST_s;*/
/*TITLE 'PROC PRINT of sorted and de-duped baseline questionnaire data set';*/
/*RUN;*/
	
*Sorted and de-duped baseline questionnaire data set contains [#] observations (questionnaires) and 50 variables, including 21 question variables and 21 dummy question variables;



/*************************************************************************************
 Merge and match each participant questionnaire to the MIS via the [CBO] ID and/or name
**************************************************************************************/

DATA match_check;
	MERGE MIS_s (IN=MISx) QST_s (IN=QSTx);
	BY [CBO]_ID;
	inMIS = MISx;
	inQST = QSTx;
RUN;

PROC FREQ DATA = match_check;
	TABLE inMIS*inQST/LIST;
	TITLE 'Match baseline questionnaires to MIS records';
RUN;

PROC SORT DATA = match_check OUT = merged;
	 BY Partic_group BatchNumber ICF_Received;
RUN;

*(7) Metadata and print of sorted merged data set;

PROC CONTENTS
DATA = merged;
TITLE 'PROC CONTENTS of sorted merged data set';
RUN;

PROC PRINT DATA = merged;
VAR [CBO]_ID inMIS inQST ICF_Received;
TITLE 'PROC PRINT of sorted merged data set';
RUN;

*Initial sorted merged data set contains 86 observations and 65 variables;

/* 	[W] records in initial sorted merged data set:
 		[X] records in both QST and MIS (before dropping no ICFs)
		[Y] records found only in QST  (before dropping no ICFs)
		[Z] records found only in MIS	*/



/*************************************************************************************
 Check the match and drop observations not found in QST data set (i.e. MIS-only obs)
**************************************************************************************/

/*Print [X] [CBO] IDs found in both QST and MIS*/
PROC PRINT DATA = merged NOOBS;
	WHERE 	inQST = 1 AND inMIS = 1;
	VAR [CBO]_ID
		PARTIC_GROUP
		BatchNumber
		ICF_Received;
	TITLE 'Print records in both QST and MIS';
RUN;

/*Print [Y] [CBO] IDs found in QST and not in MIS*/
PROC PRINT DATA = merged NOOBS;
	WHERE 	inQST = 1 AND inMIS = 0;
	VAR [CBO]_ID
		PARTIC_GROUP
		BatchNumber
		ICF_Received
		[CBO]_ID_old;
	TITLE 'Print records in QST only';
RUN;

/*Print [Z] [CBO] IDs found in MIS and not in QST - these should not be included in MIS data set*/
PROC PRINT DATA = merged NOOBS;
	WHERE 	inQST = 0 AND inMIS = 1;
	VAR [CBO]_ID
		PARTIC_GROUP
		BatchNumber
		ICF_Received;
	TITLE 'Print records in MIS only';
RUN;


/*NOTE: The following 4 [CBO] IDs are to be excluded from the final sample per decisions by research staff:
	11111
	22222
	33333
	44444

/*Drop [Z] observations found in MIS and not in QST data set AND
  Drop 4 observations to be excluded from final sample*/
DATA merged_1;
	SET merged;
	WHERE inQST = 1 AND [CBO]_ID not in ('11111' '22222' '33333' '44444');
RUN;

PROC FREQ DATA = merged_1;
	TABLE inMIS*inQST/LIST;
	TITLE 'PROC FREQ of merged data set without MIS-only observations';
RUN;

*(8) Metadata and print of merged data set without MIS-only observations;
/**/
/*PROC CONTENTS*/
/*DATA = merged_1;*/
/*TITLE 'PROC CONTENTS of merged data set without MIS-only observations';*/
/*RUN;*/
/**/
/*PROC PRINT DATA = merged_1;*/
/*VAR [CBO]_ID inMIS inQST ICF_Received;*/
/*TITLE 'PROC PRINT of merged data set without MIS-only observations';*/
/*RUN;*/

*Merged data set without MIS-only observations AND without excluded [CBO] IDs contains [#] observations and 63 variables;

/* 	[#] records in merged data set without MIS-only observations AND without excluded [CBO] IDs:
 		[#] records in both QST and MIS (before dropping no-ICFs)
		[#] records found only in QST  (before dropping no-ICFs) */



/**********************************************************************************
 Confirm that each participant has an informed consent form (5 missing expected)
**********************************************************************************/

PROC SORT DATA = merged_1;
	 BY inMIS inQST ICF_Received;
RUN;

PROC FREQ DATA = merged_1;
	TABLES inMIS*inQST*ICF_received/LIST;
	TITLE 'Print tables of ICF receipt';
RUN;

/*Print 62 observations with ICFs received*/
PROC PRINT DATA = merged_1 NOOBS;
	WHERE ICF_Received = 1;
	VAR [CBO]_ID 
		PARTIC_GROUP
		BatchNumber
		inMIS inQST ICF_Received;
	TITLE 'Print [CBO] IDs of participants for whom ICFs have been received';
RUN;

/*	[#] ICFs received: 
		[#] in QST only
		[#]in both QST and MIS	*/

/*Print 5 observations with missing ICFs*/
PROC PRINT DATA = merged_1 NOOBS;
	WHERE ICF_Received = 2;
	VAR [CBO]_ID 
		PARTIC_GROUP
		BatchNumber
		inMIS inQST ICF_Received;
	TITLE 'Print [CBO] IDs of participants for whom ICFs are missing';
RUN;

/*	5 ICFs missing: 5 in both QST and MIS	*/


/*Drop observations with missing consent forms*/
DATA merged_2;
	SET merged_1;
	WHERE ICF_Received = 1;
RUN;

PROC FREQ DATA = merged_2;
	TABLE inMIS*inQST/LIST;
	TITLE 'PROC FREQ of merged data set excluding observations with missing ICF';
RUN;

*(9) Metadata and print of sorted merged data set excluding observations with missing ICF;

PROC CONTENTS
DATA = merged_2;
TITLE 'PROC CONTENTS of sorted merged data set excluding observations with missing ICF';
RUN;

PROC PRINT DATA = merged_2;
VAR [CBO]_ID inMIS inQST ICF_Received;
TITLE 'PROC PRINT of sorted merged data set excluding observations missing ICF';
RUN;

*Merged data set without MIS-only observations contains 62 observations and 65 variables;

/* 	[X] records in final merged data set:
	
   +[#] in initial merged data set
   -[#] that are only in the MIS
   -[#] excluded by [CBO]/MDRC decision
   -[#] that are missing ICFs
   =[X] records in final merged data set
 
 		[#] records in both QST and MIS (after dropping no ICFs)
		[#] records found only in QST  (after dropping no ICFs)-- these [CBO] IDs should be included in MIS data set */

PROC PRINT DATA = merged_2 NOOBS;
	WHERE 	inMIS = 0;
	VAR [CBO]_ID
		PARTIC_GROUP
		BatchNumber
		ICF_Received;
	TITLE 'Print records in QST only';
RUN;



/**************************************************************************************
 Check orientation dates in MIS correspond with intake date/date of questionnaire form
***************************************************************************************/

PROC PRINT DATA =  merged_2;
	WHERE qst_date NE Last_Orientation;
	VAR [CBO]_ID BatchNumber inMIS inQst qst_date Last_Orientation;
	TITLE 'Print [CBO] IDs where orientation dates do not match questionnaire dates';
RUN;

/* 	[X] observations with orientation date and questionnaire date mismatch:
    	[Y] records are found only in questionnaire data set 
		[X-Y] records require further investigation */

PROC PRINT DATA =  merged_2;
	WHERE qst_date NE Last_Orientation AND inMIS=1 AND inQST=1;
	VAR [CBO]_ID BatchNumber qst_date Last_Orientation;
	TITLE 'Print [CBO] IDs where orientation dates do not match questionnaire dates';
RUN;



/**************************************************************************************
 Check missing rates for question variables
***************************************************************************************/

PROC MEANS DATA =  merged_2 n nmiss;
	WHERE inQST = 1;
	VAR Q1-Q21;
	TITLE 'Check missing rates for question variables';
RUN;



/**************************************************************************************
 Check for straight-lining in each of the three sections
***************************************************************************************/

DATA straight_line; 
	SET merged_2;
	WHERE inQST = 1; 
	KEEP 	Age_At_Enrollment
			AgeCat
		 	BatchNumber
		 	[CBO]_ID
			PARTIC_GROUP
			Q1-Q21
			straightA
			straightB
			straightC
			strtln_sum;
	
	/*Create straight-lining variables by section*/
	IF Q1 = Q2 = Q3 = Q4 = Q5 = Q6 = Q7 THEN straightA = 1; 
		ELSE straightA = 0;

	IF Q8 = Q9 = Q10 = Q11 = Q12 THEN straightB = 1; 
		ELSE straightB = 0; 

	IF Q13 = Q14 = Q15 = Q16 = Q17 = Q18 = Q19 = Q20 = Q21 THEN straightC = 1; 
		ELSE straightC = 0;

	strtln_sum = straightA + straightB + straightC;

	/*Create age category variable for age analysis*/
	IF 18 LE Age_at_Enrollment LE 24 THEN AgeCat = '18-24';
		ELSE IF 25 LE Age_at_Enrollment LE 30 THEN AgeCat = '25-30';
		ELSE IF 31 LE Age_at_Enrollment LE 35 THEN AgeCat = '31-35';
		ELSE IF 36 LE Age_at_Enrollment LE 40 THEN AgeCat = '36-40';
		ELSE IF 40 LE Age_at_Enrollment LE 45 THEN AgeCat = '40-45';
		ELSE IF Age_at_Enrollment GE 46 THEN AgeCat = '46+';	
RUN;	
			
PROC PRINT DATA = straight_line;	
	VAR [CBO]_ID PARTIC_GROUP straightA straightB straightC strtln_sum;
	TITLE 'Print straight-lining by [CBO] ID';
RUN;

PROC FREQ DATA = straight_line;
	TABLE strtln_sum/LIST;
	TABLES straightA*straightB*straightC/LIST;
	TITLE 'Print straight-lining summary';
RUN;

/* Straight-lining summary
	[#] straight-lined 0 sections

	[#] straight-lined 1 section
		[#] straight-lined section A
		[#] straight-lined section B

	[#] straight-lined 2 sections
		[#] straight-lined A and B
	
	[#] straight-lined 3 sections */

/*Section A summary*/
DATA straightA_ds;
SET straight_line;
WHERE straightA = 1;
RUN;

PROC FREQ DATA = straightA_ds;
	TABLE Q1/LIST;
	TITLE 'Print section A straight-line summary';
RUN;

/*Section B summary*/
DATA straightB_ds;
SET straight_line;
WHERE straightB = 1;
RUN;

PROC FREQ DATA = straightB_ds;
	TABLE Q8/LIST;
	TITLE 'Print section B straight-line summary';
RUN;

/*Section C summary*/
DATA straightC_ds;
SET straight_line;
WHERE straightC = 1;
RUN;

PROC FREQ DATA = straightC_ds;
	TABLE Q13/LIST;
	TITLE 'Print section C straight-line summary';
RUN;


/*Check straight-lining against age*/
PROC FREQ DATA = straight_line;
	TABLE AgeCat*strtln_sum/LIST;
	TITLE 'Check straight-lining against age';
RUN;

TITLE;

/*DATA SAV.cbe_sample_160329 (KEEP= [CBO]_ID qst_date partic_group);*/
/*SET merged_2;*/
/*WHERE [CBO]_ID not in ('11111' '22222' '33333' '44444');*/
/*RUN;*/

/**************************************************************************************
 Analyze questionnaire responses by participant group
***************************************************************************************/
/**/
/*PROC MEANS DATA = merged_2;*/
/*	VAR dummy_Q1-dummy_Q21;*/
/*RUN;*/
/**/
/*PROC MEANS DATA = merged_2;*/
/*	WHERE Partic_group = 'C';*/
/*	VAR dummy_Q1-dummy_Q21;*/
/*RUN;*/
/**/
/*PROC MEANS DATA = merged_2;*/
/*	WHERE Partic_group = 'P';*/
/*	VAR dummy_Q1-dummy_Q21;*/
/*RUN;*/



/**************************************************************************************
/* Analyze questionnaire responses by participant group*/
/****************************************************************************************/*/
/*%MeansExtract04(inputds = work.merged_2*/
/*			   ,var 	= dummy_Q1-dummy_Q21*/
/*			   ,excelss = MEANS*/
/*               ,excelfn = !WBE\CBE\SECURE\QST\XLS\CBE_PT_BL_QST_160328.xlsx);*/
/**/
/*%MeansExtract04(inputds = work.merged_2*/
/*			   ,wherex	= (Partic_group = 'P')*/
/*			   ,var 	= dummy_Q1-dummy_Q21*/
/*			   ,excelss = MEANS_prog*/
/*               ,excelfn = !WBE\CBE\SECURE\QST\XLS\CBE_PT_BL_QST_160328.xlsx);*/
/*			   */
/*%MeansExtract04(inputds = work.merged_2*/
/*			   ,wherex	= (Partic_group = 'C')*/
/*			   ,var 	= dummy_Q1-dummy_Q21*/
/*			   ,excelss = MEANS_comp*/
/*               ,excelfn = !WBE\CBE\SECURE\QST\XLS\CBE_PT_BL_QST_160328.xlsx);*/

