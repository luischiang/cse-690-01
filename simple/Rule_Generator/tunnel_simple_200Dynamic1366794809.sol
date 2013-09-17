<?xml version = "1.0" encoding="UTF-8" standalone="yes"?>
<CPLEXSolution version="1.2">
 <header
   problemName="tunnel_200Dynamic1366794809.lp"
   objectiveValue="50"
   solutionTypeValue="1"
   solutionTypeString="basic"
   solutionStatusValue="1"
   solutionStatusString="optimal"
   solutionMethodString="dual"
   primalFeasible="1"
   dualFeasible="1"
   simplexIterations="3"
   writeLevel="1"/>
 <quality
   epRHS="1e-06"
   epOpt="1e-06"
   maxPrimalInfeas="0"
   maxDualInfeas="0"
   maxPrimalResidual="0"
   maxDualResidual="0"
   maxX="50"
   maxPi="25"
   maxSlack="50"
   maxRedCost="0"
   kappa="711.419744318182"/>
 <linearConstraints>
  <constraint name="Coverage.1" index="0" status="LL" slack="0" dual="25"/>
  <constraint name="Coverage.2" index="1" status="LL" slack="0" dual="25"/>
  <constraint name="ProcLoad.M3" index="2" status="LL" slack="0" dual="0"/>
  <constraint name="ProcLoad.M1" index="3" status="LL" slack="0" dual="0.5"/>
  <constraint name="ProcLoad.M7" index="4" status="LL" slack="0" dual="0.5"/>
  <constraint name="ProcLoad.M8" index="5" status="LL" slack="0" dual="0"/>
  <constraint name="ProcLoad.M2" index="6" status="LL" slack="0" dual="0"/>
  <constraint name="ProcLoad.M9" index="7" status="LL" slack="0" dual="0"/>
  <constraint name="ProcLoadBound.M3" index="8" status="BS" slack="50" dual="0"/>
  <constraint name="ProcLoadBound.M1" index="9" status="BS" slack="50" dual="0"/>
  <constraint name="ProcLoadBound.M7" index="10" status="BS" slack="50" dual="0"/>
  <constraint name="ProcLoadBound.M8" index="11" status="BS" slack="50" dual="0"/>
  <constraint name="ProcLoadBound.M2" index="12" status="BS" slack="50" dual="0"/>
  <constraint name="ProcLoadBound.M9" index="13" status="BS" slack="50" dual="0"/>
  <constraint name="MaxProcLoadBound.M3" index="14" status="LL" slack="0" dual="0"/>
  <constraint name="MaxProcLoadBound.M1" index="15" status="LL" slack="0" dual="-0.5"/>
  <constraint name="MaxProcLoadBound.M7" index="16" status="LL" slack="0" dual="-0.5"/>
  <constraint name="MaxProcLoadBound.M8" index="17" status="BS" slack="0" dual="0"/>
  <constraint name="MaxProcLoadBound.M2" index="18" status="BS" slack="0" dual="0"/>
  <constraint name="MaxProcLoadBound.M9" index="19" status="BS" slack="0" dual="0"/>
 </linearConstraints>
 <variables>
  <variable name="LoadFunction" index="0" status="BS" value="50" reducedCost="0"/>
  <variable name="f_1_6" index="1" status="BS" value="0.5" reducedCost="0"/>
  <variable name="f_1_3" index="2" status="BS" value="0.5" reducedCost="0"/>
  <variable name="f_1_7" index="3" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_2" index="4" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_1" index="5" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_4" index="6" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_0" index="7" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_5" index="8" status="LL" value="0" reducedCost="0"/>
  <variable name="f_2_6" index="9" status="LL" value="0" reducedCost="0"/>
  <variable name="f_2_3" index="10" status="LL" value="0" reducedCost="0"/>
  <variable name="f_2_7" index="11" status="LL" value="0" reducedCost="0"/>
  <variable name="f_2_2" index="12" status="BS" value="0.5" reducedCost="0"/>
  <variable name="f_2_1" index="13" status="LL" value="0" reducedCost="0"/>
  <variable name="f_2_4" index="14" status="LL" value="0" reducedCost="0"/>
  <variable name="f_2_0" index="15" status="BS" value="0.5" reducedCost="0"/>
  <variable name="f_2_5" index="16" status="LL" value="0" reducedCost="0"/>
  <variable name="Load.M3" index="17" status="BS" value="50" reducedCost="0"/>
  <variable name="Load.M1" index="18" status="BS" value="50" reducedCost="0"/>
  <variable name="Load.M7" index="19" status="BS" value="50" reducedCost="0"/>
  <variable name="Load.M8" index="20" status="BS" value="50" reducedCost="0"/>
  <variable name="Load.M2" index="21" status="BS" value="50" reducedCost="0"/>
  <variable name="Load.M9" index="22" status="BS" value="50" reducedCost="0"/>
 </variables>
</CPLEXSolution>
