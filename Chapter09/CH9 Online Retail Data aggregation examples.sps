* Encoding: UTF-8.
* Chapter 9 Aggregation examples using Online Retail data from UC Irvine data respository.
* The source data in Excel format can be downloaded at.
* https://archive.ics.uci.edu/ml/datasets/Online+Retail.

GET DATA
  /TYPE=XLSX
  /FILE='C:\Data\Online Retail.xlsx'
  /SHEET=name 'Online Retail'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
Descriptives all.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.

DATASET ACTIVATE DataSet1.
DESCRIPTIVES VARIABLES=CustomerID InvoiceDate InvoiceNo Quantity UnitPrice
  /STATISTICS=MEAN STDDEV MIN MAX.


SELECT IF (not(missing(CustomerID)) and not(missing(InvoiceNo))).
COMPUTE itemcost=Quantity * UnitPrice.
descriptives all.


DATASET DECLARE invoicelevel.
AGGREGATE
  /OUTFILE='invoicelevel'
  /BREAK=InvoiceNo
  /CustomerID=FIRST(CustomerID) 
  /InvoiceDate=FIRST(InvoiceDate) 
  /itemcost_total=SUM(itemcost)
  /numproducts=N.

descriptives all.

* for second aggregate to the CustomerID level start with the invoicelevel file
* verify first that this is the best strategy.
* get the number of purchase events from the N of rows 
* sort by customerID and date then use LAG to get the difference in days.
* get the largest purchase amount and the smallest purchase amount.
* need to address the first row in the file - this ID happens to have only one purchase but the 
* prior value of ID is missing of course as is the prior value of date.
* could deal with this after the lag and DO IF .
* note that this first case has a huge itemcost value = 77,183 since the quantity was 74,215.


DATASET ACTIVATE invoicelevel.
sort cases by customerid invoicedate.
SHIFT VALUES VARIABLE=InvoiceDate RESULT=priorinvoicedate LAG=1
  /VARIABLE=CustomerID RESULT=priorcustID LAG=1.
Do if customerid ne priorcustid or missing(priorcustid).
compute daysincepurchase=0.
else if customerid=priorcustid.
compute daysincepurchase=datediff(invoicedate,priorinvoicedate,"days").
end if.
descriptives all.


DATASET ACTIVATE invoicelevel.
DATASET DECLARE customerlevel.
AGGREGATE
  /OUTFILE='customerlevel'
  /BREAK=CustomerID
  /daysincepurchase_max=MAX(daysincepurchase) 
  /First_purchase_date=MIN(InvoiceDate) 
  /largest_purchase=MAX(itemcost_total)
  /num_purchases=N.
DATASET ACTIVATE customerlevel.
descriptives all.

* match back the customer level to the invoice level using a table lookup and then find
* the invoice where the itemcost_total equals the largest_purchase value.
* select just these invoices and then match the invoice level back to the original data to find
* the associated items that made up this largest purchase event.

* match the customer level back to the invoice level.
STAR JOIN
  /SELECT t0.InvoiceNo, t0.InvoiceDate, t0.itemcost_total, t0.numproducts, t0.priorinvoicedate, 
    t0.priorcustID, t0.daysincepurchase, t1.daysincepurchase_max, t1.First_purchase_date, 
    t1.largest_purchase, t1.num_purchases
  /FROM * AS t0
  /JOIN 'customerlevel' AS t1
    ON t0.CustomerID=t1.CustomerID
  /OUTFILE FILE=*.
* find the invoice for each customer that is their largest purchase.
compute largestinvoice=0.
if itemcost_total=largest_purchase largestinvoice=1.
FREQUENCIES largestinvoice.