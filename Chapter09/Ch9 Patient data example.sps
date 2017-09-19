* Encoding: UTF-8.
*Chapter 9 SPSS code.
* First restructure example.
*Read in the spreadsheet created for use with this example.
GET DATA
  /TYPE=XLSX
  /FILE='C:\Data\Patient_test_results.xlsx'
  /SHEET=name 'Sheet1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.


SORT CASES BY PatientID test.
CASESTOVARS
  /ID=PatientID
  /INDEX=test
  /GROUPBY=VARIABLE.

compute CHOL_HDL_RATIO= chol__tot/hdl. 
compute NON_HDL_CHOL= chol__tot - hdl. 
EXECUTE.


