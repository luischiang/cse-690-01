Minimize
 Cost:   LoadFunction 
Subject To
Coverage.1: f_1_6 + f_1_3 + f_1_7 + f_1_2 + f_1_1 + f_1_4 + f_1_0 + f_1_5  = 1
Coverage.2:  + f_2_6 + f_2_3 + f_2_7 + f_2_2 + f_2_1 + f_2_4 + f_2_0 + f_2_5  = 1
ProcLoad.M3: Load.M3  - 50 f_2_6 - 50 f_2_4 - 50 f_1_2 - 50 f_1_1 - 50 f_2_1 - 50 f_1_4 - 50 f_1_6 - 50 f_2_2 = 0
ProcLoad.M1: Load.M1  - 50 f_1_7 - 50 f_2_3 - 50 f_2_4 - 50 f_1_2 - 50 f_1_4 - 50 f_2_2 - 50 f_2_7 - 50 f_1_3 = 0
ProcLoad.M7: Load.M7  - 50 f_2_6 - 50 f_2_5 - 50 f_1_0 - 50 f_1_5 - 50 f_1_1 - 50 f_2_1 - 50 f_1_6 - 50 f_2_0 = 0
ProcLoad.M8: Load.M8  - 50 f_2_3 - 50 f_2_4 - 50 f_1_0 - 50 f_1_1 - 50 f_2_1 - 50 f_1_4 - 50 f_1_3 - 50 f_2_0 = 0
ProcLoad.M2: Load.M2  - 50 f_1_7 - 50 f_2_6 - 50 f_2_5 - 50 f_1_2 - 50 f_1_5 - 50 f_1_6 - 50 f_2_2 - 50 f_2_7 = 0
ProcLoad.M9: Load.M9  - 50 f_1_7 - 50 f_2_3 - 50 f_2_5 - 50 f_1_0 - 50 f_1_5 - 50 f_2_7 - 50 f_1_3 - 50 f_2_0 = 0
ProcLoadBound.M3: Load.M3 <= 100
ProcLoadBound.M1: Load.M1 <= 100
ProcLoadBound.M7: Load.M7 <= 100
ProcLoadBound.M8: Load.M8 <= 100
ProcLoadBound.M2: Load.M2 <= 100
ProcLoadBound.M9: Load.M9 <= 100
MaxProcLoadBound.M3: Load.M3 - LoadFunction <= 0
MaxProcLoadBound.M1: Load.M1 - LoadFunction <= 0
MaxProcLoadBound.M7: Load.M7 - LoadFunction <= 0
MaxProcLoadBound.M8: Load.M8 - LoadFunction <= 0
MaxProcLoadBound.M2: Load.M2 - LoadFunction <= 0
MaxProcLoadBound.M9: Load.M9 - LoadFunction <= 0
Bounds
 0 <= f_1_6 <= 1
 0 <= f_1_3 <= 1
 0 <= f_1_7 <= 1
 0 <= f_1_2 <= 1
 0 <= f_1_1 <= 1
 0 <= f_1_4 <= 1
 0 <= f_1_0 <= 1
 0 <= f_1_5 <= 1
 0 <= f_2_6 <= 1
 0 <= f_2_3 <= 1
 0 <= f_2_7 <= 1
 0 <= f_2_2 <= 1
 0 <= f_2_1 <= 1
 0 <= f_2_4 <= 1
 0 <= f_2_0 <= 1
 0 <= f_2_5 <= 1
End
