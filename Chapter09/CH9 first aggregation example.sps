* Encoding: UTF-8.
* Chapter 9 First aggregation example.
* This example uses the General Social Survey 2016 subset created in Chapter 3.
GET 
  FILE='C:\GSS Data\GSS2016sm33.sav'. 
* use recode to create income with midpoint values.
RECODE RINCOM16 (1=750)(2=2000)(3=3500)(4=4500)(5=5500)(6=6500)(7=7500)(8=9000)
(9=11250)(10=13750)(11=16250)(12=18750)(13=21250)(14=23750)(15=27500)(16=32500)
(17=37500)(18=45000)(19=55000)(20=67500)(21=82500)(22=95500)(23=120000)
(24=140000)(25=160000)(26=200000) INTO RINCOME_MIDPT.
VARIABLE LABELS RINCOME_MIDPT 'Respondents income using midpoint of selected category'.

DESCRIPTIVES all.


AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES OVERWRITEVARS=YES
  /BREAK=region
  /educ_mean=MEAN(educ) 
  /RINCOME_MIDPT_mean=MEAN(RINCOME_MIDPT) 
  /RINCOME_MIDPT_sd 'Standard deviation of income (midpoint)'=SD(RINCOME_MIDPT).

compute zincome_region= (RINCOME_MIDPT - RINCOME_MIDPT_mean) / RINCOME_MIDPT_sd.
descriptives zincome_region.

