* Encoding: UTF-8.
* Start with the combined file create after downloading the Population Reference Bureau
* extract in CSV format and merging them so all of the data for each nation is on the same row 
* in the SPSS data file.

GET
  FILE='C:\Data\WPDS_2017_alldata.sav'.

*first example used.

CORRELATIONS
  /VARIABLES=Population_mid2017 GNI_per_Capita_PPP_2016 Life_Expectancy_Females 
    Life_Expectancy_Males Secondary_School_Enroll_Ratio_Females Secondary_School_Enroll_Ratio_Males
  /PRINT=TWOTAIL NOSIG
  /STATISTICS DESCRIPTIVES
  /MISSING=PAIRWISE.

* listwise version of first example.

CORRELATIONS
  /VARIABLES=Population_mid2017 GNI_per_Capita_PPP_2016 Life_Expectancy_Females 
    Life_Expectancy_Males Secondary_School_Enroll_Ratio_Females Secondary_School_Enroll_Ratio_Males
  /PRINT=TWOTAIL NOSIG
  /STATISTICS DESCRIPTIVES
  /MISSING=LISTWISE.

T-TEST PAIRS=Life_Expectancy_Females Secondary_School_Enroll_Ratio_Females WITH 
    Life_Expectancy_Males Secondary_School_Enroll_Ratio_Males (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.


PARTIAL CORR
  /VARIABLES=Births_per_1K Infant_Mortality_Rate BY Secondary_School_Enroll_Ratio_Females
  /SIGNIFICANCE=TWOTAIL
  /STATISTICS=DESCRIPTIVES CORR 
  /MISSING=LISTWISE.





