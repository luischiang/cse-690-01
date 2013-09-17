Minimize
 Cost:   LoadFunction 
Subject To
Coverage.1: d_1_0 + d_1_1 + d_1_2 + d_1_3  >= 6
Coverage.2: d_2_0 + d_2_1 + d_2_2 + d_2_3  >= 6
ProcLoad.M11: Load_M11  -  d_2_3 -  d_2_2 -  d_1_3 -  d_1_2 = 0
ProcLoad.M8: Load_M8  -  d_2_1 -  d_1_1 -  d_2_3 -  d_1_3 = 0
ProcLoad.M1: Load_M1  -  d_2_3 -  d_1_2 -  d_1_0 -  d_1_1 -  d_2_1 -  d_2_2 -  d_1_3 -  d_2_0 = 0
ProcLoad.M5: Load_M5  -  d_1_0 -  d_2_1 -  d_1_1 -  d_2_0 = 0
ProcLoad.M2: Load_M2  -  d_1_0 -  d_2_2 -  d_2_0 -  d_1_2 = 0
MaxProcLoadBound.M11: Load_M11 - LoadFunction <= 0
MaxProcLoadBound.M8: Load_M8 - LoadFunction <= 0
MaxProcLoadBound.M1: Load_M1 - LoadFunction <= 0
MaxProcLoadBound.M5: Load_M5 - LoadFunction <= 0
MaxProcLoadBound.M2: Load_M2 - LoadFunction <= 0
RuleLoad.S1:  2 d_2_3 + 2 d_1_2 + 2 d_1_0 + 2 d_1_1 + 2 d_2_1 + 2 d_2_2 + 2 d_1_3 + 2 d_2_0 <= 189
RuleLoad.S8:  2 d_2_1 + 2 d_1_1 + 2 d_2_3 + 2 d_1_3 <= 189
RuleLoad.S2:  2 d_1_0 + 1 d_2_1 + 1 d_2_3 + 2 d_2_2 + 2 d_2_0 + 2 d_1_2 <= 189
RuleLoad.S5:  3 d_1_0 + 2 d_2_1 + 3 d_1_1 + 2 d_2_0 + 1 d_1_3 + 1 d_1_2 <= 189
RuleLoad.S11:  2 d_2_3 + 2 d_2_2 + 2 d_1_3 + 2 d_1_2 <= 189
Binaries
d_1_0
d_1_1
d_1_2
d_1_3
d_2_0
d_2_1
d_2_2
d_2_3
End
