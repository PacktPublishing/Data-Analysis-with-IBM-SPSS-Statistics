*** The following code is adapted from O'Connell's website           ***.
*** Fill in the statements following "enter your specifications here"***.
***  and ending with "end of user specifications"                    ***. 
***                                                                  ***.
* Encoding: UTF-8.
* Parallel Analysis program.

set mxloops=9000 printback=off width=80  seed = 1953125.
matrix.

* enter your specifications here.
compute ncases   = 112. 
compute nvars    = 6.
compute ndatsets = 1000.
compute percent  = 95.

* Specify the desired kind of parallel analysis, where:
  1 = principal components analysis
  2 = principal axis/common factor analysis.
compute kind = 2 .

****************** End of user specifications. ******************

* principal components analysis.
do if (kind = 1).
compute evals = make(nvars,ndatsets,-9999).
compute nm1 = 1 / (ncases-1).
loop #nds = 1 to ndatsets.
compute x = sqrt(2 * (ln(uniform(ncases,nvars)) * -1) ) &*
            cos(6.283185 * uniform(ncases,nvars) ).
compute vcv = nm1 * (sscp(x) - ((t(csum(x))*csum(x))/ncases)).
compute d = inv(mdiag(sqrt(diag(vcv)))).
compute evals(:,#nds) = eval(d * vcv * d).
end loop.
end if.

* principal axis / common factor analysis with SMCs on the diagonal.
do if (kind = 2).
compute evals = make(nvars,ndatsets,-9999).
compute nm1 = 1 / (ncases-1).
loop #nds = 1 to ndatsets.
compute x = sqrt(2 * (ln(uniform(ncases,nvars)) * -1) ) &*
            cos(6.283185 * uniform(ncases,nvars) ).
compute vcv = nm1 * (sscp(x) - ((t(csum(x))*csum(x))/ncases)).
compute d = inv(mdiag(sqrt(diag(vcv)))).
compute r = d * vcv * d.
compute smc = 1 - (1 &/ diag(inv(r)) ).
call setdiag(r,smc).
compute evals(:,#nds) = eval(r).
end loop.
end if.

* identifying the eigenvalues corresponding to the desired percentile.
compute num = rnd((percent*ndatsets)/100).
compute results = { t(1:nvars), t(1:nvars), t(1:nvars) }.
loop #root = 1 to nvars.
compute ranks = rnkorder(evals(#root,:)).
loop #col = 1 to ndatsets.
do if (ranks(1,#col) = num).
compute results(#root,3) = evals(#root,#col).
break.
end if.
end loop.
end loop.
compute results(:,2) = rsum(evals) / ndatsets.

print /title="PARALLEL ANALYSIS:".
do if   (kind = 1).
print /title="Principal Components".
else if (kind = 2).
print /title="Principal Axis / Common Factor Analysis".
end if.
compute specifs = {ncases; nvars; ndatsets; percent}.
print specifs /title="Specifications for this Run:"
 /rlabels="Ncases" "Nvars" "Ndatsets" "Percent".
print results /title="Random Data Eigenvalues"
 /clabels="Root" "Means" "Prcntyle"  /format "f12.6".

do if   (kind = 2).
print / space = 1.
print /title="Compare the random data eigenvalues to the".
print /title="real-data eigenvalues that are obtained from a".
print /title="Common Factor Analysis in which the # of factors".
print /title="extracted equals the # of variables/items, and the".
print /title="number of iterations is fixed at zero;".
print /title="To obtain these real-data values using SPSS, see the".
print /title="sample commands at the end of the parallel.sps program,".
print /title="or use the rawpar.sps program.".
print / space = 1.
print /title="Warning: Parallel analyses of adjusted correlation matrices".
print /title="eg, with SMCs on the diagonal, tend to indicate more factors".
print /title="than warranted (Buja, A., & Eyuboglu, N., 1992, Remarks on parallel".
print /title="analysis. Multivariate Behavioral Research, 27, 509-540.).".
print /title="The eigenvalues for trivial, negligible factors in the real".
print /title="data commonly surpass corresponding random data eigenvalues".
print /title="for the same roots. The eigenvalues from parallel analyses".
print /title="can be used to determine the real data eigenvalues that are".
print /title="beyond chance, but additional procedures should then be used".
print /title="to trim trivial factors.".
print / space = 1.
print /title="Principal components eigenvalues are often used to determine".
print /title="the number of common factors. This is the default in most".
print /title="statistical software packages, and it is the primary practice".
print /title="in the literature. It is also the method used by many factor".
print /title="analysis experts, including Cattell, who often examined".
print /title="principal components eigenvalues in his scree plots to determine".
print /title="the number of common factors. But others believe this common".
print /title="practice is wrong. Principal components eigenvalues are based".
print /title="on all of the variance in correlation matrices, including both".
print /title="the variance that is shared among variables and the variances".
print /title="that are unique to the variables. In contrast, principal".
print /title="axis eigenvalues are based solely on the shared variance".
print /title="among the variables. The two procedures are qualitatively".
print /title="different. Some therefore claim that the eigenvalues from one".
print /title="extraction method should not be used to determine".
print /title="the number of factors for the other extraction method.".
print /title="The issue remains neglected and unsettled.".

end if.

end matrix.


* Commands for obtaining the necessary real-data eigenvalues for
  principal axis / common factor analysis using SPSS;
  make sure to insert valid filenames/locations, and
  remove the '*' from the first columns.
* correlations var1 to var20 / matrix out ('filename') / missing = listwise.
* matrix.
* MGET /type= corr /file='filename' .
* compute smc = 1 - (1 &/ diag(inv(cr)) ).
* call setdiag(cr,smc).
* compute evals = eval(cr).
* print { t(1:nrow(cr)) , evals }
 /title="Raw Data Eigenvalues"
 /clabels="Root" "Eigen."  /format "f12.6".
* end matrix.

