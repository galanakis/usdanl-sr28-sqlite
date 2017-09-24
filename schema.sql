/*
  This file defines the database structure as it is defined
  in the sr28_doc.pdf pages 27 to 38.
  */

/*
  Comments on the structure of the database.

  The center of the database is the NUT_DATA table which we can think
  as a 2D table with the rows being the food items and the columns the
  nutrients.

  The food items are described in FOOD_DES.
  For each food item there is one associated food group (an item in
  FD_GROUP) and one or more langual descriptions (LANGUAL is a table
  containing all the different langual food descriptions for each food
  item. In fact it contains a a hash code, but the table LANGDESC 
  contains the actual description). In addition for each food item
  there is are various weight options, which define different serving
  sizes (cup, spoon etc).
  Every food item belongs to exactly one food group, but may have
  multible descriptive langual "tags" and multiple weight options.
  Therefore the FD_GROUP, LANGDESC, LANGUAL, and WEIGHT tables
  are holding the food group, the multiple langual descriptions and
  the multiple serving options of each food item.

  The nutrients are described in the NUTR_DEF file, which is relatively
  simple. It has the name, the tagname (something like a nick name) and
  the units. There is also a preferred sorting order to match the one
  found in nutrition labels.

  The most important file is the NUT_DATA which is a 2D array providing
  the amounts of each nutrient (column) for each food item (row).
  Together with the value we also get what type of data the nutrient
  concentration corresponds to (SRC_CD) and what method was used
  to calculate this value (DERIV_CD). For each entry in the Food/Nutrient
  table there can be multiple references to supporting research 
  (DATSRCLN contains the links to multiple bibliographical references,
  hashed by the table DATA_SRC).
  To summarize, for every food/nutrient combination there is one code
  defining the type of data, there one method of calculation and 
  multiple bibliographic references.
  
  Finally for each food/nutrient combination there is a footnote,
  but this might be the same for different combinations.

  */

-- Supporting table: food group categories with their descriptions
DROP TABLE IF EXISTS FD_GROUP;
CREATE TABLE FD_GROUP (
  FdGrp_Cd integer NOT NULL PRIMARY KEY,
  FdGrp_Desc text NOT NULL
);

-- Main table: Contains info about the food items
DROP TABLE IF EXISTS FOOD_DES;
CREATE TABLE FOOD_DES (
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
DROP TABLE IF EXISTS NUTR_DEF;
CREATE TABLE NUTR_DEF (
  Nutr_No integer NOT NULL PRIMARY KEY,
  Units text NOT NULL,
  Tagname text DEFAULT '',
  NutrDesc text NOT NULL,
  Num_Dec text NOT NULL,
  SR_Order integer NOT NULL
);

-- Supporting table: contains codes indicating the type of data
DROP TABLE IF EXISTS SRC_CD;
CREATE TABLE SRC_CD (
  Src_Cd integer NOT NULL PRIMARY KEY,
  SrcCd_Desc text NOT NULL
);

-- Supporting table: defines codes about the method with which the data was obtained
DROP TABLE IF EXISTS DERIV_CD;
CREATE TABLE DERIV_CD (
  Deriv_Cd text NOT NULL PRIMARY KEY,
  Deriv_Desc text NOT NULL
);

-- Main table: Contains the information on all nutrients per food item
DROP TABLE IF EXISTS NUT_DATA;
CREATE TABLE NUT_DATA (
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
DROP TABLE IF EXISTS LANGDESC;
CREATE TABLE LANGDESC (
  Factor_Code text NOT NULL PRIMARY KEY,
  Description text NOT NULL
);

-- Supporting table: Associates a food items with a langual code
DROP TABLE IF EXISTS LANGUAL;
CREATE TABLE LANGUAL (
  NDB_No integer NOT NULL REFERENCES FOOD_DES(NDB_No),
  Factor_Code text NOT NULL REFERENCES LANGDESC(Factor_Code),
  PRIMARY KEY (NDB_No,Factor_Code)
);

-- Main table: contains information about weight and servings
DROP TABLE IF EXISTS WEIGHT;
CREATE TABLE WEIGHT (
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
DROP TABLE IF EXISTS FOOTNOTE;
CREATE TABLE FOOTNOTE (
  NDB_No integer NOT NULL REFERENCES FOOD_DES(NDB_No),
  Footnt_No integer NOT NULL,
  Footnt_Typ text NOT NULL,
  Nutr_No integer REFERENCES NUTR_DEF(Nutr_No),
  Footnt_Txt text NOT NULL
);

-- Supporting table: contains bibliography for each data source
DROP TABLE IF EXISTS DATA_SRC;
CREATE TABLE DATA_SRC (
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
DROP TABLE IF EXISTS DATSRCLN;
CREATE TABLE DATSRCLN (
  NDB_No integer NOT NULL REFERENCES FOOD_DES(NDB_No),
  Nutr_No integer NOT NULL REFERENCES NUTR_DEF(Nutr_No),
  DataSrc_ID text NOT NULL REFERENCES DATA_SRC(DataSrc_ID),
  PRIMARY KEY(NDB_No,Nutr_No,DataSrc_ID)
);


