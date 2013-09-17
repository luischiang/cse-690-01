<?xml version = "1.0" encoding="UTF-8" standalone="yes"?>
<CPLEXSolution version="1.2">
 <header
   problemName="200Dynamic1366508807.lp"
   objectiveValue="16.6666666666667"
   solutionTypeValue="1"
   solutionTypeString="basic"
   solutionStatusValue="1"
   solutionStatusString="optimal"
   solutionMethodString="dual"
   primalFeasible="1"
   dualFeasible="1"
   simplexIterations="13"
   writeLevel="1"/>
 <quality
   epRHS="1e-06"
   epOpt="1e-06"
   maxPrimalInfeas="0"
   maxDualInfeas="0"
   maxPrimalResidual="7.105427357601e-15"
   maxDualResidual="5.55111512312578e-17"
   maxX="16.6666666666667"
   maxPi="16.6666666666667"
   maxSlack="83.3333333333333"
   maxRedCost="0"
   kappa="6568.77055921053"/>
 <linearConstraints>
  <constraint name="Coverage.1" index="0" status="LL" slack="0" dual="16.6666666666667"/>
  <constraint name="ProcLoad.M3" index="1" status="LL" slack="0" dual="0.166666666666667"/>
  <constraint name="ProcLoad.M5" index="2" status="LL" slack="0" dual="0.166666666666667"/>
  <constraint name="ProcLoad.M12" index="3" status="LL" slack="0" dual="-0"/>
  <constraint name="ProcLoad.M10" index="4" status="LL" slack="0" dual="-0"/>
  <constraint name="ProcLoad.M4" index="5" status="LL" slack="0" dual="0"/>
  <constraint name="ProcLoad.M11" index="6" status="LL" slack="0" dual="0.166666666666667"/>
  <constraint name="ProcLoad.M7" index="7" status="LL" slack="0" dual="0.166666666666667"/>
  <constraint name="ProcLoad.M1" index="8" status="LL" slack="0" dual="0.166666666666667"/>
  <constraint name="ProcLoad.M8" index="9" status="LL" slack="0" dual="0"/>
  <constraint name="ProcLoad.M2" index="10" status="LL" slack="0" dual="-0"/>
  <constraint name="ProcLoad.M9" index="11" status="LL" slack="0" dual="0.166666666666667"/>
  <constraint name="ProcLoad.M6" index="12" status="LL" slack="0" dual="0"/>
  <constraint name="ProcLoadBound.M3" index="13" status="BS" slack="83.3333333333333" dual="0"/>
  <constraint name="ProcLoadBound.M5" index="14" status="BS" slack="83.3333333333333" dual="0"/>
  <constraint name="ProcLoadBound.M12" index="15" status="BS" slack="83.3333333333333" dual="0"/>
  <constraint name="ProcLoadBound.M10" index="16" status="BS" slack="83.3333333333333" dual="0"/>
  <constraint name="ProcLoadBound.M4" index="17" status="BS" slack="83.3333333333333" dual="0"/>
  <constraint name="ProcLoadBound.M11" index="18" status="BS" slack="83.3333333333333" dual="0"/>
  <constraint name="ProcLoadBound.M7" index="19" status="BS" slack="83.3333333333333" dual="0"/>
  <constraint name="ProcLoadBound.M1" index="20" status="BS" slack="83.3333333333333" dual="0"/>
  <constraint name="ProcLoadBound.M8" index="21" status="BS" slack="83.3333333333333" dual="0"/>
  <constraint name="ProcLoadBound.M2" index="22" status="BS" slack="83.3333333333333" dual="0"/>
  <constraint name="ProcLoadBound.M9" index="23" status="BS" slack="83.3333333333333" dual="0"/>
  <constraint name="ProcLoadBound.M6" index="24" status="BS" slack="83.3333333333333" dual="0"/>
  <constraint name="MaxProcLoadBound.M3" index="25" status="LL" slack="0" dual="-0.166666666666667"/>
  <constraint name="MaxProcLoadBound.M5" index="26" status="LL" slack="0" dual="-0.166666666666667"/>
  <constraint name="MaxProcLoadBound.M12" index="27" status="LL" slack="0" dual="0"/>
  <constraint name="MaxProcLoadBound.M10" index="28" status="LL" slack="0" dual="0"/>
  <constraint name="MaxProcLoadBound.M4" index="29" status="LL" slack="0" dual="0"/>
  <constraint name="MaxProcLoadBound.M11" index="30" status="LL" slack="0" dual="-0.166666666666667"/>
  <constraint name="MaxProcLoadBound.M7" index="31" status="LL" slack="0" dual="-0.166666666666667"/>
  <constraint name="MaxProcLoadBound.M1" index="32" status="LL" slack="0" dual="-0.166666666666667"/>
  <constraint name="MaxProcLoadBound.M8" index="33" status="BS" slack="0" dual="0"/>
  <constraint name="MaxProcLoadBound.M2" index="34" status="LL" slack="0" dual="0"/>
  <constraint name="MaxProcLoadBound.M9" index="35" status="LL" slack="0" dual="-0.166666666666667"/>
  <constraint name="MaxProcLoadBound.M6" index="36" status="BS" slack="0" dual="0"/>
 </linearConstraints>
 <variables>
  <variable name="LoadFunction" index="0" status="BS" value="16.6666666666667" reducedCost="0"/>
  <variable name="f_1_33" index="1" status="BS" value="0" reducedCost="0"/>
  <variable name="f_1_32" index="2" status="BS" value="0" reducedCost="0"/>
  <variable name="f_1_21" index="3" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_7" index="4" status="BS" value="0.166666666666667" reducedCost="0"/>
  <variable name="f_1_26" index="5" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_2" index="6" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_17" index="7" status="BS" value="0" reducedCost="0"/>
  <variable name="f_1_1" index="8" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_18" index="9" status="BS" value="0.166666666666667" reducedCost="0"/>
  <variable name="f_1_30" index="10" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_16" index="11" status="BS" value="0.166666666666667" reducedCost="0"/>
  <variable name="f_1_27" index="12" status="BS" value="0.166666666666667" reducedCost="0"/>
  <variable name="f_1_25" index="13" status="BS" value="0.166666666666667" reducedCost="0"/>
  <variable name="f_1_28" index="14" status="BS" value="0.166666666666667" reducedCost="0"/>
  <variable name="f_1_14" index="15" status="BS" value="0" reducedCost="0"/>
  <variable name="f_1_20" index="16" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_24" index="17" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_10" index="18" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_31" index="19" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_35" index="20" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_11" index="21" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_22" index="22" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_0" index="23" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_13" index="24" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_23" index="25" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_29" index="26" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_6" index="27" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_3" index="28" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_9" index="29" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_12" index="30" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_15" index="31" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_8" index="32" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_4" index="33" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_34" index="34" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_19" index="35" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_5" index="36" status="LL" value="0" reducedCost="0"/>
  <variable name="Load.M3" index="37" status="BS" value="16.6666666666667" reducedCost="0"/>
  <variable name="Load.M5" index="38" status="BS" value="16.6666666666667" reducedCost="0"/>
  <variable name="Load.M12" index="39" status="BS" value="16.6666666666667" reducedCost="0"/>
  <variable name="Load.M10" index="40" status="BS" value="16.6666666666667" reducedCost="0"/>
  <variable name="Load.M4" index="41" status="BS" value="16.6666666666667" reducedCost="0"/>
  <variable name="Load.M11" index="42" status="BS" value="16.6666666666667" reducedCost="0"/>
  <variable name="Load.M7" index="43" status="BS" value="16.6666666666667" reducedCost="0"/>
  <variable name="Load.M1" index="44" status="BS" value="16.6666666666667" reducedCost="0"/>
  <variable name="Load.M8" index="45" status="BS" value="16.6666666666667" reducedCost="0"/>
  <variable name="Load.M2" index="46" status="BS" value="16.6666666666667" reducedCost="0"/>
  <variable name="Load.M9" index="47" status="BS" value="16.6666666666667" reducedCost="0"/>
  <variable name="Load.M6" index="48" status="BS" value="16.6666666666667" reducedCost="0"/>
 </variables>
</CPLEXSolution>
