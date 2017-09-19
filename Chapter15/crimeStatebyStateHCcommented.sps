* Encoding: UTF-8.
GET
  FILE='C:\Users\tbabinec\Documents\KSBSPSSBOOK_DATA\ChapterCluster\CrimeStatebyState.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.
*.
*Run DESCRIPTIVES.
*The variables have widely different SDs/Variances, suggesting the need for standardizing. 
*Figure 1.
DESCRIPTIVES VARIABLES=MurderandManslaughterRate RevisedRapeRate RobberyRate AggravatedAssaultRate
    BurglaryRate Larceny_TheftRate MotorVehicleTheftRate
  /STATISTICS=MEAN STDDEV MIN MAX.
*.
*First cluster run is exploratory.
*Figure 2 agglomeration schedule start.
*Figure 3 agglomeration schedule finish.
*Figure 4 dendogram.
*.
DATASET DECLARE D0.5999347690493206.
PROXIMITIES   MurderandManslaughterRate RevisedRapeRate RobberyRate AggravatedAssaultRate 
    BurglaryRate Larceny_TheftRate MotorVehicleTheftRate
  /MATRIX OUT(D0.5999347690493206)
  /VIEW=CASE
  /MEASURE=SEUCLID
  /PRINT NONE
  /STANDARDIZE=VARIABLE Z.
CLUSTER
  /MATRIX IN(D0.5999347690493206)
  /METHOD WARD
  /PRINT SCHEDULE
  /PLOT DENDROGRAM VICICLE.
Dataset Close D0.5999347690493206.
*.
*Second cluster run runs the 4-cluster solution.
*.
DATASET DECLARE D0.9976844462521434.
PROXIMITIES   MurderandManslaughterRate RevisedRapeRate RobberyRate AggravatedAssaultRate 
    BurglaryRate Larceny_TheftRate MotorVehicleTheftRate
  /MATRIX OUT(D0.9976844462521434)
  /VIEW=CASE
  /MEASURE=SEUCLID
  /PRINT NONE
  /STANDARDIZE=VARIABLE Z.
CLUSTER
  /MATRIX IN(D0.9976844462521434)
  /METHOD WARD
  /PRINT SCHEDULE
  /PLOT DENDROGRAM VICICLE
  /SAVE CLUSTER(4).
Dataset Close D0.9976844462521434.
*.
*Produce descriptives for each cluster, including COUNT to get cluster sizes. 
*Figure 5 means report table.
*.
DATASET ACTIVATE DataSet1.
MEANS TABLES=MurderandManslaughterRate RevisedRapeRate RobberyRate AggravatedAssaultRate
    BurglaryRate Larceny_TheftRate MotorVehicleTheftRate BY CLU4_1
  /CELLS=MEAN STDDEV COUNT.
*.
*Produce same output but show only the means.
* Could also produce via pivot table editing. 
*Figure 6 and figure 7. Figure 7 was post-processed in Pivot Table editor to add background colors.  
MEANS TABLES=MurderandManslaughterRate RevisedRapeRate RobberyRate AggravatedAssaultRate 
    BurglaryRate Larceny_TheftRate MotorVehicleTheftRate BY CLU4_1
  /CELLS=MEAN.  
MEANS TABLES=MurderandManslaughterRate RevisedRapeRate RobberyRate AggravatedAssaultRate 
    BurglaryRate Larceny_TheftRate MotorVehicleTheftRate BY CLU4_1
  /CELLS=MEAN.  
*.
*Create zscores.
DESCRIPTIVES VARIABLES=MurderandManslaughterRate RevisedRapeRate RobberyRate AggravatedAssaultRate 
    BurglaryRate Larceny_TheftRate MotorVehicleTheftRate
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX.
*.
*Produce means table on standardized inputs.
*Figure 8 statistics on zscores.
MEANS TABLES=ZMurderandManslaughterRate ZRevisedRapeRate ZRobberyRate ZAggravatedAssaultRate 
    ZBurglaryRate ZLarceny_TheftRate ZMotorVehicleTheftRate BY CLU4_1
  /CELLS=MEAN.

*Produce profile plot featuring the cluster means in standardized metric.  
* Chart Builder.
*Figure 9 - multiple lines chard. Post-processed in Chart Editor to change color.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=MEAN(ZMurderandManslaughterRate) 
    MEAN(ZRevisedRapeRate) MEAN(ZRobberyRate) MEAN(ZAggravatedAssaultRate) MEAN(ZBurglaryRate) 
    MEAN(ZLarceny_TheftRate) MEAN(ZMotorVehicleTheftRate) CLU4_1 MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: CLU4_1=col(source(s), name("CLU4_1"), unit.category())
  GUIDE: axis(dim(2), label("Mean"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("Ward Method                          ",
    "   "))
  SCALE: cat(dim(1), include("0", "1", "2", "3", "4", "5", "6"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: line(position(INDEX*SUMMARY), color.interior(CLU4_1), missing.wings())
END GPL.  

*Produce scatterplot showing clustering on two of the variables.
* Chart Builder.
*Figure 10-scatterplot with colors-post-processed in Chart Editor to change color.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=RevisedRapeRate BurglaryRate CLU4_1 MISSING=LISTWISE 
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: RevisedRapeRate=col(source(s), name("RevisedRapeRate"))
  DATA: BurglaryRate=col(source(s), name("BurglaryRate"))
  DATA: CLU4_1=col(source(s), name("CLU4_1"), unit.category())
  GUIDE: axis(dim(1), label("RevisedRapeRate"))
  GUIDE: axis(dim(2), label("BurglaryRate"))
  GUIDE: legend(aesthetic(aesthetic.color.exterior), label("Ward Method                          ",
    "   "))
  ELEMENT: point(position(RevisedRapeRate*BurglaryRate), color.exterior(CLU4_1))
END GPL.



