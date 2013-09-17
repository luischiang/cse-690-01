Minimize
 Cost:   LoadFunction 
Subject To
Coverage.1: f_1_1 + f_1_3 + f_1_0 + f_1_2  = 1
Coverage.2:  + f_2_1 + f_2_3 + f_2_0 + f_2_2  = 1
Coverage.3:  + f_3_1 + f_3_3 + f_3_0 + f_3_2  = 1
Coverage.4:  + f_4_1 + f_4_3 + f_4_0 + f_4_2  = 1
ProcLoad.M11: Load.M11  - 10 f_4_2 - 10 f_3_3 - 10 f_2_3 - 10 f_3_2 - 10 f_1_2 - 10 f_2_2 - 10 f_4_3 - 10 f_1_3 = 0
ProcLoad.M8: Load.M8  - 10 f_3_3 - 10 f_2_3 - 10 f_4_1 - 10 f_1_1 - 10 f_2_1 - 10 f_3_1 - 10 f_4_3 - 10 f_1_3 = 0
ProcLoad.M1: Load.M1  - 10 f_2_3 - 10 f_3_2 - 10 f_4_0 - 10 f_1_2 - 10 f_1_0 - 10 f_2_1 - 10 f_3_1 - 10 f_3_0 - 10 f_2_0 - 10 f_4_3 - 10 f_4_2 - 10 f_3_3 - 10 f_4_1 - 10 f_1_1 - 10 f_2_2 - 10 f_1_3 = 0
ProcLoad.M5: Load.M5  - 10 f_4_0 - 10 f_4_1 - 10 f_1_0 - 10 f_1_1 - 10 f_2_1 - 10 f_3_1 - 10 f_3_0 - 10 f_2_0 = 0
ProcLoad.M2: Load.M2  - 10 f_4_2 - 10 f_3_2 - 10 f_4_0 - 10 f_1_2 - 10 f_1_0 - 10 f_2_2 - 10 f_3_0 - 10 f_2_0 = 0
ProcLoadBound.M11: Load.M11 <= 100
ProcLoadBound.M8: Load.M8 <= 100
ProcLoadBound.M1: Load.M1 <= 100
ProcLoadBound.M5: Load.M5 <= 100
ProcLoadBound.M2: Load.M2 <= 100
MaxProcLoadBound.M11: Load.M11 - LoadFunction <= 0
MaxProcLoadBound.M8: Load.M8 - LoadFunction <= 0
MaxProcLoadBound.M1: Load.M1 - LoadFunction <= 0
MaxProcLoadBound.M5: Load.M5 - LoadFunction <= 0
MaxProcLoadBound.M2: Load.M2 - LoadFunction <= 0
Bounds
 0 <= f_4_1 <= 1
 0 <= f_4_3 <= 1
 0 <= f_4_0 <= 1
 0 <= f_4_2 <= 1
 0 <= f_1_1 <= 1
 0 <= f_1_3 <= 1
 0 <= f_1_0 <= 1
 0 <= f_1_2 <= 1
 0 <= f_3_1 <= 1
 0 <= f_3_3 <= 1
 0 <= f_3_0 <= 1
 0 <= f_3_2 <= 1
 0 <= f_2_1 <= 1
 0 <= f_2_3 <= 1
 0 <= f_2_0 <= 1
 0 <= f_2_2 <= 1
End
