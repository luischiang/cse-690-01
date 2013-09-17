<?xml version = "1.0" encoding="UTF-8" standalone="yes"?>
<CPLEXSolution version="1.2">
 <header
   problemName="tunnel_200Dynamic1364830529.lp"
   objectiveValue="50"
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
   maxX="50"
   maxPi="50"
   maxSlack="50"
   maxRedCost="0"
   kappa="482.0625"/>
 <linearConstraints>
  <constraint name="Coverage.1" index="0" status="LL" slack="0" dual="50"/>
  <constraint name="ProcLoad.M3" index="1" status="LL" slack="0" dual="0.5"/>
  <constraint name="ProcLoad.M1" index="2" status="LL" slack="0" dual="0.5"/>
  <constraint name="ProcLoad.M2" index="3" status="LL" slack="0" dual="0"/>
  <constraint name="ProcLoad.M4" index="4" status="LL" slack="0" dual="0"/>
  <constraint name="ProcLoadBound.M3" index="5" status="BS" slack="50" dual="0"/>
  <constraint name="ProcLoadBound.M1" index="6" status="BS" slack="50" dual="0"/>
  <constraint name="ProcLoadBound.M2" index="7" status="BS" slack="50" dual="0"/>
  <constraint name="ProcLoadBound.M4" index="8" status="BS" slack="50" dual="0"/>
  <constraint name="MaxProcLoadBound.M3" index="9" status="LL" slack="0" dual="-0.5"/>
  <constraint name="MaxProcLoadBound.M1" index="10" status="LL" slack="0" dual="-0.5"/>
  <constraint name="MaxProcLoadBound.M2" index="11" status="BS" slack="0" dual="0"/>
  <constraint name="MaxProcLoadBound.M4" index="12" status="BS" slack="0" dual="0"/>
 </linearConstraints>
 <variables>
  <variable name="LoadFunction" index="0" status="BS" value="50" reducedCost="0"/>
  <variable name="f_1_1" index="1" status="BS" value="0.5" reducedCost="0"/>
  <variable name="f_1_3" index="2" status="BS" value="0.5" reducedCost="0"/>
  <variable name="f_1_0" index="3" status="LL" value="0" reducedCost="0"/>
  <variable name="f_1_2" index="4" status="LL" value="0" reducedCost="0"/>
  <variable name="Load.M3" index="5" status="BS" value="50" reducedCost="0"/>
  <variable name="Load.M1" index="6" status="BS" value="50" reducedCost="0"/>
  <variable name="Load.M2" index="7" status="BS" value="50" reducedCost="0"/>
  <variable name="Load.M4" index="8" status="BS" value="50" reducedCost="0"/>
 </variables>
</CPLEXSolution>
