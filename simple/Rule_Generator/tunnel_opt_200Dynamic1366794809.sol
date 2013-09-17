<?xml version = "1.0" encoding="UTF-8" standalone="yes"?>
<CPLEXSolution version="1.2">
 <header
   problemName="tunnel_200Dynamic1366794809.ilp"
   solutionName="incumbent"
   solutionIndex="-1"
   objectiveValue="50"
   solutionTypeValue="3"
   solutionTypeString="primal"
   solutionStatusValue="101"
   solutionStatusString="integer optimal solution"
   solutionMethodString="mip"
   primalFeasible="1"
   dualFeasible="1"
   MIPNodes="0"
   MIPIterations="3"
   writeLevel="1"/>
 <quality
   epInt="1e-05"
   epRHS="1e-06"
   maxIntInfeas="0"
   maxPrimalInfeas="0"
   maxX="50"
   maxSlack="181"/>
 <linearConstraints>
  <constraint name="Coverage.1" index="0" slack="0"/>
  <constraint name="Coverage.2" index="1" slack="0"/>
  <constraint name="ProcLoad.M3" index="2" slack="0"/>
  <constraint name="ProcLoad.M1" index="3" slack="0"/>
  <constraint name="ProcLoad.M7" index="4" slack="0"/>
  <constraint name="ProcLoad.M8" index="5" slack="0"/>
  <constraint name="ProcLoad.M2" index="6" slack="0"/>
  <constraint name="ProcLoad.M9" index="7" slack="0"/>
  <constraint name="ProcLoadBound.M3" index="8" slack="50"/>
  <constraint name="ProcLoadBound.M1" index="9" slack="50"/>
  <constraint name="ProcLoadBound.M7" index="10" slack="50"/>
  <constraint name="ProcLoadBound.M8" index="11" slack="50"/>
  <constraint name="ProcLoadBound.M2" index="12" slack="50"/>
  <constraint name="ProcLoadBound.M9" index="13" slack="50"/>
  <constraint name="MaxProcLoadBound.M3" index="14" slack="0"/>
  <constraint name="MaxProcLoadBound.M1" index="15" slack="0"/>
  <constraint name="MaxProcLoadBound.M7" index="16" slack="0"/>
  <constraint name="MaxProcLoadBound.M8" index="17" slack="0"/>
  <constraint name="MaxProcLoadBound.M2" index="18" slack="0"/>
  <constraint name="MaxProcLoadBound.M9" index="19" slack="0"/>
  <constraint name="RuleLoad.S6" index="20" slack="181"/>
  <constraint name="RuleLoad.S1" index="21" slack="165"/>
  <constraint name="RuleLoad.S9" index="22" slack="173"/>
  <constraint name="RuleLoad.S8" index="23" slack="173"/>
  <constraint name="RuleLoad.S2" index="24" slack="169"/>
  <constraint name="RuleLoad.S5" index="25" slack="181"/>
  <constraint name="RuleLoad.S7" index="26" slack="173"/>
  <constraint name="RuleLoad.S3" index="27" slack="173"/>
  <constraint name="SanityCheck.1.0" index="28" slack="1"/>
  <constraint name="SanityCheck.1.1" index="29" slack="0"/>
  <constraint name="SanityCheck.1.2" index="30" slack="1"/>
  <constraint name="SanityCheck.1.3" index="31" slack="1"/>
  <constraint name="SanityCheck.1.4" index="32" slack="1"/>
  <constraint name="SanityCheck.1.5" index="33" slack="1"/>
  <constraint name="SanityCheck.1.6" index="34" slack="1"/>
  <constraint name="SanityCheck.1.7" index="35" slack="1"/>
  <constraint name="SanityCheck.2.0" index="36" slack="1"/>
  <constraint name="SanityCheck.2.1" index="37" slack="1"/>
  <constraint name="SanityCheck.2.2" index="38" slack="1"/>
  <constraint name="SanityCheck.2.3" index="39" slack="1"/>
  <constraint name="SanityCheck.2.4" index="40" slack="1"/>
  <constraint name="SanityCheck.2.5" index="41" slack="1"/>
  <constraint name="SanityCheck.2.6" index="42" slack="1"/>
  <constraint name="SanityCheck.2.7" index="43" slack="0"/>
 </linearConstraints>
 <variables>
  <variable name="LoadFunction" index="0" value="50"/>
  <variable name="f_1_0" index="1" value="0"/>
  <variable name="f_1_1" index="2" value="1"/>
  <variable name="f_1_2" index="3" value="0"/>
  <variable name="f_1_3" index="4" value="0"/>
  <variable name="f_1_4" index="5" value="0"/>
  <variable name="f_1_5" index="6" value="0"/>
  <variable name="f_1_6" index="7" value="0"/>
  <variable name="f_1_7" index="8" value="0"/>
  <variable name="f_2_0" index="9" value="0"/>
  <variable name="f_2_1" index="10" value="0"/>
  <variable name="f_2_2" index="11" value="0"/>
  <variable name="f_2_3" index="12" value="0"/>
  <variable name="f_2_4" index="13" value="0"/>
  <variable name="f_2_5" index="14" value="0"/>
  <variable name="f_2_6" index="15" value="0"/>
  <variable name="f_2_7" index="16" value="1"/>
  <variable name="Load.M3" index="17" value="50"/>
  <variable name="Load.M1" index="18" value="50"/>
  <variable name="Load.M7" index="19" value="50"/>
  <variable name="Load.M8" index="20" value="50"/>
  <variable name="Load.M2" index="21" value="50"/>
  <variable name="Load.M9" index="22" value="50"/>
  <variable name="a_2_6" index="23" value="1"/>
  <variable name="a_2_3" index="24" value="1"/>
  <variable name="a_2_4" index="25" value="1"/>
  <variable name="a_2_5" index="26" value="1"/>
  <variable name="a_2_1" index="27" value="1"/>
  <variable name="a_2_2" index="28" value="1"/>
  <variable name="a_2_7" index="29" value="1"/>
  <variable name="a_2_0" index="30" value="1"/>
  <variable name="a_1_7" index="31" value="1"/>
  <variable name="a_1_2" index="32" value="1"/>
  <variable name="a_1_0" index="33" value="1"/>
  <variable name="a_1_5" index="34" value="1"/>
  <variable name="a_1_1" index="35" value="1"/>
  <variable name="a_1_4" index="36" value="1"/>
  <variable name="a_1_6" index="37" value="1"/>
  <variable name="a_1_3" index="38" value="1"/>
 </variables>
</CPLEXSolution>
