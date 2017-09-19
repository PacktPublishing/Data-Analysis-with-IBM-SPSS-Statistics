* Encoding: UTF-8.
GET 
  FILE='C:\Program Files\IBM\SPSS\Statistics\24\Samples\English\satisf.sav'.

RECODE quality (1 thru 3=0) (4 thru 5=1) INTO qualsatpos.
VARIABLE LABELS  qualsatpos 'Satisfied with Quality'.

* Recode all the satisfaction questions including the Quality variable recoded above.
RECODE quality  price numitems org service overall (1 thru 3=0) (4 thru 5=1) INTO 
              qualsatpos pricesatpos numitemsatpos orgsatpos servicesatpos overallsatpos.

FREQUENCIES qualsatpos pricesatpos numitemsatpos orgsatpos servicesatpos overallsatpos.

COMPUTE meansat=MEAN(quality,org,overall,price,service,numitems).

COMPUTE satisf_cnt=SUM(qualsatpos, pricesatpos, numitemsatpos, orgsatpos, servicesatpos, overallsatpos).
FREQUENCIES satisf_cnt.

IF regular=0 and distance le 2 custcategory=1.
IF regular=0 and distance gt 2 custcategory=2.
IF (regular=1 or regular=2) and distance le 2 custcategory=3.
IF (regular=1 or regular=2) and distance gt 2 custcategory=4.
IF regular >=3 and distance <=2 custcategory=5.
IF regular >=3 and distance >2 custcategory=6.
value labels custcategory 1 'New_near' 2 'New_far' 3'Monthly_near' 4'Monthly_far' 5'Weekly_near' 6'Weekly_far'.
FREQUENCIES custcategory.

DO IF STORE=1.
RECODE  dept(1,4,6,=1)(2,3,5,7=2)INTO Key_Depts.
COMPUTE meanstoresat=MEAN(quality,price,service,numitems).
ELSE IF STORE=2.
RECODE  dept(1,4,6,=1)(2,3,5,7=2)INTO Key_Depts.
COMPUTE meanstoresat=MEAN(quality,overall,price,numitems).
ELSE IF STORE=3.
RECODE dept(4,5=1)(1,2,3,6,7=2)INTO Key_Depts.
COMPUTE meanstoresat=MEAN(quality,org,price,price,service,numitems).
ELSE IF STORE=4.
RECODE  dept(2,3,5,7,=1)(1,4,6=2)INTO Key_Depts.
COMPUTE meanstoresat=MEAN(quality,org,overall,price,service,numitems).
END IF.
var labels meanstoresat 'Satisfaction tailored for each store'.
value lables Key_Depts 1'Core Departments' 2'Convenience Departments'.
CROSSTABS store by Key_Depts.
descriptives meanstoresat.


