/*libname mylib 'C:\temp';
run;*/

/*Demo Program for Course Project - Insurance Risk Analytics*/

libname mylib '/home/shuangl0/my_courses/Risk/';
run;

/*Model1-Q1*/
proc genmod data=mylib.project1;
class ppc(param=ref ref=last) cons_typ(param=ref ref=last);
model claims = ppc cons_typ height sqf/dist=p link=log type3;
run;

proc genmod data=mylib.project1;
class ppc(param=ref ref=last) cons_typ(param=ref ref=last);
model claims = ppc cons_typ sqf/dist=p link=log type3;
run;

/*Model1-Q2*/
proc genmod data=mylib.project1;
class ppc(param=ref ref=last) cons_typ(param=ref ref=last);
model claims = ppc cons_typ sqf/dist=p link=log type3;
estimate 'ppc A vs.B' ppc 1 -1 0/exp;
estimate 'ppc B vs.C' ppc 0 1 -1/exp;
estimate 'ppc C vs.D' ppc 0 0 1/exp;
estimate 'cons_typ fire_re vs.frame' cons_typ 1 -1/exp;
run;

data mylib.project; set mylib.project1;
if ppc='A' or ppc='B' then ppc_new='AB';
else ppc_new='CD';
if cons_typ='fire_re' then cons_new='fire_re';
else cons_new='ao';
run;

proc genmod data=mylib.project;
class ppc_new(param=ref ref=last) cons_new(param=ref ref=last);
model claims = ppc_new cons_new sqf/dist=p link=log type3;
estimate 'ppc AB vs.CD' ppc_new 1/exp;
estimate 'cons_typ ao vs.fire_re' cons_new 1/exp;
run;

/*Model1-Q3*/
proc genmod data=mylib.project;
class ppc_new(param=ref ref=last) cons_new(param=ref ref=last);
model claims = ppc_new cons_new sqf/dist=p link=log obstats;
ods output obstats=residuals;
run;

data residuals;
   set residuals;
   h=hesswgt*std**2;
   cookd=streschi**2*h/((1-h)*4);
   adjpred=2*sqrt(pred);
   adjlinp=xbeta+(claims-pred)/pred;
   absres=abs(stresdev);
run;

proc gplot data=residuals;
   plot stresdev*(pred adjpred) absres*adjpred;
   symbol1 v=star color=blue;
   title 'Diagnostic Residual Plots';
run;

proc gplot data=residuals;
   plot adjlinp*xbeta;
   plot2 adjlinp*xbeta;
   symbol1 v=star color=blue;
   symbol2 v=none i=sm70s width=3;
   title 'Diagnostic Residual Plots';
run;

proc gplot data=residuals;
   plot cookd*pred;
   symbol1 v=star color=blue;
   title "Influential Observations Identified by Cook's D";
run;
quit;

proc print data=residuals;
   where cookd ge .0238;
   var claims pred ppc_new cons_new sqf cookd stresdev;
   title 'Potential Influential Observations';
run;

/*Model2-Q1*/
proc genmod data=mylib.project;
class ppc_new(param=ref ref=last) cons_new(param=ref ref=last);
model claims = ppc_new cons_new sqf/dist=nb link=log type3;
estimate 'ppc AB vs.CD' ppc_new 1/exp;
estimate 'cons_typ ao vs.fire_re' cons_new 1/exp;
run;

proc genmod data=mylib.project;
model claims = sqf/dist=nb link=log type3;
run;

/*Model2-Q3*/
proc genmod data=mylib.project;
model claims = sqf/dist=nb link=log obstats;
ods output obstats=residuals;
run;

data residuals;
   set residuals;
   h=hesswgt*std**2;
   cookd=streschi**2*h/((1-h)*2);
   adjpred=2*sqrt(pred);
   adjlinp=xbeta+(claims-pred)/pred;
   absres=abs(stresdev);
run;

proc gplot data=residuals;
   plot stresdev*(pred adjpred) absres*adjpred;
   symbol1 v=star color=blue;
   title 'Diagnostic Residual Plots';
run;

proc gplot data=residuals;
   plot adjlinp*xbeta;
   plot2 adjlinp*xbeta;
   symbol1 v=star color=blue;
   symbol2 v=none i=sm70s width=3;
   title 'Diagnostic Residual Plots';
run;

proc gplot data=residuals;
   plot cookd*pred;
   symbol1 v=star color=blue;
   title "Influential Observations Identified by Cook's D";
run;
quit;

proc print data=residuals;
   where cookd ge .0235;
   var claims pred sqf cookd stresdev;
   title 'Potential Influential Observations';
run;

/*Model3-Q1*/
proc genmod data=mylib.project;
model claims = sqf sqf*sqf/dist=nb link=log obstats;
ods output obstats=residuals;
run;

data residuals;
   set residuals;
   h=hesswgt*std**2;
   cookd=streschi**2*h/((1-h)*3);
   adjpred=2*sqrt(pred);
   adjlinp=xbeta+(claims-pred)/pred;
   absres=abs(stresdev);
run;

proc gplot data=residuals;
   plot stresdev*(pred adjpred) absres*adjpred;
   symbol1 v=star color=blue;
   title 'Diagnostic Residual Plots';
run;

proc gplot data=residuals;
   plot adjlinp*xbeta;
   plot2 adjlinp*xbeta;
   symbol1 v=star color=blue;
   symbol2 v=none i=sm70s width=3;
   title 'Diagnostic Residual Plots';
run;

proc gplot data=residuals;
   plot cookd*pred;
   symbol1 v=star color=blue;
   title "Influential Observations Identified by Cook's D";
run;
quit;

proc print data=residuals;
   where cookd ge .0237;
   var claims pred sqf cookd stresdev;
   title 'Potential Influential Observations';
run;
