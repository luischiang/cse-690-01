<?xml version = "1.0" encoding="UTF-8" standalone="yes"?>
<CPLEXSolution version="1.2">
 <header
   problemName="tunnel_10000Dynamic1367373940.lp"
   objectiveValue="30"
   solutionTypeValue="1"
   solutionTypeString="basic"
   solutionStatusValue="1"
   solutionStatusString="optimal"
   solutionMethodString="dual"
   primalFeasible="1"
   dualFeasible="1"
   simplexIterations="2"
   writeLevel="1"/>
 <quality
   epRHS="1e-06"
   epOpt="1e-06"
   maxPrimalInfeas="0"
   maxDualInfeas="0"
   maxPrimalResidual="0"
   maxDualResidual="0"
   maxX="30"
   maxPi="10"
   maxSlack="100"
   maxRedCost="0"
   kappa="1403.11111111111"/>
 <linearConstraints>
  <constraint name="Coverage.1" index="0" status="LL" slack="0" dual="10"/>
  <constraint name="Coverage.2" index="1" status="LL" slack="0" dual="10"/>
  <constraint name="Coverage.3" index="2" status="LL" slack="0" dual="10"/>
  <constraint name="ProcLoad.M11" index="3" status="LL" slack="0" dual="0"/>
  <constraint name="ProcLoad.M8" index="4" status="LL" slack="0" dual="0"/>
  <constraint name="ProcLoad.M1" index="5" status="LL" slack="0" dual="1"/>
  <constraint name="ProcLoad.M5" index="6" status="LL" slack="0" dual="0"/>
  <constraint name="ProcLoad.M2" index="7" status="LL" slack="0" dual="0"/>
  <constraint name="ProcLoadBound.M11" index="8" status="BS" slack="90" dual="0"/>
  <constraint name="ProcLoadBound.M8" index="9" status="BS" slack="70" dual="0"/>
  <constraint name="ProcLoadBound.M1" index="10" status="BS" slack="70" dual="0"/>
  <constraint name="ProcLoadBound.M5" index="11" status="BS" slack="80" dual="0"/>
  <constraint name="ProcLoadBound.M2" index="12" status="BS" slack="100" dual="0"/>
  <constraint name="MaxProcLoadBound.M11" index="13" status="BS" slack="20" dual="0"/>
  <constraint name="MaxProcLoadBound.M8" index="14" status="LL" slack="0" dual="0"/>
  <constraint name="MaxProcLoadBound.M1" index="15" status="LL" slack="0" dual="-1"/>
  <constraint name="MaxProcLoadBound.M5" index="16" status="BS" slack="10" dual="0"/>
  <constraint name="MaxProcLoadBound.M2" index="17" status="BS" slack="30" dual="0"/>
 </linearConstraints>
 <variables>
  <variable name="LoadFunction" index="0" status="BS" value="30" reducedCost="0"/>
  <variable name="f_1_1" index="1" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_3" index="2" status="BS" value="1" reducedCost="0"/>
  <variable name="f_1_0" index="3" status="BS" value="0" reducedCost="0"/>
  <variable name="f_1_2" index="4" status="LL" value="0" reducedCost="0"/>
  <variable name="f_2_1" index="5" status="BS" value="1" reducedCost="0"/>
  <variable name="f_2_3" index="6" status="LL" value="0" reducedCost="0"/>
  <variable name="f_2_0" index="7" status="LL" value="0" reducedCost="0"/>
  <variable name="f_2_2" index="8" status="LL" value="0" reducedCost="0"/>
  <variable name="f_3_1" index="9" status="BS" value="1" reducedCost="0"/>
  <variable name="f_3_3" index="10" status="LL" value="0" reducedCost="0"/>
  <variable name="f_3_0" index="11" status="LL" value="0" reducedCost="0"/>
  <variable name="f_3_2" index="12" status="LL" value="0" reducedCost="0"/>
  <variable name="Load.M11" index="13" status="BS" value="10" reducedCost="0"/>
  <variable name="Load.M8" index="14" status="BS" value="30" reducedCost="0"/>
  <variable name="Load.M1" index="15" status="BS" value="30" reducedCost="0"/>
  <variable name="Load.M5" index="16" status="BS" value="20" reducedCost="0"/>
  <variable name="Load.M2" index="17" status="BS" value="0" reducedCost="0"/>
 </variables>
</CPLEXSolution>
