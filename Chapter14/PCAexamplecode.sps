* Encoding: UTF-8.

GET
  FILE='C:\Users\tbabinec\Documents\KSBSPSSBOOK_DATA\chapterPCAandFA\CrimeStatebyState.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

DATASET ACTIVATE DataSet1.
*.
*Chapter 14 Figure 1. Syntax not shown in the chapter.
DESCRIPTIVES VARIABLES=MurderandManslaughterRate RevisedRapeRate RobberyRate AggravatedAssaultRate 
    BurglaryRate Larceny_TheftRate MotorVehicleTheftRate
  /STATISTICS=MEAN STDDEV MIN MAX.
*.
*Chapter 14 Figure 2. CORRELATIONS produces a pivot table
* Post-process the table in pivot table editor to show only correlations. 
* Syntax not shown in the chapter. 
CORRELATIONS
  /VARIABLES=MurderandManslaughterRate RevisedRapeRate RobberyRate AggravatedAssaultRate 
    BurglaryRate Larceny_TheftRate MotorVehicleTheftRate
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*first PCA run. Produces the following chapter output:
* Figure 3 - determinant.
* Figure 4 - inverse of correlation matrix.
* Figure 5 - KMO and Bartlett's test.
* Figure 6 - anti-image correlation matrix. 
* Figure 7 - communalities table.
* Figure 8 - total variance explained table.
* Figure 9 - scree plot. 
* Figure 10 - component matrix. 
FACTOR
 /VARIABLES MurderandManslaughterRate RevisedRapeRate RobberyRate 
 AggravatedAssaultRate BurglaryRate Larceny_TheftRate  MotorVehicleTheftRate
 /MISSING LISTWISE
 /ANALYSIS MurderandManslaughterRate RevisedRapeRate RobberyRate  AggravatedAssaultRate
 BurglaryRate Larceny_TheftRate MotorVehicleTheftRate
 /PRINT INITIAL DET KMO INV AIC EXTRACTION
 /PLOT EIGEN
 /CRITERIA FACTORS(7) ITERATE(25)
 /EXTRACTION PC
 /ROTATION NOROTATE
 /METHOD=CORRELATION.
*.
*second PCA run--two-component solution.
* Figure 11 - Communalities table.
* Figure 12 - Total variance explained table.
* Figure 13 - Component matrix.
* Figure 14 - Component loading plot.
FACTOR
 /VARIABLES MurderandManslaughterRate RevisedRapeRate RobberyRate  AggravatedAssaultRate
 BurglaryRate Larceny_TheftRate MotorVehicleTheftRate
 /MISSING LISTWISE
 /ANALYSIS MurderandManslaughterRate RevisedRapeRate RobberyRate  AggravatedAssaultRate 
 BurglaryRate Larceny_TheftRate MotorVehicleTheftRate
 /PRINT INITIAL EXTRACTION
 /PLOT ROTATION
 /CRITERIA FACTORS(2) ITERATE(25)
 /EXTRACTION PC
 /ROTATION NOROTATE
 /SAVE REG(ALL)
 /METHOD=CORRELATION.

*.
*Figure 15 - the book figure is post-edited to change markers and add
* horizontal and vertical reference lines at 0. 
* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=FAC1_1 FAC2_1 state2 MISSING=LISTWISE REPORTMISSING=NO    
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: FAC1_1=col(source(s), name("FAC1_1"))
  DATA: FAC2_1=col(source(s), name("FAC2_1"))
  DATA: state2=col(source(s), name("state2"), unit.category())
  GUIDE: axis(dim(1), label("REGR factor score   1 for analysis 1"))
  GUIDE: axis(dim(2), label("REGR factor score   2 for analysis 1"))
  ELEMENT: point(position(FAC1_1*FAC2_1), label(state2))
END GPL.
*.
*figure 16 syntax - table produced by SUMMARIZE.
DATASET COPY  figure16data.
DATASET ACTIVATE  figure16data.
FILTER OFF.
USE ALL.
SELECT IF (state2='DC' or state2='VT').
EXECUTE.
DATASET ACTIVATE figure16data.
SUMMARIZE
  /TABLES=State MurderandManslaughterRate RevisedRapeRate RobberyRate AggravatedAssaultRate 
    BurglaryRate Larceny_TheftRate MotorVehicleTheftRate FAC1_1
  /FORMAT=VALIDLIST NOCASENUM TOTAL LIMIT=100
  /TITLE='Case Summaries'
  /MISSING=VARIABLE
  /CELLS=COUNT.
*.
*figure 17 syntax - figure produced by SUMMARIZE. 
DATASET ACTIVATE  DataSet1.
DATASET COPY  figure17data.
DATASET ACTIVATE  figure17data.
FILTER OFF.
USE ALL.
SELECT IF (state2='AK' or state2='LA').
EXECUTE.
DATASET ACTIVATE figure17data.
SUMMARIZE
  /TABLES=State MurderandManslaughterRate RevisedRapeRate RobberyRate AggravatedAssaultRate 
    BurglaryRate Larceny_TheftRate MotorVehicleTheftRate FAC2_1
  /FORMAT=VALIDLIST NOCASENUM TOTAL LIMIT=100
  /TITLE='Case Summaries'
  /MISSING=VARIABLE
  /CELLS=COUNT.
