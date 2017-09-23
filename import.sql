/*
  This file handles the dirty details of importing the official
  CSV data into the data base. And checking for consistency.
*/

-- Import the data files
.separator "^"
.import sr28asc/FD_GROUP.txt FD_GROUP
.import sr28asc/FOOD_DES.txt FOOD_DES
.import sr28asc/LANGDESC.txt LANGDESC
.import sr28asc/LANGUAL.txt  LANGUAL
.import sr28asc/NUTR_DEF.txt NUTR_DEF
.import sr28asc/NUT_DATA.txt NUT_DATA
.import sr28asc/SRC_CD.txt   SRC_CD
.import sr28asc/DERIV_CD.txt DERIV_CD
.import sr28asc/WEIGHT.txt   WEIGHT
.import sr28asc/FOOTNOTE.txt FOOTNOTE
.import sr28asc/DATA_SRC.txt DATA_SRC
.import sr28asc/DATSRCLN.txt DATSRCLN

/*******************************************************************\
-- The import from CSV import an empty strin instead of NULL 
-- for an empty column. This affects the checking for foreign 
-- key consitency and it may cause issues if the user assumes 
-- NULL values. Here we null every optional value which has 
-- been set to an empty string by import. This is necessary 
-- because of the way the .import command works.
-- The variables that are being nullified are the ones that
-- can be blanc according to the documentation.
\******************************************************************/

UPDATE FOOD_DES SET ComName=NULL where ComName='';
UPDATE FOOD_DES SET ManufacName=NULL where ManufacName='';
UPDATE FOOD_DES SET Survey=NULL where Survey='';
UPDATE FOOD_DES SET Ref_desc=NULL where Ref_desc='';
UPDATE FOOD_DES SET Refuse=NULL where Refuse='';
UPDATE FOOD_DES SET SciName=NULL where SciName='';
UPDATE FOOD_DES SET N_Factor=NULL where N_Factor='';
UPDATE FOOD_DES SET Pro_Factor=NULL where Pro_Factor='';
UPDATE FOOD_DES SET Fat_Factor=NULL where Fat_Factor='';
UPDATE FOOD_DES SET CHO_Factor=NULL where CHO_Factor='';
UPDATE NUT_DATA SET Std_Error=NULL where Std_Error='';
UPDATE NUT_DATA SET Deriv_Cd=NULL where Deriv_Cd='';
UPDATE NUT_DATA SET Ref_NDB_No=NULL where Ref_NDB_No='';
UPDATE NUT_DATA SET Add_Nutr_Mark=NULL where Add_Nutr_Mark='';
UPDATE NUT_DATA SET Num_Studies=NULL where Num_Studies='';
UPDATE NUT_DATA SET Min=NULL where Min='';
UPDATE NUT_DATA SET Max=NULL where Max='';
UPDATE NUT_DATA SET DF=NULL where DF='';
UPDATE NUT_DATA SET Low_EB=NULL where Low_EB='';
UPDATE NUT_DATA SET Up_EB=NULL where Up_EB='';
UPDATE NUT_DATA SET Stat_cmt=NULL where Stat_cmt='';
UPDATE NUT_DATA SET AddMod_Date=NULL where AddMod_Date='';
UPDATE NUT_DATA SET CC=NULL where CC='';
UPDATE NUTR_DEF SET Tagname=NULL where Tagname='';
UPDATE FOOTNOTE SET Nutr_No=NULL where Nutr_No='';
UPDATE WEIGHT SET Num_Data_Pts=NULL where Num_Data_Pts='';
UPDATE WEIGHT SET Std_Dev=NULL where Std_Dev='';
UPDATE DATA_SRC SET Authors=NULL where Authors='';
UPDATE DATA_SRC SET Year=NULL where Year='';
UPDATE DATA_SRC SET Journal=NULL where Journal='';
UPDATE DATA_SRC SET Vol_City=NULL where Vol_City='';
UPDATE DATA_SRC SET Issue_State=NULL where Issue_State='';
UPDATE DATA_SRC SET Start_Page=NULL where Start_Page='';
UPDATE DATA_SRC SET End_Page=NULL where End_Page='';

/*******************************************************************\
-- We check if the database satisfies the foreign key contraint.
-- We cannot do that by setting the PRAGMA Foreign_Key=ON because
-- the database will try to enforce the contraint for the empty
-- string values. After setting the empty strings to NULL it will
-- work.
\******************************************************************/

PRAGMA foreign_key_check;
