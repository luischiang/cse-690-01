<?xml version = "1.0" encoding="UTF-8" standalone="yes"?>
<CPLEXSolution version="1.2">
 <header
   problemName="tunnel_200Dynamic1366792887.ilp"
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
   MIPIterations="19"
   writeLevel="1"/>
 <quality
   epInt="1e-05"
   epRHS="1e-06"
   maxIntInfeas="0"
   maxPrimalInfeas="0"
   maxX="100"
   maxSlack="169"/>
 <linearConstraints>
  <constraint name="Coverage.1" index="0" slack="0"/>
  <constraint name="Coverage.2" index="1" slack="0"/>
  <constraint name="ProcLoad.M3" index="2" slack="0"/>
  <constraint name="ProcLoad.M5" index="3" slack="0"/>
  <constraint name="ProcLoad.M12" index="4" slack="0"/>
  <constraint name="ProcLoad.M10" index="5" slack="0"/>
  <constraint name="ProcLoad.M4" index="6" slack="0"/>
  <constraint name="ProcLoad.M11" index="7" slack="0"/>
  <constraint name="ProcLoad.M1" index="8" slack="0"/>
  <constraint name="ProcLoad.M8" index="9" slack="0"/>
  <constraint name="ProcLoad.M7" index="10" slack="0"/>
  <constraint name="ProcLoad.M2" index="11" slack="0"/>
  <constraint name="ProcLoad.M9" index="12" slack="0"/>
  <constraint name="ProcLoad.M6" index="13" slack="0"/>
  <constraint name="ProcLoadBound.M3" index="14" slack="0"/>
  <constraint name="ProcLoadBound.M5" index="15" slack="100"/>
  <constraint name="ProcLoadBound.M12" index="16" slack="100"/>
  <constraint name="ProcLoadBound.M10" index="17" slack="100"/>
  <constraint name="ProcLoadBound.M4" index="18" slack="50"/>
  <constraint name="ProcLoadBound.M11" index="19" slack="50"/>
  <constraint name="ProcLoadBound.M1" index="20" slack="100"/>
  <constraint name="ProcLoadBound.M8" index="21" slack="50"/>
  <constraint name="ProcLoadBound.M7" index="22" slack="50"/>
  <constraint name="ProcLoadBound.M2" index="23" slack="100"/>
  <constraint name="ProcLoadBound.M9" index="24" slack="0"/>
  <constraint name="ProcLoadBound.M6" index="25" slack="0"/>
  <constraint name="MaxProcLoadBound.M3" index="26" slack="0"/>
  <constraint name="MaxProcLoadBound.M5" index="27" slack="100"/>
  <constraint name="MaxProcLoadBound.M12" index="28" slack="100"/>
  <constraint name="MaxProcLoadBound.M10" index="29" slack="100"/>
  <constraint name="MaxProcLoadBound.M4" index="30" slack="50"/>
  <constraint name="MaxProcLoadBound.M11" index="31" slack="50"/>
  <constraint name="MaxProcLoadBound.M1" index="32" slack="100"/>
  <constraint name="MaxProcLoadBound.M8" index="33" slack="50"/>
  <constraint name="MaxProcLoadBound.M7" index="34" slack="50"/>
  <constraint name="MaxProcLoadBound.M2" index="35" slack="100"/>
  <constraint name="MaxProcLoadBound.M9" index="36" slack="0"/>
  <constraint name="MaxProcLoadBound.M6" index="37" slack="0"/>
  <constraint name="RuleLoad.S6" index="38" slack="169"/>
  <constraint name="RuleLoad.S1" index="39" slack="135"/>
  <constraint name="RuleLoad.S11" index="40" slack="165"/>
  <constraint name="RuleLoad.S10" index="41" slack="169"/>
  <constraint name="RuleLoad.S9" index="42" slack="147"/>
  <constraint name="RuleLoad.S4" index="43" slack="139"/>
  <constraint name="RuleLoad.S8" index="44" slack="169"/>
  <constraint name="RuleLoad.S2" index="45" slack="139"/>
  <constraint name="RuleLoad.S5" index="46" slack="165"/>
  <constraint name="RuleLoad.S7" index="47" slack="165"/>
  <constraint name="RuleLoad.S3" index="48" slack="99"/>
  <constraint name="SanityCheck.1.0" index="49" slack="1"/>
  <constraint name="SanityCheck.1.1" index="50" slack="1"/>
  <constraint name="SanityCheck.1.2" index="51" slack="1"/>
  <constraint name="SanityCheck.1.3" index="52" slack="1"/>
  <constraint name="SanityCheck.1.4" index="53" slack="1"/>
  <constraint name="SanityCheck.1.5" index="54" slack="1"/>
  <constraint name="SanityCheck.1.6" index="55" slack="1"/>
  <constraint name="SanityCheck.1.7" index="56" slack="1"/>
  <constraint name="SanityCheck.1.8" index="57" slack="0.5"/>
  <constraint name="SanityCheck.1.9" index="58" slack="1"/>
  <constraint name="SanityCheck.1.10" index="59" slack="1"/>
  <constraint name="SanityCheck.1.11" index="60" slack="1"/>
  <constraint name="SanityCheck.1.12" index="61" slack="1"/>
  <constraint name="SanityCheck.1.13" index="62" slack="1"/>
  <constraint name="SanityCheck.1.14" index="63" slack="1"/>
  <constraint name="SanityCheck.1.15" index="64" slack="0.5"/>
  <constraint name="SanityCheck.1.16" index="65" slack="1"/>
  <constraint name="SanityCheck.1.17" index="66" slack="1"/>
  <constraint name="SanityCheck.1.18" index="67" slack="1"/>
  <constraint name="SanityCheck.1.19" index="68" slack="1"/>
  <constraint name="SanityCheck.1.20" index="69" slack="1"/>
  <constraint name="SanityCheck.1.21" index="70" slack="1"/>
  <constraint name="SanityCheck.1.22" index="71" slack="1"/>
  <constraint name="SanityCheck.1.23" index="72" slack="1"/>
  <constraint name="SanityCheck.1.24" index="73" slack="1"/>
  <constraint name="SanityCheck.1.25" index="74" slack="1"/>
  <constraint name="SanityCheck.1.26" index="75" slack="1"/>
  <constraint name="SanityCheck.1.27" index="76" slack="1"/>
  <constraint name="SanityCheck.1.28" index="77" slack="1"/>
  <constraint name="SanityCheck.1.29" index="78" slack="1"/>
  <constraint name="SanityCheck.2.0" index="79" slack="1"/>
  <constraint name="SanityCheck.2.1" index="80" slack="1"/>
  <constraint name="SanityCheck.2.2" index="81" slack="1"/>
  <constraint name="SanityCheck.2.3" index="82" slack="0.5"/>
  <constraint name="SanityCheck.2.4" index="83" slack="1"/>
  <constraint name="SanityCheck.2.5" index="84" slack="1"/>
  <constraint name="SanityCheck.2.6" index="85" slack="1"/>
  <constraint name="SanityCheck.2.7" index="86" slack="1"/>
  <constraint name="SanityCheck.2.8" index="87" slack="1"/>
  <constraint name="SanityCheck.2.9" index="88" slack="1"/>
  <constraint name="SanityCheck.2.10" index="89" slack="1"/>
  <constraint name="SanityCheck.2.11" index="90" slack="1"/>
  <constraint name="SanityCheck.2.12" index="91" slack="1"/>
  <constraint name="SanityCheck.2.13" index="92" slack="1"/>
  <constraint name="SanityCheck.2.14" index="93" slack="1"/>
  <constraint name="SanityCheck.2.15" index="94" slack="1"/>
  <constraint name="SanityCheck.2.16" index="95" slack="1"/>
  <constraint name="SanityCheck.2.17" index="96" slack="1"/>
  <constraint name="SanityCheck.2.18" index="97" slack="1"/>
  <constraint name="SanityCheck.2.19" index="98" slack="1"/>
  <constraint name="SanityCheck.2.20" index="99" slack="1"/>
  <constraint name="SanityCheck.2.21" index="100" slack="1"/>
  <constraint name="SanityCheck.2.22" index="101" slack="1"/>
  <constraint name="SanityCheck.2.23" index="102" slack="1"/>
  <constraint name="SanityCheck.2.24" index="103" slack="1"/>
  <constraint name="SanityCheck.2.25" index="104" slack="1"/>
  <constraint name="SanityCheck.2.26" index="105" slack="1"/>
  <constraint name="SanityCheck.2.27" index="106" slack="1"/>
  <constraint name="SanityCheck.2.28" index="107" slack="1"/>
  <constraint name="SanityCheck.2.29" index="108" slack="0.5"/>
 </linearConstraints>
 <variables>
  <variable name="LoadFunction" index="0" value="100"/>
  <variable name="f_1_0" index="1" value="0"/>
  <variable name="f_1_1" index="2" value="0"/>
  <variable name="f_1_2" index="3" value="0"/>
  <variable name="f_1_3" index="4" value="0"/>
  <variable name="f_1_4" index="5" value="0"/>
  <variable name="f_1_5" index="6" value="0"/>
  <variable name="f_1_6" index="7" value="0"/>
  <variable name="f_1_7" index="8" value="0"/>
  <variable name="f_1_8" index="9" value="0.5"/>
  <variable name="f_1_9" index="10" value="0"/>
  <variable name="f_1_10" index="11" value="0"/>
  <variable name="f_1_11" index="12" value="0"/>
  <variable name="f_1_12" index="13" value="0"/>
  <variable name="f_1_13" index="14" value="0"/>
  <variable name="f_1_14" index="15" value="0"/>
  <variable name="f_1_15" index="16" value="0.5"/>
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
  <variable name="f_2_0" index="31" value="0"/>
  <variable name="f_2_1" index="32" value="0"/>
  <variable name="f_2_2" index="33" value="0"/>
  <variable name="f_2_3" index="34" value="0.5"/>
  <variable name="f_2_4" index="35" value="0"/>
  <variable name="f_2_5" index="36" value="0"/>
  <variable name="f_2_6" index="37" value="0"/>
  <variable name="f_2_7" index="38" value="0"/>
  <variable name="f_2_8" index="39" value="0"/>
  <variable name="f_2_9" index="40" value="0"/>
  <variable name="f_2_10" index="41" value="0"/>
  <variable name="f_2_11" index="42" value="0"/>
  <variable name="f_2_12" index="43" value="0"/>
  <variable name="f_2_13" index="44" value="0"/>
  <variable name="f_2_14" index="45" value="0"/>
  <variable name="f_2_15" index="46" value="0"/>
  <variable name="f_2_16" index="47" value="0"/>
  <variable name="f_2_17" index="48" value="0"/>
  <variable name="f_2_18" index="49" value="0"/>
  <variable name="f_2_19" index="50" value="0"/>
  <variable name="f_2_20" index="51" value="0"/>
  <variable name="f_2_21" index="52" value="0"/>
  <variable name="f_2_22" index="53" value="0"/>
  <variable name="f_2_23" index="54" value="0"/>
  <variable name="f_2_24" index="55" value="0"/>
  <variable name="f_2_25" index="56" value="0"/>
  <variable name="f_2_26" index="57" value="0"/>
  <variable name="f_2_27" index="58" value="0"/>
  <variable name="f_2_28" index="59" value="0"/>
  <variable name="f_2_29" index="60" value="0.5"/>
  <variable name="Load.M3" index="61" value="100"/>
  <variable name="Load.M5" index="62" value="0"/>
  <variable name="Load.M12" index="63" value="0"/>
  <variable name="Load.M10" index="64" value="0"/>
  <variable name="Load.M4" index="65" value="50"/>
  <variable name="Load.M11" index="66" value="50"/>
  <variable name="Load.M1" index="67" value="0"/>
  <variable name="Load.M8" index="68" value="50"/>
  <variable name="Load.M7" index="69" value="50"/>
  <variable name="Load.M2" index="70" value="0"/>
  <variable name="Load.M9" index="71" value="100"/>
  <variable name="Load.M6" index="72" value="100"/>
  <variable name="a_1_19" index="73" value="1"/>
  <variable name="a_1_7" index="74" value="1"/>
  <variable name="a_2_14" index="75" value="1"/>
  <variable name="a_2_3" index="76" value="1"/>
  <variable name="a_2_13" index="77" value="1"/>
  <variable name="a_1_26" index="78" value="1"/>
  <variable name="a_1_2" index="79" value="1"/>
  <variable name="a_1_15" index="80" value="1"/>
  <variable name="a_2_17" index="81" value="1"/>
  <variable name="a_2_0" index="82" value="1"/>
  <variable name="a_1_22" index="83" value="1"/>
  <variable name="a_2_6" index="84" value="1"/>
  <variable name="a_2_19" index="85" value="1"/>
  <variable name="a_1_12" index="86" value="1"/>
  <variable name="a_1_0" index="87" value="1"/>
  <variable name="a_1_21" index="88" value="1"/>
  <variable name="a_1_10" index="89" value="1"/>
  <variable name="a_1_23" index="90" value="1"/>
  <variable name="a_1_18" index="91" value="1"/>
  <variable name="a_1_20" index="92" value="1"/>
  <variable name="a_1_5" index="93" value="1"/>
  <variable name="a_1_27" index="94" value="1"/>
  <variable name="a_2_2" index="95" value="1"/>
  <variable name="a_1_6" index="96" value="1"/>
  <variable name="a_1_17" index="97" value="1"/>
  <variable name="a_1_8" index="98" value="1"/>
  <variable name="a_1_9" index="99" value="1"/>
  <variable name="a_1_11" index="100" value="1"/>
  <variable name="a_1_13" index="101" value="1"/>
  <variable name="a_1_25" index="102" value="1"/>
  <variable name="a_1_24" index="103" value="1"/>
  <variable name="a_1_29" index="104" value="1"/>
  <variable name="a_1_1" index="105" value="1"/>
  <variable name="a_1_16" index="106" value="1"/>
  <variable name="a_2_26" index="107" value="1"/>
  <variable name="a_1_4" index="108" value="1"/>
  <variable name="a_1_28" index="109" value="1"/>
  <variable name="a_2_25" index="110" value="1"/>
  <variable name="a_1_14" index="111" value="1"/>
  <variable name="a_1_3" index="112" value="1"/>
  <variable name="a_2_12" index="113" value="1"/>
  <variable name="a_2_15" index="114" value="1"/>
  <variable name="a_2_10" index="115" value="1"/>
  <variable name="a_2_9" index="116" value="1"/>
  <variable name="a_2_7" index="117" value="1"/>
  <variable name="a_2_8" index="118" value="1"/>
  <variable name="a_2_1" index="119" value="1"/>
  <variable name="a_2_20" index="120" value="1"/>
  <variable name="a_2_21" index="121" value="1"/>
  <variable name="a_2_29" index="122" value="1"/>
  <variable name="a_2_4" index="123" value="1"/>
  <variable name="a_2_5" index="124" value="1"/>
  <variable name="a_2_11" index="125" value="1"/>
  <variable name="a_2_23" index="126" value="1"/>
  <variable name="a_2_24" index="127" value="1"/>
  <variable name="a_2_18" index="128" value="1"/>
  <variable name="a_2_28" index="129" value="1"/>
  <variable name="a_2_16" index="130" value="1"/>
  <variable name="a_2_27" index="131" value="1"/>
  <variable name="a_2_22" index="132" value="1"/>
 </variables>
</CPLEXSolution>
