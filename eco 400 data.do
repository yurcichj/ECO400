use "data400final1217025.dta", clear

*creation of dtable
quietly eststo summstats: estpost summarize AdjustedSalaries Attendance HomeGoals CapSpace LTIR LogSalaries
esttab using sumstats.rtf, replace cell("mean sd min max") title("Summary Statistics") note("Sources: Hockey Reference, Minneapolis Federal Reserve, Spotrac")

*creating graphs for assignment 4
histogram AdjustedSalaries, percent bin(10) title("Frequency of Adjusted Salaries On Team Basis") addlabel addlabopts(mlabsize(6-pt) mlabcolor(black)) normopts(lcolor(green) lwidth(thick)) xtitle("Salaries (Adjusted)") ytitle("Frequency (Percent)") caption("Sources: Minneapolis Federal Reserve, Spotrac")

twoway (scatter AvgAgeTeam LTIR, msymbol(circle_hollow) mcolor(navy)) ///
       (lfit AvgAgeTeam LTIR, lcolor(red)), ///
       title("Age of Team vs. Salary on LTIR") ///
       ytitle("Average Age of Team (Years)") ///
       xtitle("Salary on LTIR ($ Millions)") ///
       legend(order(1 "Teams" 2 "Fitted Line")) ///
       caption("Sources: Minneapolis Federal Reserve, Spotrac")

*regressions and regression tables
estimates clear

reg LogSalaries post2018 post2022, robust
estimates store olsreg1

reg LogSalaries LogAttendance post2018 post2022, robust
estimates store olsreg2

reg LogSalaries LogAttendance HomeGoals post2018 post2022, robust
estimates store olsreg3

reg LogSalaries LogAttendance HomeGoals LogCapSpace LogLTIR post2018 post2022, robust
estimates store olsreg4

reg LogSalaries LogAttendance HomeGoals LogCapSpace LogLTIR Distance CanadaTeam PlayoffTeam StanleyCup post2018 post2022, robust
estimates store olsreg5

esttab olsreg1 olsreg2 olsreg3 olsreg4 olsreg5 using OLSresultsfinal.rtf, replace nonotes stats(N r2) addnotes("* p<0.10, ** p<0.05, *** p<0.01") starlevel("*" 0.10 "**" 0.05 "***" 0.01)

xtset hometeam_id year

estimates clear

xtreg LogSalaries post2018 post2022, fe
estimates store fereg1

xtreg LogSalaries LogAttendance post2018 post2022, fe
estimates store fereg2

xtreg LogSalaries LogAttendance HomeGoals post2018 post2022, fe
estimates store fereg3

xtreg LogSalaries LogAttendance HomeGoals LogCapSpace LogLTIR post2018 post2022, fe
estimates store fereg4

xtreg LogSalaries LogAttendance HomeGoals LogCapSpace LogLTIR Distance CanadaTeam PlayoffTeam StanleyCup post2018 post2022, fe
estimates store fereg5

esttab fereg1 fereg2 fereg3 fereg4 fereg5 using FEresults.rtf, replace nonotes stats(N r2) addnotes("* p<0.10, ** p<0.05, *** p<0.01") starlevel("*" 0.10 "**" 0.05 "***" 0.01)