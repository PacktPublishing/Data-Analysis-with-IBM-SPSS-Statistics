* Encoding: UTF-8.
* create GSS2016small with 28 fields.
* Modified 4/3/17 to use INCOM06 rather than INCOME - better set of values.
SAVE OUTFILE='C:\GSS Data\GSS2016sm28 40317.sav'
  /keep = happy marital hapmar age 
  VOTE12   PRES12 educ speduc natpark natroad  NATENRGY 
cappun natmass  natchld natsci 
partyid degree incom16 satfin size spdeg polviews
 rincom16 res16 childs wrkstat sex region /COMPRESSED.

