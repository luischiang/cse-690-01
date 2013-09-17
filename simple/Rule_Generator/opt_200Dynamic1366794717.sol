<?xml version = "1.0" encoding="UTF-8" standalone="yes"?>
<CPLEXSolution version="1.2">
 <header
   problemName="200Dynamic1366794717.ilp"
   solutionName="incumbent"
   solutionIndex="-1"
   objectiveValue="25"
   solutionTypeValue="3"
   solutionTypeString="primal"
   solutionStatusValue="101"
   solutionStatusString="integer optimal solution"
   solutionMethodString="mip"
   primalFeasible="1"
   dualFeasible="1"
   MIPNodes="0"
   MIPIterations="4"
   writeLevel="1"/>
 <quality
   epInt="1e-05"
   epRHS="1e-06"
   maxIntInfeas="0"
   maxPrimalInfeas="0"
   maxX="25"
   maxSlack="192"/>
 <linearConstraints>
  <constraint name="Coverage.1" index="0" slack="0"/>
  <constraint name="ProcLoad.M3" index="1" slack="0"/>
  <constraint name="ProcLoad.M1" index="2" slack="0"/>
  <constraint name="ProcLoad.M7" index="3" slack="0"/>
  <constraint name="ProcLoad.M8" index="4" slack="0"/>
  <constraint name="ProcLoad.M2" index="5" slack="0"/>
  <constraint name="ProcLoad.M9" index="6" slack="0"/>
  <constraint name="ProcLoadBound.M3" index="7" slack="75"/>
  <constraint name="ProcLoadBound.M1" index="8" slack="75"/>
  <constraint name="ProcLoadBound.M7" index="9" slack="75"/>
  <constraint name="ProcLoadBound.M8" index="10" slack="75"/>
  <constraint name="ProcLoadBound.M2" index="11" slack="75"/>
  <constraint name="ProcLoadBound.M9" index="12" slack="75"/>
  <constraint name="MaxProcLoadBound.M3" index="13" slack="0"/>
  <constraint name="MaxProcLoadBound.M1" index="14" slack="0"/>
  <constraint name="MaxProcLoadBound.M7" index="15" slack="0"/>
  <constraint name="MaxProcLoadBound.M8" index="16" slack="0"/>
  <constraint name="MaxProcLoadBound.M2" index="17" slack="0"/>
  <constraint name="MaxProcLoadBound.M9" index="18" slack="0"/>
  <constraint name="RuleLoad.S6" index="19" slack="188"/>
  <constraint name="RuleLoad.S1" index="20" slack="184"/>
  <constraint name="RuleLoad.S9" index="21" slack="192"/>
  <constraint name="RuleLoad.S4" index="22" slack="190"/>
  <constraint name="RuleLoad.S8" index="23" slack="184"/>
  <constraint name="RuleLoad.S2" index="24" slack="190"/>
  <constraint name="RuleLoad.S5" index="25" slack="190"/>
  <constraint name="RuleLoad.S7" index="26" slack="192"/>
  <constraint name="RuleLoad.S3" index="27" slack="192"/>
  <constraint name="SanityCheck.1.0" index="28" slack="0.5"/>
  <constraint name="SanityCheck.1.1" index="29" slack="1"/>
  <constraint name="SanityCheck.1.2" index="30" slack="0.5"/>
  <constraint name="SanityCheck.1.3" index="31" slack="1"/>
  <constraint name="SanityCheck.1.4" index="32" slack="1"/>
  <constraint name="SanityCheck.1.5" index="33" slack="1"/>
  <constraint name="SanityCheck.1.6" index="34" slack="1"/>
  <constraint name="SanityCheck.1.7" index="35" slack="1"/>
 </linearConstraints>
 <variables>
  <variable name="LoadFunction" index="0" value="25"/>
  <variable name="f_1_0" index="1" value="0.5"/>
  <variable name="f_1_1" index="2" value="0"/>
  <variable name="f_1_2" index="3" value="0.5"/>
  <variable name="f_1_3" index="4" value="0"/>
  <variable name="f_1_4" index="5" value="0"/>
  <variable name="f_1_5" index="6" value="0"/>
  <variable name="f_1_6" index="7" value="0"/>
  <variable name="f_1_7" index="8" value="0"/>
  <variable name="Load.M3" index="9" value="25"/>
  <variable name="Load.M1" index="10" value="25"/>
  <variable name="Load.M7" index="11" value="25"/>
  <variable name="Load.M8" index="12" value="25"/>
  <variable name="Load.M2" index="13" value="25"/>
  <variable name="Load.M9" index="14" value="25"/>
  <variable name="a_1_5" index="15" value="1"/>
  <variable name="a_1_0" index="16" value="1"/>
  <variable name="a_1_7" index="17" value="1"/>
  <variable name="a_1_1" index="18" value="1"/>
  <variable name="a_1_4" index="19" value="1"/>
  <variable name="a_1_6" index="20" value="1"/>
  <variable name="a_1_3" index="21" value="1"/>
  <variable name="a_1_2" index="22" value="1"/>
 </variables>
</CPLEXSolution>
