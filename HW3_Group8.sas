LIBNAME UTD 'E:\New folder'; run;

data hw;
set utd.hw3data;
RUN;

* data manipulations;

data creditC;
set hw;
profit = totfc + 0.016*tottrans;
if tottrans = 0 then active =0; else active = 1;
climit = limit/10000;
ttrans = tottrans/10000;
run;

data credit;
set creditC;
if profit < 0 then profit = 0;
run;

*Q1. Model profit = age  ttrans rewards climit numcard, modes of acquisition, type of card, types of affinity;

PROC QLIM data=credit;
model profit = age ttrans rewards climit numcard
               ds ts net quantum platinum gold sectorB sectorC sectorD sectorE sectorF;
endogenous profit ~ censored (lb=0);
Run; 

*Q2. Run a selection model Run a selection model;

*Model active = age, rewards, climit, numcard, modes of acquisition, type of card, types of affinity
 Model totfc = age, ttrans, rewards, climit, numcard, modes of acquisition, type of card, types of affinity;

proc QLIM data=credit; 
model active = age rewards climit numcard ds ts net gold platinum 
               quantum sectorB sectorC sectorD sectorE sectorF/discrete;
model totfc = age ttrans rewards climit numcard ds ts net gold platinum 
               quantum sectorB sectorC sectorD sectorE sectorF/ select(active=1); 
run; 

*Q3. Survival analysis;

*Duration = age, ttrans, rewards, climit, numcard, modes of acquition, type of card, types of affinity;


data creditcard;
set credit;
if dur = 37 then censor = 1; else censor = 0;
run;


proc phreg data = creditcard;
model dur*censor(1) = age ttrans rewards climit numcard ds ts net
                      gold platinum quantum sectorB sectorC sectorD sectorE sectorF;
run;


*Q4. Run the same model as above using PROC LIFEREG with Weibull distribution;

proc lifereg data = creditcard;
model dur*censor(1) = age ttrans rewards climit numcard ds ts net
                      gold platinum quantum sectorB sectorC sectorD sectorE sectorF/dist = weibull;
run;


*Q5. Use PROC LIFETEST to test whether survivor function of affinity groups
are significantly different from that of non-affinity groups.(that is compare sectorA with other sectors);

proc lifetest data = creditcard plots=(s);
time dur*censor(1);
strata sectorA;
run;

