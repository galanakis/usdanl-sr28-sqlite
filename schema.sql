/*
  This file defines the database structure as it is defined
  in the sr28_doc.pdf pages 27 to 38.
*/


-- Supporting table: food group categories with their descriptions
DROP TABLE IF EXISTS `FD_GROUP`;
CREATE TABLE `FD_GROUP` (
  FdGrp_Cd integer NOT NULL PRIMARY KEY,
  FdGrp_Desc text NOT NULL
);

-- Main table: Contains info about the food items
DROP TABLE IF EXISTS `FOOD_DES`;
CREATE TABLE `FOOD_DES` (
  NDB_No integer NOT NULL PRIMARY KEY,
  FdGrp_Cd integer NOT NULL REFERENCES FD_GROUP(FdGrp_Cd),
  Long_Desc text NOT NULL DEFAULT '',
  Shrt_Desc text NOT NULL DEFAULT '',
  ComName text DEFAULT '',
  ManufacName text DEFAULT '',
  Survey text DEFAULT '',
  Ref_desc text DEFAULT '',
  Refuse integer,
  SciName text DEFAULT '',
  N_Factor real,
  Pro_Factor real,
  Fat_Factor real,
  CHO_Factor real
);


-- Supporting table: Descriptions of all the known nutrients
DROP TABLE IF EXISTS `NUTR_DEF`;
CREATE TABLE `NUTR_DEF` (
  Nutr_No integer NOT NULL PRIMARY KEY,
  Units text NOT NULL,
  Tagname text DEFAULT '',
  NutrDesc text NOT NULL,
  Num_Dec text NOT NULL,
  SR_Order integer NOT NULL
);

-- Supporting table: contains codes indicating the type of data
DROP TABLE IF EXISTS `SRC_CD`;
CREATE TABLE `SRC_CD` (
  Src_Cd integer NOT NULL PRIMARY KEY,
  SrcCd_Desc text NOT NULL
);

-- Supporting table: defines codes about the method with which the data was obtained
DROP TABLE IF EXISTS `DERIV_CD`;
CREATE TABLE `DERIV_CD` (
  Deriv_Cd text NOT NULL PRIMARY KEY,
  Deriv_Desc text NOT NULL
);

-- Main table: Contains the information on all nutrients per food item
DROP TABLE IF EXISTS `NUT_DATA`;
CREATE TABLE `NUT_DATA` (
  NDB_No integer NOT NULL REFERENCES FOOD_DES(NDB_No),
  Nutr_No integer NOT NULL REFERENCES NUTR_DEF(Nutr_No),
  Nutr_Val real NOT NULL,
  Num_Data_Pts integer NOT NULL,
  Std_Error real,
  Src_Cd integer REFERENCES SRC_CD(Src_Cd),
  Deriv_Cd text REFERENCES DERIV_CD(Deriv_Cd),
  Ref_NDB_No integer REFERENCES FOOD_DES(NDB_No),
  Add_Nutr_Mark text,
  Num_Studies integer,
  Min real,
  Max real,
  DF integer,
  Low_EB real,
  Up_EB real,
  Stat_cmt text,
  AddMod_Date text,
  CC text,
  PRIMARY KEY(NDB_No, Nutr_No)
);


-- Supporting table: Langual food groups
DROP TABLE IF EXISTS `LANGDESC`;
CREATE TABLE `LANGDESC` (
  Factor_Code text NOT NULL PRIMARY KEY,
  Description text NOT NULL
);

-- Supporting table: Associates a food items with a langual code
DROP TABLE IF EXISTS `LANGUAL`;
CREATE TABLE `LANGUAL` (
  NDB_No integer NOT NULL REFERENCES FOOD_DES(NDB_No),
  Factor_Code text NOT NULL REFERENCES LANGDESC(Factor_Code),
  PRIMARY KEY (NDB_No,Factor_Code)
);

-- Main table: contains information about weight and servings
DROP TABLE IF EXISTS `WEIGHT`;
CREATE TABLE `WEIGHT` (
    NDB_No integer NOT NULL REFERENCES FOOD_DES(NDB_No),
    Seq integer NOT NULL,
    Amount real NOT NULL,
    Msre_Desc text NOT NULL,
    Gm_Wgt real NOT NULL,
    Num_Data_Pts integer,
    Std_Dev real,
    PRIMARY KEY(NDB_No, Seq)
);

-- Supporting table: Contains footnotes for each food and nutrient combination
DROP TABLE IF EXISTS `FOOTNOTE`;
CREATE TABLE `FOOTNOTE` (
	NDB_No integer NOT NULL REFERENCES FOOD_DES(NDB_No),
	Footnt_No integer NOT NULL,
	Footnt_Typ text NOT NULL,
	Nutr_No int REFERENCES NUTR_DEF(Nutr_No),
	Footnt_Txt text NOT NULL
);

-- Supporting table: contains bibliography for each data source
DROP TABLE IF EXISTS `DATA_SRC`;
CREATE TABLE `DATA_SRC` (
	DataSrc_ID text NOT NULL PRIMARY KEY,
	Authors text,
	Title text NOT NULL,
	Year text,
	Journal text,
	Vol_City text,
	Issue_State text,
	Start_Page text,
	End_Page text
);

-- Supporting table: It links the nutrient data file with the data sources
DROP TABLE IF EXISTS `DATSRCLN`;
CREATE TABLE `DATSRCLN` (
	NDB_No integer NOT NULL REFERENCES FOOD_DES(NDB_No),
	Nutr_No integer NOT NULL REFERENCES NUTR_DEF(Nutr_No),
	DataSrc_ID text NOT NULL REFERENCES DATA_SRC(DataSrc_ID),
  PRIMARY KEY(NDB_No,Nutr_No,DataSrc_ID)
);


