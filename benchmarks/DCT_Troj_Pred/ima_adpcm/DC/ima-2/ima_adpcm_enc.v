/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Thu Jul 29 10:50:13 2021
/////////////////////////////////////////////////////////////
`timescale 1ps / 1ps

module ima_adpcm_enc ( clock, reset, inSamp, inValid, inReady, outPCM, 
        outValid, outPredictSamp, outStepIndex );
  input [15:0] inSamp;
  output [3:0] outPCM;
  output [15:0] outPredictSamp;
  output [6:0] outStepIndex;
  input clock, reset, inValid;
  output inReady, outValid;
  wire   N176, trojan_ena, N430, \C42/DATA2_0 , \C42/DATA2_2 , \C42/DATA2_3 ,
         \C42/DATA2_4 , \C42/DATA2_5 , \C42/DATA2_6 , \C42/DATA2_7 ,
         \C42/DATA2_8 , \C42/DATA2_9 , \C42/DATA2_10 , \C42/DATA2_11 ,
         \C42/DATA2_12 , \C42/DATA2_13 , \C42/DATA2_14 , \C42/DATA2_15 ,
         \C42/DATA2_16 , \C42/DATA2_17 , n523, n524, n525, n526, n527, n528,
         n529, n530, n531, n532, n533, n534, n535, n536, n537, n538, n539,
         n540, n541, n542, n543, n544, n545, n546, n547, n548, n549, n550,
         n551, n552, n553, n554, n555, n556, n557, n558, n559, n560, n561,
         n562, n563, n564, n565, n566, n567, n568, n569, n570, n571, n572,
         n573, n574, n575, n576, n577, n578, n579, n580, n581, n582, n583,
         n584, n585, n586, n587, n588, n589, n590, n591, n592, n593, n594,
         n595, n596, n597, n598, n599, n600, n601, n602, n607, n608, n609,
         n610, n611, n612, n613, n614, n615, n616, n617, n618, n619, n620,
         n621, \C1/Z_17 , \C1/Z_16 , \C1/Z_15 , \C1/Z_14 , \C1/Z_13 ,
         \C1/Z_12 , \C1/Z_11 , \C1/Z_10 , \C1/Z_9 , \C1/Z_8 , \C1/Z_7 ,
         \C1/Z_6 , \C1/Z_5 , \C1/Z_4 , \C1/Z_3 , \C1/Z_2 ,
         \DP_OP_36J1_122_4812/n43 , \DP_OP_36J1_122_4812/n42 ,
         \DP_OP_36J1_122_4812/n41 , \DP_OP_36J1_122_4812/n40 ,
         \DP_OP_36J1_122_4812/n39 , \DP_OP_36J1_122_4812/n38 ,
         \DP_OP_36J1_122_4812/n37 , \DP_OP_36J1_122_4812/n36 ,
         \DP_OP_36J1_122_4812/n35 , \DP_OP_36J1_122_4812/n34 ,
         \DP_OP_36J1_122_4812/n33 , \DP_OP_36J1_122_4812/n32 ,
         \DP_OP_36J1_122_4812/n31 , \DP_OP_36J1_122_4812/n30 ,
         \DP_OP_36J1_122_4812/n29 , \DP_OP_36J1_122_4812/n28 ,
         \DP_OP_36J1_122_4812/n27 , \DP_OP_36J1_122_4812/n26 ,
         \DP_OP_36J1_122_4812/n25 , \DP_OP_36J1_122_4812/n20 ,
         \DP_OP_36J1_122_4812/n19 , \DP_OP_36J1_122_4812/n18 ,
         \DP_OP_36J1_122_4812/n17 , \DP_OP_36J1_122_4812/n16 ,
         \DP_OP_36J1_122_4812/n15 , \DP_OP_36J1_122_4812/n14 ,
         \DP_OP_36J1_122_4812/n13 , \DP_OP_36J1_122_4812/n12 ,
         \DP_OP_36J1_122_4812/n11 , \DP_OP_36J1_122_4812/n10 ,
         \DP_OP_36J1_122_4812/n9 , \DP_OP_36J1_122_4812/n8 ,
         \DP_OP_36J1_122_4812/n7 , \DP_OP_36J1_122_4812/n6 ,
         \DP_OP_36J1_122_4812/n5 , \DP_OP_36J1_122_4812/n4 ,
         \DP_OP_36J1_122_4812/n3 , \DP_OP_36J1_122_4812/n2 ,
         \DP_OP_73J1_125_3932/n16 , \DP_OP_73J1_125_3932/n15 ,
         \DP_OP_73J1_125_3932/n14 , \DP_OP_73J1_125_3932/n13 ,
         \DP_OP_73J1_125_3932/n12 , \DP_OP_73J1_125_3932/n11 ,
         \DP_OP_73J1_125_3932/n10 , \DP_OP_73J1_125_3932/n9 ,
         \DP_OP_73J1_125_3932/n8 , \DP_OP_73J1_125_3932/n7 ,
         \DP_OP_73J1_125_3932/n6 , \DP_OP_73J1_125_3932/n5 ,
         \DP_OP_73J1_125_3932/n4 , \DP_OP_73J1_125_3932/n3 ,
         \DP_OP_73J1_125_3932/n2 , \DP_OP_73J1_125_3932/n1 , n623, n624, n625,
         n626, n627, n628, n629, n630, n631, n632, n633, n634, n635, n636,
         n637, n638, n639, n640, n641, n642, n643, n644, n645, n646, n647,
         n648, n649, n650, n651, n652, n653, n654, n655, n656, n657, n658,
         n659, n660, n661, n662, n663, n664, n665, n666, n667, n668, n669,
         n670, n671, n672, n673, n674, n675, n676, n677, n678, n679, n680,
         n681, n682, n683, n684, n685, n686, n687, n688, n689, n690, n691,
         n692, n693, n694, n695, n696, n697, n698, n699, n700, n701, n702,
         n703, n704, n705, n706, n707, n708, n709, n710, n711, n712, n713,
         n714, n715, n716, n717, n718, n719, n720, n721, n722, n723, n724,
         n725, n726, n727, n728, n729, n730, n731, n732, n733, n734, n735,
         n736, n737, n738, n739, n740, n741, n742, n743, n744, n745, n746,
         n747, n748, n749, n750, n751, n752, n753, n754, n755, n756, n757,
         n758, n759, n760, n761, n762, n763, n764, n765, n766, n767, n768,
         n769, n770, n771, n772, n773, n774, n775, n776, n777, n778, n779,
         n780, n781, n782, n783, n784, n785, n786, n787, n788, n789, n790,
         n791, n792, n793, n794, n795, n796, n797, n798, n799, n800, n801,
         n802, n803, n804, n805, n806, n807, n808, n809, n810, n811, n812,
         n813, n814, n815, n816, n817, n818, n819, n820, n821, n822, n823,
         n824, n825, n826, n827, n828, n829, n830, n831, n832, n833, n834,
         n835, n836, n837, n838, n839, n840, n841, n842, n843, n844, n845,
         n846, n847, n848, n849, n850, n851, n852, n853, n854, n855, n856,
         n857, n858, n859, n860, n861, n862, n863, n864, n865, n866, n867,
         n868, n869, n870, n871, n872, n873, n874, n875, n876, n877, n878,
         n879, n880, n881, n882, n883, n884, n885, n886, n887, n888, n889,
         n890, n891, n892, n893, n894, n895, n896, n897, n898, n899, n900,
         n901, n902, n903, n904, n905, n906, n907, n908, n909, n910, n911,
         n912, n913, n914, n915, n916, n917, n918, n919, n920, n921, n922,
         n923, n924, n925, n926, n927, n928, n929, n930, n931, n932, n933,
         n934, n935, n936, n937, n938, n939, n940, n941, n942, n943, n944,
         n945, n946, n947, n948, n949, n950, n951, n952, n953, n954, n955,
         n956, n957, n958, n959, n960, n961, n962, n963, n964, n965, n966,
         n967, n968, n969, n970, n971, n972, n973, n974, n975, n976, n977,
         n978, n979, n980, n981, n982, n983, n984, n985, n986, n987, n988,
         n989, n990, n991, n992, n993, n994, n995, n996, n997, n998, n999,
         n1000, n1001, n1002, n1003, n1004, n1005, n1006, n1007, n1008, n1009,
         n1010, n1011, n1012, n1013, n1014, n1015, n1016, n1017, n1018, n1019,
         n1020, n1021, n1022, n1023, n1024, n1025, n1026, n1027, n1028, n1029,
         n1030, n1031, n1032, n1033, n1034, n1035, n1036, n1037, n1038, n1039,
         n1040, n1041, n1042, n1043, n1044, n1045, n1046, n1047, n1048, n1049,
         n1050, n1051, n1052, n1053, n1054, n1055, n1056, n1057, n1058, n1059,
         n1060, n1061, n1062, n1063, n1064, n1065, n1066, n1067, n1068, n1069,
         n1070, n1071, n1072, n1073, n1074, n1075, n1076, n1077, n1078, n1079,
         n1080, n1081, n1082, n1083, n1084, n1085, n1086, n1087, n1088, n1089,
         n1090, n1091, n1092, n1093, n1094, n1095, n1096, n1097, n1098, n1099,
         n1100, n1101, n1102, n1103, n1104, n1105, n1106, n1107, n1108, n1109,
         n1110, n1111, n1112, n1113, n1114, n1115, n1116, n1117, n1118, n1119,
         n1120, n1121, n1122, n1123, n1124, n1125, n1126, n1127, n1128, n1129,
         n1130, n1131, n1132, n1133, n1134, n1135, n1136, n1137, n1138, n1139,
         n1140, n1141, n1142, n1143, n1144, n1145, n1146, n1147, n1148, n1149,
         n1150, n1151, n1152, n1153, n1154, n1155, n1156, n1157, n1158, n1159,
         n1160, n1161, n1162, n1163, n1164, n1165, n1166, n1167, n1168, n1169,
         n1170, n1171, n1172, n1173, n1174, n1175, n1176, n1177, n1178, n1179,
         n1180, n1181, n1182, n1183, n1184, n1185, n1186, n1187, n1188, n1189,
         n1190, n1191, n1192, n1193, n1194, n1195, n1196, n1197, n1198, n1199,
         n1200, n1201, n1202, n1203, n1204, n1205, n1206, n1207, n1208, n1209,
         n1210, n1211, n1212, n1213, n1214, n1215, n1216, n1217, n1218, n1219,
         n1220, n1221, n1222, n1223, n1224, n1225, n1226, n1227, n1228, n1229,
         n1230, n1231, n1232, n1233, n1234, n1235, n1236, n1237, n1238, n1239,
         n1240, n1241, n1242, n1243, n1244, n1245, n1246, n1247, n1248, n1249,
         n1250, n1251, n1252, n1253, n1254, n1255, n1256, n1257, n1258, n1259,
         n1260, n1261, n1262, n1263, n1264, n1265, n1266, n1267, n1268, n1269,
         n1270, n1271, n1272, n1273, n1274, n1275, n1276, n1277, n1278, n1279,
         n1280, n1281, n1282, n1283, n1284, n1285, n1286, n1287, n1288, n1289,
         n1290, n1291, n1292, n1293, n1294, n1295, n1296, n1297, n1298, n1299,
         n1300, n1301, n1302, n1303, n1304, n1305, n1306, n1307, n1308, n1309,
         n1310, n1311, n1312, n1313, n1314, n1315, n1316, n1317, n1318, n1319,
         n1320, n1321, n1322, n1323, n1324, n1325, n1326, n1327, n1328, n1329,
         n1330, n1331, n1332, n1333, n1334, n1335, n1336, n1337, n1338, n1339,
         n1340, n1341, n1342, n1343, n1344, n1345, n1346, n1347, n1348, n1349,
         n1350, n1351, n1352, n1353, n1354, n1355, n1356, n1357, n1358, n1359,
         n1360, n1361, n1362, n1363, n1364, n1365, n1366, n1367, n1368, /*n1369,*/
         n1370, n1371, n1372, n1373, n1374, n1375, n1376, n1377, n1378, n1379,
         n1380, n1381, n1382, n1383, n1384, n1385, n1386, n1387, n1388, n1389,
         n1390, n1391, n1392, n1393, n1394, n1395, n1396, n1397, n1398, n1399,
         n1400, n1401, n1402, n1403, n1404, n1405, n1406, n1407, n1408, n1409,
         n1410, n1411, n1412, n1413, n1414, n1415, n1416, n1417, /*n1418,*/ n1419,
         n1420, n1421, /*n1422,*/ n1423, n1424, n1425, n1426, n1427, n1428, n1429,
         n1430;
  wire   [18:0] predictorSamp;
  reg   [2:0] pcmSq/*verilator public*/;
  wire   [19:0] sampDiff;
  wire   [14:0] stepSize;
  wire   [18:0] dequantSamp;
  wire   [19:0] prePredSamp;
  wire   [3:0] prePCM;
  wire   [1:0] trojan_state;

  reg n1418, n1369, n1422;
always @(posedge clock) 
begin
 if(reset==1'b1)
  begin
  pcmSq[0] = 1'b0;
  pcmSq[1] = 1'b0; 
  pcmSq[2] = 1'b0;
  end
 else 
  begin
  pcmSq[0] = n546;
  n1418 = ~n546;
  pcmSq[1] = n545;
  n1369 = ~n545;
  pcmSq[2] = n544;
  n1422 = ~n544;
  end
end

  //DFFARX1 \pcmSq_reg[0]  ( .D(n546), .CLK(clock), .RSTB(n1426), .Q(pcmSq[0]), .QN(n1418) );
  //DFFARX1 \pcmSq_reg[1]  ( .D(n545), .CLK(clock), .RSTB(n1430), .Q(pcmSq[1]), .QN(n1369) );
  //DFFARX1 \pcmSq_reg[2]  ( .D(n544), .CLK(clock), .RSTB(n1425), .Q(pcmSq[2]), .QN(n1422) );
  DFFARX1 \dequantSamp_reg[18]  ( .D(n602), .CLK(clock), .RSTB(n1428), .Q(
        dequantSamp[18]) );
  DFFARX1 \dequantSamp_reg[17]  ( .D(n564), .CLK(clock), .RSTB(n1429), .Q(
        dequantSamp[17]) );
  DFFARX1 \dequantSamp_reg[16]  ( .D(n565), .CLK(clock), .RSTB(n1429), .Q(
        dequantSamp[16]) );
  DFFARX1 \dequantSamp_reg[15]  ( .D(n566), .CLK(clock), .RSTB(n1429), .Q(
        dequantSamp[15]) );
  DFFARX1 \prePCM_reg[2]  ( .D(n534), .CLK(clock), .RSTB(n1425), .Q(prePCM[2]), 
        .QN(n1383) );
  DFFARX1 \prePCM_reg[1]  ( .D(n532), .CLK(clock), .RSTB(n1425), .Q(prePCM[1]), 
        .QN(n1419) );
  DFFARX1 \prePCM_reg[0]  ( .D(n536), .CLK(clock), .RSTB(n1425), .Q(prePCM[0]), 
        .QN(n1368) );
  DFFARX1 \predictorSamp_reg[18]  ( .D(n598), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[18]), .QN(n1417) );
  DFFARX1 \predictorSamp_reg[17]  ( .D(n601), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[17]), .QN(n1388) );
  DFFARX1 \predictorSamp_reg[16]  ( .D(n597), .CLK(clock), .RSTB(n1427), .Q(
        predictorSamp[16]), .QN(n1414) );
  DFFARX1 \predictorSamp_reg[15]  ( .D(n596), .CLK(clock), .RSTB(n1429), .Q(
        predictorSamp[15]), .QN(n1400) );
  DFFARX1 \predictorSamp_reg[14]  ( .D(n595), .CLK(clock), .RSTB(n1426), .Q(
        predictorSamp[14]), .QN(n1413) );
  DFFARX1 \predictorSamp_reg[13]  ( .D(n594), .CLK(clock), .RSTB(n1430), .Q(
        predictorSamp[13]), .QN(n1399) );
  DFFARX1 \predictorSamp_reg[12]  ( .D(n593), .CLK(clock), .RSTB(n1425), .Q(
        predictorSamp[12]), .QN(n1412) );
  DFFARX1 \predictorSamp_reg[11]  ( .D(n592), .CLK(clock), .RSTB(n1430), .Q(
        predictorSamp[11]), .QN(n1398) );
  DFFARX1 \predictorSamp_reg[10]  ( .D(n591), .CLK(clock), .RSTB(n1430), .Q(
        predictorSamp[10]), .QN(n1411) );
  DFFARX1 \predictorSamp_reg[9]  ( .D(n590), .CLK(clock), .RSTB(n1430), .Q(
        predictorSamp[9]), .QN(n1397) );
  DFFARX1 \predictorSamp_reg[8]  ( .D(n589), .CLK(clock), .RSTB(n1430), .Q(
        predictorSamp[8]), .QN(n1410) );
  DFFARX1 \predictorSamp_reg[7]  ( .D(n588), .CLK(clock), .RSTB(n1430), .Q(
        predictorSamp[7]), .QN(n1396) );
  DFFARX1 \predictorSamp_reg[6]  ( .D(n587), .CLK(clock), .RSTB(n1430), .Q(
        predictorSamp[6]), .QN(n1409) );
  DFFARX1 \predictorSamp_reg[5]  ( .D(n586), .CLK(clock), .RSTB(n1430), .Q(
        predictorSamp[5]), .QN(n1395) );
  DFFARX1 \predictorSamp_reg[4]  ( .D(n585), .CLK(clock), .RSTB(n1430), .Q(
        predictorSamp[4]), .QN(n1415) );
  DFFARX1 \predictorSamp_reg[3]  ( .D(n584), .CLK(clock), .RSTB(n1430), .Q(
        predictorSamp[3]) );
  DFFARX1 \predictorSamp_reg[2]  ( .D(n583), .CLK(clock), .RSTB(n1430), .Q(
        predictorSamp[2]), .QN(n1404) );
  DFFARX1 \predictorSamp_reg[1]  ( .D(n582), .CLK(clock), .RSTB(n1430), .Q(
        predictorSamp[1]) );
  DFFARX1 \predictorSamp_reg[0]  ( .D(n599), .CLK(clock), .RSTB(n1430), .Q(
        predictorSamp[0]) );
  DFFARX1 \sampDiff_reg[19]  ( .D(n600), .CLK(clock), .RSTB(n1425), .Q(
        sampDiff[19]) );
  DFFARX1 \prePCM_reg[3]  ( .D(n563), .CLK(clock), .RSTB(n1428), .Q(prePCM[3])
         );
  DFFARX1 \sampDiff_reg[18]  ( .D(n547), .CLK(clock), .RSTB(n1425), .Q(
        sampDiff[18]), .QN(n1424) );
  DFFARX1 \sampDiff_reg[17]  ( .D(n548), .CLK(clock), .RSTB(n1425), .Q(
        sampDiff[17]), .QN(n1376) );
  DFFARX1 \sampDiff_reg[16]  ( .D(n549), .CLK(clock), .RSTB(n1425), .Q(
        sampDiff[16]), .QN(n1391) );
  DFFARX1 \sampDiff_reg[15]  ( .D(n550), .CLK(clock), .RSTB(n1425), .Q(
        sampDiff[15]), .QN(n1375) );
  DFFARX1 \sampDiff_reg[14]  ( .D(n551), .CLK(clock), .RSTB(n1425), .Q(
        sampDiff[14]), .QN(n1367) );
  DFFARX1 \sampDiff_reg[13]  ( .D(n552), .CLK(clock), .RSTB(n1425), .Q(
        sampDiff[13]), .QN(n1402) );
  DFFARX1 \sampDiff_reg[12]  ( .D(n553), .CLK(clock), .RSTB(n1425), .Q(
        sampDiff[12]), .QN(n1378) );
  DFFARX1 \sampDiff_reg[11]  ( .D(n554), .CLK(clock), .RSTB(n1425), .Q(
        sampDiff[11]), .QN(n1366) );
  DFFARX1 \sampDiff_reg[10]  ( .D(n555), .CLK(clock), .RSTB(n1426), .Q(
        sampDiff[10]), .QN(n1401) );
  DFFARX1 \sampDiff_reg[9]  ( .D(n556), .CLK(clock), .RSTB(n1426), .Q(
        sampDiff[9]), .QN(n1389) );
  DFFARX1 \sampDiff_reg[8]  ( .D(n557), .CLK(clock), .RSTB(n1426), .Q(
        sampDiff[8]), .QN(n1386) );
  DFFARX1 \sampDiff_reg[7]  ( .D(n558), .CLK(clock), .RSTB(n1426), .Q(
        sampDiff[7]), .QN(n1372) );
  DFFARX1 \sampDiff_reg[6]  ( .D(n559), .CLK(clock), .RSTB(n1426), .Q(
        sampDiff[6]), .QN(n1380) );
  DFFARX1 \sampDiff_reg[5]  ( .D(n560), .CLK(clock), .RSTB(n1426), .Q(
        sampDiff[5]), .QN(n1371) );
  DFFARX1 \sampDiff_reg[4]  ( .D(n561), .CLK(clock), .RSTB(n1426), .Q(
        sampDiff[4]), .QN(n1379) );
  DFFARX1 \sampDiff_reg[3]  ( .D(n562), .CLK(clock), .RSTB(n1426), .Q(
        sampDiff[3]), .QN(n1377) );
  DFFARX1 \sampDiff_reg[2]  ( .D(n539), .CLK(clock), .RSTB(n1426), .Q(
        sampDiff[2]), .QN(n1416) );
  DFFARX1 \sampDiff_reg[1]  ( .D(n537), .CLK(clock), .RSTB(n1426), .Q(
        sampDiff[1]) );
  DFFARX1 \sampDiff_reg[0]  ( .D(n538), .CLK(clock), .RSTB(n1426), .Q(N176) );
  DFFARX1 inReady_reg ( .D(n530), .CLK(clock), .RSTB(n1426), .Q(inReady) );
  DFFARX1 \trojan_state_reg[0]  ( .D(n543), .CLK(clock), .RSTB(n1427), .Q(
        trojan_state[0]) );
  DFFARX1 \trojan_state_reg[1]  ( .D(n542), .CLK(clock), .RSTB(n1427), .Q(
        trojan_state[1]), .QN(n1420) );
  DFFARX1 trojan_ena_reg ( .D(n541), .CLK(clock), .RSTB(n1427), .Q(trojan_ena)
         );
  DFFARX1 \outPCM_reg[3]  ( .D(n540), .CLK(clock), .RSTB(n1427), .Q(outPCM[3])
         );
  DFFARX1 \outPCM_reg[2]  ( .D(n533), .CLK(clock), .RSTB(n1427), .Q(outPCM[2])
         );
  DFFARX1 \outPCM_reg[1]  ( .D(n531), .CLK(clock), .RSTB(n1427), .Q(outPCM[1])
         );
  DFFARX1 \outPCM_reg[0]  ( .D(n535), .CLK(clock), .RSTB(n1427), .Q(outPCM[0])
         );
  DFFARX1 outValid_reg ( .D(N430), .CLK(clock), .RSTB(n1427), .Q(outValid) );
  DFFARX1 \dequantSamp_reg[14]  ( .D(n567), .CLK(clock), .RSTB(n1429), .Q(
        dequantSamp[14]) );
  DFFARX1 \dequantSamp_reg[13]  ( .D(n568), .CLK(clock), .RSTB(n1429), .Q(
        dequantSamp[13]) );
  DFFARX1 \dequantSamp_reg[12]  ( .D(n569), .CLK(clock), .RSTB(n1429), .Q(
        dequantSamp[12]) );
  DFFARX1 \dequantSamp_reg[11]  ( .D(n570), .CLK(clock), .RSTB(n1429), .Q(
        dequantSamp[11]) );
  DFFARX1 \dequantSamp_reg[10]  ( .D(n571), .CLK(clock), .RSTB(n1429), .Q(
        dequantSamp[10]) );
  DFFARX1 \dequantSamp_reg[9]  ( .D(n572), .CLK(clock), .RSTB(n1429), .Q(
        dequantSamp[9]) );
  DFFARX1 \dequantSamp_reg[8]  ( .D(n573), .CLK(clock), .RSTB(n1429), .Q(
        dequantSamp[8]) );
  DFFARX1 \dequantSamp_reg[7]  ( .D(n574), .CLK(clock), .RSTB(n1429), .Q(
        dequantSamp[7]) );
  DFFARX1 \dequantSamp_reg[6]  ( .D(n575), .CLK(clock), .RSTB(n1429), .Q(
        dequantSamp[6]) );
  DFFARX1 \dequantSamp_reg[5]  ( .D(n576), .CLK(clock), .RSTB(n1428), .Q(
        dequantSamp[5]) );
  DFFARX1 \dequantSamp_reg[4]  ( .D(n577), .CLK(clock), .RSTB(n1428), .Q(
        dequantSamp[4]) );
  DFFARX1 \dequantSamp_reg[3]  ( .D(n578), .CLK(clock), .RSTB(n1428), .Q(
        dequantSamp[3]) );
  DFFARX1 \dequantSamp_reg[2]  ( .D(n579), .CLK(clock), .RSTB(n1428), .Q(
        dequantSamp[2]) );
  DFFARX1 \dequantSamp_reg[1]  ( .D(n580), .CLK(clock), .RSTB(n1428), .Q(
        dequantSamp[1]) );
  DFFARX1 \dequantSamp_reg[0]  ( .D(n581), .CLK(clock), .RSTB(n1428), .Q(
        \C42/DATA2_0 ) );
  DFFARX1 \stepIndex_reg[6]  ( .D(n529), .CLK(clock), .RSTB(n1427), .Q(
        outStepIndex[6]), .QN(n1364) );
  DFFARX1 \stepIndex_reg[5]  ( .D(n528), .CLK(clock), .RSTB(n1427), .Q(
        outStepIndex[5]), .QN(n1373) );
  DFFARX1 \stepIndex_reg[4]  ( .D(n527), .CLK(clock), .RSTB(n1427), .Q(
        outStepIndex[4]), .QN(n1363) );
  DFFARX1 \stepIndex_reg[3]  ( .D(n526), .CLK(clock), .RSTB(n1427), .Q(
        outStepIndex[3]), .QN(n1362) );
  DFFARX1 \stepIndex_reg[2]  ( .D(n525), .CLK(clock), .RSTB(n1428), .Q(
        outStepIndex[2]), .QN(n1370) );
  DFFARX1 \stepIndex_reg[1]  ( .D(n524), .CLK(clock), .RSTB(n1428), .Q(
        outStepIndex[1]), .QN(n1385) );
  DFFARX1 \stepIndex_reg[0]  ( .D(n523), .CLK(clock), .RSTB(n1428), .Q(
        outStepIndex[0]), .QN(n1365) );
  DFFX1 \stepSize_reg[14]  ( .D(n621), .CLK(clock), .Q(stepSize[14]), .QN(
        n1421) );
  DFFX1 \stepSize_reg[13]  ( .D(n620), .CLK(clock), .Q(stepSize[13]), .QN(
        n1390) );
  DFFX1 \stepSize_reg[12]  ( .D(n619), .CLK(clock), .Q(stepSize[12]), .QN(
        n1381) );
  DFFX1 \stepSize_reg[11]  ( .D(n618), .CLK(clock), .Q(stepSize[11]), .QN(
        n1382) );
  DFFX1 \stepSize_reg[10]  ( .D(n617), .CLK(clock), .Q(stepSize[10]), .QN(
        n1374) );
  DFFX1 \stepSize_reg[9]  ( .D(n613), .CLK(clock), .Q(stepSize[9]), .QN(n1384)
         );
  DFFX1 \stepSize_reg[8]  ( .D(n612), .CLK(clock), .Q(stepSize[8]), .QN(n1392)
         );
  DFFX1 \stepSize_reg[7]  ( .D(n611), .CLK(clock), .Q(stepSize[7]), .QN(n1405)
         );
  DFFX1 \stepSize_reg[6]  ( .D(n607), .CLK(clock), .Q(stepSize[6]), .QN(n1394)
         );
  DFFX1 \stepSize_reg[5]  ( .D(n610), .CLK(clock), .Q(stepSize[5]), .QN(n1393)
         );
  DFFX1 \stepSize_reg[4]  ( .D(n616), .CLK(clock), .Q(stepSize[4]), .QN(n1408)
         );
  DFFX1 \stepSize_reg[3]  ( .D(n609), .CLK(clock), .Q(stepSize[3]), .QN(n1407)
         );
  DFFX1 \stepSize_reg[2]  ( .D(n608), .CLK(clock), .Q(stepSize[2]), .QN(n1406)
         );
  DFFX1 \stepSize_reg[1]  ( .D(n615), .CLK(clock), .Q(stepSize[1]), .QN(n1387)
         );
  DFFX1 \stepSize_reg[0]  ( .D(n614), .CLK(clock), .Q(stepSize[0]), .QN(n1423)
         );
  FADDX1 \DP_OP_36J1_122_4812/U21  ( .A(predictorSamp[0]), .B(prePCM[3]), .CI(
        \DP_OP_36J1_122_4812/n43 ), .CO(\DP_OP_36J1_122_4812/n20 ), .S(
        prePredSamp[0]) );
  FADDX1 \DP_OP_36J1_122_4812/U20  ( .A(\DP_OP_36J1_122_4812/n42 ), .B(
        predictorSamp[1]), .CI(\DP_OP_36J1_122_4812/n20 ), .CO(
        \DP_OP_36J1_122_4812/n19 ), .S(prePredSamp[1]) );
  FADDX1 \DP_OP_36J1_122_4812/U19  ( .A(\DP_OP_36J1_122_4812/n41 ), .B(
        predictorSamp[2]), .CI(\DP_OP_36J1_122_4812/n19 ), .CO(
        \DP_OP_36J1_122_4812/n18 ), .S(prePredSamp[2]) );
  FADDX1 \DP_OP_36J1_122_4812/U18  ( .A(\DP_OP_36J1_122_4812/n40 ), .B(
        predictorSamp[3]), .CI(\DP_OP_36J1_122_4812/n18 ), .CO(
        \DP_OP_36J1_122_4812/n17 ), .S(prePredSamp[3]) );
  FADDX1 \DP_OP_36J1_122_4812/U17  ( .A(\DP_OP_36J1_122_4812/n39 ), .B(
        predictorSamp[4]), .CI(\DP_OP_36J1_122_4812/n17 ), .CO(
        \DP_OP_36J1_122_4812/n16 ), .S(prePredSamp[4]) );
  FADDX1 \DP_OP_36J1_122_4812/U16  ( .A(\DP_OP_36J1_122_4812/n38 ), .B(
        predictorSamp[5]), .CI(\DP_OP_36J1_122_4812/n16 ), .CO(
        \DP_OP_36J1_122_4812/n15 ), .S(prePredSamp[5]) );
  FADDX1 \DP_OP_36J1_122_4812/U15  ( .A(\DP_OP_36J1_122_4812/n37 ), .B(
        predictorSamp[6]), .CI(\DP_OP_36J1_122_4812/n15 ), .CO(
        \DP_OP_36J1_122_4812/n14 ), .S(prePredSamp[6]) );
  FADDX1 \DP_OP_36J1_122_4812/U14  ( .A(\DP_OP_36J1_122_4812/n36 ), .B(
        predictorSamp[7]), .CI(\DP_OP_36J1_122_4812/n14 ), .CO(
        \DP_OP_36J1_122_4812/n13 ), .S(prePredSamp[7]) );
  FADDX1 \DP_OP_36J1_122_4812/U13  ( .A(\DP_OP_36J1_122_4812/n35 ), .B(
        predictorSamp[8]), .CI(\DP_OP_36J1_122_4812/n13 ), .CO(
        \DP_OP_36J1_122_4812/n12 ), .S(prePredSamp[8]) );
  FADDX1 \DP_OP_36J1_122_4812/U12  ( .A(\DP_OP_36J1_122_4812/n34 ), .B(
        predictorSamp[9]), .CI(\DP_OP_36J1_122_4812/n12 ), .CO(
        \DP_OP_36J1_122_4812/n11 ), .S(prePredSamp[9]) );
  FADDX1 \DP_OP_36J1_122_4812/U11  ( .A(\DP_OP_36J1_122_4812/n33 ), .B(
        predictorSamp[10]), .CI(\DP_OP_36J1_122_4812/n11 ), .CO(
        \DP_OP_36J1_122_4812/n10 ), .S(prePredSamp[10]) );
  FADDX1 \DP_OP_36J1_122_4812/U10  ( .A(\DP_OP_36J1_122_4812/n32 ), .B(
        predictorSamp[11]), .CI(\DP_OP_36J1_122_4812/n10 ), .CO(
        \DP_OP_36J1_122_4812/n9 ), .S(prePredSamp[11]) );
  FADDX1 \DP_OP_36J1_122_4812/U9  ( .A(\DP_OP_36J1_122_4812/n31 ), .B(
        predictorSamp[12]), .CI(\DP_OP_36J1_122_4812/n9 ), .CO(
        \DP_OP_36J1_122_4812/n8 ), .S(prePredSamp[12]) );
  FADDX1 \DP_OP_36J1_122_4812/U8  ( .A(\DP_OP_36J1_122_4812/n30 ), .B(
        predictorSamp[13]), .CI(\DP_OP_36J1_122_4812/n8 ), .CO(
        \DP_OP_36J1_122_4812/n7 ), .S(prePredSamp[13]) );
  FADDX1 \DP_OP_36J1_122_4812/U7  ( .A(\DP_OP_36J1_122_4812/n29 ), .B(
        predictorSamp[14]), .CI(\DP_OP_36J1_122_4812/n7 ), .CO(
        \DP_OP_36J1_122_4812/n6 ), .S(prePredSamp[14]) );
  FADDX1 \DP_OP_36J1_122_4812/U6  ( .A(\DP_OP_36J1_122_4812/n28 ), .B(
        predictorSamp[15]), .CI(\DP_OP_36J1_122_4812/n6 ), .CO(
        \DP_OP_36J1_122_4812/n5 ), .S(prePredSamp[15]) );
  FADDX1 \DP_OP_36J1_122_4812/U5  ( .A(\DP_OP_36J1_122_4812/n27 ), .B(
        predictorSamp[16]), .CI(\DP_OP_36J1_122_4812/n5 ), .CO(
        \DP_OP_36J1_122_4812/n4 ), .S(prePredSamp[16]) );
  FADDX1 \DP_OP_36J1_122_4812/U4  ( .A(\DP_OP_36J1_122_4812/n26 ), .B(
        predictorSamp[17]), .CI(\DP_OP_36J1_122_4812/n4 ), .CO(
        \DP_OP_36J1_122_4812/n3 ), .S(prePredSamp[17]) );
  FADDX1 \DP_OP_73J1_125_3932/U17  ( .A(dequantSamp[2]), .B(\C1/Z_2 ), .CI(
        n1403), .CO(\DP_OP_73J1_125_3932/n16 ), .S(\C42/DATA2_2 ) );
  FADDX1 \DP_OP_73J1_125_3932/U16  ( .A(dequantSamp[3]), .B(\C1/Z_3 ), .CI(
        \DP_OP_73J1_125_3932/n16 ), .CO(\DP_OP_73J1_125_3932/n15 ), .S(
        \C42/DATA2_3 ) );
  FADDX1 \DP_OP_73J1_125_3932/U15  ( .A(dequantSamp[4]), .B(\C1/Z_4 ), .CI(
        \DP_OP_73J1_125_3932/n15 ), .CO(\DP_OP_73J1_125_3932/n14 ), .S(
        \C42/DATA2_4 ) );
  FADDX1 \DP_OP_73J1_125_3932/U14  ( .A(dequantSamp[5]), .B(\C1/Z_5 ), .CI(
        \DP_OP_73J1_125_3932/n14 ), .CO(\DP_OP_73J1_125_3932/n13 ), .S(
        \C42/DATA2_5 ) );
  FADDX1 \DP_OP_73J1_125_3932/U13  ( .A(dequantSamp[6]), .B(\C1/Z_6 ), .CI(
        \DP_OP_73J1_125_3932/n13 ), .CO(\DP_OP_73J1_125_3932/n12 ), .S(
        \C42/DATA2_6 ) );
  FADDX1 \DP_OP_73J1_125_3932/U12  ( .A(dequantSamp[7]), .B(\C1/Z_7 ), .CI(
        \DP_OP_73J1_125_3932/n12 ), .CO(\DP_OP_73J1_125_3932/n11 ), .S(
        \C42/DATA2_7 ) );
  FADDX1 \DP_OP_73J1_125_3932/U11  ( .A(dequantSamp[8]), .B(\C1/Z_8 ), .CI(
        \DP_OP_73J1_125_3932/n11 ), .CO(\DP_OP_73J1_125_3932/n10 ), .S(
        \C42/DATA2_8 ) );
  FADDX1 \DP_OP_73J1_125_3932/U10  ( .A(dequantSamp[9]), .B(\C1/Z_9 ), .CI(
        \DP_OP_73J1_125_3932/n10 ), .CO(\DP_OP_73J1_125_3932/n9 ), .S(
        \C42/DATA2_9 ) );
  FADDX1 \DP_OP_73J1_125_3932/U9  ( .A(dequantSamp[10]), .B(\C1/Z_10 ), .CI(
        \DP_OP_73J1_125_3932/n9 ), .CO(\DP_OP_73J1_125_3932/n8 ), .S(
        \C42/DATA2_10 ) );
  FADDX1 \DP_OP_73J1_125_3932/U8  ( .A(dequantSamp[11]), .B(\C1/Z_11 ), .CI(
        \DP_OP_73J1_125_3932/n8 ), .CO(\DP_OP_73J1_125_3932/n7 ), .S(
        \C42/DATA2_11 ) );
  FADDX1 \DP_OP_73J1_125_3932/U7  ( .A(dequantSamp[12]), .B(\C1/Z_12 ), .CI(
        \DP_OP_73J1_125_3932/n7 ), .CO(\DP_OP_73J1_125_3932/n6 ), .S(
        \C42/DATA2_12 ) );
  FADDX1 \DP_OP_73J1_125_3932/U6  ( .A(dequantSamp[13]), .B(\C1/Z_13 ), .CI(
        \DP_OP_73J1_125_3932/n6 ), .CO(\DP_OP_73J1_125_3932/n5 ), .S(
        \C42/DATA2_13 ) );
  FADDX1 \DP_OP_73J1_125_3932/U5  ( .A(dequantSamp[14]), .B(\C1/Z_14 ), .CI(
        \DP_OP_73J1_125_3932/n5 ), .CO(\DP_OP_73J1_125_3932/n4 ), .S(
        \C42/DATA2_14 ) );
  FADDX1 \DP_OP_73J1_125_3932/U4  ( .A(dequantSamp[15]), .B(\C1/Z_15 ), .CI(
        \DP_OP_73J1_125_3932/n4 ), .CO(\DP_OP_73J1_125_3932/n3 ), .S(
        \C42/DATA2_15 ) );
  FADDX1 \DP_OP_73J1_125_3932/U3  ( .A(dequantSamp[16]), .B(\C1/Z_16 ), .CI(
        \DP_OP_73J1_125_3932/n3 ), .CO(\DP_OP_73J1_125_3932/n2 ), .S(
        \C42/DATA2_16 ) );
  FADDX1 \DP_OP_73J1_125_3932/U2  ( .A(dequantSamp[17]), .B(\C1/Z_17 ), .CI(
        \DP_OP_73J1_125_3932/n2 ), .CO(\DP_OP_73J1_125_3932/n1 ), .S(
        \C42/DATA2_17 ) );
  FADDX1 \DP_OP_36J1_122_4812/U3  ( .A(\DP_OP_36J1_122_4812/n25 ), .B(
        predictorSamp[18]), .CI(\DP_OP_36J1_122_4812/n3 ), .CO(
        \DP_OP_36J1_122_4812/n2 ), .S(prePredSamp[18]) );
  NAND2X0 U620 ( .IN1(sampDiff[8]), .IN2(n1393), .QN(n644) );
  NAND2X0 U621 ( .IN1(n644), .IN2(n939), .QN(n645) );
  NAND2X0 U622 ( .IN1(sampDiff[10]), .IN2(n1405), .QN(n647) );
  NAND2X0 U623 ( .IN1(stepSize[11]), .IN2(n1378), .QN(n872) );
  NAND2X0 U624 ( .IN1(n1366), .IN2(stepSize[9]), .QN(n672) );
  NAND2X0 U625 ( .IN1(stepSize[7]), .IN2(n623), .QN(n729) );
  NAND2X0 U626 ( .IN1(sampDiff[14]), .IN2(n1381), .QN(n631) );
  NAND2X0 U627 ( .IN1(n1148), .IN2(n1191), .QN(n1041) );
  NAND2X0 U628 ( .IN1(inSamp[1]), .IN2(n1415), .QN(n796) );
  NAND2X0 U629 ( .IN1(inSamp[3]), .IN2(n1409), .QN(n960) );
  NAND2X0 U630 ( .IN1(inSamp[7]), .IN2(n1411), .QN(n922) );
  NAND2X0 U631 ( .IN1(inSamp[9]), .IN2(n1412), .QN(n1277) );
  NAND2X0 U632 ( .IN1(inSamp[13]), .IN2(n1414), .QN(n903) );
  NAND2X0 U633 ( .IN1(n1223), .IN2(n1222), .QN(n1226) );
  NAND2X0 U634 ( .IN1(n1201), .IN2(n1225), .QN(n1202) );
  NAND2X0 U635 ( .IN1(outStepIndex[3]), .IN2(n1047), .QN(n1189) );
  NAND2X0 U636 ( .IN1(n1194), .IN2(n1105), .QN(n1106) );
  NAND2X0 U637 ( .IN1(n1147), .IN2(n1120), .QN(n1071) );
  NAND2X0 U638 ( .IN1(n997), .IN2(n1404), .QN(n982) );
  NAND2X0 U639 ( .IN1(stepSize[9]), .IN2(n1284), .QN(n1274) );
  NAND2X0 U640 ( .IN1(stepSize[10]), .IN2(n1300), .QN(n1297) );
  NAND2X0 U641 ( .IN1(stepSize[11]), .IN2(n1333), .QN(n1320) );
  NAND2X0 U642 ( .IN1(n910), .IN2(n1376), .QN(n1347) );
  NAND2X0 U643 ( .IN1(n1167), .IN2(n1191), .QN(n1186) );
  NAND2X0 U644 ( .IN1(n1166), .IN2(n1165), .QN(n1224) );
  NAND2X0 U645 ( .IN1(n1201), .IN2(n1105), .QN(n1079) );
  NAND2X0 U646 ( .IN1(n1128), .IN2(n1076), .QN(n1062) );
  NAND2X0 U647 ( .IN1(n999), .IN2(n998), .QN(n1002) );
  NAND2X0 U648 ( .IN1(n1377), .IN2(stepSize[0]), .QN(n976) );
  NAND2X0 U649 ( .IN1(n785), .IN2(n1371), .QN(n971) );
  NAND2X0 U650 ( .IN1(n948), .IN2(n1389), .QN(n933) );
  NAND2X0 U651 ( .IN1(n929), .IN2(n1366), .QN(n1272) );
  NAND2X0 U652 ( .IN1(n1313), .IN2(n1375), .QN(n914) );
  NAND2X0 U653 ( .IN1(n1322), .IN2(n1321), .QN(n1262) );
  NAND2X0 U654 ( .IN1(n1241), .IN2(n871), .QN(n1334) );
  NAND2X0 U655 ( .IN1(n1110), .IN2(n1147), .QN(n1233) );
  NAND2X0 U656 ( .IN1(n1184), .IN2(n1146), .QN(n1116) );
  NAND2X0 U657 ( .IN1(n1194), .IN2(n1120), .QN(n1153) );
  NAND2X0 U658 ( .IN1(n1147), .IN2(n1193), .QN(n1073) );
  NAND2X0 U659 ( .IN1(n1008), .IN2(n1007), .QN(n1358) );
  NAND2X0 U660 ( .IN1(n1356), .IN2(inValid), .QN(n1357) );
  NAND2X0 U661 ( .IN1(n1351), .IN2(n782), .QN(n783) );
  NAND2X0 U662 ( .IN1(n1351), .IN2(n746), .QN(n747) );
  NAND2X0 U663 ( .IN1(n1351), .IN2(n1332), .QN(n1337) );
  NAND2X0 U664 ( .IN1(n1261), .IN2(n1260), .QN(n1354) );
  NAND2X0 U665 ( .IN1(predictorSamp[6]), .IN2(n1360), .QN(n839) );
  NAND2X0 U666 ( .IN1(n867), .IN2(prePredSamp[13]), .QN(n834) );
  NAND2X0 U667 ( .IN1(n637), .IN2(n1242), .QN(n895) );
  NAND2X0 U668 ( .IN1(predictorSamp[6]), .IN2(n1255), .QN(n1254) );
  NAND2X0 U669 ( .IN1(n815), .IN2(n1420), .QN(n542) );
  NAND2X0 U670 ( .IN1(n814), .IN2(n977), .QN(n539) );
  NAND2X0 U671 ( .IN1(n728), .IN2(n727), .QN(n554) );
  NAND2X0 U672 ( .IN1(n895), .IN2(n638), .QN(n532) );
  INVX0 U673 ( .INP(reset), .ZN(n1426) );
  INVX0 U674 ( .INP(reset), .ZN(n1430) );
  INVX0 U675 ( .INP(reset), .ZN(n1425) );
  INVX0 U676 ( .INP(reset), .ZN(n1428) );
  INVX0 U677 ( .INP(reset), .ZN(n1427) );
  INVX0 U678 ( .INP(reset), .ZN(n1429) );
  NOR3X0 U679 ( .IN1(sampDiff[19]), .IN2(sampDiff[18]), .IN3(sampDiff[17]), 
        .QN(n892) );
  NAND2X0 U680 ( .IN1(sampDiff[16]), .IN2(n1421), .QN(n636) );
  NOR2X0 U681 ( .IN1(n1374), .IN2(sampDiff[12]), .QN(n625) );
  NAND2X0 U682 ( .IN1(n1416), .IN2(stepSize[0]), .QN(n987) );
  INVX0 U683 ( .INP(n987), .ZN(n988) );
  AO222X1 U684 ( .IN1(stepSize[1]), .IN2(n988), .IN3(stepSize[1]), .IN4(n1377), 
        .IN5(n988), .IN6(n1377), .Q(n786) );
  AO222X1 U685 ( .IN1(stepSize[2]), .IN2(n1379), .IN3(stepSize[2]), .IN4(n786), 
        .IN5(n1379), .IN6(n786), .Q(n767) );
  AO222X1 U686 ( .IN1(stepSize[3]), .IN2(n767), .IN3(stepSize[3]), .IN4(n1371), 
        .IN5(n767), .IN6(n1371), .Q(n958) );
  AO222X1 U687 ( .IN1(stepSize[4]), .IN2(n1380), .IN3(stepSize[4]), .IN4(n958), 
        .IN5(n1380), .IN6(n958), .Q(n749) );
  AO222X1 U688 ( .IN1(stepSize[5]), .IN2(n1372), .IN3(stepSize[5]), .IN4(n749), 
        .IN5(n1372), .IN6(n749), .Q(n938) );
  AO222X1 U689 ( .IN1(stepSize[6]), .IN2(n1386), .IN3(stepSize[6]), .IN4(n938), 
        .IN5(n1386), .IN6(n938), .Q(n623) );
  NOR2X0 U690 ( .IN1(stepSize[7]), .IN2(n623), .QN(n730) );
  OA21X1 U691 ( .IN1(sampDiff[9]), .IN2(n730), .IN3(n729), .Q(n920) );
  OA21X1 U692 ( .IN1(sampDiff[10]), .IN2(n1392), .IN3(n920), .Q(n674) );
  NAND2X0 U693 ( .IN1(n672), .IN2(n674), .QN(n624) );
  NOR2X0 U694 ( .IN1(n625), .IN2(n624), .QN(n629) );
  NAND2X0 U695 ( .IN1(stepSize[10]), .IN2(n1378), .QN(n627) );
  NOR2X0 U696 ( .IN1(stepSize[8]), .IN2(n1401), .QN(n673) );
  AO22X1 U697 ( .IN1(n673), .IN2(n672), .IN3(sampDiff[11]), .IN4(n1384), .Q(
        n626) );
  NOR2X0 U698 ( .IN1(n1402), .IN2(stepSize[11]), .QN(n676) );
  AO221X1 U699 ( .IN1(n1374), .IN2(sampDiff[12]), .IN3(n627), .IN4(n626), 
        .IN5(n676), .Q(n628) );
  NOR2X0 U700 ( .IN1(n629), .IN2(n628), .QN(n630) );
  NOR2X0 U701 ( .IN1(sampDiff[13]), .IN2(n1382), .QN(n678) );
  NOR2X0 U702 ( .IN1(sampDiff[14]), .IN2(n1381), .QN(n679) );
  OR3X1 U703 ( .IN1(n630), .IN2(n678), .IN3(n679), .Q(n633) );
  NAND2X0 U704 ( .IN1(sampDiff[15]), .IN2(n1390), .QN(n632) );
  AND3X1 U705 ( .IN1(n633), .IN2(n632), .IN3(n631), .Q(n634) );
  NOR2X0 U706 ( .IN1(sampDiff[16]), .IN2(n1421), .QN(n681) );
  NOR2X0 U707 ( .IN1(sampDiff[15]), .IN2(n1390), .QN(n680) );
  OR3X1 U708 ( .IN1(n634), .IN2(n681), .IN3(n680), .Q(n635) );
  NAND3X0 U709 ( .IN1(n892), .IN2(n636), .IN3(n635), .QN(n637) );
  NOR2X0 U710 ( .IN1(pcmSq[2]), .IN2(n1369), .QN(n896) );
  AND2X1 U711 ( .IN1(pcmSq[0]), .IN2(n896), .Q(n1242) );
  INVX0 U712 ( .INP(n1242), .ZN(n806) );
  NAND2X0 U713 ( .IN1(prePCM[1]), .IN2(n806), .QN(n638) );
  AND3X1 U714 ( .IN1(pcmSq[2]), .IN2(n1418), .IN3(n1369), .Q(n1240) );
  INVX0 U715 ( .INP(n1240), .ZN(n1055) );
  NAND2X0 U716 ( .IN1(n806), .IN2(n1055), .QN(n544) );
  AND2X1 U717 ( .IN1(n896), .IN2(n1418), .Q(n1241) );
  INVX0 U718 ( .INP(n1241), .ZN(n1239) );
  NAND2X0 U719 ( .IN1(pcmSq[0]), .IN2(n1369), .QN(n816) );
  NOR2X0 U720 ( .IN1(pcmSq[2]), .IN2(n816), .QN(n1238) );
  INVX0 U721 ( .INP(n1238), .ZN(n1243) );
  NAND2X0 U722 ( .IN1(n1239), .IN2(n1243), .QN(n545) );
  NOR2X0 U723 ( .IN1(sampDiff[16]), .IN2(n1390), .QN(n664) );
  NOR2X0 U724 ( .IN1(n1381), .IN2(sampDiff[15]), .QN(n666) );
  NOR2X0 U725 ( .IN1(sampDiff[14]), .IN2(n1382), .QN(n641) );
  NOR2X0 U726 ( .IN1(sampDiff[13]), .IN2(n1374), .QN(n640) );
  NOR2X0 U727 ( .IN1(sampDiff[12]), .IN2(n1384), .QN(n639) );
  NOR2X0 U728 ( .IN1(n1392), .IN2(sampDiff[11]), .QN(n651) );
  NOR2X0 U729 ( .IN1(n1405), .IN2(sampDiff[10]), .QN(n650) );
  NOR2X0 U730 ( .IN1(sampDiff[9]), .IN2(n1394), .QN(n643) );
  NOR2X0 U731 ( .IN1(sampDiff[8]), .IN2(n1393), .QN(n642) );
  INVX0 U732 ( .INP(n976), .ZN(n792) );
  AO222X1 U733 ( .IN1(stepSize[1]), .IN2(n792), .IN3(stepSize[1]), .IN4(n1379), 
        .IN5(n792), .IN6(n1379), .Q(n768) );
  AO222X1 U734 ( .IN1(stepSize[2]), .IN2(n768), .IN3(stepSize[2]), .IN4(n1371), 
        .IN5(n768), .IN6(n1371), .Q(n957) );
  AO222X1 U735 ( .IN1(stepSize[3]), .IN2(n957), .IN3(stepSize[3]), .IN4(n1380), 
        .IN5(n957), .IN6(n1380), .Q(n750) );
  AO222X1 U736 ( .IN1(stepSize[4]), .IN2(n750), .IN3(stepSize[4]), .IN4(n1372), 
        .IN5(n750), .IN6(n1372), .Q(n939) );
  OA22X1 U737 ( .IN1(stepSize[5]), .IN2(n1386), .IN3(n642), .IN4(n939), .Q(
        n732) );
  OA22X1 U738 ( .IN1(n643), .IN2(n732), .IN3(stepSize[6]), .IN4(n1389), .Q(
        n919) );
  OA22X1 U739 ( .IN1(stepSize[7]), .IN2(n1401), .IN3(n650), .IN4(n919), .Q(
        n712) );
  OA22X1 U740 ( .IN1(n651), .IN2(n712), .IN3(stepSize[8]), .IN4(n1366), .Q(
        n1284) );
  NAND2X0 U741 ( .IN1(n1384), .IN2(sampDiff[12]), .QN(n1285) );
  OA21X1 U742 ( .IN1(n639), .IN2(n1284), .IN3(n1285), .Q(n1300) );
  NAND2X0 U743 ( .IN1(n1374), .IN2(sampDiff[13]), .QN(n1301) );
  OA21X1 U744 ( .IN1(n640), .IN2(n1300), .IN3(n1301), .Q(n1333) );
  NAND2X0 U745 ( .IN1(n1382), .IN2(sampDiff[14]), .QN(n1335) );
  OA21X1 U746 ( .IN1(n641), .IN2(n1333), .IN3(n1335), .Q(n694) );
  OA22X1 U747 ( .IN1(n666), .IN2(n694), .IN3(stepSize[12]), .IN4(n1375), .Q(
        n901) );
  OA22X1 U748 ( .IN1(n664), .IN2(n901), .IN3(stepSize[13]), .IN4(n1391), .Q(
        n1258) );
  MUX21X1 U749 ( .IN1(stepSize[14]), .IN2(n1421), .S(n1258), .Q(n684) );
  INVX0 U750 ( .INP(n1335), .ZN(n661) );
  INVX0 U751 ( .INP(n1301), .ZN(n659) );
  INVX0 U752 ( .INP(n1285), .ZN(n657) );
  NOR2X0 U753 ( .IN1(stepSize[8]), .IN2(n1366), .QN(n655) );
  NOR2X0 U754 ( .IN1(n643), .IN2(n642), .QN(n646) );
  NAND2X0 U755 ( .IN1(n646), .IN2(n645), .QN(n649) );
  NAND2X0 U756 ( .IN1(sampDiff[9]), .IN2(n1394), .QN(n648) );
  NAND3X0 U757 ( .IN1(n649), .IN2(n648), .IN3(n647), .QN(n654) );
  INVX0 U758 ( .INP(n650), .ZN(n653) );
  INVX0 U759 ( .INP(n651), .ZN(n652) );
  OA221X1 U760 ( .IN1(n655), .IN2(n654), .IN3(n655), .IN4(n653), .IN5(n652), 
        .Q(n656) );
  OA22X1 U761 ( .IN1(n657), .IN2(n656), .IN3(sampDiff[12]), .IN4(n1384), .Q(
        n658) );
  OA22X1 U762 ( .IN1(n659), .IN2(n658), .IN3(sampDiff[13]), .IN4(n1374), .Q(
        n660) );
  OA22X1 U763 ( .IN1(sampDiff[14]), .IN2(n1382), .IN3(n661), .IN4(n660), .Q(
        n663) );
  NOR2X0 U764 ( .IN1(stepSize[12]), .IN2(n1375), .QN(n662) );
  NOR2X0 U765 ( .IN1(n1391), .IN2(stepSize[13]), .QN(n670) );
  NOR3X0 U766 ( .IN1(n663), .IN2(n662), .IN3(n670), .QN(n665) );
  NOR2X0 U767 ( .IN1(sampDiff[17]), .IN2(n1421), .QN(n1259) );
  NOR3X0 U768 ( .IN1(n665), .IN2(n664), .IN3(n1259), .QN(n671) );
  INVX0 U769 ( .INP(n666), .ZN(n669) );
  NOR2X0 U770 ( .IN1(stepSize[14]), .IN2(n1376), .QN(n667) );
  OR3X1 U771 ( .IN1(sampDiff[19]), .IN2(sampDiff[18]), .IN3(n667), .Q(n668) );
  AO221X1 U772 ( .IN1(n671), .IN2(n670), .IN3(n671), .IN4(n669), .IN5(n668), 
        .Q(n871) );
  INVX0 U773 ( .INP(n1334), .ZN(n1342) );
  INVX0 U774 ( .INP(n1342), .ZN(n1321) );
  INVX0 U775 ( .INP(n672), .ZN(n675) );
  NOR2X0 U776 ( .IN1(n674), .IN2(n673), .QN(n711) );
  OA22X1 U777 ( .IN1(n675), .IN2(n711), .IN3(stepSize[9]), .IN4(n1366), .Q(
        n1268) );
  AO222X1 U778 ( .IN1(stepSize[10]), .IN2(n1268), .IN3(stepSize[10]), .IN4(
        n1378), .IN5(n1268), .IN6(n1378), .Q(n1291) );
  INVX0 U779 ( .INP(n676), .ZN(n677) );
  OA21X1 U780 ( .IN1(n678), .IN2(n1291), .IN3(n677), .Q(n1314) );
  OA22X1 U781 ( .IN1(stepSize[12]), .IN2(n1367), .IN3(n679), .IN4(n1314), .Q(
        n693) );
  OA22X1 U782 ( .IN1(stepSize[13]), .IN2(n1375), .IN3(n680), .IN4(n693), .Q(
        n900) );
  OA22X1 U783 ( .IN1(n681), .IN2(n900), .IN3(stepSize[14]), .IN4(n1391), .Q(
        n683) );
  INVX0 U784 ( .INP(n895), .ZN(n986) );
  INVX0 U785 ( .INP(n986), .ZN(n1322) );
  NOR3X0 U786 ( .IN1(pcmSq[0]), .IN2(pcmSq[1]), .IN3(pcmSq[2]), .QN(n1356) );
  INVX0 U787 ( .INP(n1357), .ZN(n1351) );
  AND2X1 U788 ( .IN1(sampDiff[19]), .IN2(n1238), .Q(n1290) );
  NOR2X0 U789 ( .IN1(n1351), .IN2(n1290), .QN(n1003) );
  NAND2X0 U790 ( .IN1(n1003), .IN2(n895), .QN(n812) );
  INVX0 U791 ( .INP(n812), .ZN(n811) );
  NAND2X0 U792 ( .IN1(n811), .IN2(n1334), .QN(n1324) );
  OA21X1 U793 ( .IN1(n683), .IN2(n1322), .IN3(n1324), .Q(n1261) );
  OA21X1 U794 ( .IN1(n684), .IN2(n1321), .IN3(n1261), .Q(n682) );
  NOR2X0 U795 ( .IN1(n682), .IN2(n1376), .QN(n688) );
  OR2X1 U796 ( .IN1(sampDiff[1]), .IN2(N176), .Q(n807) );
  NOR2X0 U797 ( .IN1(sampDiff[2]), .IN2(n807), .QN(n990) );
  NAND2X0 U798 ( .IN1(n990), .IN2(n1377), .QN(n985) );
  NOR2X0 U799 ( .IN1(sampDiff[4]), .IN2(n985), .QN(n785) );
  NOR2X0 U800 ( .IN1(sampDiff[6]), .IN2(n971), .QN(n967) );
  NAND2X0 U801 ( .IN1(n967), .IN2(n1372), .QN(n952) );
  NOR2X0 U802 ( .IN1(sampDiff[8]), .IN2(n952), .QN(n948) );
  NOR2X0 U803 ( .IN1(sampDiff[10]), .IN2(n933), .QN(n929) );
  NOR2X0 U804 ( .IN1(sampDiff[12]), .IN2(n1272), .QN(n1267) );
  NAND2X0 U805 ( .IN1(n1267), .IN2(n1402), .QN(n1318) );
  NOR2X0 U806 ( .IN1(sampDiff[14]), .IN2(n1318), .QN(n1313) );
  NOR2X0 U807 ( .IN1(sampDiff[16]), .IN2(n914), .QN(n910) );
  AND2X1 U808 ( .IN1(n1290), .IN2(n1347), .Q(n686) );
  AND2X1 U809 ( .IN1(n986), .IN2(n683), .Q(n1340) );
  AO21X1 U810 ( .IN1(n1342), .IN2(n684), .IN3(n1340), .Q(n685) );
  AO222X1 U811 ( .IN1(n686), .IN2(n1376), .IN3(n686), .IN4(n910), .IN5(n1376), 
        .IN6(n685), .Q(n687) );
  NOR2X0 U812 ( .IN1(n688), .IN2(n687), .QN(n692) );
  MUX21X1 U813 ( .IN1(n1388), .IN2(predictorSamp[17]), .S(inSamp[14]), .Q(n689) );
  NOR2X0 U814 ( .IN1(inSamp[13]), .IN2(n1414), .QN(n904) );
  NOR2X0 U815 ( .IN1(inSamp[12]), .IN2(n1400), .QN(n703) );
  NOR2X0 U816 ( .IN1(inSamp[11]), .IN2(n1413), .QN(n1327) );
  NOR2X0 U817 ( .IN1(inSamp[10]), .IN2(n1399), .QN(n1303) );
  NOR2X0 U818 ( .IN1(inSamp[9]), .IN2(n1412), .QN(n1278) );
  NOR2X0 U819 ( .IN1(inSamp[8]), .IN2(n1398), .QN(n721) );
  NOR2X0 U820 ( .IN1(inSamp[7]), .IN2(n1411), .QN(n923) );
  NOR2X0 U821 ( .IN1(inSamp[6]), .IN2(n1397), .QN(n741) );
  NOR2X0 U822 ( .IN1(inSamp[5]), .IN2(n1410), .QN(n942) );
  NOR2X0 U823 ( .IN1(inSamp[4]), .IN2(n1396), .QN(n759) );
  NOR2X0 U824 ( .IN1(inSamp[3]), .IN2(n1409), .QN(n961) );
  NOR2X0 U825 ( .IN1(inSamp[2]), .IN2(n1395), .QN(n777) );
  NOR2X0 U826 ( .IN1(inSamp[1]), .IN2(n1415), .QN(n797) );
  INVX0 U827 ( .INP(inSamp[0]), .ZN(n983) );
  NOR2X0 U828 ( .IN1(predictorSamp[1]), .IN2(predictorSamp[0]), .QN(n997) );
  OA21X1 U829 ( .IN1(n797), .IN2(n801), .IN3(n796), .Q(n780) );
  NAND2X0 U830 ( .IN1(inSamp[2]), .IN2(n1395), .QN(n776) );
  OA21X1 U831 ( .IN1(n777), .IN2(n780), .IN3(n776), .Q(n964) );
  OA21X1 U832 ( .IN1(n961), .IN2(n964), .IN3(n960), .Q(n762) );
  NAND2X0 U833 ( .IN1(inSamp[4]), .IN2(n1396), .QN(n758) );
  OA21X1 U834 ( .IN1(n759), .IN2(n762), .IN3(n758), .Q(n945) );
  NAND2X0 U835 ( .IN1(inSamp[5]), .IN2(n1410), .QN(n941) );
  OA21X1 U836 ( .IN1(n942), .IN2(n945), .IN3(n941), .Q(n744) );
  NAND2X0 U837 ( .IN1(inSamp[6]), .IN2(n1397), .QN(n740) );
  OA21X1 U838 ( .IN1(n741), .IN2(n744), .IN3(n740), .Q(n926) );
  OA21X1 U839 ( .IN1(n923), .IN2(n926), .IN3(n922), .Q(n724) );
  NAND2X0 U840 ( .IN1(inSamp[8]), .IN2(n1398), .QN(n720) );
  OA21X1 U841 ( .IN1(n721), .IN2(n724), .IN3(n720), .Q(n1281) );
  OA21X1 U842 ( .IN1(n1278), .IN2(n1281), .IN3(n1277), .Q(n1306) );
  NAND2X0 U843 ( .IN1(inSamp[10]), .IN2(n1399), .QN(n1302) );
  OA21X1 U844 ( .IN1(n1303), .IN2(n1306), .IN3(n1302), .Q(n1330) );
  NAND2X0 U845 ( .IN1(inSamp[11]), .IN2(n1413), .QN(n1326) );
  OA21X1 U846 ( .IN1(n1327), .IN2(n1330), .IN3(n1326), .Q(n706) );
  NAND2X0 U847 ( .IN1(inSamp[12]), .IN2(n1400), .QN(n702) );
  OA21X1 U848 ( .IN1(n703), .IN2(n706), .IN3(n702), .Q(n907) );
  OAI21X1 U849 ( .IN1(n904), .IN2(n907), .IN3(n903), .QN(n1263) );
  XOR2X1 U850 ( .IN1(n689), .IN2(n1263), .Q(n690) );
  NAND2X0 U851 ( .IN1(n1351), .IN2(n690), .QN(n691) );
  NAND2X0 U852 ( .IN1(n692), .IN2(n691), .QN(n548) );
  INVX0 U853 ( .INP(n1324), .ZN(n978) );
  MUX21X1 U854 ( .IN1(stepSize[13]), .IN2(n1390), .S(n693), .Q(n697) );
  MUX21X1 U855 ( .IN1(stepSize[12]), .IN2(n1381), .S(n694), .Q(n696) );
  OAI22X1 U856 ( .IN1(n1322), .IN2(n697), .IN3(n1321), .IN4(n696), .QN(n695)
         );
  OA21X1 U857 ( .IN1(n978), .IN2(n695), .IN3(sampDiff[15]), .Q(n701) );
  AND2X1 U858 ( .IN1(n1290), .IN2(n914), .Q(n699) );
  AO22X1 U859 ( .IN1(n986), .IN2(n697), .IN3(n1342), .IN4(n696), .Q(n698) );
  AO222X1 U860 ( .IN1(n699), .IN2(n1375), .IN3(n699), .IN4(n1313), .IN5(n1375), 
        .IN6(n698), .Q(n700) );
  NOR2X0 U861 ( .IN1(n701), .IN2(n700), .QN(n710) );
  INVX0 U862 ( .INP(n706), .ZN(n707) );
  INVX0 U863 ( .INP(n702), .ZN(n704) );
  NOR2X0 U864 ( .IN1(n704), .IN2(n703), .QN(n705) );
  MUX21X1 U865 ( .IN1(n707), .IN2(n706), .S(n705), .Q(n708) );
  NAND2X0 U866 ( .IN1(n1351), .IN2(n708), .QN(n709) );
  NAND2X0 U867 ( .IN1(n710), .IN2(n709), .QN(n550) );
  MUX21X1 U868 ( .IN1(stepSize[9]), .IN2(n1384), .S(n711), .Q(n715) );
  MUX21X1 U869 ( .IN1(stepSize[8]), .IN2(n1392), .S(n712), .Q(n714) );
  OAI22X1 U870 ( .IN1(n1322), .IN2(n715), .IN3(n1321), .IN4(n714), .QN(n713)
         );
  OA21X1 U871 ( .IN1(n978), .IN2(n713), .IN3(sampDiff[11]), .Q(n719) );
  AND2X1 U872 ( .IN1(n1290), .IN2(n1272), .Q(n717) );
  AO22X1 U873 ( .IN1(n986), .IN2(n715), .IN3(n1342), .IN4(n714), .Q(n716) );
  AO222X1 U874 ( .IN1(n717), .IN2(n1366), .IN3(n717), .IN4(n929), .IN5(n1366), 
        .IN6(n716), .Q(n718) );
  NOR2X0 U875 ( .IN1(n719), .IN2(n718), .QN(n728) );
  INVX0 U876 ( .INP(n724), .ZN(n725) );
  INVX0 U877 ( .INP(n720), .ZN(n722) );
  NOR2X0 U878 ( .IN1(n722), .IN2(n721), .QN(n723) );
  MUX21X1 U879 ( .IN1(n725), .IN2(n724), .S(n723), .Q(n726) );
  NAND2X0 U880 ( .IN1(n1351), .IN2(n726), .QN(n727) );
  INVX0 U881 ( .INP(n729), .ZN(n731) );
  NOR2X0 U882 ( .IN1(n731), .IN2(n730), .QN(n735) );
  MUX21X1 U883 ( .IN1(stepSize[6]), .IN2(n1394), .S(n732), .Q(n734) );
  OAI22X1 U884 ( .IN1(n1322), .IN2(n735), .IN3(n1321), .IN4(n734), .QN(n733)
         );
  OA21X1 U885 ( .IN1(n978), .IN2(n733), .IN3(sampDiff[9]), .Q(n739) );
  AND2X1 U886 ( .IN1(n1290), .IN2(n933), .Q(n737) );
  AO22X1 U887 ( .IN1(n986), .IN2(n735), .IN3(n1342), .IN4(n734), .Q(n736) );
  AO222X1 U888 ( .IN1(n737), .IN2(n1389), .IN3(n737), .IN4(n948), .IN5(n1389), 
        .IN6(n736), .Q(n738) );
  NOR2X0 U889 ( .IN1(n739), .IN2(n738), .QN(n748) );
  INVX0 U890 ( .INP(n744), .ZN(n745) );
  INVX0 U891 ( .INP(n740), .ZN(n742) );
  NOR2X0 U892 ( .IN1(n742), .IN2(n741), .QN(n743) );
  MUX21X1 U893 ( .IN1(n745), .IN2(n744), .S(n743), .Q(n746) );
  NAND2X0 U894 ( .IN1(n748), .IN2(n747), .QN(n556) );
  MUX21X1 U895 ( .IN1(stepSize[5]), .IN2(n1393), .S(n749), .Q(n753) );
  MUX21X1 U896 ( .IN1(stepSize[4]), .IN2(n1408), .S(n750), .Q(n752) );
  OAI22X1 U897 ( .IN1(n1322), .IN2(n753), .IN3(n1321), .IN4(n752), .QN(n751)
         );
  OA21X1 U898 ( .IN1(n978), .IN2(n751), .IN3(sampDiff[7]), .Q(n757) );
  AND2X1 U899 ( .IN1(n1290), .IN2(n952), .Q(n755) );
  AO22X1 U900 ( .IN1(n986), .IN2(n753), .IN3(n1342), .IN4(n752), .Q(n754) );
  AO222X1 U901 ( .IN1(n755), .IN2(n1372), .IN3(n755), .IN4(n967), .IN5(n1372), 
        .IN6(n754), .Q(n756) );
  NOR2X0 U902 ( .IN1(n757), .IN2(n756), .QN(n766) );
  INVX0 U903 ( .INP(n762), .ZN(n763) );
  INVX0 U904 ( .INP(n758), .ZN(n760) );
  NOR2X0 U905 ( .IN1(n760), .IN2(n759), .QN(n761) );
  MUX21X1 U906 ( .IN1(n763), .IN2(n762), .S(n761), .Q(n764) );
  NAND2X0 U907 ( .IN1(n1351), .IN2(n764), .QN(n765) );
  NAND2X0 U908 ( .IN1(n766), .IN2(n765), .QN(n558) );
  MUX21X1 U909 ( .IN1(stepSize[3]), .IN2(n1407), .S(n767), .Q(n771) );
  MUX21X1 U910 ( .IN1(stepSize[2]), .IN2(n1406), .S(n768), .Q(n770) );
  OAI22X1 U911 ( .IN1(n1322), .IN2(n771), .IN3(n1321), .IN4(n770), .QN(n769)
         );
  OA21X1 U912 ( .IN1(n978), .IN2(n769), .IN3(sampDiff[5]), .Q(n775) );
  AND2X1 U913 ( .IN1(n1290), .IN2(n971), .Q(n773) );
  AO22X1 U914 ( .IN1(n986), .IN2(n771), .IN3(n1342), .IN4(n770), .Q(n772) );
  AO222X1 U915 ( .IN1(n773), .IN2(n1371), .IN3(n773), .IN4(n785), .IN5(n1371), 
        .IN6(n772), .Q(n774) );
  NOR2X0 U916 ( .IN1(n775), .IN2(n774), .QN(n784) );
  INVX0 U917 ( .INP(n780), .ZN(n781) );
  INVX0 U918 ( .INP(n776), .ZN(n778) );
  NOR2X0 U919 ( .IN1(n778), .IN2(n777), .QN(n779) );
  MUX21X1 U920 ( .IN1(n781), .IN2(n780), .S(n779), .Q(n782) );
  NAND2X0 U921 ( .IN1(n784), .IN2(n783), .QN(n560) );
  INVX0 U922 ( .INP(n1290), .ZN(n1345) );
  OR2X1 U923 ( .IN1(n785), .IN2(n1345), .Q(n790) );
  MUX21X1 U924 ( .IN1(stepSize[2]), .IN2(n1406), .S(n786), .Q(n791) );
  INVX0 U925 ( .INP(n791), .ZN(n788) );
  AO221X1 U926 ( .IN1(n792), .IN2(stepSize[1]), .IN3(n976), .IN4(n1387), .IN5(
        n1334), .Q(n787) );
  OA21X1 U927 ( .IN1(n788), .IN2(n1322), .IN3(n787), .Q(n789) );
  AO222X1 U928 ( .IN1(sampDiff[4]), .IN2(n790), .IN3(sampDiff[4]), .IN4(n985), 
        .IN5(n790), .IN6(n789), .Q(n805) );
  NOR2X0 U929 ( .IN1(n791), .IN2(n1322), .QN(n795) );
  AO221X1 U930 ( .IN1(n792), .IN2(n1387), .IN3(n976), .IN4(stepSize[1]), .IN5(
        n1321), .Q(n793) );
  NAND2X0 U931 ( .IN1(n1324), .IN2(n793), .QN(n794) );
  NOR2X0 U932 ( .IN1(n795), .IN2(n794), .QN(n803) );
  INVX0 U933 ( .INP(n801), .ZN(n800) );
  INVX0 U934 ( .INP(n796), .ZN(n798) );
  NOR2X0 U935 ( .IN1(n798), .IN2(n797), .QN(n799) );
  MUX21X1 U936 ( .IN1(n801), .IN2(n800), .S(n799), .Q(n802) );
  OA22X1 U937 ( .IN1(n803), .IN2(n1379), .IN3(n1357), .IN4(n802), .Q(n804) );
  NAND2X0 U938 ( .IN1(n805), .IN2(n804), .QN(n561) );
  OA22X1 U939 ( .IN1(stepSize[0]), .IN2(n806), .IN3(n807), .IN4(n1243), .Q(
        n813) );
  NOR2X0 U940 ( .IN1(n997), .IN2(n1404), .QN(n809) );
  NAND2X0 U941 ( .IN1(n1356), .IN2(n982), .QN(n808) );
  NAND2X0 U942 ( .IN1(n1238), .IN2(n807), .QN(n1000) );
  OA22X1 U943 ( .IN1(n809), .IN2(n808), .IN3(sampDiff[2]), .IN4(n1000), .Q(
        n810) );
  OA222X1 U944 ( .IN1(n1416), .IN2(n813), .IN3(n1416), .IN4(n812), .IN5(n811), 
        .IN6(n810), .Q(n814) );
  NAND2X0 U945 ( .IN1(n988), .IN2(n986), .QN(n977) );
  INVX0 U946 ( .INP(n1356), .ZN(n996) );
  NAND2X0 U947 ( .IN1(pcmSq[1]), .IN2(pcmSq[2]), .QN(n1059) );
  NAND3X0 U948 ( .IN1(n996), .IN2(trojan_state[0]), .IN3(n1059), .QN(n815) );
  NOR2X0 U949 ( .IN1(n1422), .IN2(n816), .QN(n1355) );
  INVX0 U950 ( .INP(n1355), .ZN(n1360) );
  NOR2X0 U951 ( .IN1(n1419), .IN2(n1368), .QN(n817) );
  NOR2X0 U952 ( .IN1(n817), .IN2(n1383), .QN(n823) );
  OA221X1 U953 ( .IN1(prePCM[1]), .IN2(n1368), .IN3(n1419), .IN4(prePCM[0]), 
        .IN5(prePCM[2]), .Q(n1011) );
  NOR2X0 U954 ( .IN1(n1383), .IN2(n1368), .QN(n1014) );
  NAND2X0 U955 ( .IN1(n1383), .IN2(outStepIndex[0]), .QN(n1013) );
  OA21X1 U956 ( .IN1(n1014), .IN2(n1385), .IN3(n1013), .Q(n1010) );
  INVX0 U957 ( .INP(n818), .ZN(n819) );
  OA221X1 U958 ( .IN1(prePCM[2]), .IN2(n819), .IN3(n1383), .IN4(n818), .IN5(
        n1355), .Q(n1008) );
  FADDX1 U959 ( .A(prePCM[2]), .B(n1363), .CI(n820), .CO(n821), .S(n825) );
  FADDX1 U960 ( .A(prePCM[2]), .B(n1373), .CI(n821), .CO(n824), .S(n1009) );
  FADDX1 U961 ( .A(n1362), .B(n823), .CI(n822), .CO(n820), .S(n829) );
  FADDX1 U962 ( .A(prePCM[2]), .B(n1364), .CI(n824), .CO(n818), .S(n827) );
  AO221X1 U963 ( .IN1(n1009), .IN2(n825), .IN3(n1009), .IN4(n829), .IN5(n827), 
        .Q(n1007) );
  NAND2X0 U964 ( .IN1(n825), .IN2(n1007), .QN(n826) );
  AO22X1 U965 ( .IN1(outStepIndex[4]), .IN2(n1360), .IN3(n1008), .IN4(n826), 
        .Q(n527) );
  INVX0 U966 ( .INP(n827), .ZN(n828) );
  AO22X1 U967 ( .IN1(n828), .IN2(n1008), .IN3(n1360), .IN4(outStepIndex[6]), 
        .Q(n529) );
  NAND2X0 U968 ( .IN1(n829), .IN2(n1007), .QN(n830) );
  AO22X1 U969 ( .IN1(outStepIndex[3]), .IN2(n1360), .IN3(n1008), .IN4(n830), 
        .Q(n526) );
  XOR2X1 U970 ( .IN1(predictorSamp[18]), .IN2(prePCM[3]), .Q(n831) );
  XOR2X1 U971 ( .IN1(\DP_OP_36J1_122_4812/n2 ), .IN2(n831), .Q(n898) );
  INVX0 U972 ( .INP(n898), .ZN(n832) );
  NAND3X0 U973 ( .IN1(prePredSamp[18]), .IN2(n1355), .IN3(n832), .QN(n870) );
  OA21X1 U974 ( .IN1(prePredSamp[18]), .IN2(n832), .IN3(n1355), .Q(n867) );
  NAND2X0 U975 ( .IN1(predictorSamp[13]), .IN2(n1360), .QN(n833) );
  NAND3X0 U976 ( .IN1(n870), .IN2(n834), .IN3(n833), .QN(n594) );
  NAND2X0 U977 ( .IN1(n867), .IN2(prePredSamp[4]), .QN(n836) );
  NAND2X0 U978 ( .IN1(predictorSamp[4]), .IN2(n1360), .QN(n835) );
  NAND3X0 U979 ( .IN1(n870), .IN2(n836), .IN3(n835), .QN(n585) );
  NAND2X0 U980 ( .IN1(n867), .IN2(prePredSamp[17]), .QN(n838) );
  NAND2X0 U981 ( .IN1(predictorSamp[17]), .IN2(n1360), .QN(n837) );
  NAND3X0 U982 ( .IN1(n870), .IN2(n838), .IN3(n837), .QN(n601) );
  NAND2X0 U983 ( .IN1(n867), .IN2(prePredSamp[6]), .QN(n840) );
  NAND3X0 U984 ( .IN1(n870), .IN2(n840), .IN3(n839), .QN(n587) );
  NAND2X0 U985 ( .IN1(n867), .IN2(prePredSamp[3]), .QN(n842) );
  NAND2X0 U986 ( .IN1(predictorSamp[3]), .IN2(n1360), .QN(n841) );
  NAND3X0 U987 ( .IN1(n870), .IN2(n842), .IN3(n841), .QN(n584) );
  NAND2X0 U988 ( .IN1(n867), .IN2(prePredSamp[10]), .QN(n844) );
  NAND2X0 U989 ( .IN1(predictorSamp[10]), .IN2(n1360), .QN(n843) );
  NAND3X0 U990 ( .IN1(n870), .IN2(n844), .IN3(n843), .QN(n591) );
  NAND2X0 U991 ( .IN1(n867), .IN2(prePredSamp[9]), .QN(n846) );
  NAND2X0 U992 ( .IN1(predictorSamp[9]), .IN2(n1360), .QN(n845) );
  NAND3X0 U993 ( .IN1(n870), .IN2(n846), .IN3(n845), .QN(n590) );
  NAND2X0 U994 ( .IN1(n867), .IN2(prePredSamp[14]), .QN(n848) );
  NAND2X0 U995 ( .IN1(predictorSamp[14]), .IN2(n1360), .QN(n847) );
  NAND3X0 U996 ( .IN1(n870), .IN2(n848), .IN3(n847), .QN(n595) );
  NAND2X0 U997 ( .IN1(n867), .IN2(prePredSamp[2]), .QN(n850) );
  NAND2X0 U998 ( .IN1(predictorSamp[2]), .IN2(n1360), .QN(n849) );
  NAND3X0 U999 ( .IN1(n870), .IN2(n850), .IN3(n849), .QN(n583) );
  NAND2X0 U1000 ( .IN1(n867), .IN2(prePredSamp[8]), .QN(n852) );
  NAND2X0 U1001 ( .IN1(predictorSamp[8]), .IN2(n1360), .QN(n851) );
  NAND3X0 U1002 ( .IN1(n870), .IN2(n852), .IN3(n851), .QN(n589) );
  NAND2X0 U1003 ( .IN1(n867), .IN2(prePredSamp[16]), .QN(n854) );
  NAND2X0 U1004 ( .IN1(predictorSamp[16]), .IN2(n1360), .QN(n853) );
  NAND3X0 U1005 ( .IN1(n854), .IN2(n870), .IN3(n853), .QN(n597) );
  NAND2X0 U1006 ( .IN1(n867), .IN2(prePredSamp[1]), .QN(n856) );
  NAND2X0 U1007 ( .IN1(predictorSamp[1]), .IN2(n1360), .QN(n855) );
  NAND3X0 U1008 ( .IN1(n870), .IN2(n856), .IN3(n855), .QN(n582) );
  NAND2X0 U1009 ( .IN1(n867), .IN2(prePredSamp[11]), .QN(n858) );
  NAND2X0 U1010 ( .IN1(predictorSamp[11]), .IN2(n1360), .QN(n857) );
  NAND3X0 U1011 ( .IN1(n870), .IN2(n858), .IN3(n857), .QN(n592) );
  NAND2X0 U1012 ( .IN1(n867), .IN2(prePredSamp[0]), .QN(n860) );
  NAND2X0 U1013 ( .IN1(predictorSamp[0]), .IN2(n1360), .QN(n859) );
  NAND3X0 U1014 ( .IN1(n870), .IN2(n860), .IN3(n859), .QN(n599) );
  NAND2X0 U1015 ( .IN1(n867), .IN2(prePredSamp[7]), .QN(n862) );
  NAND2X0 U1016 ( .IN1(predictorSamp[7]), .IN2(n1360), .QN(n861) );
  NAND3X0 U1017 ( .IN1(n870), .IN2(n862), .IN3(n861), .QN(n588) );
  NAND2X0 U1018 ( .IN1(n867), .IN2(prePredSamp[15]), .QN(n864) );
  NAND2X0 U1019 ( .IN1(predictorSamp[15]), .IN2(n1360), .QN(n863) );
  NAND3X0 U1020 ( .IN1(n870), .IN2(n864), .IN3(n863), .QN(n596) );
  NAND2X0 U1021 ( .IN1(n867), .IN2(prePredSamp[5]), .QN(n866) );
  NAND2X0 U1022 ( .IN1(predictorSamp[5]), .IN2(n1360), .QN(n865) );
  NAND3X0 U1023 ( .IN1(n870), .IN2(n866), .IN3(n865), .QN(n586) );
  NAND2X0 U1024 ( .IN1(n867), .IN2(prePredSamp[12]), .QN(n869) );
  NAND2X0 U1025 ( .IN1(predictorSamp[12]), .IN2(n1360), .QN(n868) );
  NAND3X0 U1026 ( .IN1(n870), .IN2(n869), .IN3(n868), .QN(n593) );
  XOR2X1 U1027 ( .IN1(prePCM[3]), .IN2(dequantSamp[18]), .Q(
        \DP_OP_36J1_122_4812/n25 ) );
  MUX21X1 U1028 ( .IN1(n871), .IN2(prePCM[2]), .S(n1239), .Q(n534) );
  NOR2X0 U1029 ( .IN1(sampDiff[13]), .IN2(n1381), .QN(n889) );
  NOR2X0 U1030 ( .IN1(n1378), .IN2(stepSize[11]), .QN(n887) );
  NAND3X0 U1031 ( .IN1(sampDiff[11]), .IN2(n1374), .IN3(n872), .QN(n885) );
  OA21X1 U1032 ( .IN1(n1423), .IN2(n1387), .IN3(n987), .Q(n873) );
  OAI22X1 U1033 ( .IN1(sampDiff[2]), .IN2(n1387), .IN3(sampDiff[1]), .IN4(n873), .QN(n874) );
  AO222X1 U1034 ( .IN1(stepSize[2]), .IN2(n1377), .IN3(stepSize[2]), .IN4(n874), .IN5(n1377), .IN6(n874), .Q(n875) );
  AO222X1 U1035 ( .IN1(stepSize[3]), .IN2(n1379), .IN3(stepSize[3]), .IN4(n875), .IN5(n1379), .IN6(n875), .Q(n876) );
  AO222X1 U1036 ( .IN1(stepSize[4]), .IN2(n876), .IN3(stepSize[4]), .IN4(n1371), .IN5(n876), .IN6(n1371), .Q(n877) );
  AO222X1 U1037 ( .IN1(stepSize[5]), .IN2(n1380), .IN3(stepSize[5]), .IN4(n877), .IN5(n1380), .IN6(n877), .Q(n878) );
  AO222X1 U1038 ( .IN1(stepSize[6]), .IN2(n878), .IN3(stepSize[6]), .IN4(n1372), .IN5(n878), .IN6(n1372), .Q(n879) );
  AO222X1 U1039 ( .IN1(stepSize[7]), .IN2(n1386), .IN3(stepSize[7]), .IN4(n879), .IN5(n1386), .IN6(n879), .Q(n880) );
  AO222X1 U1040 ( .IN1(stepSize[8]), .IN2(n880), .IN3(stepSize[8]), .IN4(n1389), .IN5(n880), .IN6(n1389), .Q(n882) );
  OR2X1 U1041 ( .IN1(stepSize[9]), .IN2(n882), .Q(n883) );
  AO22X1 U1042 ( .IN1(stepSize[11]), .IN2(n1378), .IN3(stepSize[10]), .IN4(
        n1366), .Q(n881) );
  AO221X1 U1043 ( .IN1(n883), .IN2(n1401), .IN3(n882), .IN4(stepSize[9]), 
        .IN5(n881), .Q(n884) );
  NAND2X0 U1044 ( .IN1(n885), .IN2(n884), .QN(n886) );
  NOR2X0 U1045 ( .IN1(n887), .IN2(n886), .QN(n888) );
  OA222X1 U1046 ( .IN1(n1367), .IN2(stepSize[13]), .IN3(n1402), .IN4(
        stepSize[12]), .IN5(n889), .IN6(n888), .Q(n891) );
  AO22X1 U1047 ( .IN1(stepSize[14]), .IN2(n1375), .IN3(stepSize[13]), .IN4(
        n1367), .Q(n890) );
  OA22X1 U1048 ( .IN1(n891), .IN2(n890), .IN3(stepSize[14]), .IN4(n1375), .Q(
        n893) );
  NAND3X0 U1049 ( .IN1(n893), .IN2(n892), .IN3(n1391), .QN(n894) );
  NAND2X0 U1050 ( .IN1(n894), .IN2(n1240), .QN(n899) );
  AND4X1 U1051 ( .IN1(n1334), .IN2(n895), .IN3(n1243), .IN4(n899), .Q(n1236)
         );
  NOR2X0 U1052 ( .IN1(n896), .IN2(n1240), .QN(n1057) );
  NOR2X0 U1053 ( .IN1(n1236), .IN2(n1057), .QN(n1237) );
  AO22X1 U1054 ( .IN1(n1237), .IN2(\C42/DATA2_15 ), .IN3(n1236), .IN4(
        dequantSamp[15]), .Q(n566) );
  AO22X1 U1055 ( .IN1(n1237), .IN2(\C42/DATA2_16 ), .IN3(n1236), .IN4(
        dequantSamp[16]), .Q(n565) );
  AO22X1 U1056 ( .IN1(n1237), .IN2(\C42/DATA2_17 ), .IN3(n1236), .IN4(
        dequantSamp[17]), .Q(n564) );
  XOR2X1 U1057 ( .IN1(\DP_OP_73J1_125_3932/n1 ), .IN2(dequantSamp[18]), .Q(
        n897) );
  AO22X1 U1058 ( .IN1(n1237), .IN2(n897), .IN3(n1236), .IN4(dequantSamp[18]), 
        .Q(n602) );
  AO22X1 U1059 ( .IN1(n1242), .IN2(stepSize[14]), .IN3(stepSize[13]), .IN4(
        n1241), .Q(\C1/Z_16 ) );
  MUX21X1 U1060 ( .IN1(predictorSamp[18]), .IN2(n898), .S(n1355), .Q(n598) );
  OAI21X1 U1061 ( .IN1(n1240), .IN2(n1368), .IN3(n899), .QN(n536) );
  XOR2X1 U1062 ( .IN1(prePCM[3]), .IN2(\C42/DATA2_0 ), .Q(
        \DP_OP_36J1_122_4812/n43 ) );
  XOR2X1 U1063 ( .IN1(prePCM[3]), .IN2(dequantSamp[1]), .Q(
        \DP_OP_36J1_122_4812/n42 ) );
  XOR2X1 U1064 ( .IN1(prePCM[3]), .IN2(dequantSamp[2]), .Q(
        \DP_OP_36J1_122_4812/n41 ) );
  XOR2X1 U1065 ( .IN1(prePCM[3]), .IN2(dequantSamp[3]), .Q(
        \DP_OP_36J1_122_4812/n40 ) );
  XOR2X1 U1066 ( .IN1(prePCM[3]), .IN2(dequantSamp[4]), .Q(
        \DP_OP_36J1_122_4812/n39 ) );
  XOR2X1 U1067 ( .IN1(prePCM[3]), .IN2(dequantSamp[5]), .Q(
        \DP_OP_36J1_122_4812/n38 ) );
  XOR2X1 U1068 ( .IN1(prePCM[3]), .IN2(dequantSamp[6]), .Q(
        \DP_OP_36J1_122_4812/n37 ) );
  XOR2X1 U1069 ( .IN1(prePCM[3]), .IN2(dequantSamp[7]), .Q(
        \DP_OP_36J1_122_4812/n36 ) );
  XOR2X1 U1070 ( .IN1(prePCM[3]), .IN2(dequantSamp[8]), .Q(
        \DP_OP_36J1_122_4812/n35 ) );
  XOR2X1 U1071 ( .IN1(prePCM[3]), .IN2(dequantSamp[9]), .Q(
        \DP_OP_36J1_122_4812/n34 ) );
  XOR2X1 U1072 ( .IN1(prePCM[3]), .IN2(dequantSamp[10]), .Q(
        \DP_OP_36J1_122_4812/n33 ) );
  XOR2X1 U1073 ( .IN1(prePCM[3]), .IN2(dequantSamp[11]), .Q(
        \DP_OP_36J1_122_4812/n32 ) );
  XOR2X1 U1074 ( .IN1(prePCM[3]), .IN2(dequantSamp[12]), .Q(
        \DP_OP_36J1_122_4812/n31 ) );
  XOR2X1 U1075 ( .IN1(prePCM[3]), .IN2(dequantSamp[13]), .Q(
        \DP_OP_36J1_122_4812/n30 ) );
  XOR2X1 U1076 ( .IN1(prePCM[3]), .IN2(dequantSamp[14]), .Q(
        \DP_OP_36J1_122_4812/n29 ) );
  XOR2X1 U1077 ( .IN1(prePCM[3]), .IN2(dequantSamp[15]), .Q(
        \DP_OP_36J1_122_4812/n28 ) );
  XOR2X1 U1078 ( .IN1(prePCM[3]), .IN2(dequantSamp[16]), .Q(
        \DP_OP_36J1_122_4812/n27 ) );
  XOR2X1 U1079 ( .IN1(prePCM[3]), .IN2(dequantSamp[17]), .Q(
        \DP_OP_36J1_122_4812/n26 ) );
  MUX21X1 U1080 ( .IN1(n1421), .IN2(stepSize[14]), .S(n900), .Q(n912) );
  MUX21X1 U1081 ( .IN1(n1390), .IN2(stepSize[13]), .S(n901), .Q(n911) );
  AOI22X1 U1082 ( .IN1(n912), .IN2(n986), .IN3(n911), .IN4(n1342), .QN(n902)
         );
  AO21X1 U1083 ( .IN1(n902), .IN2(n1324), .IN3(n1391), .Q(n918) );
  INVX0 U1084 ( .INP(n907), .ZN(n908) );
  INVX0 U1085 ( .INP(n903), .ZN(n905) );
  NOR2X0 U1086 ( .IN1(n905), .IN2(n904), .QN(n906) );
  MUX21X1 U1087 ( .IN1(n908), .IN2(n907), .S(n906), .Q(n909) );
  NAND2X0 U1088 ( .IN1(n909), .IN2(n1351), .QN(n917) );
  OR2X1 U1089 ( .IN1(n910), .IN2(n1345), .Q(n915) );
  OA22X1 U1090 ( .IN1(n1322), .IN2(n912), .IN3(n1334), .IN4(n911), .Q(n913) );
  AO222X1 U1091 ( .IN1(sampDiff[16]), .IN2(n915), .IN3(sampDiff[16]), .IN4(
        n914), .IN5(n915), .IN6(n913), .Q(n916) );
  NAND3X0 U1092 ( .IN1(n918), .IN2(n917), .IN3(n916), .QN(n549) );
  MUX21X1 U1093 ( .IN1(n1405), .IN2(stepSize[7]), .S(n919), .Q(n930) );
  MUX21X1 U1094 ( .IN1(stepSize[8]), .IN2(n1392), .S(n920), .Q(n931) );
  AOI22X1 U1095 ( .IN1(n930), .IN2(n1342), .IN3(n986), .IN4(n931), .QN(n921)
         );
  AO21X1 U1096 ( .IN1(n921), .IN2(n1324), .IN3(n1401), .Q(n937) );
  INVX0 U1097 ( .INP(n926), .ZN(n927) );
  INVX0 U1098 ( .INP(n922), .ZN(n924) );
  NOR2X0 U1099 ( .IN1(n924), .IN2(n923), .QN(n925) );
  MUX21X1 U1100 ( .IN1(n927), .IN2(n926), .S(n925), .Q(n928) );
  NAND2X0 U1101 ( .IN1(n928), .IN2(n1351), .QN(n936) );
  OR2X1 U1102 ( .IN1(n929), .IN2(n1345), .Q(n934) );
  OA22X1 U1103 ( .IN1(n931), .IN2(n1322), .IN3(n1334), .IN4(n930), .Q(n932) );
  AO222X1 U1104 ( .IN1(sampDiff[10]), .IN2(n934), .IN3(sampDiff[10]), .IN4(
        n933), .IN5(n934), .IN6(n932), .Q(n935) );
  NAND3X0 U1105 ( .IN1(n937), .IN2(n936), .IN3(n935), .QN(n555) );
  MUX21X1 U1106 ( .IN1(n1394), .IN2(stepSize[6]), .S(n938), .Q(n949) );
  MUX21X1 U1107 ( .IN1(n1393), .IN2(stepSize[5]), .S(n939), .Q(n950) );
  AOI22X1 U1108 ( .IN1(n949), .IN2(n986), .IN3(n1342), .IN4(n950), .QN(n940)
         );
  AO21X1 U1109 ( .IN1(n940), .IN2(n1324), .IN3(n1386), .Q(n956) );
  INVX0 U1110 ( .INP(n945), .ZN(n946) );
  INVX0 U1111 ( .INP(n941), .ZN(n943) );
  NOR2X0 U1112 ( .IN1(n943), .IN2(n942), .QN(n944) );
  MUX21X1 U1113 ( .IN1(n946), .IN2(n945), .S(n944), .Q(n947) );
  NAND2X0 U1114 ( .IN1(n947), .IN2(n1351), .QN(n955) );
  OR2X1 U1115 ( .IN1(n948), .IN2(n1345), .Q(n953) );
  OA22X1 U1116 ( .IN1(n950), .IN2(n1321), .IN3(n1322), .IN4(n949), .Q(n951) );
  AO222X1 U1117 ( .IN1(sampDiff[8]), .IN2(n953), .IN3(sampDiff[8]), .IN4(n952), 
        .IN5(n953), .IN6(n951), .Q(n954) );
  NAND3X0 U1118 ( .IN1(n956), .IN2(n955), .IN3(n954), .QN(n557) );
  MUX21X1 U1119 ( .IN1(n1407), .IN2(stepSize[3]), .S(n957), .Q(n968) );
  MUX21X1 U1120 ( .IN1(n1408), .IN2(stepSize[4]), .S(n958), .Q(n969) );
  AOI22X1 U1121 ( .IN1(n968), .IN2(n1342), .IN3(n969), .IN4(n986), .QN(n959)
         );
  AO21X1 U1122 ( .IN1(n959), .IN2(n1324), .IN3(n1380), .Q(n975) );
  INVX0 U1123 ( .INP(n964), .ZN(n965) );
  INVX0 U1124 ( .INP(n960), .ZN(n962) );
  NOR2X0 U1125 ( .IN1(n962), .IN2(n961), .QN(n963) );
  MUX21X1 U1126 ( .IN1(n965), .IN2(n964), .S(n963), .Q(n966) );
  NAND2X0 U1127 ( .IN1(n966), .IN2(n1351), .QN(n974) );
  OR2X1 U1128 ( .IN1(n967), .IN2(n1345), .Q(n972) );
  OA22X1 U1129 ( .IN1(n1322), .IN2(n969), .IN3(n1321), .IN4(n968), .Q(n970) );
  AO222X1 U1130 ( .IN1(sampDiff[6]), .IN2(n972), .IN3(sampDiff[6]), .IN4(n971), 
        .IN5(n972), .IN6(n970), .Q(n973) );
  NAND3X0 U1131 ( .IN1(n975), .IN2(n974), .IN3(n973), .QN(n559) );
  NOR2X0 U1132 ( .IN1(n976), .IN2(n1321), .QN(n995) );
  INVX0 U1133 ( .INP(n977), .ZN(n980) );
  NOR2X0 U1134 ( .IN1(n988), .IN2(n1322), .QN(n979) );
  AO221X1 U1135 ( .IN1(stepSize[1]), .IN2(n980), .IN3(n1387), .IN4(n979), 
        .IN5(n978), .Q(n981) );
  OA221X1 U1136 ( .IN1(n981), .IN2(n1342), .IN3(n981), .IN4(n1423), .IN5(
        sampDiff[3]), .Q(n994) );
  FADDX1 U1137 ( .A(predictorSamp[3]), .B(n983), .CI(n982), .CO(n801), .S(n984) );
  NOR2X0 U1138 ( .IN1(n984), .IN2(n1357), .QN(n993) );
  AND2X1 U1139 ( .IN1(n1290), .IN2(n985), .Q(n991) );
  OA221X1 U1140 ( .IN1(n988), .IN2(stepSize[1]), .IN3(n987), .IN4(n1387), 
        .IN5(n986), .Q(n989) );
  AO222X1 U1141 ( .IN1(n991), .IN2(n1377), .IN3(n991), .IN4(n990), .IN5(n1377), 
        .IN6(n989), .Q(n992) );
  OR4X1 U1142 ( .IN1(n995), .IN2(n994), .IN3(n993), .IN4(n992), .Q(n562) );
  NOR2X0 U1143 ( .IN1(n997), .IN2(n996), .QN(n999) );
  NAND2X0 U1144 ( .IN1(predictorSamp[1]), .IN2(predictorSamp[0]), .QN(n998) );
  AO21X1 U1145 ( .IN1(sampDiff[1]), .IN2(N176), .IN3(n1000), .Q(n1001) );
  NAND2X0 U1146 ( .IN1(n1002), .IN2(n1001), .QN(n1004) );
  MUX21X1 U1147 ( .IN1(n1004), .IN2(sampDiff[1]), .S(n1003), .Q(n537) );
  AO22X1 U1148 ( .IN1(n1351), .IN2(predictorSamp[0]), .IN3(N176), .IN4(n1357), 
        .Q(n538) );
  NOR2X0 U1149 ( .IN1(trojan_state[1]), .IN2(n1059), .QN(n1005) );
  MUX21X1 U1150 ( .IN1(n1005), .IN2(trojan_state[1]), .S(trojan_state[0]), .Q(
        n543) );
  NOR2X0 U1151 ( .IN1(trojan_state[0]), .IN2(n1420), .QN(n1006) );
  OR2X1 U1152 ( .IN1(n1006), .IN2(trojan_ena), .Q(n541) );
  MUX21X1 U1153 ( .IN1(prePCM[3]), .IN2(outPCM[3]), .S(n1360), .Q(n540) );
  MUX21X1 U1154 ( .IN1(prePCM[2]), .IN2(outPCM[2]), .S(n1360), .Q(n533) );
  MUX21X1 U1155 ( .IN1(prePCM[1]), .IN2(outPCM[1]), .S(n1360), .Q(n531) );
  MUX21X1 U1156 ( .IN1(prePCM[0]), .IN2(outPCM[0]), .S(n1360), .Q(n535) );
  OR2X1 U1157 ( .IN1(n1355), .IN2(trojan_ena), .Q(N430) );
  AO22X1 U1158 ( .IN1(n1242), .IN2(stepSize[0]), .IN3(n1240), .IN4(stepSize[1]), .Q(\C1/Z_2 ) );
  OAI22X1 U1159 ( .IN1(n1009), .IN2(n1358), .IN3(n1355), .IN4(n1373), .QN(n528) );
  FADDX1 U1160 ( .A(n1370), .B(n1011), .CI(n1010), .CO(n822), .S(n1012) );
  OAI22X1 U1161 ( .IN1(n1355), .IN2(n1370), .IN3(n1012), .IN4(n1358), .QN(n525) );
  INVX0 U1162 ( .INP(n1013), .ZN(n1359) );
  NOR2X0 U1163 ( .IN1(n1359), .IN2(n1014), .QN(n1015) );
  MUX21X1 U1164 ( .IN1(n1385), .IN2(outStepIndex[1]), .S(n1015), .Q(n1016) );
  OAI22X1 U1165 ( .IN1(n1355), .IN2(n1385), .IN3(n1358), .IN4(n1016), .QN(n524) );
  NAND2X0 U1166 ( .IN1(outStepIndex[1]), .IN2(outStepIndex[2]), .QN(n1164) );
  NOR2X0 U1167 ( .IN1(n1365), .IN2(n1164), .QN(n1110) );
  INVX0 U1168 ( .INP(n1110), .ZN(n1036) );
  NAND3X0 U1169 ( .IN1(outStepIndex[6]), .IN2(n1362), .IN3(n1363), .QN(n1163)
         );
  NOR2X0 U1170 ( .IN1(n1362), .IN2(n1364), .QN(n1147) );
  INVX0 U1171 ( .INP(n1147), .ZN(n1192) );
  NOR2X0 U1172 ( .IN1(n1164), .IN2(outStepIndex[0]), .QN(n1033) );
  INVX0 U1173 ( .INP(n1033), .ZN(n1191) );
  OA22X1 U1174 ( .IN1(n1036), .IN2(n1163), .IN3(n1192), .IN4(n1191), .Q(n1160)
         );
  NAND3X0 U1175 ( .IN1(outStepIndex[3]), .IN2(outStepIndex[4]), .IN3(
        outStepIndex[5]), .QN(n1174) );
  NAND2X0 U1176 ( .IN1(n1385), .IN2(outStepIndex[0]), .QN(n1125) );
  NOR2X0 U1177 ( .IN1(n1370), .IN2(n1125), .QN(n1193) );
  INVX0 U1178 ( .INP(n1193), .ZN(n1167) );
  NOR2X0 U1179 ( .IN1(outStepIndex[0]), .IN2(outStepIndex[1]), .QN(n1208) );
  NAND2X0 U1180 ( .IN1(outStepIndex[2]), .IN2(n1208), .QN(n1066) );
  NAND2X0 U1181 ( .IN1(n1363), .IN2(outStepIndex[5]), .QN(n1168) );
  NOR2X0 U1182 ( .IN1(n1362), .IN2(n1168), .QN(n1109) );
  INVX0 U1183 ( .INP(n1109), .ZN(n1222) );
  OA22X1 U1184 ( .IN1(n1174), .IN2(n1167), .IN3(n1066), .IN4(n1222), .Q(n1018)
         );
  NOR2X0 U1185 ( .IN1(n1385), .IN2(outStepIndex[2]), .QN(n1121) );
  INVX0 U1186 ( .INP(n1121), .ZN(n1098) );
  NOR2X0 U1187 ( .IN1(n1365), .IN2(n1098), .QN(n1219) );
  INVX0 U1188 ( .INP(n1219), .ZN(n1148) );
  AO21X1 U1189 ( .IN1(n1222), .IN2(n1163), .IN3(n1148), .Q(n1017) );
  NAND2X0 U1190 ( .IN1(outStepIndex[4]), .IN2(outStepIndex[6]), .QN(n1173) );
  INVX0 U1191 ( .INP(n1173), .ZN(n1194) );
  NAND2X0 U1192 ( .IN1(n1194), .IN2(n1033), .QN(n1215) );
  AND4X1 U1193 ( .IN1(n1160), .IN2(n1018), .IN3(n1017), .IN4(n1215), .Q(n1103)
         );
  NOR2X0 U1194 ( .IN1(n1222), .IN2(n1191), .QN(n1157) );
  NAND4X0 U1195 ( .IN1(outStepIndex[4]), .IN2(n1362), .IN3(n1373), .IN4(n1364), 
        .QN(n1138) );
  NOR2X0 U1196 ( .IN1(n1036), .IN2(n1138), .QN(n1020) );
  INVX0 U1197 ( .INP(n1066), .ZN(n1184) );
  NOR2X0 U1198 ( .IN1(n1110), .IN2(n1184), .QN(n1190) );
  NOR2X0 U1199 ( .IN1(n1190), .IN2(n1192), .QN(n1019) );
  OA22X1 U1200 ( .IN1(n1363), .IN2(n1192), .IN3(n1373), .IN4(n1364), .Q(n1076)
         );
  INVX0 U1201 ( .INP(n1076), .ZN(n1060) );
  NOR4X0 U1202 ( .IN1(n1157), .IN2(n1020), .IN3(n1019), .IN4(n1060), .QN(n1214) );
  NOR2X0 U1203 ( .IN1(outStepIndex[5]), .IN2(outStepIndex[6]), .QN(n1047) );
  NOR2X0 U1204 ( .IN1(n1363), .IN2(n1189), .QN(n1185) );
  OA21X1 U1205 ( .IN1(n1219), .IN2(n1208), .IN3(n1185), .Q(n1029) );
  NAND2X0 U1206 ( .IN1(n1365), .IN2(n1121), .QN(n1149) );
  INVX0 U1207 ( .INP(n1149), .ZN(n1196) );
  NOR2X0 U1208 ( .IN1(n1196), .IN2(n1110), .QN(n1021) );
  NOR2X0 U1209 ( .IN1(n1021), .IN2(n1173), .QN(n1028) );
  NOR2X0 U1210 ( .IN1(n1021), .IN2(n1174), .QN(n1022) );
  NOR2X0 U1211 ( .IN1(n1173), .IN2(n1148), .QN(n1038) );
  NOR2X0 U1212 ( .IN1(n1173), .IN2(n1066), .QN(n1124) );
  NOR2X0 U1213 ( .IN1(outStepIndex[1]), .IN2(outStepIndex[2]), .QN(n1105) );
  NAND2X0 U1214 ( .IN1(n1105), .IN2(n1365), .QN(n1137) );
  NOR2X0 U1215 ( .IN1(n1137), .IN2(n1192), .QN(n1040) );
  NOR4X0 U1216 ( .IN1(n1022), .IN2(n1038), .IN3(n1124), .IN4(n1040), .QN(n1091) );
  INVX0 U1217 ( .INP(n1125), .ZN(n1225) );
  NOR2X0 U1218 ( .IN1(n1196), .IN2(n1225), .QN(n1032) );
  INVX0 U1219 ( .INP(n1185), .ZN(n1223) );
  INVX0 U1220 ( .INP(n1168), .ZN(n1221) );
  NAND2X0 U1221 ( .IN1(n1362), .IN2(n1221), .QN(n1166) );
  OA21X1 U1222 ( .IN1(n1163), .IN2(n1137), .IN3(n1073), .Q(n1205) );
  OA221X1 U1223 ( .IN1(n1166), .IN2(n1148), .IN3(n1166), .IN4(n1167), .IN5(
        n1205), .Q(n1023) );
  OA21X1 U1224 ( .IN1(n1032), .IN2(n1223), .IN3(n1023), .Q(n1025) );
  NAND2X0 U1225 ( .IN1(n1105), .IN2(n1109), .QN(n1024) );
  INVX0 U1226 ( .INP(n1137), .ZN(n1227) );
  NAND3X0 U1227 ( .IN1(outStepIndex[4]), .IN2(outStepIndex[5]), .IN3(n1362), 
        .QN(n1162) );
  INVX0 U1228 ( .INP(n1162), .ZN(n1195) );
  NAND2X0 U1229 ( .IN1(n1227), .IN2(n1195), .QN(n1117) );
  NAND4X0 U1230 ( .IN1(n1091), .IN2(n1025), .IN3(n1024), .IN4(n1117), .QN(
        n1144) );
  NAND2X0 U1231 ( .IN1(n1121), .IN2(n1195), .QN(n1086) );
  INVX0 U1232 ( .INP(n1166), .ZN(n1146) );
  INVX0 U1233 ( .INP(n1174), .ZN(n1201) );
  NAND2X0 U1234 ( .IN1(n1201), .IN2(n1184), .QN(n1129) );
  INVX0 U1235 ( .INP(n1163), .ZN(n1088) );
  NAND2X0 U1236 ( .IN1(n1225), .IN2(n1088), .QN(n1026) );
  NAND4X0 U1237 ( .IN1(n1086), .IN2(n1116), .IN3(n1129), .IN4(n1026), .QN(
        n1027) );
  NOR4X0 U1238 ( .IN1(n1029), .IN2(n1028), .IN3(n1144), .IN4(n1027), .QN(n1030) );
  NAND3X0 U1239 ( .IN1(n1103), .IN2(n1214), .IN3(n1030), .QN(n607) );
  NOR2X0 U1240 ( .IN1(n1227), .IN2(n1193), .QN(n1031) );
  OA22X1 U1241 ( .IN1(n1032), .IN2(n1166), .IN3(n1031), .IN4(n1163), .Q(n1035)
         );
  NAND2X0 U1242 ( .IN1(n1201), .IN2(n1033), .QN(n1143) );
  NAND2X0 U1243 ( .IN1(n1184), .IN2(n1109), .QN(n1034) );
  AND3X1 U1244 ( .IN1(n1035), .IN2(n1143), .IN3(n1034), .Q(n1108) );
  NAND2X0 U1245 ( .IN1(outStepIndex[0]), .IN2(n1105), .QN(n1104) );
  OA22X1 U1246 ( .IN1(n1036), .IN2(n1223), .IN3(n1163), .IN4(n1104), .Q(n1046)
         );
  NOR2X0 U1247 ( .IN1(n1162), .IN2(n1104), .QN(n1156) );
  NAND2X0 U1248 ( .IN1(n1227), .IN2(n1146), .QN(n1142) );
  OA21X1 U1249 ( .IN1(n1167), .IN2(n1162), .IN3(n1142), .Q(n1112) );
  NOR2X0 U1250 ( .IN1(n1149), .IN2(n1162), .QN(n1037) );
  NOR2X0 U1251 ( .IN1(n1038), .IN2(n1037), .QN(n1135) );
  NOR2X0 U1252 ( .IN1(n1148), .IN2(n1163), .QN(n1039) );
  NOR2X0 U1253 ( .IN1(n1040), .IN2(n1039), .QN(n1068) );
  NAND3X0 U1254 ( .IN1(n1112), .IN2(n1135), .IN3(n1068), .QN(n1044) );
  INVX0 U1255 ( .INP(n1164), .ZN(n1111) );
  NOR2X0 U1256 ( .IN1(outStepIndex[4]), .IN2(n1189), .QN(n1220) );
  AO22X1 U1257 ( .IN1(n1111), .IN2(n1220), .IN3(n1194), .IN4(n1186), .Q(n1043)
         );
  INVX0 U1258 ( .INP(n1138), .ZN(n1207) );
  NAND3X0 U1259 ( .IN1(n1047), .IN2(n1362), .IN3(n1363), .QN(n1187) );
  INVX0 U1260 ( .INP(n1187), .ZN(n1218) );
  NOR2X0 U1261 ( .IN1(n1111), .IN2(n1193), .QN(n1065) );
  INVX0 U1262 ( .INP(n1065), .ZN(n1092) );
  AO22X1 U1263 ( .IN1(n1207), .IN2(n1041), .IN3(n1218), .IN4(n1092), .Q(n1042)
         );
  NOR4X0 U1264 ( .IN1(n1156), .IN2(n1044), .IN3(n1043), .IN4(n1042), .QN(n1045) );
  NAND4X0 U1265 ( .IN1(n1108), .IN2(n1046), .IN3(n1045), .IN4(n1073), .QN(
        n1177) );
  NAND3X0 U1266 ( .IN1(n1196), .IN2(outStepIndex[4]), .IN3(n1047), .QN(n1048)
         );
  OA221X1 U1267 ( .IN1(n1104), .IN2(n1174), .IN3(n1104), .IN4(n1187), .IN5(
        n1048), .Q(n1051) );
  INVX0 U1268 ( .INP(n1208), .ZN(n1188) );
  OA22X1 U1269 ( .IN1(n1188), .IN2(n1223), .IN3(n1066), .IN4(n1192), .Q(n1050)
         );
  NOR2X0 U1270 ( .IN1(n1121), .IN2(n1184), .QN(n1061) );
  INVX0 U1271 ( .INP(n1220), .ZN(n1165) );
  OA22X1 U1272 ( .IN1(n1061), .IN2(n1187), .IN3(n1167), .IN4(n1165), .Q(n1049)
         );
  NOR2X0 U1273 ( .IN1(n1149), .IN2(n1163), .QN(n1084) );
  INVX0 U1274 ( .INP(n1084), .ZN(n1152) );
  NAND4X0 U1275 ( .IN1(n1051), .IN2(n1050), .IN3(n1049), .IN4(n1152), .QN(
        n1053) );
  AO21X1 U1276 ( .IN1(n1196), .IN2(n1109), .IN3(n1060), .Q(n1155) );
  NAND2X0 U1277 ( .IN1(n1194), .IN2(n1227), .QN(n1141) );
  OA21X1 U1278 ( .IN1(n1192), .IN2(n1164), .IN3(n1141), .Q(n1070) );
  INVX0 U1279 ( .INP(n1070), .ZN(n1052) );
  OR4X1 U1280 ( .IN1(n1177), .IN2(n1053), .IN3(n1155), .IN4(n1052), .Q(n609)
         );
  NAND3X0 U1281 ( .IN1(predictorSamp[4]), .IN2(predictorSamp[2]), .IN3(
        predictorSamp[3]), .QN(n1256) );
  NOR2X0 U1282 ( .IN1(n1395), .IN2(n1256), .QN(n1255) );
  NOR2X0 U1283 ( .IN1(n1396), .IN2(n1254), .QN(n1253) );
  NAND2X0 U1284 ( .IN1(predictorSamp[8]), .IN2(n1253), .QN(n1252) );
  NOR2X0 U1285 ( .IN1(n1397), .IN2(n1252), .QN(n1251) );
  NAND2X0 U1286 ( .IN1(predictorSamp[10]), .IN2(n1251), .QN(n1250) );
  NOR2X0 U1287 ( .IN1(n1398), .IN2(n1250), .QN(n1249) );
  NAND2X0 U1288 ( .IN1(predictorSamp[12]), .IN2(n1249), .QN(n1248) );
  NOR2X0 U1289 ( .IN1(n1399), .IN2(n1248), .QN(n1247) );
  NAND2X0 U1290 ( .IN1(predictorSamp[14]), .IN2(n1247), .QN(n1246) );
  NOR2X0 U1291 ( .IN1(n1400), .IN2(n1246), .QN(n1245) );
  NAND2X0 U1292 ( .IN1(predictorSamp[16]), .IN2(n1245), .QN(n1244) );
  NOR2X0 U1293 ( .IN1(n1388), .IN2(n1244), .QN(n1054) );
  MUX21X1 U1294 ( .IN1(predictorSamp[18]), .IN2(n1417), .S(n1054), .Q(
        outPredictSamp[15]) );
  MUX21X1 U1295 ( .IN1(n1395), .IN2(predictorSamp[5]), .S(n1256), .Q(
        outPredictSamp[2]) );
  MUX21X1 U1296 ( .IN1(n1396), .IN2(predictorSamp[7]), .S(n1254), .Q(
        outPredictSamp[4]) );
  MUX21X1 U1297 ( .IN1(n1397), .IN2(predictorSamp[9]), .S(n1252), .Q(
        outPredictSamp[6]) );
  MUX21X1 U1298 ( .IN1(n1398), .IN2(predictorSamp[11]), .S(n1250), .Q(
        outPredictSamp[8]) );
  MUX21X1 U1299 ( .IN1(n1399), .IN2(predictorSamp[13]), .S(n1248), .Q(
        outPredictSamp[10]) );
  MUX21X1 U1300 ( .IN1(n1400), .IN2(predictorSamp[15]), .S(n1246), .Q(
        outPredictSamp[12]) );
  MUX21X1 U1301 ( .IN1(n1388), .IN2(predictorSamp[17]), .S(n1244), .Q(
        outPredictSamp[14]) );
  MUX21X1 U1302 ( .IN1(predictorSamp[2]), .IN2(n1404), .S(predictorSamp[3]), 
        .Q(outPredictSamp[0]) );
  NOR2X0 U1303 ( .IN1(n1055), .IN2(n1423), .QN(n1216) );
  AND2X1 U1304 ( .IN1(dequantSamp[1]), .IN2(n1216), .Q(n1403) );
  INVX0 U1305 ( .INP(inValid), .ZN(n1056) );
  NAND2X0 U1306 ( .IN1(n1057), .IN2(n1056), .QN(n1058) );
  AND3X1 U1307 ( .IN1(n1059), .IN2(n1418), .IN3(n1058), .Q(n546) );
  AO21X1 U1308 ( .IN1(n1137), .IN2(n1194), .IN3(n1060), .Q(n621) );
  AO222X1 U1309 ( .IN1(stepSize[14]), .IN2(n1238), .IN3(n1237), .IN4(
        \C42/DATA2_14 ), .IN5(n1236), .IN6(dequantSamp[14]), .Q(n567) );
  NOR2X0 U1310 ( .IN1(n1192), .IN2(n1061), .QN(n1063) );
  NAND3X0 U1311 ( .IN1(outStepIndex[0]), .IN2(outStepIndex[2]), .IN3(n1194), 
        .QN(n1128) );
  NOR2X0 U1312 ( .IN1(n1063), .IN2(n1062), .QN(n1064) );
  NAND4X0 U1313 ( .IN1(n1070), .IN2(n1064), .IN3(n1215), .IN4(n1073), .QN(n620) );
  AO222X1 U1314 ( .IN1(stepSize[13]), .IN2(n1238), .IN3(n1237), .IN4(
        \C42/DATA2_13 ), .IN5(n1236), .IN6(dequantSamp[13]), .Q(n568) );
  OA22X1 U1315 ( .IN1(n1190), .IN2(n1173), .IN3(n1065), .IN4(n1163), .Q(n1069)
         );
  NOR2X0 U1316 ( .IN1(n1066), .IN2(n1163), .QN(n1179) );
  INVX0 U1317 ( .INP(n1104), .ZN(n1120) );
  NAND2X0 U1318 ( .IN1(n1076), .IN2(n1071), .QN(n1178) );
  NOR2X0 U1319 ( .IN1(n1179), .IN2(n1178), .QN(n1067) );
  NAND4X0 U1320 ( .IN1(n1070), .IN2(n1069), .IN3(n1068), .IN4(n1067), .QN(n619) );
  AO222X1 U1321 ( .IN1(stepSize[12]), .IN2(n1238), .IN3(n1237), .IN4(
        \C42/DATA2_12 ), .IN5(n1236), .IN6(dequantSamp[12]), .Q(n569) );
  OA21X1 U1322 ( .IN1(n1192), .IN2(n1188), .IN3(n1071), .Q(n1072) );
  OA21X1 U1323 ( .IN1(n1370), .IN2(n1174), .IN3(n1072), .Q(n1074) );
  NAND4X0 U1324 ( .IN1(n1074), .IN2(n1073), .IN3(n1152), .IN4(n1215), .QN(
        n1115) );
  OA21X1 U1325 ( .IN1(n1110), .IN2(n1105), .IN3(n1088), .Q(n1075) );
  NOR2X0 U1326 ( .IN1(n1115), .IN2(n1075), .QN(n1078) );
  AO221X1 U1327 ( .IN1(n1173), .IN2(n1365), .IN3(n1173), .IN4(n1174), .IN5(
        n1098), .Q(n1077) );
  NAND4X0 U1328 ( .IN1(n1078), .IN2(n1077), .IN3(n1076), .IN4(n1141), .QN(n618) );
  AO222X1 U1329 ( .IN1(stepSize[11]), .IN2(n1238), .IN3(n1237), .IN4(
        \C42/DATA2_11 ), .IN5(n1236), .IN6(dequantSamp[11]), .Q(n570) );
  INVX0 U1330 ( .INP(n1178), .ZN(n1081) );
  NAND2X0 U1331 ( .IN1(n1088), .IN2(n1120), .QN(n1080) );
  AND4X1 U1332 ( .IN1(n1081), .IN2(n1080), .IN3(n1233), .IN4(n1079), .Q(n1095)
         );
  NAND2X0 U1333 ( .IN1(n1219), .IN2(n1147), .QN(n1140) );
  NOR2X0 U1334 ( .IN1(n1190), .IN2(n1162), .QN(n1083) );
  NAND2X0 U1335 ( .IN1(n1162), .IN2(n1163), .QN(n1082) );
  NOR2X0 U1336 ( .IN1(n1365), .IN2(n1385), .QN(n1206) );
  AO222X1 U1337 ( .IN1(n1186), .IN2(n1082), .IN3(n1206), .IN4(n1194), .IN5(
        n1201), .IN6(n1196), .Q(n1210) );
  NOR4X0 U1338 ( .IN1(n1124), .IN2(n1084), .IN3(n1083), .IN4(n1210), .QN(n1085) );
  NAND4X0 U1339 ( .IN1(n1095), .IN2(n1205), .IN3(n1140), .IN4(n1085), .QN(n617) );
  AO222X1 U1340 ( .IN1(stepSize[10]), .IN2(n1238), .IN3(n1237), .IN4(
        \C42/DATA2_10 ), .IN5(n1236), .IN6(dequantSamp[10]), .Q(n571) );
  INVX0 U1341 ( .INP(n1086), .ZN(n1087) );
  NOR2X0 U1342 ( .IN1(n1156), .IN2(n1087), .QN(n1090) );
  NAND3X0 U1343 ( .IN1(outStepIndex[1]), .IN2(n1088), .IN3(n1365), .QN(n1089)
         );
  NAND4X0 U1344 ( .IN1(n1091), .IN2(n1090), .IN3(n1089), .IN4(n1141), .QN(
        n1099) );
  AO21X1 U1345 ( .IN1(n1092), .IN2(n1109), .IN3(n1179), .Q(n1093) );
  NOR2X0 U1346 ( .IN1(n1099), .IN2(n1093), .QN(n1094) );
  NAND4X0 U1347 ( .IN1(n1095), .IN2(n1117), .IN3(n1094), .IN4(n1143), .QN(n613) );
  AO222X1 U1348 ( .IN1(stepSize[9]), .IN2(n1238), .IN3(n1237), .IN4(
        \C42/DATA2_9 ), .IN5(n1236), .IN6(dequantSamp[9]), .Q(n572) );
  NOR2X0 U1349 ( .IN1(n1164), .IN2(n1166), .QN(n1145) );
  AO22X1 U1350 ( .IN1(n1110), .IN2(n1195), .IN3(n1109), .IN4(n1120), .Q(n1096)
         );
  OR3X1 U1351 ( .IN1(n1145), .IN2(n1179), .IN3(n1096), .Q(n1198) );
  NOR2X0 U1352 ( .IN1(n1162), .IN2(n1191), .QN(n1097) );
  NOR2X0 U1353 ( .IN1(n1198), .IN2(n1097), .QN(n1102) );
  NOR2X0 U1354 ( .IN1(n1098), .IN2(n1192), .QN(n1172) );
  NOR2X0 U1355 ( .IN1(n1137), .IN2(n1222), .QN(n1100) );
  NOR4X0 U1356 ( .IN1(n1172), .IN2(n1100), .IN3(n1099), .IN4(n1155), .QN(n1101) );
  NAND4X0 U1357 ( .IN1(n1103), .IN2(n1102), .IN3(n1153), .IN4(n1101), .QN(n612) );
  AO222X1 U1358 ( .IN1(stepSize[8]), .IN2(n1238), .IN3(n1237), .IN4(
        \C42/DATA2_8 ), .IN5(n1236), .IN6(dequantSamp[8]), .Q(n573) );
  AOI22X1 U1359 ( .IN1(n1219), .IN2(n1221), .IN3(n1195), .IN4(n1206), .QN(
        n1119) );
  OA22X1 U1360 ( .IN1(n1149), .IN2(n1192), .IN3(n1174), .IN4(n1104), .Q(n1107)
         );
  NAND3X0 U1361 ( .IN1(n1108), .IN2(n1107), .IN3(n1106), .QN(n1131) );
  NAND2X0 U1362 ( .IN1(n1110), .IN2(n1109), .QN(n1151) );
  NAND2X0 U1363 ( .IN1(n1111), .IN2(n1185), .QN(n1113) );
  NAND3X0 U1364 ( .IN1(n1151), .IN2(n1113), .IN3(n1112), .QN(n1114) );
  NOR4X0 U1365 ( .IN1(n1155), .IN2(n1131), .IN3(n1115), .IN4(n1114), .QN(n1118) );
  NAND4X0 U1366 ( .IN1(n1119), .IN2(n1118), .IN3(n1117), .IN4(n1116), .QN(n611) );
  AO222X1 U1367 ( .IN1(stepSize[7]), .IN2(n1238), .IN3(n1237), .IN4(
        \C42/DATA2_7 ), .IN5(n1236), .IN6(dequantSamp[7]), .Q(n574) );
  AO222X1 U1368 ( .IN1(stepSize[6]), .IN2(n1238), .IN3(n1237), .IN4(
        \C42/DATA2_6 ), .IN5(n1236), .IN6(dequantSamp[6]), .Q(n575) );
  NOR2X0 U1369 ( .IN1(n1148), .IN2(n1223), .QN(n1123) );
  OA21X1 U1370 ( .IN1(n1121), .IN2(n1120), .IN3(n1207), .Q(n1122) );
  NOR4X0 U1371 ( .IN1(n1124), .IN2(n1123), .IN3(n1122), .IN4(n1178), .QN(n1235) );
  NOR2X0 U1372 ( .IN1(n1208), .IN2(n1186), .QN(n1126) );
  OA22X1 U1373 ( .IN1(n1126), .IN2(n1138), .IN3(n1125), .IN4(n1222), .Q(n1136)
         );
  NOR2X0 U1374 ( .IN1(n1190), .IN2(n1166), .QN(n1133) );
  NOR3X0 U1375 ( .IN1(n1370), .IN2(n1223), .IN3(outStepIndex[1]), .QN(n1132)
         );
  NAND2X0 U1376 ( .IN1(n1184), .IN2(n1195), .QN(n1127) );
  NAND4X0 U1377 ( .IN1(n1152), .IN2(n1129), .IN3(n1128), .IN4(n1127), .QN(
        n1130) );
  NOR4X0 U1378 ( .IN1(n1133), .IN2(n1132), .IN3(n1131), .IN4(n1130), .QN(n1134) );
  NAND4X0 U1379 ( .IN1(n1235), .IN2(n1136), .IN3(n1135), .IN4(n1134), .QN(n610) );
  AO222X1 U1380 ( .IN1(stepSize[5]), .IN2(n1238), .IN3(n1237), .IN4(
        \C42/DATA2_5 ), .IN5(n1236), .IN6(dequantSamp[5]), .Q(n576) );
  NOR2X0 U1381 ( .IN1(n1184), .IN2(n1186), .QN(n1139) );
  OA22X1 U1382 ( .IN1(n1139), .IN2(n1138), .IN3(n1174), .IN4(n1137), .Q(n1161)
         );
  NAND4X0 U1383 ( .IN1(n1143), .IN2(n1142), .IN3(n1141), .IN4(n1140), .QN(
        n1229) );
  NOR4X0 U1384 ( .IN1(n1145), .IN2(n1220), .IN3(n1144), .IN4(n1229), .QN(n1159) );
  NOR2X0 U1385 ( .IN1(n1147), .IN2(n1146), .QN(n1150) );
  OA22X1 U1386 ( .IN1(n1150), .IN2(n1149), .IN3(n1174), .IN4(n1148), .Q(n1154)
         );
  NAND4X0 U1387 ( .IN1(n1154), .IN2(n1153), .IN3(n1152), .IN4(n1151), .QN(
        n1211) );
  NOR4X0 U1388 ( .IN1(n1157), .IN2(n1156), .IN3(n1155), .IN4(n1211), .QN(n1158) );
  NAND4X0 U1389 ( .IN1(n1161), .IN2(n1160), .IN3(n1159), .IN4(n1158), .QN(n616) );
  AO222X1 U1390 ( .IN1(stepSize[4]), .IN2(n1238), .IN3(n1237), .IN4(
        \C42/DATA2_4 ), .IN5(n1236), .IN6(dequantSamp[4]), .Q(n577) );
  AO222X1 U1391 ( .IN1(stepSize[3]), .IN2(n1238), .IN3(n1237), .IN4(
        \C42/DATA2_3 ), .IN5(n1236), .IN6(dequantSamp[3]), .Q(n578) );
  OA22X1 U1392 ( .IN1(n1164), .IN2(n1163), .IN3(n1188), .IN4(n1162), .Q(n1183)
         );
  NAND2X0 U1393 ( .IN1(n1184), .IN2(n1224), .QN(n1182) );
  NOR2X0 U1394 ( .IN1(n1223), .IN2(n1167), .QN(n1171) );
  NOR2X0 U1395 ( .IN1(n1168), .IN2(n1191), .QN(n1170) );
  AO22X1 U1396 ( .IN1(n1219), .IN2(n1220), .IN3(n1225), .IN4(n1207), .Q(n1169)
         );
  NOR4X0 U1397 ( .IN1(n1172), .IN2(n1171), .IN3(n1170), .IN4(n1169), .QN(n1181) );
  NAND2X0 U1398 ( .IN1(n1174), .IN2(n1173), .QN(n1175) );
  AO22X1 U1399 ( .IN1(n1196), .IN2(n1175), .IN3(n1227), .IN4(n1218), .Q(n1176)
         );
  NOR4X0 U1400 ( .IN1(n1179), .IN2(n1178), .IN3(n1177), .IN4(n1176), .QN(n1180) );
  NAND4X0 U1401 ( .IN1(n1183), .IN2(n1182), .IN3(n1181), .IN4(n1180), .QN(n608) );
  AO222X1 U1402 ( .IN1(stepSize[2]), .IN2(n1238), .IN3(n1237), .IN4(
        \C42/DATA2_2 ), .IN5(n1236), .IN6(dequantSamp[2]), .Q(n579) );
  AOI22X1 U1403 ( .IN1(n1186), .IN2(n1185), .IN3(n1184), .IN4(n1221), .QN(
        n1213) );
  OA22X1 U1404 ( .IN1(n1190), .IN2(n1189), .IN3(n1188), .IN4(n1187), .Q(n1204)
         );
  NOR2X0 U1405 ( .IN1(n1192), .IN2(n1191), .QN(n1200) );
  OA21X1 U1406 ( .IN1(n1194), .IN2(n1207), .IN3(n1193), .Q(n1199) );
  AO22X1 U1407 ( .IN1(n1196), .IN2(n1220), .IN3(n1219), .IN4(n1195), .Q(n1197)
         );
  NOR4X0 U1408 ( .IN1(n1200), .IN2(n1199), .IN3(n1198), .IN4(n1197), .QN(n1203) );
  NAND4X0 U1409 ( .IN1(n1205), .IN2(n1204), .IN3(n1203), .IN4(n1202), .QN(
        n1230) );
  AO22X1 U1410 ( .IN1(n1208), .IN2(n1207), .IN3(n1218), .IN4(n1206), .Q(n1209)
         );
  NOR4X0 U1411 ( .IN1(n1211), .IN2(n1230), .IN3(n1210), .IN4(n1209), .QN(n1212) );
  NAND4X0 U1412 ( .IN1(n1215), .IN2(n1214), .IN3(n1213), .IN4(n1212), .QN(n615) );
  XOR2X1 U1413 ( .IN1(dequantSamp[1]), .IN2(n1216), .Q(n1217) );
  AO222X1 U1414 ( .IN1(stepSize[1]), .IN2(n1238), .IN3(n1237), .IN4(n1217), 
        .IN5(n1236), .IN6(dequantSamp[1]), .Q(n580) );
  NAND2X0 U1415 ( .IN1(n1218), .IN2(n1365), .QN(n1234) );
  OA21X1 U1416 ( .IN1(n1221), .IN2(n1220), .IN3(n1219), .Q(n1231) );
  AO22X1 U1417 ( .IN1(n1227), .IN2(n1226), .IN3(n1225), .IN4(n1224), .Q(n1228)
         );
  NOR4X0 U1418 ( .IN1(n1231), .IN2(n1230), .IN3(n1229), .IN4(n1228), .QN(n1232) );
  NAND4X0 U1419 ( .IN1(n1235), .IN2(n1234), .IN3(n1233), .IN4(n1232), .QN(n614) );
  AO222X1 U1420 ( .IN1(stepSize[0]), .IN2(n1238), .IN3(n1237), .IN4(
        \C42/DATA2_0 ), .IN5(n1236), .IN6(\C42/DATA2_0 ), .Q(n581) );
  NOR2X0 U1421 ( .IN1(n1421), .IN2(n1239), .QN(\C1/Z_17 ) );
  AO222X1 U1422 ( .IN1(n1242), .IN2(stepSize[13]), .IN3(n1240), .IN4(
        stepSize[14]), .IN5(n1241), .IN6(stepSize[12]), .Q(\C1/Z_15 ) );
  AO222X1 U1423 ( .IN1(n1242), .IN2(stepSize[12]), .IN3(n1240), .IN4(
        stepSize[13]), .IN5(n1241), .IN6(stepSize[11]), .Q(\C1/Z_14 ) );
  AO222X1 U1424 ( .IN1(n1242), .IN2(stepSize[11]), .IN3(n1241), .IN4(
        stepSize[10]), .IN5(n1240), .IN6(stepSize[12]), .Q(\C1/Z_13 ) );
  AO222X1 U1425 ( .IN1(n1242), .IN2(stepSize[10]), .IN3(n1241), .IN4(
        stepSize[9]), .IN5(n1240), .IN6(stepSize[11]), .Q(\C1/Z_12 ) );
  AO222X1 U1426 ( .IN1(n1242), .IN2(stepSize[9]), .IN3(n1241), .IN4(
        stepSize[8]), .IN5(n1240), .IN6(stepSize[10]), .Q(\C1/Z_11 ) );
  AO222X1 U1427 ( .IN1(n1242), .IN2(stepSize[8]), .IN3(n1241), .IN4(
        stepSize[7]), .IN5(n1240), .IN6(stepSize[9]), .Q(\C1/Z_10 ) );
  AO222X1 U1428 ( .IN1(n1242), .IN2(stepSize[7]), .IN3(n1241), .IN4(
        stepSize[6]), .IN5(n1240), .IN6(stepSize[8]), .Q(\C1/Z_9 ) );
  AO222X1 U1429 ( .IN1(n1242), .IN2(stepSize[6]), .IN3(n1241), .IN4(
        stepSize[5]), .IN5(n1240), .IN6(stepSize[7]), .Q(\C1/Z_8 ) );
  AO222X1 U1430 ( .IN1(n1242), .IN2(stepSize[5]), .IN3(n1241), .IN4(
        stepSize[4]), .IN5(n1240), .IN6(stepSize[6]), .Q(\C1/Z_7 ) );
  AO222X1 U1431 ( .IN1(n1242), .IN2(stepSize[4]), .IN3(n1241), .IN4(
        stepSize[3]), .IN5(n1240), .IN6(stepSize[5]), .Q(\C1/Z_6 ) );
  AO222X1 U1432 ( .IN1(n1242), .IN2(stepSize[3]), .IN3(n1241), .IN4(
        stepSize[2]), .IN5(n1240), .IN6(stepSize[4]), .Q(\C1/Z_5 ) );
  AO222X1 U1433 ( .IN1(n1242), .IN2(stepSize[2]), .IN3(n1241), .IN4(
        stepSize[1]), .IN5(n1240), .IN6(stepSize[3]), .Q(\C1/Z_4 ) );
  AO222X1 U1434 ( .IN1(n1242), .IN2(stepSize[1]), .IN3(n1241), .IN4(
        stepSize[0]), .IN5(n1240), .IN6(stepSize[2]), .Q(\C1/Z_3 ) );
  AO21X1 U1435 ( .IN1(prePCM[3]), .IN2(n1243), .IN3(n1290), .Q(n563) );
  OA21X1 U1436 ( .IN1(predictorSamp[16]), .IN2(n1245), .IN3(n1244), .Q(
        outPredictSamp[13]) );
  OA21X1 U1437 ( .IN1(predictorSamp[14]), .IN2(n1247), .IN3(n1246), .Q(
        outPredictSamp[11]) );
  OA21X1 U1438 ( .IN1(predictorSamp[12]), .IN2(n1249), .IN3(n1248), .Q(
        outPredictSamp[9]) );
  OA21X1 U1439 ( .IN1(predictorSamp[10]), .IN2(n1251), .IN3(n1250), .Q(
        outPredictSamp[7]) );
  OA21X1 U1440 ( .IN1(predictorSamp[8]), .IN2(n1253), .IN3(n1252), .Q(
        outPredictSamp[5]) );
  OA21X1 U1441 ( .IN1(predictorSamp[6]), .IN2(n1255), .IN3(n1254), .Q(
        outPredictSamp[3]) );
  AND2X1 U1442 ( .IN1(predictorSamp[2]), .IN2(predictorSamp[3]), .Q(n1257) );
  OA21X1 U1443 ( .IN1(predictorSamp[4]), .IN2(n1257), .IN3(n1256), .Q(
        outPredictSamp[1]) );
  OA22X1 U1444 ( .IN1(n1259), .IN2(n1258), .IN3(stepSize[14]), .IN4(n1376), 
        .Q(n1341) );
  OA22X1 U1445 ( .IN1(n1341), .IN2(n1334), .IN3(n1376), .IN4(n1322), .Q(n1260)
         );
  NOR2X0 U1446 ( .IN1(sampDiff[18]), .IN2(n1347), .QN(n1346) );
  AO22X1 U1447 ( .IN1(sampDiff[18]), .IN2(n1262), .IN3(n1290), .IN4(n1346), 
        .Q(n1266) );
  INVX0 U1448 ( .INP(inSamp[15]), .ZN(n1344) );
  AO222X1 U1449 ( .IN1(inSamp[14]), .IN2(n1388), .IN3(inSamp[14]), .IN4(n1263), 
        .IN5(n1388), .IN6(n1263), .Q(n1343) );
  NOR2X0 U1450 ( .IN1(n1264), .IN2(n1357), .QN(n1265) );
  AO221X1 U1451 ( .IN1(sampDiff[19]), .IN2(n1354), .IN3(sampDiff[19]), .IN4(
        n1266), .IN5(n1265), .Q(n600) );
  INVX0 U1452 ( .INP(n1267), .ZN(n1295) );
  NAND2X0 U1453 ( .IN1(n1295), .IN2(n1290), .QN(n1273) );
  MUX21X1 U1454 ( .IN1(stepSize[10]), .IN2(n1374), .S(n1268), .Q(n1275) );
  INVX0 U1455 ( .INP(n1275), .ZN(n1270) );
  MUX21X1 U1456 ( .IN1(n1384), .IN2(stepSize[9]), .S(n1284), .Q(n1269) );
  OA22X1 U1457 ( .IN1(n1322), .IN2(n1270), .IN3(n1321), .IN4(n1269), .Q(n1271)
         );
  AO222X1 U1458 ( .IN1(sampDiff[12]), .IN2(n1273), .IN3(sampDiff[12]), .IN4(
        n1272), .IN5(n1273), .IN6(n1271), .Q(n1289) );
  OA22X1 U1459 ( .IN1(n1275), .IN2(n1322), .IN3(n1334), .IN4(n1274), .Q(n1276)
         );
  AO21X1 U1460 ( .IN1(n1276), .IN2(n1324), .IN3(n1378), .Q(n1288) );
  INVX0 U1461 ( .INP(n1281), .ZN(n1282) );
  INVX0 U1462 ( .INP(n1277), .ZN(n1279) );
  NOR2X0 U1463 ( .IN1(n1279), .IN2(n1278), .QN(n1280) );
  MUX21X1 U1464 ( .IN1(n1282), .IN2(n1281), .S(n1280), .Q(n1283) );
  NAND2X0 U1465 ( .IN1(n1351), .IN2(n1283), .QN(n1287) );
  OR3X1 U1466 ( .IN1(n1285), .IN2(n1334), .IN3(n1284), .Q(n1286) );
  NAND4X0 U1467 ( .IN1(n1289), .IN2(n1288), .IN3(n1287), .IN4(n1286), .QN(n553) );
  NAND2X0 U1468 ( .IN1(n1290), .IN2(n1318), .QN(n1296) );
  MUX21X1 U1469 ( .IN1(stepSize[11]), .IN2(n1382), .S(n1291), .Q(n1298) );
  INVX0 U1470 ( .INP(n1298), .ZN(n1293) );
  MUX21X1 U1471 ( .IN1(n1374), .IN2(stepSize[10]), .S(n1300), .Q(n1292) );
  OA22X1 U1472 ( .IN1(n1293), .IN2(n1322), .IN3(n1334), .IN4(n1292), .Q(n1294)
         );
  AO222X1 U1473 ( .IN1(sampDiff[13]), .IN2(n1296), .IN3(sampDiff[13]), .IN4(
        n1295), .IN5(n1296), .IN6(n1294), .Q(n1312) );
  OA22X1 U1474 ( .IN1(n1322), .IN2(n1298), .IN3(n1321), .IN4(n1297), .Q(n1299)
         );
  AO21X1 U1475 ( .IN1(n1299), .IN2(n1324), .IN3(n1402), .Q(n1311) );
  OR3X1 U1476 ( .IN1(n1301), .IN2(n1334), .IN3(n1300), .Q(n1310) );
  INVX0 U1477 ( .INP(n1306), .ZN(n1307) );
  INVX0 U1478 ( .INP(n1302), .ZN(n1304) );
  NOR2X0 U1479 ( .IN1(n1304), .IN2(n1303), .QN(n1305) );
  MUX21X1 U1480 ( .IN1(n1307), .IN2(n1306), .S(n1305), .Q(n1308) );
  NAND2X0 U1481 ( .IN1(n1351), .IN2(n1308), .QN(n1309) );
  NAND4X0 U1482 ( .IN1(n1312), .IN2(n1311), .IN3(n1310), .IN4(n1309), .QN(n552) );
  OR2X1 U1483 ( .IN1(n1313), .IN2(n1345), .Q(n1319) );
  MUX21X1 U1484 ( .IN1(stepSize[12]), .IN2(n1381), .S(n1314), .Q(n1323) );
  INVX0 U1485 ( .INP(n1323), .ZN(n1316) );
  MUX21X1 U1486 ( .IN1(n1382), .IN2(stepSize[11]), .S(n1333), .Q(n1315) );
  OA22X1 U1487 ( .IN1(n1322), .IN2(n1316), .IN3(n1334), .IN4(n1315), .Q(n1317)
         );
  AO222X1 U1488 ( .IN1(sampDiff[14]), .IN2(n1319), .IN3(sampDiff[14]), .IN4(
        n1318), .IN5(n1319), .IN6(n1317), .Q(n1339) );
  OA22X1 U1489 ( .IN1(n1323), .IN2(n1322), .IN3(n1321), .IN4(n1320), .Q(n1325)
         );
  AO21X1 U1490 ( .IN1(n1325), .IN2(n1324), .IN3(n1367), .Q(n1338) );
  INVX0 U1491 ( .INP(n1330), .ZN(n1331) );
  INVX0 U1492 ( .INP(n1326), .ZN(n1328) );
  NOR2X0 U1493 ( .IN1(n1328), .IN2(n1327), .QN(n1329) );
  MUX21X1 U1494 ( .IN1(n1331), .IN2(n1330), .S(n1329), .Q(n1332) );
  OR3X1 U1495 ( .IN1(n1335), .IN2(n1334), .IN3(n1333), .Q(n1336) );
  NAND4X0 U1496 ( .IN1(n1339), .IN2(n1338), .IN3(n1337), .IN4(n1336), .QN(n551) );
  AO22X1 U1497 ( .IN1(n1342), .IN2(n1341), .IN3(n1340), .IN4(n1376), .Q(n1353)
         );
  FADDX1 U1498 ( .A(n1344), .B(predictorSamp[18]), .CI(n1343), .CO(n1264), .S(
        n1350) );
  NOR2X0 U1499 ( .IN1(n1346), .IN2(n1345), .QN(n1349) );
  NAND2X0 U1500 ( .IN1(sampDiff[18]), .IN2(n1347), .QN(n1348) );
  AO22X1 U1501 ( .IN1(n1351), .IN2(n1350), .IN3(n1349), .IN4(n1348), .Q(n1352)
         );
  AO221X1 U1502 ( .IN1(sampDiff[18]), .IN2(n1354), .IN3(n1424), .IN4(n1353), 
        .IN5(n1352), .Q(n547) );
  AO221X1 U1503 ( .IN1(n1357), .IN2(n1356), .IN3(n1357), .IN4(inReady), .IN5(
        n1355), .Q(n530) );
  NOR2X0 U1504 ( .IN1(n1359), .IN2(n1358), .QN(n1361) );
  AO222X1 U1505 ( .IN1(outStepIndex[0]), .IN2(n1361), .IN3(outStepIndex[0]), 
        .IN4(n1360), .IN5(n1361), .IN6(n1383), .Q(n523) );
endmodule

