Minimize
 Cost:   LoadFunction 
Subject To
Coverage.1: d_1_0 + d_1_1 + d_1_2 + d_1_3 + d_1_4 + d_1_5 + d_1_6 + d_1_7  >= 9
Coverage.2: d_2_0 + d_2_1 + d_2_2 + d_2_3 + d_2_4 + d_2_5 + d_2_6 + d_2_7  >= 9
ProcLoad.M3: Load_M3  -  d_2_6 -  d_2_4 -  d_1_2 -  d_1_1 -  d_2_1 -  d_1_4 -  d_1_6 -  d_2_2 = 0
ProcLoad.M1: Load_M1  -  d_1_7 -  d_2_3 -  d_2_4 -  d_1_2 -  d_1_4 -  d_2_2 -  d_2_7 -  d_1_3 = 0
ProcLoad.M7: Load_M7  -  d_2_6 -  d_2_5 -  d_1_0 -  d_1_5 -  d_1_1 -  d_2_1 -  d_1_6 -  d_2_0 = 0
ProcLoad.M8: Load_M8  -  d_2_3 -  d_2_4 -  d_1_0 -  d_1_1 -  d_2_1 -  d_1_4 -  d_1_3 -  d_2_0 = 0
ProcLoad.M2: Load_M2  -  d_1_7 -  d_2_6 -  d_2_5 -  d_1_2 -  d_1_5 -  d_1_6 -  d_2_2 -  d_2_7 = 0
ProcLoad.M9: Load_M9  -  d_1_7 -  d_2_3 -  d_2_5 -  d_1_0 -  d_1_5 -  d_2_7 -  d_1_3 -  d_2_0 = 0
MaxProcLoadBound.M3: Load_M3 - LoadFunction <= 0
MaxProcLoadBound.M1: Load_M1 - LoadFunction <= 0
MaxProcLoadBound.M7: Load_M7 - LoadFunction <= 0
MaxProcLoadBound.M8: Load_M8 - LoadFunction <= 0
MaxProcLoadBound.M2: Load_M2 - LoadFunction <= 0
MaxProcLoadBound.M9: Load_M9 - LoadFunction <= 0
RuleLoad.S6:  1 d_2_6 + 1 d_2_3 + 1 d_2_4 + 1 d_2_5 + 1 d_2_1 + 1 d_2_2 + 1 d_2_7 + 1 d_2_0 <= 189
RuleLoad.S1:  3 d_1_7 + 2 d_2_3 + 2 d_2_4 + 3 d_1_2 + 1 d_1_0 + 1 d_1_5 + 1 d_1_1 + 3 d_1_4 + 2 d_2_2 + 1 d_1_6 + 2 d_2_7 + 3 d_1_3 <= 189
RuleLoad.S9:  2 d_1_7 + 2 d_2_3 + 2 d_2_5 + 2 d_1_0 + 2 d_1_5 + 2 d_2_7 + 2 d_1_3 + 2 d_2_0 <= 189
RuleLoad.S8:  2 d_2_3 + 2 d_2_4 + 2 d_1_0 + 2 d_1_1 + 2 d_2_1 + 2 d_1_4 + 2 d_1_3 + 2 d_2_0 <= 189
RuleLoad.S2:  2 d_1_7 + 2 d_2_6 + 1 d_2_3 + 1 d_2_4 + 2 d_2_5 + 2 d_1_2 + 2 d_1_5 + 1 d_2_1 + 2 d_1_6 + 2 d_2_2 + 2 d_2_7 + 1 d_2_0 <= 189
RuleLoad.S5:  1 d_1_7 + 1 d_1_2 + 1 d_1_0 + 1 d_1_5 + 1 d_1_1 + 1 d_1_4 + 1 d_1_6 + 1 d_1_3 <= 189
RuleLoad.S7:  2 d_2_6 + 2 d_2_5 + 2 d_1_0 + 2 d_1_5 + 2 d_1_1 + 2 d_2_1 + 2 d_1_6 + 2 d_2_0 <= 189
RuleLoad.S3:  2 d_2_6 + 2 d_2_4 + 2 d_1_2 + 2 d_1_1 + 2 d_2_1 + 2 d_1_4 + 2 d_1_6 + 2 d_2_2 <= 189
Binaries
d_1_0
d_1_1
d_1_2
d_1_3
d_1_4
d_1_5
d_1_6
d_1_7
d_2_0
d_2_1
d_2_2
d_2_3
d_2_4
d_2_5
d_2_6
d_2_7
End
