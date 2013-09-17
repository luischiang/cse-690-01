<?xml version = "1.0" encoding="UTF-8" standalone="yes"?>
<CPLEXSolution version="1.2">
 <header
   problemName="tunnel_200Dynamic1366793707.ilp"
   solutionName="incumbent"
   solutionIndex="-1"
   objectiveValue="10"
   solutionTypeValue="3"
   solutionTypeString="primal"
   solutionStatusValue="101"
   solutionStatusString="integer optimal solution"
   solutionMethodString="mip"
   primalFeasible="1"
   dualFeasible="1"
   MIPNodes="0"
   MIPIterations="10"
   writeLevel="1"/>
 <quality
   epInt="1e-05"
   epRHS="1e-06"
   maxIntInfeas="0"
   maxPrimalInfeas="0"
   maxX="10"
   maxSlack="179"/>
 <linearConstraints>
  <constraint name="Coverage.1" index="0" slack="0"/>
  <constraint name="ProcLoad.M5" index="1" slack="0"/>
  <constraint name="ProcLoad.M12" index="2" slack="0"/>
  <constraint name="ProcLoad.M10" index="3" slack="0"/>
  <constraint name="ProcLoad.M4" index="4" slack="0"/>
  <constraint name="ProcLoad.M11" index="5" slack="0"/>
  <constraint name="ProcLoad.M1" index="6" slack="0"/>
  <constraint name="ProcLoad.M8" index="7" slack="0"/>
  <constraint name="ProcLoad.M7" index="8" slack="0"/>
  <constraint name="ProcLoad.M2" index="9" slack="0"/>
  <constraint name="ProcLoad.M9" index="10" slack="0"/>
  <constraint name="ProcLoad.M6" index="11" slack="0"/>
  <constraint name="ProcLoadBound.M5" index="12" slack="90"/>
  <constraint name="ProcLoadBound.M12" index="13" slack="90"/>
  <constraint name="ProcLoadBound.M10" index="14" slack="90"/>
  <constraint name="ProcLoadBound.M4" index="15" slack="90"/>
  <constraint name="ProcLoadBound.M11" index="16" slack="90"/>
  <constraint name="ProcLoadBound.M1" index="17" slack="90"/>
  <constraint name="ProcLoadBound.M8" index="18" slack="90"/>
  <constraint name="ProcLoadBound.M7" index="19" slack="90"/>
  <constraint name="ProcLoadBound.M2" index="20" slack="90"/>
  <constraint name="ProcLoadBound.M9" index="21" slack="90"/>
  <constraint name="ProcLoadBound.M6" index="22" slack="100"/>
  <constraint name="MaxProcLoadBound.M5" index="23" slack="0"/>
  <constraint name="MaxProcLoadBound.M12" index="24" slack="0"/>
  <constraint name="MaxProcLoadBound.M10" index="25" slack="0"/>
  <constraint name="MaxProcLoadBound.M4" index="26" slack="0"/>
  <constraint name="MaxProcLoadBound.M11" index="27" slack="0"/>
  <constraint name="MaxProcLoadBound.M1" index="28" slack="0"/>
  <constraint name="MaxProcLoadBound.M8" index="29" slack="0"/>
  <constraint name="MaxProcLoadBound.M7" index="30" slack="0"/>
  <constraint name="MaxProcLoadBound.M2" index="31" slack="0"/>
  <constraint name="MaxProcLoadBound.M9" index="32" slack="0"/>
  <constraint name="MaxProcLoadBound.M6" index="33" slack="10"/>
  <constraint name="RuleLoad.S6" index="34" slack="179"/>
  <constraint name="RuleLoad.S1" index="35" slack="147"/>
  <constraint name="RuleLoad.S11" index="36" slack="177"/>
  <constraint name="RuleLoad.S10" index="37" slack="179"/>
  <constraint name="RuleLoad.S9" index="38" slack="168"/>
  <constraint name="RuleLoad.S4" index="39" slack="179"/>
  <constraint name="RuleLoad.S8" index="40" slack="179"/>
  <constraint name="RuleLoad.S2" index="41" slack="179"/>
  <constraint name="RuleLoad.S5" index="42" slack="153"/>
  <constraint name="RuleLoad.S7" index="43" slack="177"/>
  <constraint name="SanityCheck.1.0" index="44" slack="1"/>
  <constraint name="SanityCheck.1.1" index="45" slack="0.8"/>
  <constraint name="SanityCheck.1.2" index="46" slack="1"/>
  <constraint name="SanityCheck.1.3" index="47" slack="0.8"/>
  <constraint name="SanityCheck.1.4" index="48" slack="0.8"/>
  <constraint name="SanityCheck.1.5" index="49" slack="0.8"/>
  <constraint name="SanityCheck.1.6" index="50" slack="1"/>
  <constraint name="SanityCheck.1.7" index="51" slack="1"/>
  <constraint name="SanityCheck.1.8" index="52" slack="1"/>
  <constraint name="SanityCheck.1.9" index="53" slack="1"/>
  <constraint name="SanityCheck.1.10" index="54" slack="1"/>
  <constraint name="SanityCheck.1.11" index="55" slack="1"/>
  <constraint name="SanityCheck.1.12" index="56" slack="0.8"/>
  <constraint name="SanityCheck.1.13" index="57" slack="1"/>
  <constraint name="SanityCheck.1.14" index="58" slack="1"/>
  <constraint name="SanityCheck.1.15" index="59" slack="1"/>
  <constraint name="SanityCheck.1.16" index="60" slack="1"/>
  <constraint name="SanityCheck.1.17" index="61" slack="1"/>
  <constraint name="SanityCheck.1.18" index="62" slack="1"/>
  <constraint name="SanityCheck.1.19" index="63" slack="1"/>
  <constraint name="SanityCheck.1.20" index="64" slack="1"/>
  <constraint name="SanityCheck.1.21" index="65" slack="1"/>
  <constraint name="SanityCheck.1.22" index="66" slack="1"/>
  <constraint name="SanityCheck.1.23" index="67" slack="1"/>
  <constraint name="SanityCheck.1.24" index="68" slack="1"/>
  <constraint name="SanityCheck.1.25" index="69" slack="1"/>
  <constraint name="SanityCheck.1.26" index="70" slack="1"/>
  <constraint name="SanityCheck.1.27" index="71" slack="1"/>
  <constraint name="SanityCheck.1.28" index="72" slack="1"/>
  <constraint name="SanityCheck.1.29" index="73" slack="1"/>
 </linearConstraints>
 <variables>
  <variable name="LoadFunction" index="0" value="10"/>
  <variable name="f_1_0" index="1" value="0"/>
  <variable name="f_1_1" index="2" value="0.2"/>
  <variable name="f_1_2" index="3" value="0"/>
  <variable name="f_1_3" index="4" value="0.2"/>
  <variable name="f_1_4" index="5" value="0.2"/>
  <variable name="f_1_5" index="6" value="0.2"/>
  <variable name="f_1_6" index="7" value="0"/>
  <variable name="f_1_7" index="8" value="0"/>
  <variable name="f_1_8" index="9" value="0"/>
  <variable name="f_1_9" index="10" value="0"/>
  <variable name="f_1_10" index="11" value="0"/>
  <variable name="f_1_11" index="12" value="0"/>
  <variable name="f_1_12" index="13" value="0.2"/>
  <variable name="f_1_13" index="14" value="0"/>
  <variable name="f_1_14" index="15" value="0"/>
  <variable name="f_1_15" index="16" value="0"/>
  <variable name="f_1_16" index="17" value="0"/>
  <variable name="f_1_17" index="18" value="0"/>
  <variable name="f_1_18" index="19" value="0"/>
  <variable name="f_1_19" index="20" value="0"/>
  <variable name="f_1_20" index="21" value="0"/>
  <variable name="f_1_21" index="22" value="0"/>
  <variable name="f_1_22" index="23" value="0"/>
  <variable name="f_1_23" index="24" value="0"/>
  <variable name="f_1_24" index="25" value="0"/>
  <variable name="f_1_25" index="26" value="0"/>
  <variable name="f_1_26" index="27" value="0"/>
  <variable name="f_1_27" index="28" value="0"/>
  <variable name="f_1_28" index="29" value="0"/>
  <variable name="f_1_29" index="30" value="0"/>
  <variable name="Load.M5" index="31" value="10"/>
  <variable name="Load.M12" index="32" value="10"/>
  <variable name="Load.M10" index="33" value="10"/>
  <variable name="Load.M4" index="34" value="10"/>
  <variable name="Load.M11" index="35" value="10"/>
  <variable name="Load.M1" index="36" value="10"/>
  <variable name="Load.M8" index="37" value="10"/>
  <variable name="Load.M7" index="38" value="10"/>
  <variable name="Load.M2" index="39" value="10"/>
  <variable name="Load.M9" index="40" value="10"/>
  <variable name="Load.M6" index="41" value="0"/>
  <variable name="a_1_19" index="42" value="1"/>
  <variable name="a_1_7" index="43" value="1"/>
  <variable name="a_1_15" index="44" value="1"/>
  <variable name="a_1_26" index="45" value="1"/>
  <variable name="a_1_2" index="46" value="1"/>
  <variable name="a_1_22" index="47" value="1"/>
  <variable name="a_1_8" index="48" value="1"/>
  <variable name="a_1_12" index="49" value="1"/>
  <variable name="a_1_0" index="50" value="1"/>
  <variable name="a_1_21" index="51" value="1"/>
  <variable name="a_1_10" index="52" value="1"/>
  <variable name="a_1_23" index="53" value="1"/>
  <variable name="a_1_9" index="54" value="1"/>
  <variable name="a_1_11" index="55" value="1"/>
  <variable name="a_1_18" index="56" value="1"/>
  <variable name="a_1_25" index="57" value="1"/>
  <variable name="a_1_13" index="58" value="1"/>
  <variable name="a_1_20" index="59" value="1"/>
  <variable name="a_1_29" index="60" value="1"/>
  <variable name="a_1_24" index="61" value="1"/>
  <variable name="a_1_5" index="62" value="1"/>
  <variable name="a_1_16" index="63" value="1"/>
  <variable name="a_1_1" index="64" value="1"/>
  <variable name="a_1_28" index="65" value="1"/>
  <variable name="a_1_4" index="66" value="1"/>
  <variable name="a_1_27" index="67" value="1"/>
  <variable name="a_1_6" index="68" value="1"/>
  <variable name="a_1_17" index="69" value="1"/>
  <variable name="a_1_14" index="70" value="1"/>
  <variable name="a_1_3" index="71" value="1"/>
 </variables>
</CPLEXSolution>
