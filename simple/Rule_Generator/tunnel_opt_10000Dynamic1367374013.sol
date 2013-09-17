<?xml version = "1.0" encoding="UTF-8" standalone="yes"?>
<CPLEXSolution version="1.2">
 <header
   problemName="tunnel_10000Dynamic1367374013.ilp"
   solutionName="incumbent"
   solutionIndex="-1"
   objectiveValue="30"
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
   maxX="30"
   maxSlack="9985"/>
 <linearConstraints>
  <constraint name="Coverage.1" index="0" slack="0"/>
  <constraint name="Coverage.3" index="1" slack="0"/>
  <constraint name="Coverage.2" index="2" slack="0"/>
  <constraint name="ProcLoad.M11" index="3" slack="0"/>
  <constraint name="ProcLoad.M8" index="4" slack="0"/>
  <constraint name="ProcLoad.M1" index="5" slack="0"/>
  <constraint name="ProcLoad.M5" index="6" slack="0"/>
  <constraint name="ProcLoad.M2" index="7" slack="0"/>
  <constraint name="ProcLoadBound.M11" index="8" slack="100"/>
  <constraint name="ProcLoadBound.M8" index="9" slack="100"/>
  <constraint name="ProcLoadBound.M1" index="10" slack="70"/>
  <constraint name="ProcLoadBound.M5" index="11" slack="70"/>
  <constraint name="ProcLoadBound.M2" index="12" slack="70"/>
  <constraint name="MaxProcLoadBound.M11" index="13" slack="30"/>
  <constraint name="MaxProcLoadBound.M8" index="14" slack="30"/>
  <constraint name="MaxProcLoadBound.M1" index="15" slack="0"/>
  <constraint name="MaxProcLoadBound.M5" index="16" slack="0"/>
  <constraint name="MaxProcLoadBound.M2" index="17" slack="0"/>
  <constraint name="RuleLoad.S6" index="18" slack="9985"/>
  <constraint name="RuleLoad.S1" index="19" slack="9965"/>
  <constraint name="RuleLoad.S11" index="20" slack="9977"/>
  <constraint name="RuleLoad.S4" index="21" slack="9985"/>
  <constraint name="RuleLoad.S8" index="22" slack="9977"/>
  <constraint name="RuleLoad.S2" index="23" slack="9975"/>
  <constraint name="RuleLoad.S5" index="24" slack="9973"/>
  <constraint name="RuleLoad.S3" index="25" slack="9985"/>
  <constraint name="SanityCheck.1.0" index="26" slack="0"/>
  <constraint name="SanityCheck.1.1" index="27" slack="1"/>
  <constraint name="SanityCheck.1.2" index="28" slack="1"/>
  <constraint name="SanityCheck.1.3" index="29" slack="1"/>
  <constraint name="SanityCheck.3.0" index="30" slack="0"/>
  <constraint name="SanityCheck.3.1" index="31" slack="1"/>
  <constraint name="SanityCheck.3.2" index="32" slack="1"/>
  <constraint name="SanityCheck.3.3" index="33" slack="1"/>
  <constraint name="SanityCheck.2.0" index="34" slack="0"/>
  <constraint name="SanityCheck.2.1" index="35" slack="1"/>
  <constraint name="SanityCheck.2.2" index="36" slack="1"/>
  <constraint name="SanityCheck.2.3" index="37" slack="1"/>
 </linearConstraints>
 <variables>
  <variable name="LoadFunction" index="0" value="30"/>
  <variable name="f_1_0" index="1" value="1"/>
  <variable name="f_1_1" index="2" value="0"/>
  <variable name="f_1_2" index="3" value="0"/>
  <variable name="f_1_3" index="4" value="0"/>
  <variable name="f_3_0" index="5" value="1"/>
  <variable name="f_3_1" index="6" value="0"/>
  <variable name="f_3_2" index="7" value="0"/>
  <variable name="f_3_3" index="8" value="0"/>
  <variable name="f_2_0" index="9" value="1"/>
  <variable name="f_2_1" index="10" value="0"/>
  <variable name="f_2_2" index="11" value="0"/>
  <variable name="f_2_3" index="12" value="0"/>
  <variable name="Load.M11" index="13" value="0"/>
  <variable name="Load.M8" index="14" value="0"/>
  <variable name="Load.M1" index="15" value="30"/>
  <variable name="Load.M5" index="16" value="30"/>
  <variable name="Load.M2" index="17" value="30"/>
  <variable name="a_3_3" index="18" value="1"/>
  <variable name="a_3_1" index="19" value="1"/>
  <variable name="a_3_2" index="20" value="1"/>
  <variable name="a_3_0" index="21" value="1"/>
  <variable name="a_2_3" index="22" value="1"/>
  <variable name="a_1_2" index="23" value="1"/>
  <variable name="a_1_0" index="24" value="1"/>
  <variable name="a_2_1" index="25" value="1"/>
  <variable name="a_1_1" index="26" value="1"/>
  <variable name="a_2_2" index="27" value="1"/>
  <variable name="a_2_0" index="28" value="1"/>
  <variable name="a_1_3" index="29" value="1"/>
 </variables>
</CPLEXSolution>
