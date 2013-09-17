<?xml version = "1.0" encoding="UTF-8" standalone="yes"?>
<CPLEXSolution version="1.2">
 <header
   problemName="tunnel_1000Dynamic1367373277.ilp"
   solutionName="incumbent"
   solutionIndex="-1"
   objectiveValue="100"
   solutionTypeValue="3"
   solutionTypeString="primal"
   solutionStatusValue="101"
   solutionStatusString="integer optimal solution"
   solutionMethodString="mip"
   primalFeasible="1"
   dualFeasible="1"
   MIPNodes="0"
   MIPIterations="0"
   writeLevel="1"/>
 <quality
   epInt="1e-05"
   epRHS="1e-06"
   maxIntInfeas="0"
   maxPrimalInfeas="0"
   maxX="100"
   maxSlack="981"/>
 <linearConstraints>
  <constraint name="Coverage.1" index="0" slack="0"/>
  <constraint name="Coverage.2" index="1" slack="0"/>
  <constraint name="ProcLoad.M11" index="2" slack="0"/>
  <constraint name="ProcLoad.M8" index="3" slack="0"/>
  <constraint name="ProcLoad.M1" index="4" slack="0"/>
  <constraint name="ProcLoad.M5" index="5" slack="0"/>
  <constraint name="ProcLoad.M2" index="6" slack="0"/>
  <constraint name="ProcLoadBound.M11" index="7" slack="100"/>
  <constraint name="ProcLoadBound.M8" index="8" slack="100"/>
  <constraint name="ProcLoadBound.M1" index="9" slack="0"/>
  <constraint name="ProcLoadBound.M5" index="10" slack="0"/>
  <constraint name="ProcLoadBound.M2" index="11" slack="0"/>
  <constraint name="MaxProcLoadBound.M11" index="12" slack="100"/>
  <constraint name="MaxProcLoadBound.M8" index="13" slack="100"/>
  <constraint name="MaxProcLoadBound.M1" index="14" slack="0"/>
  <constraint name="MaxProcLoadBound.M5" index="15" slack="0"/>
  <constraint name="MaxProcLoadBound.M2" index="16" slack="0"/>
  <constraint name="RuleLoad.S1" index="17" slack="973"/>
  <constraint name="RuleLoad.S8" index="18" slack="981"/>
  <constraint name="RuleLoad.S2" index="19" slack="979"/>
  <constraint name="RuleLoad.S5" index="20" slack="977"/>
  <constraint name="RuleLoad.S11" index="21" slack="981"/>
  <constraint name="SanityCheck.1.0" index="22" slack="0"/>
  <constraint name="SanityCheck.1.1" index="23" slack="1"/>
  <constraint name="SanityCheck.1.2" index="24" slack="1"/>
  <constraint name="SanityCheck.1.3" index="25" slack="1"/>
  <constraint name="SanityCheck.2.0" index="26" slack="0"/>
  <constraint name="SanityCheck.2.1" index="27" slack="1"/>
  <constraint name="SanityCheck.2.2" index="28" slack="1"/>
  <constraint name="SanityCheck.2.3" index="29" slack="1"/>
 </linearConstraints>
 <variables>
  <variable name="LoadFunction" index="0" value="100"/>
  <variable name="f_1_0" index="1" value="1"/>
  <variable name="f_1_1" index="2" value="0"/>
  <variable name="f_1_2" index="3" value="0"/>
  <variable name="f_1_3" index="4" value="0"/>
  <variable name="f_2_0" index="5" value="1"/>
  <variable name="f_2_1" index="6" value="0"/>
  <variable name="f_2_2" index="7" value="0"/>
  <variable name="f_2_3" index="8" value="0"/>
  <variable name="Load.M11" index="9" value="0"/>
  <variable name="Load.M8" index="10" value="0"/>
  <variable name="Load.M1" index="11" value="100"/>
  <variable name="Load.M5" index="12" value="100"/>
  <variable name="Load.M2" index="13" value="100"/>
  <variable name="a_2_3" index="14" value="1"/>
  <variable name="a_1_2" index="15" value="1"/>
  <variable name="a_1_0" index="16" value="1"/>
  <variable name="a_1_1" index="17" value="1"/>
  <variable name="a_2_1" index="18" value="1"/>
  <variable name="a_2_2" index="19" value="1"/>
  <variable name="a_1_3" index="20" value="1"/>
  <variable name="a_2_0" index="21" value="1"/>
 </variables>
</CPLEXSolution>
