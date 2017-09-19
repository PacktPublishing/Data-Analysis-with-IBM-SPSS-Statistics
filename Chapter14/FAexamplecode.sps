* Encoding: UTF-8.
*.
*Factor example figure 18 - Run the following syntax and make the Data Editor window the active window.
matrix data variables=rowtype_
 general picture blocks maze reading vocab.
begin data.
mean 0 0 0 0 0 0
stddev 1 1 1 1 1 1
n 112 112 112 112 112 112
corr 1
corr .47 1
corr .55 .57 1
corr .34 .19 .45 1
corr .58 .26 .35 .18 1
corr .51 .24 .36 .22 .79 1
end data.
*variable labels
 general 'nonverbal measure of general intelligence'
 picture 'picture completion test'
 blocks 'block design test'
 maze 'maze test'
 reading 'reading comprehension test'
 vocab 'vocabulary test'.
*.
*Matrix-End matrix block produces reduced correlation matrix and eigenvalues.
* Produces figures 19,20,21.
MATRIX.
MGET /FILE=* /TYPE=CORR.
COMPUTE RINV=INV(CR).
COMPUTE SDIAG = DIAG(RINV).
COMPUTE S2=INV(MDIAG(SDIAG)).
COMPUTE RMS2=CR-S2.
CALL EIGEN(RMS2,VECTORS,VALUES).
PRINT CR/FORMAT F6.3/TITLE 'CR'.
PRINT RINV/FORMAT F6.3/TITLE 'RINV'.
PRINT SDIAG/FORMAT F6.3/TITLE 'SDIAG'.
PRINT S2/FORMAT F6.3/TITLE 'S2'.
PRINT RMS2 /FORMAT F5.3 /TITLE 'R - S2 MATRIX'.
PRINT VALUES /FORMAT=F6.3 /TITLE='EIGENVALUES'.
PRINT VECTORS /FORMAT=F5.3 /TITLE='EIGENVECTORS'.
END MATRIX.
*.
*figure 22 PARALLEL ANALYSIS produced by separate job.  
*.
*produce 1-factor and 2-factor solutions.
* 1st FACTOR produces figures 23,24,25,26,27.
* KMO and Bartlett's Test
* Communalities
* Total Variance Explained
* Factor Matrix
* Reproduced Correlations table. 
FACTOR /MATRIX=IN(COR=*)
 /MISSING LISTWISE
 /ANALYSIS=GENERAL PICTURE BLOCKS MAZE READING VOCAB
 /PRINT UNI COR INITIAL EXTRACTION REP KMO
 /CRI=FACTORS(1) ITERATE(99) ECONVERGE(.0001)
 /EXT PAF
 /ROT NOROTATE
 /METHOD=CORRELATION.
*.
* 2nd FACTOR produces figures 28,29,30,31,32,33,34.
* Communalities
* Total Variance Explained
* Factor Matrix
* Reproduced Correlations
* Pattern matrix
* Structure matrix
* Factor Correlation matrix.
FACTOR /MATRIX=IN(COR=*)
 /MISSING LISTWISE
 /ANALYSIS=GENERAL PICTURE BLOCKS MAZE READING VOCAB
 /PRINT INITIAL EXTRACTION ROTATION REP
 /CRI=FACTORS(2) ITERATE(99) ECONVERGE(.0001)
 /EXT PAF
 /ROT PROMAX
 /METHOD=CORRELATION.
