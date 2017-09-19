
*Read the Old Faithful data.
GET
  FILE='C:\Users\tbabinec\Documents\KSBSPSSBOOK_DATA\ChapterCluster\faithful.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.
*.
*These commands produce the two histograms.
*Figures 11 and 12.
DATASET ACTIVATE DataSet1.
FREQUENCIES VARIABLES=eruption waiting
  /FORMAT=NOTABLE
  /HISTOGRAM
  /ORDER=ANALYSIS.
*.
*The GGRAPH code produces the bivariate scatterplot of the two eruption variables.
*Figure 13-bivariate scatterplot.
* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=eruption waiting MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: eruption=col(source(s), name("eruption"))
  DATA: waiting=col(source(s), name("waiting"))
  GUIDE: axis(dim(1), label("eruption time in minutes"))
  GUIDE: axis(dim(2), label("waiting time to next eruption"))
  ELEMENT: point(position(eruption*waiting))
END GPL.
*.
*Simple descriptive statistics.
*Figure 13a-Run the second DESCRIPTIVES to get zscore variables for quick cluster.
DESCRIPTIVES VARIABLES=eruption waiting
  /STATISTICS=MEAN STDDEV MIN MAX.
DESCRIPTIVES VARIABLES=eruption waiting
  /SAVE
  /STATISTICS=MEAN STDDEV MIN MAX.  
*scatterplot of zscored variables.
*Figure 14.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Zeruption Zwaiting MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Zeruption=col(source(s), name("Zeruption"))
  DATA: Zwaiting=col(source(s), name("Zwaiting"))
  GUIDE: axis(dim(1), label("Zscore:  eruption time in minutes"))
  GUIDE: axis(dim(2), label("Zscore:  waiting time to next eruption"))
  ELEMENT: point(position(Zeruption*Zwaiting))
END GPL.
*.
*Run K-means analysis.
*Figures 15-21 come from Quick Cluster output.
QUICK CLUSTER eruption waiting
  /MISSING=LISTWISE
  /CRITERIA=CLUSTER(2) MXITER(99) CONVERGE(0)
  /METHOD=KMEANS(NOUPDATE)
  /SAVE CLUSTER DISTANCE
  /PRINT INITIAL ANOVA CLUSTER DISTAN.
*
*scatterplot.
*Figure 22. 
* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=Zeruption Zwaiting QCL_1 MISSING=LISTWISE 
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: Zeruption=col(source(s), name("Zeruption"))
  DATA: Zwaiting=col(source(s), name("Zwaiting"))
  DATA: QCL_1=col(source(s), name("QCL_1"), unit.category())
  GUIDE: axis(dim(1), label("Zscore:  eruption time in minutes"))
  GUIDE: axis(dim(2), label("Zscore:  waiting time to next eruption"))
  GUIDE: legend(aesthetic(aesthetic.color.exterior), label("Cluster Number of Case"))
  ELEMENT: point(position(Zeruption*Zwaiting), color.exterior(QCL_1))
END GPL.
*.
*mean profiles
*Figure 23. 
MEANS TABLES=eruption waiting BY QCL_1
  /CELLS=MEAN COUNT STDDEV.
  
