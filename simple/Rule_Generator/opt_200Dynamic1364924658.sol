<?xml version = "1.0" encoding="UTF-8" standalone="yes"?>
<CPLEXSolution version="1.2">
 <header
   problemName="200Dynamic1364924658.ilp"
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
   maxSlack="196"/>
 <linearConstraints>
  <constraint name="Coverage.1" index="0" slack="0"/>
  <constraint name="ProcLoad.M3" index="1" slack="0"/>
  <constraint name="ProcLoad.M1" index="2" slack="0"/>
  <constraint name="ProcLoad.M2" index="3" slack="0"/>
  <constraint name="ProcLoad.M4" index="4" slack="0"/>
  <constraint name="ProcLoadBound.M3" index="5" slack="50"/>
  <constraint name="ProcLoadBound.M1" index="6" slack="50"/>
  <constraint name="ProcLoadBound.M2" index="7" slack="50"/>
  <constraint name="ProcLoadBound.M4" index="8" slack="50"/>
  <constraint name="MaxProcLoadBound.M3" index="9" slack="0"/>
  <constraint name="MaxProcLoadBound.M1" index="10" slack="0"/>
  <constraint name="MaxProcLoadBound.M2" index="11" slack="0"/>
  <constraint name="MaxProcLoadBound.M4" index="12" slack="0"/>
  <constraint name="RuleLoad.S1" index="13" slack="196"/>
  <constraint name="RuleLoad.S2" index="14" slack="193"/>
  <constraint name="RuleLoad.S5" index="15" slack="196"/>
  <constraint name="RuleLoad.S4" index="16" slack="191"/>
  <constraint name="RuleLoad.S3" index="17" slack="194"/>
  <constraint name="SanityCheck.1.0" index="18" slack="0.5"/>
  <constraint name="SanityCheck.1.1" index="19" slack="1"/>
  <constraint name="SanityCheck.1.2" index="20" slack="0.5"/>
  <constraint name="SanityCheck.1.3" index="21" slack="1"/>
 </linearConstraints>
 <variables>
  <variable name="LoadFunction" index="0" value="50"/>
  <variable name="f_1_0" index="1" value="0.5"/>
  <variable name="f_1_1" index="2" value="0"/>
  <variable name="f_1_2" index="3" value="0.5"/>
  <variable name="f_1_3" index="4" value="0"/>
  <variable name="Load.M3" index="5" value="50"/>
  <variable name="Load.M1" index="6" value="50"/>
  <variable name="Load.M2" index="7" value="50"/>
  <variable name="Load.M4" index="8" value="50"/>
  <variable name="a_1_0" index="9" value="1"/>
  <variable name="a_1_1" index="10" value="1"/>
  <variable name="a_1_3" index="11" value="1"/>
  <variable name="a_1_2" index="12" value="1"/>
 </variables>
</CPLEXSolution>
