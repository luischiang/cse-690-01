Minimize
 Cost:   LoadFunction 
Subject To
Coverage.1: f_1_1 + f_1_3 + f_1_0 + f_1_2  = 1
ProcLoad.M3: Load.M3  - 100 f_1_3 - 100 f_1_2 = 0
ProcLoad.M1: Load.M1  - 100 f_1_0 - 100 f_1_1 = 0
ProcLoad.M2: Load.M2  - 100 f_1_0 - 100 f_1_3 = 0
ProcLoad.M4: Load.M4  - 100 f_1_1 - 100 f_1_2 = 0
ProcLoadBound.M3: Load.M3 <= 100
ProcLoadBound.M1: Load.M1 <= 100
ProcLoadBound.M2: Load.M2 <= 100
ProcLoadBound.M4: Load.M4 <= 100
MaxProcLoadBound.M3: Load.M3 - LoadFunction <= 0
MaxProcLoadBound.M1: Load.M1 - LoadFunction <= 0
MaxProcLoadBound.M2: Load.M2 - LoadFunction <= 0
MaxProcLoadBound.M4: Load.M4 - LoadFunction <= 0
Bounds
 0 <= f_1_1 <= 1
 0 <= f_1_3 <= 1
 0 <= f_1_0 <= 1
 0 <= f_1_2 <= 1
End
