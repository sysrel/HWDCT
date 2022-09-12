/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Thu Jul 29 10:52:40 2021
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
  wire trojan_ena/*verilator public*/;
  wire   N176, N429, \C42/DATA2_0 , \C42/DATA2_2 , \C42/DATA2_3 ,
         \C42/DATA2_4 , \C42/DATA2_5 , \C42/DATA2_6 , \C42/DATA2_7 ,
         \C42/DATA2_8 , \C42/DATA2_9 , \C42/DATA2_10 , \C42/DATA2_11 ,
         \C42/DATA2_12 , \C42/DATA2_13 , \C42/DATA2_14 , \C42/DATA2_15 ,
         \C42/DATA2_16 , \C42/DATA2_17 , n522, n523, n524, n525, n526, n527,
         n528, n529, n530, n531, n532, n533, n534, n535, n536, n537, n538,
         n539, n540, n541, n542, n543, n544, n545, n546, n547, n548, n549,
         n550, n551, n552, n553, n554, n555, n556, n557, n558, n559, n560,
         n561, n562, n563, n564, n565, n566, n567, n568, n569, n570, n571,
         n572, n573, n574, n575, n576, n577, n578, n579, n580, n581, n582,
         n583, n584, n585, n586, n587, n588, n589, n590, n591, n592, n593,
         n594, n595, n596, n597, n598, n599, n600, n601, n606, n607, n608,
         n609, n610, n611, n612, n613, n614, n615, n616, n617, n618, n619,
         n620, \C1/Z_17 , \C1/Z_16 , \C1/Z_15 , \C1/Z_14 , \C1/Z_13 ,
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
         \DP_OP_73J1_125_3932/n2 , \DP_OP_73J1_125_3932/n1 , n622, n623, n624,
         n625, n626, n627, n628, n629, n630, n631, n632, n633, n634, n635,
         n636, n637, n638, n639, n640, n641, n642, n643, n644, n645, n646,
         n647, n648, n649, n650, n651, n652, n653, n654, n655, n656, n657,
         n658, n659, n660, n661, n662, n663, n664, n665, n666, n667, n668,
         n669, n670, n671, n672, n673, n674, n675, n676, n677, n678, n679,
         n680, n681, n682, n683, n684, n685, n686, n687, n688, n689, n690,
         n691, n692, n693, n694, n695, n696, n697, n698, n699, n700, n701,
         n702, n703, n704, n705, n706, n707, n708, n709, n710, n711, n712,
         n713, n714, n715, n716, n717, n718, n719, n720, n721, n722, n723,
         n724, n725, n726, n727, n728, n729, n730, n731, n732, n733, n734,
         n735, n736, n737, n738, n739, n740, n741, n742, n743, n744, n745,
         n746, n747, n748, n749, n750, n751, n752, n753, n754, n755, n756,
         n757, n758, n759, n760, n761, n762, n763, n764, n765, n766, n767,
         n768, n769, n770, n771, n772, n773, n774, n775, n776, n777, n778,
         n779, n780, n781, n782, n783, n784, n785, n786, n787, n788, n789,
         n790, n791, n792, n793, n794, n795, n796, n797, n798, n799, n800,
         n801, n802, n803, n804, n805, n806, n807, n808, n809, n810, n811,
         n812, n813, n814, n815, n816, n817, n818, n819, n820, n821, n822,
         n823, n824, n825, n826, n827, n828, n829, n830, n831, n832, n833,
         n834, n835, n836, n837, n838, n839, n840, n841, n842, n843, n844,
         n845, n846, n847, n848, n849, n850, n851, n852, n853, n854, n855,
         n856, n857, n858, n859, n860, n861, n862, n863, n864, n865, n866,
         n867, n868, n869, n870, n871, n872, n873, n874, n875, n876, n877,
         n878, n879, n880, n881, n882, n883, n884, n885, n886, n887, n888,
         n889, n890, n891, n892, n893, n894, n895, n896, n897, n898, n899,
         n900, n901, n902, n903, n904, n905, n906, n907, n908, n909, n910,
         n911, n912, n913, n914, n915, n916, n917, n918, n919, n920, n921,
         n922, n923, n924, n925, n926, n927, n928, n929, n930, n931, n932,
         n933, n934, n935, n936, n937, n938, n939, n940, n941, n942, n943,
         n944, n945, n946, n947, n948, n949, n950, n951, n952, n953, n954,
         n955, n956, n957, n958, n959, n960, n961, n962, n963, n964, n965,
         n966, n967, n968, n969, n970, n971, n972, n973, n974, n975, n976,
         n977, n978, n979, n980, n981, n982, n983, n984, n985, n986, n987,
         n988, n989, n990, n991, n992, n993, n994, n995, n996, n997, n998,
         n999, n1000, n1001, n1002, n1003, n1004, n1005, n1006, n1007, n1008,
         n1009, n1010, n1011, n1012, n1013, n1014, n1015, n1016, n1017, n1018,
         n1019, n1020, n1021, n1022, n1023, n1024, n1025, n1026, n1027, n1028,
         n1029, n1030, n1031, n1032, n1033, n1034, n1035, n1036, n1037, n1038,
         n1039, n1040, n1041, n1042, n1043, n1044, n1045, n1046, n1047, n1048,
         n1049, n1050, n1051, n1052, n1053, n1054, n1055, n1056, n1057, n1058,
         n1059, n1060, n1061, n1062, n1063, n1064, n1065, n1066, n1067, n1068,
         n1069, n1070, n1071, n1072, n1073, n1074, n1075, n1076, n1077, n1078,
         n1079, n1080, n1081, n1082, n1083, n1084, n1085, n1086, n1087, n1088,
         n1089, n1090, n1091, n1092, n1093, n1094, n1095, n1096, n1097, n1098,
         n1099, n1100, n1101, n1102, n1103, n1104, n1105, n1106, n1107, n1108,
         n1109, n1110, n1111, n1112, n1113, n1114, n1115, n1116, n1117, n1118,
         n1119, n1120, n1121, n1122, n1123, n1124, n1125, n1126, n1127, n1128,
         n1129, n1130, n1131, n1132, n1133, n1134, n1135, n1136, n1137, n1138,
         n1139, n1140, n1141, n1142, n1143, n1144, n1145, n1146, n1147, n1148,
         n1149, n1150, n1151, n1152, n1153, n1154, n1155, n1156, n1157, n1158,
         n1159, n1160, n1161, n1162, n1163, n1164, n1165, n1166, n1167, n1168,
         n1169, n1170, n1171, n1172, n1173, n1174, n1175, n1176, n1177, n1178,
         n1179, n1180, n1181, n1182, n1183, n1184, n1185, n1186, n1187, n1188,
         n1189, n1190, n1191, n1192, n1193, n1194, n1195, n1196, n1197, n1198,
         n1199, n1200, n1201, n1202, n1203, n1204, n1205, n1206, n1207, n1208,
         n1209, n1210, n1211, n1212, n1213, n1214, n1215, n1216, n1217, n1218,
         n1219, n1220, n1221, n1222, n1223, n1224, n1225, n1226, n1227, n1228,
         n1229, n1230, n1231, n1232, n1233, n1234, n1235, n1236, n1237, n1238,
         n1239, n1240, n1241, n1242, n1243, n1244, n1245, n1246, n1247, n1248,
         n1249, n1250, n1251, n1252, n1253, n1254, n1255, n1256, n1257, n1258,
         n1259, n1260, n1261, n1262, n1263, n1264, n1265, n1266, n1267, n1268,
         n1269, n1270, n1271, n1272, n1273, n1274, n1275, n1276, n1277, n1278,
         n1279, n1280, n1281, n1282, n1283, n1284, n1285, n1286, n1287, n1288,
         n1289, n1290, n1291, n1292, n1293, n1294, n1295, n1296, n1297, n1298,
         n1299, n1300, n1301, n1302, n1303, n1304, n1305, n1306, n1307, n1308,
         n1309, n1310, n1311, n1312, n1313, n1314, n1315, n1316, n1317, n1318,
         n1319, n1320, n1321, n1322, n1323, n1324, n1325, n1326, n1327, n1328,
         n1329, n1330, n1331, n1332, n1333, n1334, n1335, n1336, n1337, n1338,
         n1339, n1340, n1341, n1342, n1343, n1344, n1345, n1346, n1347, n1348,
         n1349, n1350, n1351, n1352, n1353, n1354, n1355, n1356, n1357, n1358,
         n1359, n1360, n1361, n1362, n1363, n1364, n1365, n1366, /*n1367,*/ n1368,
         n1369, n1370, n1371, n1372, n1373, n1374, n1375, n1376, n1377, n1378,
         n1379, n1380, n1381, n1382, n1383, n1384, n1385, n1386, n1387, n1388,
         n1389, n1390, n1391, n1392, n1393, n1394, n1395, n1396, n1397, n1398,
         n1399, n1400, n1401, n1402, n1403, n1404, n1405, n1406, n1407, n1408,
         n1409, n1410, n1411, n1412, n1413, n1414, n1415, /*n1416,*/ n1417, n1418,
         /*n1419,*/ n1420, n1421, n1422, n1423, n1424, n1425, n1426, n1427, n1428;
  wire   [18:0] predictorSamp/*verilator public*/;
  reg   [2:0] pcmSq/*verilator public*/;
  wire   [19:0] sampDiff/*verilator public*/;
  wire   [14:0] stepSize/*verilator public*/;
  wire   [18:0] dequantSamp/*verilator public*/;
  wire   [19:0] prePredSamp/*verilator public*/;
  wire   [3:0] prePCM/*verilator public*/;
  wire   [1:0] trojan_state/*verilator public*/;
	
  reg	n1416, n1367, n1419;

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
  pcmSq[0] = n545;
  n1416 = ~n545;
  pcmSq[1] = n544;
  n1367 = ~n544;
  pcmSq[2] = n543;
  n1419 = ~n543;
  end
end

  //DFFARX1 \pcmSq_reg[0]  ( .D(n545), .CLK(clock), .RSTB(n1424), .Q(pcmSq[0]), .QN(n1416) );
  //DFFARX1 \pcmSq_reg[1]  ( .D(n544), .CLK(clock), .RSTB(n1428), .Q(pcmSq[1]), .QN(n1367) );
  //DFFARX1 \pcmSq_reg[2]  ( .D(n543), .CLK(clock), .RSTB(n1423), .Q(pcmSq[2]), .QN(n1419) );
  DFFARX1 \dequantSamp_reg[18]  ( .D(n601), .CLK(clock), .RSTB(n1426), .Q(
        dequantSamp[18]) );
  DFFARX1 \dequantSamp_reg[17]  ( .D(n563), .CLK(clock), .RSTB(n1427), .Q(
        dequantSamp[17]) );
  DFFARX1 \dequantSamp_reg[16]  ( .D(n564), .CLK(clock), .RSTB(n1427), .Q(
        dequantSamp[16]) );
  DFFARX1 \dequantSamp_reg[15]  ( .D(n565), .CLK(clock), .RSTB(n1427), .Q(
        dequantSamp[15]) );
  DFFARX1 \prePCM_reg[2]  ( .D(n533), .CLK(clock), .RSTB(n1423), .Q(prePCM[2]), 
        .QN(n1381) );
  DFFARX1 \prePCM_reg[1]  ( .D(n531), .CLK(clock), .RSTB(n1423), .Q(prePCM[1]), 
        .QN(n1417) );
  DFFARX1 \prePCM_reg[0]  ( .D(n535), .CLK(clock), .RSTB(n1423), .Q(prePCM[0]), 
        .QN(n1366) );
  DFFARX1 \predictorSamp_reg[18]  ( .D(n597), .CLK(clock), .RSTB(n1426), .Q(
        predictorSamp[18]), .QN(n1415) );
  DFFARX1 \predictorSamp_reg[17]  ( .D(n600), .CLK(clock), .RSTB(n1426), .Q(
        predictorSamp[17]), .QN(n1386) );
  DFFARX1 \predictorSamp_reg[16]  ( .D(n596), .CLK(clock), .RSTB(n1425), .Q(
        predictorSamp[16]), .QN(n1412) );
  DFFARX1 \predictorSamp_reg[15]  ( .D(n595), .CLK(clock), .RSTB(n1427), .Q(
        predictorSamp[15]), .QN(n1398) );
  DFFARX1 \predictorSamp_reg[14]  ( .D(n594), .CLK(clock), .RSTB(n1424), .Q(
        predictorSamp[14]), .QN(n1411) );
  DFFARX1 \predictorSamp_reg[13]  ( .D(n593), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[13]), .QN(n1397) );
  DFFARX1 \predictorSamp_reg[12]  ( .D(n592), .CLK(clock), .RSTB(n1423), .Q(
        predictorSamp[12]), .QN(n1410) );
  DFFARX1 \predictorSamp_reg[11]  ( .D(n591), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[11]), .QN(n1396) );
  DFFARX1 \predictorSamp_reg[10]  ( .D(n590), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[10]), .QN(n1409) );
  DFFARX1 \predictorSamp_reg[9]  ( .D(n589), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[9]), .QN(n1395) );
  DFFARX1 \predictorSamp_reg[8]  ( .D(n588), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[8]), .QN(n1408) );
  DFFARX1 \predictorSamp_reg[7]  ( .D(n587), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[7]), .QN(n1394) );
  DFFARX1 \predictorSamp_reg[6]  ( .D(n586), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[6]), .QN(n1407) );
  DFFARX1 \predictorSamp_reg[5]  ( .D(n585), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[5]), .QN(n1393) );
  DFFARX1 \predictorSamp_reg[4]  ( .D(n584), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[4]), .QN(n1413) );
  DFFARX1 \predictorSamp_reg[3]  ( .D(n583), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[3]) );
  DFFARX1 \predictorSamp_reg[2]  ( .D(n582), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[2]), .QN(n1402) );
  DFFARX1 \predictorSamp_reg[1]  ( .D(n581), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[1]) );
  DFFARX1 \predictorSamp_reg[0]  ( .D(n598), .CLK(clock), .RSTB(n1428), .Q(
        predictorSamp[0]) );
  DFFARX1 \sampDiff_reg[19]  ( .D(n599), .CLK(clock), .RSTB(n1423), .Q(
        sampDiff[19]) );
  DFFARX1 \prePCM_reg[3]  ( .D(n562), .CLK(clock), .RSTB(n1426), .Q(prePCM[3])
         );
  DFFARX1 \sampDiff_reg[18]  ( .D(n546), .CLK(clock), .RSTB(n1423), .Q(
        sampDiff[18]), .QN(n1421) );
  DFFARX1 \sampDiff_reg[17]  ( .D(n547), .CLK(clock), .RSTB(n1423), .Q(
        sampDiff[17]), .QN(n1374) );
  DFFARX1 \sampDiff_reg[16]  ( .D(n548), .CLK(clock), .RSTB(n1423), .Q(
        sampDiff[16]), .QN(n1389) );
  DFFARX1 \sampDiff_reg[15]  ( .D(n549), .CLK(clock), .RSTB(n1423), .Q(
        sampDiff[15]), .QN(n1373) );
  DFFARX1 \sampDiff_reg[14]  ( .D(n550), .CLK(clock), .RSTB(n1423), .Q(
        sampDiff[14]), .QN(n1365) );
  DFFARX1 \sampDiff_reg[13]  ( .D(n551), .CLK(clock), .RSTB(n1423), .Q(
        sampDiff[13]), .QN(n1400) );
  DFFARX1 \sampDiff_reg[12]  ( .D(n552), .CLK(clock), .RSTB(n1423), .Q(
        sampDiff[12]), .QN(n1376) );
  DFFARX1 \sampDiff_reg[11]  ( .D(n553), .CLK(clock), .RSTB(n1423), .Q(
        sampDiff[11]), .QN(n1364) );
  DFFARX1 \sampDiff_reg[10]  ( .D(n554), .CLK(clock), .RSTB(n1424), .Q(
        sampDiff[10]), .QN(n1399) );
  DFFARX1 \sampDiff_reg[9]  ( .D(n555), .CLK(clock), .RSTB(n1424), .Q(
        sampDiff[9]), .QN(n1387) );
  DFFARX1 \sampDiff_reg[8]  ( .D(n556), .CLK(clock), .RSTB(n1424), .Q(
        sampDiff[8]), .QN(n1384) );
  DFFARX1 \sampDiff_reg[7]  ( .D(n557), .CLK(clock), .RSTB(n1424), .Q(
        sampDiff[7]), .QN(n1370) );
  DFFARX1 \sampDiff_reg[6]  ( .D(n558), .CLK(clock), .RSTB(n1424), .Q(
        sampDiff[6]), .QN(n1378) );
  DFFARX1 \sampDiff_reg[5]  ( .D(n559), .CLK(clock), .RSTB(n1424), .Q(
        sampDiff[5]), .QN(n1369) );
  DFFARX1 \sampDiff_reg[4]  ( .D(n560), .CLK(clock), .RSTB(n1424), .Q(
        sampDiff[4]), .QN(n1377) );
  DFFARX1 \sampDiff_reg[3]  ( .D(n561), .CLK(clock), .RSTB(n1424), .Q(
        sampDiff[3]), .QN(n1375) );
  DFFARX1 \sampDiff_reg[2]  ( .D(n538), .CLK(clock), .RSTB(n1424), .Q(
        sampDiff[2]), .QN(n1414) );
  DFFARX1 \sampDiff_reg[1]  ( .D(n536), .CLK(clock), .RSTB(n1424), .Q(
        sampDiff[1]) );
  DFFARX1 \sampDiff_reg[0]  ( .D(n537), .CLK(clock), .RSTB(n1424), .Q(N176) );
  DFFARX1 inReady_reg ( .D(n529), .CLK(clock), .RSTB(n1424), .Q(inReady) );
  DFFARX1 \trojan_state_reg[0]  ( .D(n542), .CLK(clock), .RSTB(n1425), .Q(
        trojan_state[0]) );
  DFFARX1 \trojan_state_reg[1]  ( .D(n541), .CLK(clock), .RSTB(n1425), .Q(
        trojan_state[1]), .QN(n1422) );
  DFFARX1 trojan_ena_reg ( .D(n540), .CLK(clock), .RSTB(n1425), .Q(trojan_ena)
         );
  DFFARX1 \outPCM_reg[3]  ( .D(n539), .CLK(clock), .RSTB(n1425), .Q(outPCM[3])
         );
  DFFARX1 \outPCM_reg[2]  ( .D(n532), .CLK(clock), .RSTB(n1425), .Q(outPCM[2])
         );
  DFFARX1 \outPCM_reg[1]  ( .D(n530), .CLK(clock), .RSTB(n1425), .Q(outPCM[1])
         );
  DFFARX1 \outPCM_reg[0]  ( .D(n534), .CLK(clock), .RSTB(n1425), .Q(outPCM[0])
         );
  DFFARX1 outValid_reg ( .D(N429), .CLK(clock), .RSTB(n1425), .Q(outValid) );
  DFFARX1 \dequantSamp_reg[14]  ( .D(n566), .CLK(clock), .RSTB(n1427), .Q(
        dequantSamp[14]) );
  DFFARX1 \dequantSamp_reg[13]  ( .D(n567), .CLK(clock), .RSTB(n1427), .Q(
        dequantSamp[13]) );
  DFFARX1 \dequantSamp_reg[12]  ( .D(n568), .CLK(clock), .RSTB(n1427), .Q(
        dequantSamp[12]) );
  DFFARX1 \dequantSamp_reg[11]  ( .D(n569), .CLK(clock), .RSTB(n1427), .Q(
        dequantSamp[11]) );
  DFFARX1 \dequantSamp_reg[10]  ( .D(n570), .CLK(clock), .RSTB(n1427), .Q(
        dequantSamp[10]) );
  DFFARX1 \dequantSamp_reg[9]  ( .D(n571), .CLK(clock), .RSTB(n1427), .Q(
        dequantSamp[9]) );
  DFFARX1 \dequantSamp_reg[8]  ( .D(n572), .CLK(clock), .RSTB(n1427), .Q(
        dequantSamp[8]) );
  DFFARX1 \dequantSamp_reg[7]  ( .D(n573), .CLK(clock), .RSTB(n1427), .Q(
        dequantSamp[7]) );
  DFFARX1 \dequantSamp_reg[6]  ( .D(n574), .CLK(clock), .RSTB(n1427), .Q(
        dequantSamp[6]) );
  DFFARX1 \dequantSamp_reg[5]  ( .D(n575), .CLK(clock), .RSTB(n1426), .Q(
        dequantSamp[5]) );
  DFFARX1 \dequantSamp_reg[4]  ( .D(n576), .CLK(clock), .RSTB(n1426), .Q(
        dequantSamp[4]) );
  DFFARX1 \dequantSamp_reg[3]  ( .D(n577), .CLK(clock), .RSTB(n1426), .Q(
        dequantSamp[3]) );
  DFFARX1 \dequantSamp_reg[2]  ( .D(n578), .CLK(clock), .RSTB(n1426), .Q(
        dequantSamp[2]) );
  DFFARX1 \dequantSamp_reg[1]  ( .D(n579), .CLK(clock), .RSTB(n1426), .Q(
        dequantSamp[1]) );
  DFFARX1 \dequantSamp_reg[0]  ( .D(n580), .CLK(clock), .RSTB(n1426), .Q(
        \C42/DATA2_0 ) );
  DFFARX1 \stepIndex_reg[6]  ( .D(n528), .CLK(clock), .RSTB(n1425), .Q(
        outStepIndex[6]), .QN(n1362) );
  DFFARX1 \stepIndex_reg[5]  ( .D(n527), .CLK(clock), .RSTB(n1425), .Q(
        outStepIndex[5]), .QN(n1371) );
  DFFARX1 \stepIndex_reg[4]  ( .D(n526), .CLK(clock), .RSTB(n1425), .Q(
        outStepIndex[4]), .QN(n1361) );
  DFFARX1 \stepIndex_reg[3]  ( .D(n525), .CLK(clock), .RSTB(n1425), .Q(
        outStepIndex[3]), .QN(n1360) );
  DFFARX1 \stepIndex_reg[2]  ( .D(n524), .CLK(clock), .RSTB(n1426), .Q(
        outStepIndex[2]), .QN(n1368) );
  DFFARX1 \stepIndex_reg[1]  ( .D(n523), .CLK(clock), .RSTB(n1426), .Q(
        outStepIndex[1]), .QN(n1383) );
  DFFARX1 \stepIndex_reg[0]  ( .D(n522), .CLK(clock), .RSTB(n1426), .Q(
        outStepIndex[0]), .QN(n1363) );
  DFFX1 \stepSize_reg[14]  ( .D(n620), .CLK(clock), .Q(stepSize[14]), .QN(
        n1418) );
  DFFX1 \stepSize_reg[13]  ( .D(n619), .CLK(clock), .Q(stepSize[13]), .QN(
        n1388) );
  DFFX1 \stepSize_reg[12]  ( .D(n618), .CLK(clock), .Q(stepSize[12]), .QN(
        n1379) );
  DFFX1 \stepSize_reg[11]  ( .D(n617), .CLK(clock), .Q(stepSize[11]), .QN(
        n1380) );
  DFFX1 \stepSize_reg[10]  ( .D(n616), .CLK(clock), .Q(stepSize[10]), .QN(
        n1372) );
  DFFX1 \stepSize_reg[9]  ( .D(n612), .CLK(clock), .Q(stepSize[9]), .QN(n1382)
         );
  DFFX1 \stepSize_reg[8]  ( .D(n611), .CLK(clock), .Q(stepSize[8]), .QN(n1390)
         );
  DFFX1 \stepSize_reg[7]  ( .D(n610), .CLK(clock), .Q(stepSize[7]), .QN(n1403)
         );
  DFFX1 \stepSize_reg[6]  ( .D(n606), .CLK(clock), .Q(stepSize[6]), .QN(n1392)
         );
  DFFX1 \stepSize_reg[5]  ( .D(n609), .CLK(clock), .Q(stepSize[5]), .QN(n1391)
         );
  DFFX1 \stepSize_reg[4]  ( .D(n615), .CLK(clock), .Q(stepSize[4]), .QN(n1406)
         );
  DFFX1 \stepSize_reg[3]  ( .D(n608), .CLK(clock), .Q(stepSize[3]), .QN(n1405)
         );
  DFFX1 \stepSize_reg[2]  ( .D(n607), .CLK(clock), .Q(stepSize[2]), .QN(n1404)
         );
  DFFX1 \stepSize_reg[1]  ( .D(n614), .CLK(clock), .Q(stepSize[1]), .QN(n1385)
         );
  DFFX1 \stepSize_reg[0]  ( .D(n613), .CLK(clock), .Q(stepSize[0]), .QN(n1420)
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
        n1401), .CO(\DP_OP_73J1_125_3932/n16 ), .S(\C42/DATA2_2 ) );
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
  NAND2X0 U619 ( .IN1(sampDiff[8]), .IN2(n1391), .QN(n643) );
  NAND2X0 U620 ( .IN1(n643), .IN2(n937), .QN(n644) );
  NAND2X0 U621 ( .IN1(sampDiff[10]), .IN2(n1403), .QN(n646) );
  NAND2X0 U622 ( .IN1(stepSize[11]), .IN2(n1376), .QN(n870) );
  NAND2X0 U623 ( .IN1(n1364), .IN2(stepSize[9]), .QN(n671) );
  NAND2X0 U624 ( .IN1(stepSize[7]), .IN2(n622), .QN(n728) );
  NAND2X0 U625 ( .IN1(sampDiff[14]), .IN2(n1379), .QN(n630) );
  NAND2X0 U626 ( .IN1(n1146), .IN2(n1189), .QN(n1039) );
  NAND2X0 U627 ( .IN1(inSamp[1]), .IN2(n1413), .QN(n795) );
  NAND2X0 U628 ( .IN1(inSamp[3]), .IN2(n1407), .QN(n958) );
  NAND2X0 U629 ( .IN1(inSamp[7]), .IN2(n1409), .QN(n920) );
  NAND2X0 U630 ( .IN1(inSamp[9]), .IN2(n1410), .QN(n1275) );
  NAND2X0 U631 ( .IN1(inSamp[13]), .IN2(n1412), .QN(n901) );
  NAND2X0 U632 ( .IN1(n1221), .IN2(n1220), .QN(n1224) );
  NAND2X0 U633 ( .IN1(n1199), .IN2(n1223), .QN(n1200) );
  NAND2X0 U634 ( .IN1(outStepIndex[3]), .IN2(n1045), .QN(n1187) );
  NAND2X0 U635 ( .IN1(n1192), .IN2(n1103), .QN(n1104) );
  NAND2X0 U636 ( .IN1(n1145), .IN2(n1118), .QN(n1069) );
  NAND2X0 U637 ( .IN1(n995), .IN2(n1402), .QN(n980) );
  NAND2X0 U638 ( .IN1(stepSize[9]), .IN2(n1282), .QN(n1272) );
  NAND2X0 U639 ( .IN1(stepSize[10]), .IN2(n1298), .QN(n1295) );
  NAND2X0 U640 ( .IN1(stepSize[11]), .IN2(n1331), .QN(n1318) );
  NAND2X0 U641 ( .IN1(n908), .IN2(n1374), .QN(n1345) );
  NAND2X0 U642 ( .IN1(n1165), .IN2(n1189), .QN(n1184) );
  NAND2X0 U643 ( .IN1(n1164), .IN2(n1163), .QN(n1222) );
  NAND2X0 U644 ( .IN1(n1199), .IN2(n1103), .QN(n1077) );
  NAND2X0 U645 ( .IN1(n1126), .IN2(n1074), .QN(n1060) );
  NAND2X0 U646 ( .IN1(n997), .IN2(n996), .QN(n1000) );
  NAND2X0 U647 ( .IN1(n1375), .IN2(stepSize[0]), .QN(n974) );
  NAND2X0 U648 ( .IN1(n784), .IN2(n1369), .QN(n969) );
  NAND2X0 U649 ( .IN1(n946), .IN2(n1387), .QN(n931) );
  NAND2X0 U650 ( .IN1(n927), .IN2(n1364), .QN(n1270) );
  NAND2X0 U651 ( .IN1(n1311), .IN2(n1373), .QN(n912) );
  NAND2X0 U652 ( .IN1(n1320), .IN2(n1319), .QN(n1260) );
  NAND2X0 U653 ( .IN1(n1239), .IN2(n869), .QN(n1332) );
  NAND2X0 U654 ( .IN1(n1108), .IN2(n1145), .QN(n1231) );
  NAND2X0 U655 ( .IN1(n1182), .IN2(n1144), .QN(n1114) );
  NAND2X0 U656 ( .IN1(n1192), .IN2(n1118), .QN(n1151) );
  NAND2X0 U657 ( .IN1(n1145), .IN2(n1191), .QN(n1071) );
  NAND2X0 U658 ( .IN1(n823), .IN2(n1005), .QN(n824) );
  NAND2X0 U659 ( .IN1(n1354), .IN2(inValid), .QN(n1355) );
  NAND2X0 U660 ( .IN1(n1349), .IN2(n781), .QN(n782) );
  NAND2X0 U661 ( .IN1(n1349), .IN2(n745), .QN(n746) );
  NAND2X0 U662 ( .IN1(n1349), .IN2(n1330), .QN(n1335) );
  NAND2X0 U663 ( .IN1(n1259), .IN2(n1258), .QN(n1352) );
  NAND2X0 U664 ( .IN1(predictorSamp[6]), .IN2(n1358), .QN(n837) );
  NAND2X0 U665 ( .IN1(n865), .IN2(prePredSamp[13]), .QN(n832) );
  NAND2X0 U666 ( .IN1(n636), .IN2(n1240), .QN(n893) );
  NAND2X0 U667 ( .IN1(predictorSamp[6]), .IN2(n1253), .QN(n1252) );
  NAND2X0 U668 ( .IN1(n813), .IN2(n975), .QN(n538) );
  NAND2X0 U669 ( .IN1(n727), .IN2(n726), .QN(n553) );
  NAND2X0 U670 ( .IN1(n893), .IN2(n637), .QN(n531) );
  INVX0 U671 ( .INP(reset), .ZN(n1424) );
  INVX0 U672 ( .INP(reset), .ZN(n1428) );
  INVX0 U673 ( .INP(reset), .ZN(n1423) );
  INVX0 U674 ( .INP(reset), .ZN(n1426) );
  INVX0 U675 ( .INP(reset), .ZN(n1425) );
  INVX0 U676 ( .INP(reset), .ZN(n1427) );
  NOR3X0 U677 ( .IN1(sampDiff[19]), .IN2(sampDiff[18]), .IN3(sampDiff[17]), 
        .QN(n890) );
  NAND2X0 U678 ( .IN1(sampDiff[16]), .IN2(n1418), .QN(n635) );
  NOR2X0 U679 ( .IN1(n1372), .IN2(sampDiff[12]), .QN(n624) );
  NAND2X0 U680 ( .IN1(n1414), .IN2(stepSize[0]), .QN(n985) );
  INVX0 U681 ( .INP(n985), .ZN(n986) );
  AO222X1 U682 ( .IN1(stepSize[1]), .IN2(n986), .IN3(stepSize[1]), .IN4(n1375), 
        .IN5(n986), .IN6(n1375), .Q(n785) );
  AO222X1 U683 ( .IN1(stepSize[2]), .IN2(n1377), .IN3(stepSize[2]), .IN4(n785), 
        .IN5(n1377), .IN6(n785), .Q(n766) );
  AO222X1 U684 ( .IN1(stepSize[3]), .IN2(n766), .IN3(stepSize[3]), .IN4(n1369), 
        .IN5(n766), .IN6(n1369), .Q(n956) );
  AO222X1 U685 ( .IN1(stepSize[4]), .IN2(n1378), .IN3(stepSize[4]), .IN4(n956), 
        .IN5(n1378), .IN6(n956), .Q(n748) );
  AO222X1 U686 ( .IN1(stepSize[5]), .IN2(n1370), .IN3(stepSize[5]), .IN4(n748), 
        .IN5(n1370), .IN6(n748), .Q(n936) );
  AO222X1 U687 ( .IN1(stepSize[6]), .IN2(n1384), .IN3(stepSize[6]), .IN4(n936), 
        .IN5(n1384), .IN6(n936), .Q(n622) );
  NOR2X0 U688 ( .IN1(stepSize[7]), .IN2(n622), .QN(n729) );
  OA21X1 U689 ( .IN1(sampDiff[9]), .IN2(n729), .IN3(n728), .Q(n918) );
  OA21X1 U690 ( .IN1(sampDiff[10]), .IN2(n1390), .IN3(n918), .Q(n673) );
  NAND2X0 U691 ( .IN1(n671), .IN2(n673), .QN(n623) );
  NOR2X0 U692 ( .IN1(n624), .IN2(n623), .QN(n628) );
  NAND2X0 U693 ( .IN1(stepSize[10]), .IN2(n1376), .QN(n626) );
  NOR2X0 U694 ( .IN1(stepSize[8]), .IN2(n1399), .QN(n672) );
  AO22X1 U695 ( .IN1(n672), .IN2(n671), .IN3(sampDiff[11]), .IN4(n1382), .Q(
        n625) );
  NOR2X0 U696 ( .IN1(n1400), .IN2(stepSize[11]), .QN(n675) );
  AO221X1 U697 ( .IN1(n1372), .IN2(sampDiff[12]), .IN3(n626), .IN4(n625), 
        .IN5(n675), .Q(n627) );
  NOR2X0 U698 ( .IN1(n628), .IN2(n627), .QN(n629) );
  NOR2X0 U699 ( .IN1(sampDiff[13]), .IN2(n1380), .QN(n677) );
  NOR2X0 U700 ( .IN1(sampDiff[14]), .IN2(n1379), .QN(n678) );
  OR3X1 U701 ( .IN1(n629), .IN2(n677), .IN3(n678), .Q(n632) );
  NAND2X0 U702 ( .IN1(sampDiff[15]), .IN2(n1388), .QN(n631) );
  AND3X1 U703 ( .IN1(n632), .IN2(n631), .IN3(n630), .Q(n633) );
  NOR2X0 U704 ( .IN1(sampDiff[16]), .IN2(n1418), .QN(n680) );
  NOR2X0 U705 ( .IN1(sampDiff[15]), .IN2(n1388), .QN(n679) );
  OR3X1 U706 ( .IN1(n633), .IN2(n680), .IN3(n679), .Q(n634) );
  NAND3X0 U707 ( .IN1(n890), .IN2(n635), .IN3(n634), .QN(n636) );
  NOR2X0 U708 ( .IN1(pcmSq[2]), .IN2(n1367), .QN(n894) );
  AND2X1 U709 ( .IN1(pcmSq[0]), .IN2(n894), .Q(n1240) );
  INVX0 U710 ( .INP(n1240), .ZN(n805) );
  NAND2X0 U711 ( .IN1(prePCM[1]), .IN2(n805), .QN(n637) );
  AND3X1 U712 ( .IN1(pcmSq[2]), .IN2(n1416), .IN3(n1367), .Q(n1238) );
  INVX0 U713 ( .INP(n1238), .ZN(n1053) );
  NAND2X0 U714 ( .IN1(n805), .IN2(n1053), .QN(n543) );
  AND2X1 U715 ( .IN1(n894), .IN2(n1416), .Q(n1239) );
  INVX0 U716 ( .INP(n1239), .ZN(n1237) );
  NAND2X0 U717 ( .IN1(pcmSq[0]), .IN2(n1367), .QN(n814) );
  NOR2X0 U718 ( .IN1(pcmSq[2]), .IN2(n814), .QN(n1236) );
  INVX0 U719 ( .INP(n1236), .ZN(n1241) );
  NAND2X0 U720 ( .IN1(n1237), .IN2(n1241), .QN(n544) );
  NOR2X0 U721 ( .IN1(sampDiff[16]), .IN2(n1388), .QN(n663) );
  NOR2X0 U722 ( .IN1(n1379), .IN2(sampDiff[15]), .QN(n665) );
  NOR2X0 U723 ( .IN1(sampDiff[14]), .IN2(n1380), .QN(n640) );
  NOR2X0 U724 ( .IN1(sampDiff[13]), .IN2(n1372), .QN(n639) );
  NOR2X0 U725 ( .IN1(sampDiff[12]), .IN2(n1382), .QN(n638) );
  NOR2X0 U726 ( .IN1(n1390), .IN2(sampDiff[11]), .QN(n650) );
  NOR2X0 U727 ( .IN1(n1403), .IN2(sampDiff[10]), .QN(n649) );
  NOR2X0 U728 ( .IN1(sampDiff[9]), .IN2(n1392), .QN(n642) );
  NOR2X0 U729 ( .IN1(sampDiff[8]), .IN2(n1391), .QN(n641) );
  INVX0 U730 ( .INP(n974), .ZN(n791) );
  AO222X1 U731 ( .IN1(stepSize[1]), .IN2(n791), .IN3(stepSize[1]), .IN4(n1377), 
        .IN5(n791), .IN6(n1377), .Q(n767) );
  AO222X1 U732 ( .IN1(stepSize[2]), .IN2(n767), .IN3(stepSize[2]), .IN4(n1369), 
        .IN5(n767), .IN6(n1369), .Q(n955) );
  AO222X1 U733 ( .IN1(stepSize[3]), .IN2(n955), .IN3(stepSize[3]), .IN4(n1378), 
        .IN5(n955), .IN6(n1378), .Q(n749) );
  AO222X1 U734 ( .IN1(stepSize[4]), .IN2(n749), .IN3(stepSize[4]), .IN4(n1370), 
        .IN5(n749), .IN6(n1370), .Q(n937) );
  OA22X1 U735 ( .IN1(stepSize[5]), .IN2(n1384), .IN3(n641), .IN4(n937), .Q(
        n731) );
  OA22X1 U736 ( .IN1(n642), .IN2(n731), .IN3(stepSize[6]), .IN4(n1387), .Q(
        n917) );
  OA22X1 U737 ( .IN1(stepSize[7]), .IN2(n1399), .IN3(n649), .IN4(n917), .Q(
        n711) );
  OA22X1 U738 ( .IN1(n650), .IN2(n711), .IN3(stepSize[8]), .IN4(n1364), .Q(
        n1282) );
  NAND2X0 U739 ( .IN1(n1382), .IN2(sampDiff[12]), .QN(n1283) );
  OA21X1 U740 ( .IN1(n638), .IN2(n1282), .IN3(n1283), .Q(n1298) );
  NAND2X0 U741 ( .IN1(n1372), .IN2(sampDiff[13]), .QN(n1299) );
  OA21X1 U742 ( .IN1(n639), .IN2(n1298), .IN3(n1299), .Q(n1331) );
  NAND2X0 U743 ( .IN1(n1380), .IN2(sampDiff[14]), .QN(n1333) );
  OA21X1 U744 ( .IN1(n640), .IN2(n1331), .IN3(n1333), .Q(n693) );
  OA22X1 U745 ( .IN1(n665), .IN2(n693), .IN3(stepSize[12]), .IN4(n1373), .Q(
        n899) );
  OA22X1 U746 ( .IN1(n663), .IN2(n899), .IN3(stepSize[13]), .IN4(n1389), .Q(
        n1256) );
  MUX21X1 U747 ( .IN1(stepSize[14]), .IN2(n1418), .S(n1256), .Q(n683) );
  INVX0 U748 ( .INP(n1333), .ZN(n660) );
  INVX0 U749 ( .INP(n1299), .ZN(n658) );
  INVX0 U750 ( .INP(n1283), .ZN(n656) );
  NOR2X0 U751 ( .IN1(stepSize[8]), .IN2(n1364), .QN(n654) );
  NOR2X0 U752 ( .IN1(n642), .IN2(n641), .QN(n645) );
  NAND2X0 U753 ( .IN1(n645), .IN2(n644), .QN(n648) );
  NAND2X0 U754 ( .IN1(sampDiff[9]), .IN2(n1392), .QN(n647) );
  NAND3X0 U755 ( .IN1(n648), .IN2(n647), .IN3(n646), .QN(n653) );
  INVX0 U756 ( .INP(n649), .ZN(n652) );
  INVX0 U757 ( .INP(n650), .ZN(n651) );
  OA221X1 U758 ( .IN1(n654), .IN2(n653), .IN3(n654), .IN4(n652), .IN5(n651), 
        .Q(n655) );
  OA22X1 U759 ( .IN1(n656), .IN2(n655), .IN3(sampDiff[12]), .IN4(n1382), .Q(
        n657) );
  OA22X1 U760 ( .IN1(n658), .IN2(n657), .IN3(sampDiff[13]), .IN4(n1372), .Q(
        n659) );
  OA22X1 U761 ( .IN1(sampDiff[14]), .IN2(n1380), .IN3(n660), .IN4(n659), .Q(
        n662) );
  NOR2X0 U762 ( .IN1(stepSize[12]), .IN2(n1373), .QN(n661) );
  NOR2X0 U763 ( .IN1(n1389), .IN2(stepSize[13]), .QN(n669) );
  NOR3X0 U764 ( .IN1(n662), .IN2(n661), .IN3(n669), .QN(n664) );
  NOR2X0 U765 ( .IN1(sampDiff[17]), .IN2(n1418), .QN(n1257) );
  NOR3X0 U766 ( .IN1(n664), .IN2(n663), .IN3(n1257), .QN(n670) );
  INVX0 U767 ( .INP(n665), .ZN(n668) );
  NOR2X0 U768 ( .IN1(stepSize[14]), .IN2(n1374), .QN(n666) );
  OR3X1 U769 ( .IN1(sampDiff[19]), .IN2(sampDiff[18]), .IN3(n666), .Q(n667) );
  AO221X1 U770 ( .IN1(n670), .IN2(n669), .IN3(n670), .IN4(n668), .IN5(n667), 
        .Q(n869) );
  INVX0 U771 ( .INP(n1332), .ZN(n1340) );
  INVX0 U772 ( .INP(n1340), .ZN(n1319) );
  INVX0 U773 ( .INP(n671), .ZN(n674) );
  NOR2X0 U774 ( .IN1(n673), .IN2(n672), .QN(n710) );
  OA22X1 U775 ( .IN1(n674), .IN2(n710), .IN3(stepSize[9]), .IN4(n1364), .Q(
        n1266) );
  AO222X1 U776 ( .IN1(stepSize[10]), .IN2(n1266), .IN3(stepSize[10]), .IN4(
        n1376), .IN5(n1266), .IN6(n1376), .Q(n1289) );
  INVX0 U777 ( .INP(n675), .ZN(n676) );
  OA21X1 U778 ( .IN1(n677), .IN2(n1289), .IN3(n676), .Q(n1312) );
  OA22X1 U779 ( .IN1(stepSize[12]), .IN2(n1365), .IN3(n678), .IN4(n1312), .Q(
        n692) );
  OA22X1 U780 ( .IN1(stepSize[13]), .IN2(n1373), .IN3(n679), .IN4(n692), .Q(
        n898) );
  OA22X1 U781 ( .IN1(n680), .IN2(n898), .IN3(stepSize[14]), .IN4(n1389), .Q(
        n682) );
  INVX0 U782 ( .INP(n893), .ZN(n984) );
  INVX0 U783 ( .INP(n984), .ZN(n1320) );
  NOR3X0 U784 ( .IN1(pcmSq[0]), .IN2(pcmSq[1]), .IN3(pcmSq[2]), .QN(n1354) );
  INVX0 U785 ( .INP(n1355), .ZN(n1349) );
  AND2X1 U786 ( .IN1(sampDiff[19]), .IN2(n1236), .Q(n1288) );
  NOR2X0 U787 ( .IN1(n1349), .IN2(n1288), .QN(n1001) );
  NAND2X0 U788 ( .IN1(n1001), .IN2(n893), .QN(n811) );
  INVX0 U789 ( .INP(n811), .ZN(n810) );
  NAND2X0 U790 ( .IN1(n810), .IN2(n1332), .QN(n1322) );
  OA21X1 U791 ( .IN1(n682), .IN2(n1320), .IN3(n1322), .Q(n1259) );
  OA21X1 U792 ( .IN1(n683), .IN2(n1319), .IN3(n1259), .Q(n681) );
  NOR2X0 U793 ( .IN1(n681), .IN2(n1374), .QN(n687) );
  OR2X1 U794 ( .IN1(sampDiff[1]), .IN2(N176), .Q(n806) );
  NOR2X0 U795 ( .IN1(sampDiff[2]), .IN2(n806), .QN(n988) );
  NAND2X0 U796 ( .IN1(n988), .IN2(n1375), .QN(n983) );
  NOR2X0 U797 ( .IN1(sampDiff[4]), .IN2(n983), .QN(n784) );
  NOR2X0 U798 ( .IN1(sampDiff[6]), .IN2(n969), .QN(n965) );
  NAND2X0 U799 ( .IN1(n965), .IN2(n1370), .QN(n950) );
  NOR2X0 U800 ( .IN1(sampDiff[8]), .IN2(n950), .QN(n946) );
  NOR2X0 U801 ( .IN1(sampDiff[10]), .IN2(n931), .QN(n927) );
  NOR2X0 U802 ( .IN1(sampDiff[12]), .IN2(n1270), .QN(n1265) );
  NAND2X0 U803 ( .IN1(n1265), .IN2(n1400), .QN(n1316) );
  NOR2X0 U804 ( .IN1(sampDiff[14]), .IN2(n1316), .QN(n1311) );
  NOR2X0 U805 ( .IN1(sampDiff[16]), .IN2(n912), .QN(n908) );
  AND2X1 U806 ( .IN1(n1288), .IN2(n1345), .Q(n685) );
  AND2X1 U807 ( .IN1(n984), .IN2(n682), .Q(n1338) );
  AO21X1 U808 ( .IN1(n1340), .IN2(n683), .IN3(n1338), .Q(n684) );
  AO222X1 U809 ( .IN1(n685), .IN2(n1374), .IN3(n685), .IN4(n908), .IN5(n1374), 
        .IN6(n684), .Q(n686) );
  NOR2X0 U810 ( .IN1(n687), .IN2(n686), .QN(n691) );
  MUX21X1 U811 ( .IN1(n1386), .IN2(predictorSamp[17]), .S(inSamp[14]), .Q(n688) );
  NOR2X0 U812 ( .IN1(inSamp[13]), .IN2(n1412), .QN(n902) );
  NOR2X0 U813 ( .IN1(inSamp[12]), .IN2(n1398), .QN(n702) );
  NOR2X0 U814 ( .IN1(inSamp[11]), .IN2(n1411), .QN(n1325) );
  NOR2X0 U815 ( .IN1(inSamp[10]), .IN2(n1397), .QN(n1301) );
  NOR2X0 U816 ( .IN1(inSamp[9]), .IN2(n1410), .QN(n1276) );
  NOR2X0 U817 ( .IN1(inSamp[8]), .IN2(n1396), .QN(n720) );
  NOR2X0 U818 ( .IN1(inSamp[7]), .IN2(n1409), .QN(n921) );
  NOR2X0 U819 ( .IN1(inSamp[6]), .IN2(n1395), .QN(n740) );
  NOR2X0 U820 ( .IN1(inSamp[5]), .IN2(n1408), .QN(n940) );
  NOR2X0 U821 ( .IN1(inSamp[4]), .IN2(n1394), .QN(n758) );
  NOR2X0 U822 ( .IN1(inSamp[3]), .IN2(n1407), .QN(n959) );
  NOR2X0 U823 ( .IN1(inSamp[2]), .IN2(n1393), .QN(n776) );
  NOR2X0 U824 ( .IN1(inSamp[1]), .IN2(n1413), .QN(n796) );
  INVX0 U825 ( .INP(inSamp[0]), .ZN(n981) );
  NOR2X0 U826 ( .IN1(predictorSamp[1]), .IN2(predictorSamp[0]), .QN(n995) );
  OA21X1 U827 ( .IN1(n796), .IN2(n800), .IN3(n795), .Q(n779) );
  NAND2X0 U828 ( .IN1(inSamp[2]), .IN2(n1393), .QN(n775) );
  OA21X1 U829 ( .IN1(n776), .IN2(n779), .IN3(n775), .Q(n962) );
  OA21X1 U830 ( .IN1(n959), .IN2(n962), .IN3(n958), .Q(n761) );
  NAND2X0 U831 ( .IN1(inSamp[4]), .IN2(n1394), .QN(n757) );
  OA21X1 U832 ( .IN1(n758), .IN2(n761), .IN3(n757), .Q(n943) );
  NAND2X0 U833 ( .IN1(inSamp[5]), .IN2(n1408), .QN(n939) );
  OA21X1 U834 ( .IN1(n940), .IN2(n943), .IN3(n939), .Q(n743) );
  NAND2X0 U835 ( .IN1(inSamp[6]), .IN2(n1395), .QN(n739) );
  OA21X1 U836 ( .IN1(n740), .IN2(n743), .IN3(n739), .Q(n924) );
  OA21X1 U837 ( .IN1(n921), .IN2(n924), .IN3(n920), .Q(n723) );
  NAND2X0 U838 ( .IN1(inSamp[8]), .IN2(n1396), .QN(n719) );
  OA21X1 U839 ( .IN1(n720), .IN2(n723), .IN3(n719), .Q(n1279) );
  OA21X1 U840 ( .IN1(n1276), .IN2(n1279), .IN3(n1275), .Q(n1304) );
  NAND2X0 U841 ( .IN1(inSamp[10]), .IN2(n1397), .QN(n1300) );
  OA21X1 U842 ( .IN1(n1301), .IN2(n1304), .IN3(n1300), .Q(n1328) );
  NAND2X0 U843 ( .IN1(inSamp[11]), .IN2(n1411), .QN(n1324) );
  OA21X1 U844 ( .IN1(n1325), .IN2(n1328), .IN3(n1324), .Q(n705) );
  NAND2X0 U845 ( .IN1(inSamp[12]), .IN2(n1398), .QN(n701) );
  OA21X1 U846 ( .IN1(n702), .IN2(n705), .IN3(n701), .Q(n905) );
  OAI21X1 U847 ( .IN1(n902), .IN2(n905), .IN3(n901), .QN(n1261) );
  XOR2X1 U848 ( .IN1(n688), .IN2(n1261), .Q(n689) );
  NAND2X0 U849 ( .IN1(n1349), .IN2(n689), .QN(n690) );
  NAND2X0 U850 ( .IN1(n691), .IN2(n690), .QN(n547) );
  INVX0 U851 ( .INP(n1322), .ZN(n976) );
  MUX21X1 U852 ( .IN1(stepSize[13]), .IN2(n1388), .S(n692), .Q(n696) );
  MUX21X1 U853 ( .IN1(stepSize[12]), .IN2(n1379), .S(n693), .Q(n695) );
  OAI22X1 U854 ( .IN1(n1320), .IN2(n696), .IN3(n1319), .IN4(n695), .QN(n694)
         );
  OA21X1 U855 ( .IN1(n976), .IN2(n694), .IN3(sampDiff[15]), .Q(n700) );
  AND2X1 U856 ( .IN1(n1288), .IN2(n912), .Q(n698) );
  AO22X1 U857 ( .IN1(n984), .IN2(n696), .IN3(n1340), .IN4(n695), .Q(n697) );
  AO222X1 U858 ( .IN1(n698), .IN2(n1373), .IN3(n698), .IN4(n1311), .IN5(n1373), 
        .IN6(n697), .Q(n699) );
  NOR2X0 U859 ( .IN1(n700), .IN2(n699), .QN(n709) );
  INVX0 U860 ( .INP(n705), .ZN(n706) );
  INVX0 U861 ( .INP(n701), .ZN(n703) );
  NOR2X0 U862 ( .IN1(n703), .IN2(n702), .QN(n704) );
  MUX21X1 U863 ( .IN1(n706), .IN2(n705), .S(n704), .Q(n707) );
  NAND2X0 U864 ( .IN1(n1349), .IN2(n707), .QN(n708) );
  NAND2X0 U865 ( .IN1(n709), .IN2(n708), .QN(n549) );
  MUX21X1 U866 ( .IN1(stepSize[9]), .IN2(n1382), .S(n710), .Q(n714) );
  MUX21X1 U867 ( .IN1(stepSize[8]), .IN2(n1390), .S(n711), .Q(n713) );
  OAI22X1 U868 ( .IN1(n1320), .IN2(n714), .IN3(n1319), .IN4(n713), .QN(n712)
         );
  OA21X1 U869 ( .IN1(n976), .IN2(n712), .IN3(sampDiff[11]), .Q(n718) );
  AND2X1 U870 ( .IN1(n1288), .IN2(n1270), .Q(n716) );
  AO22X1 U871 ( .IN1(n984), .IN2(n714), .IN3(n1340), .IN4(n713), .Q(n715) );
  AO222X1 U872 ( .IN1(n716), .IN2(n1364), .IN3(n716), .IN4(n927), .IN5(n1364), 
        .IN6(n715), .Q(n717) );
  NOR2X0 U873 ( .IN1(n718), .IN2(n717), .QN(n727) );
  INVX0 U874 ( .INP(n723), .ZN(n724) );
  INVX0 U875 ( .INP(n719), .ZN(n721) );
  NOR2X0 U876 ( .IN1(n721), .IN2(n720), .QN(n722) );
  MUX21X1 U877 ( .IN1(n724), .IN2(n723), .S(n722), .Q(n725) );
  NAND2X0 U878 ( .IN1(n1349), .IN2(n725), .QN(n726) );
  INVX0 U879 ( .INP(n728), .ZN(n730) );
  NOR2X0 U880 ( .IN1(n730), .IN2(n729), .QN(n734) );
  MUX21X1 U881 ( .IN1(stepSize[6]), .IN2(n1392), .S(n731), .Q(n733) );
  OAI22X1 U882 ( .IN1(n1320), .IN2(n734), .IN3(n1319), .IN4(n733), .QN(n732)
         );
  OA21X1 U883 ( .IN1(n976), .IN2(n732), .IN3(sampDiff[9]), .Q(n738) );
  AND2X1 U884 ( .IN1(n1288), .IN2(n931), .Q(n736) );
  AO22X1 U885 ( .IN1(n984), .IN2(n734), .IN3(n1340), .IN4(n733), .Q(n735) );
  AO222X1 U886 ( .IN1(n736), .IN2(n1387), .IN3(n736), .IN4(n946), .IN5(n1387), 
        .IN6(n735), .Q(n737) );
  NOR2X0 U887 ( .IN1(n738), .IN2(n737), .QN(n747) );
  INVX0 U888 ( .INP(n743), .ZN(n744) );
  INVX0 U889 ( .INP(n739), .ZN(n741) );
  NOR2X0 U890 ( .IN1(n741), .IN2(n740), .QN(n742) );
  MUX21X1 U891 ( .IN1(n744), .IN2(n743), .S(n742), .Q(n745) );
  NAND2X0 U892 ( .IN1(n747), .IN2(n746), .QN(n555) );
  MUX21X1 U893 ( .IN1(stepSize[5]), .IN2(n1391), .S(n748), .Q(n752) );
  MUX21X1 U894 ( .IN1(stepSize[4]), .IN2(n1406), .S(n749), .Q(n751) );
  OAI22X1 U895 ( .IN1(n1320), .IN2(n752), .IN3(n1319), .IN4(n751), .QN(n750)
         );
  OA21X1 U896 ( .IN1(n976), .IN2(n750), .IN3(sampDiff[7]), .Q(n756) );
  AND2X1 U897 ( .IN1(n1288), .IN2(n950), .Q(n754) );
  AO22X1 U898 ( .IN1(n984), .IN2(n752), .IN3(n1340), .IN4(n751), .Q(n753) );
  AO222X1 U899 ( .IN1(n754), .IN2(n1370), .IN3(n754), .IN4(n965), .IN5(n1370), 
        .IN6(n753), .Q(n755) );
  NOR2X0 U900 ( .IN1(n756), .IN2(n755), .QN(n765) );
  INVX0 U901 ( .INP(n761), .ZN(n762) );
  INVX0 U902 ( .INP(n757), .ZN(n759) );
  NOR2X0 U903 ( .IN1(n759), .IN2(n758), .QN(n760) );
  MUX21X1 U904 ( .IN1(n762), .IN2(n761), .S(n760), .Q(n763) );
  NAND2X0 U905 ( .IN1(n1349), .IN2(n763), .QN(n764) );
  NAND2X0 U906 ( .IN1(n765), .IN2(n764), .QN(n557) );
  MUX21X1 U907 ( .IN1(stepSize[3]), .IN2(n1405), .S(n766), .Q(n770) );
  MUX21X1 U908 ( .IN1(stepSize[2]), .IN2(n1404), .S(n767), .Q(n769) );
  OAI22X1 U909 ( .IN1(n1320), .IN2(n770), .IN3(n1319), .IN4(n769), .QN(n768)
         );
  OA21X1 U910 ( .IN1(n976), .IN2(n768), .IN3(sampDiff[5]), .Q(n774) );
  AND2X1 U911 ( .IN1(n1288), .IN2(n969), .Q(n772) );
  AO22X1 U912 ( .IN1(n984), .IN2(n770), .IN3(n1340), .IN4(n769), .Q(n771) );
  AO222X1 U913 ( .IN1(n772), .IN2(n1369), .IN3(n772), .IN4(n784), .IN5(n1369), 
        .IN6(n771), .Q(n773) );
  NOR2X0 U914 ( .IN1(n774), .IN2(n773), .QN(n783) );
  INVX0 U915 ( .INP(n779), .ZN(n780) );
  INVX0 U916 ( .INP(n775), .ZN(n777) );
  NOR2X0 U917 ( .IN1(n777), .IN2(n776), .QN(n778) );
  MUX21X1 U918 ( .IN1(n780), .IN2(n779), .S(n778), .Q(n781) );
  NAND2X0 U919 ( .IN1(n783), .IN2(n782), .QN(n559) );
  INVX0 U920 ( .INP(n1288), .ZN(n1343) );
  OR2X1 U921 ( .IN1(n784), .IN2(n1343), .Q(n789) );
  MUX21X1 U922 ( .IN1(stepSize[2]), .IN2(n1404), .S(n785), .Q(n790) );
  INVX0 U923 ( .INP(n790), .ZN(n787) );
  AO221X1 U924 ( .IN1(n791), .IN2(stepSize[1]), .IN3(n974), .IN4(n1385), .IN5(
        n1332), .Q(n786) );
  OA21X1 U925 ( .IN1(n787), .IN2(n1320), .IN3(n786), .Q(n788) );
  AO222X1 U926 ( .IN1(sampDiff[4]), .IN2(n789), .IN3(sampDiff[4]), .IN4(n983), 
        .IN5(n789), .IN6(n788), .Q(n804) );
  NOR2X0 U927 ( .IN1(n790), .IN2(n1320), .QN(n794) );
  AO221X1 U928 ( .IN1(n791), .IN2(n1385), .IN3(n974), .IN4(stepSize[1]), .IN5(
        n1319), .Q(n792) );
  NAND2X0 U929 ( .IN1(n1322), .IN2(n792), .QN(n793) );
  NOR2X0 U930 ( .IN1(n794), .IN2(n793), .QN(n802) );
  INVX0 U931 ( .INP(n800), .ZN(n799) );
  INVX0 U932 ( .INP(n795), .ZN(n797) );
  NOR2X0 U933 ( .IN1(n797), .IN2(n796), .QN(n798) );
  MUX21X1 U934 ( .IN1(n800), .IN2(n799), .S(n798), .Q(n801) );
  OA22X1 U935 ( .IN1(n802), .IN2(n1377), .IN3(n1355), .IN4(n801), .Q(n803) );
  NAND2X0 U936 ( .IN1(n804), .IN2(n803), .QN(n560) );
  OA22X1 U937 ( .IN1(stepSize[0]), .IN2(n805), .IN3(n806), .IN4(n1241), .Q(
        n812) );
  NOR2X0 U938 ( .IN1(n995), .IN2(n1402), .QN(n808) );
  NAND2X0 U939 ( .IN1(n1354), .IN2(n980), .QN(n807) );
  NAND2X0 U940 ( .IN1(n1236), .IN2(n806), .QN(n998) );
  OA22X1 U941 ( .IN1(n808), .IN2(n807), .IN3(sampDiff[2]), .IN4(n998), .Q(n809) );
  OA222X1 U942 ( .IN1(n1414), .IN2(n812), .IN3(n1414), .IN4(n811), .IN5(n810), 
        .IN6(n809), .Q(n813) );
  NAND2X0 U943 ( .IN1(n986), .IN2(n984), .QN(n975) );
  NOR2X0 U944 ( .IN1(n1419), .IN2(n814), .QN(n1353) );
  INVX0 U945 ( .INP(n1353), .ZN(n1358) );
  NOR2X0 U946 ( .IN1(n1417), .IN2(n1366), .QN(n815) );
  NOR2X0 U947 ( .IN1(n815), .IN2(n1381), .QN(n821) );
  OA221X1 U948 ( .IN1(prePCM[1]), .IN2(n1366), .IN3(n1417), .IN4(prePCM[0]), 
        .IN5(prePCM[2]), .Q(n1009) );
  NOR2X0 U949 ( .IN1(n1381), .IN2(n1366), .QN(n1012) );
  NAND2X0 U950 ( .IN1(n1381), .IN2(outStepIndex[0]), .QN(n1011) );
  OA21X1 U951 ( .IN1(n1012), .IN2(n1383), .IN3(n1011), .Q(n1008) );
  INVX0 U952 ( .INP(n816), .ZN(n817) );
  OA221X1 U953 ( .IN1(prePCM[2]), .IN2(n817), .IN3(n1381), .IN4(n816), .IN5(
        n1353), .Q(n1006) );
  FADDX1 U954 ( .A(prePCM[2]), .B(n1361), .CI(n818), .CO(n819), .S(n823) );
  FADDX1 U955 ( .A(prePCM[2]), .B(n1371), .CI(n819), .CO(n822), .S(n1007) );
  FADDX1 U956 ( .A(n1360), .B(n821), .CI(n820), .CO(n818), .S(n827) );
  FADDX1 U957 ( .A(prePCM[2]), .B(n1362), .CI(n822), .CO(n816), .S(n825) );
  AO221X1 U958 ( .IN1(n1007), .IN2(n823), .IN3(n1007), .IN4(n827), .IN5(n825), 
        .Q(n1005) );
  AO22X1 U959 ( .IN1(outStepIndex[4]), .IN2(n1358), .IN3(n1006), .IN4(n824), 
        .Q(n526) );
  INVX0 U960 ( .INP(n825), .ZN(n826) );
  AO22X1 U961 ( .IN1(n826), .IN2(n1006), .IN3(n1358), .IN4(outStepIndex[6]), 
        .Q(n528) );
  NAND2X0 U962 ( .IN1(n827), .IN2(n1005), .QN(n828) );
  AO22X1 U963 ( .IN1(outStepIndex[3]), .IN2(n1358), .IN3(n1006), .IN4(n828), 
        .Q(n525) );
  XOR2X1 U964 ( .IN1(predictorSamp[18]), .IN2(prePCM[3]), .Q(n829) );
  XOR2X1 U965 ( .IN1(\DP_OP_36J1_122_4812/n2 ), .IN2(n829), .Q(n896) );
  INVX0 U966 ( .INP(n896), .ZN(n830) );
  NAND3X0 U967 ( .IN1(prePredSamp[18]), .IN2(n1353), .IN3(n830), .QN(n868) );
  OA21X1 U968 ( .IN1(prePredSamp[18]), .IN2(n830), .IN3(n1353), .Q(n865) );
  NAND2X0 U969 ( .IN1(predictorSamp[13]), .IN2(n1358), .QN(n831) );
  NAND3X0 U970 ( .IN1(n868), .IN2(n832), .IN3(n831), .QN(n593) );
  NAND2X0 U971 ( .IN1(n865), .IN2(prePredSamp[4]), .QN(n834) );
  NAND2X0 U972 ( .IN1(predictorSamp[4]), .IN2(n1358), .QN(n833) );
  NAND3X0 U973 ( .IN1(n868), .IN2(n834), .IN3(n833), .QN(n584) );
  NAND2X0 U974 ( .IN1(n865), .IN2(prePredSamp[17]), .QN(n836) );
  NAND2X0 U975 ( .IN1(predictorSamp[17]), .IN2(n1358), .QN(n835) );
  NAND3X0 U976 ( .IN1(n868), .IN2(n836), .IN3(n835), .QN(n600) );
  NAND2X0 U977 ( .IN1(n865), .IN2(prePredSamp[6]), .QN(n838) );
  NAND3X0 U978 ( .IN1(n868), .IN2(n838), .IN3(n837), .QN(n586) );
  NAND2X0 U979 ( .IN1(n865), .IN2(prePredSamp[3]), .QN(n840) );
  NAND2X0 U980 ( .IN1(predictorSamp[3]), .IN2(n1358), .QN(n839) );
  NAND3X0 U981 ( .IN1(n868), .IN2(n840), .IN3(n839), .QN(n583) );
  NAND2X0 U982 ( .IN1(n865), .IN2(prePredSamp[10]), .QN(n842) );
  NAND2X0 U983 ( .IN1(predictorSamp[10]), .IN2(n1358), .QN(n841) );
  NAND3X0 U984 ( .IN1(n868), .IN2(n842), .IN3(n841), .QN(n590) );
  NAND2X0 U985 ( .IN1(n865), .IN2(prePredSamp[9]), .QN(n844) );
  NAND2X0 U986 ( .IN1(predictorSamp[9]), .IN2(n1358), .QN(n843) );
  NAND3X0 U987 ( .IN1(n868), .IN2(n844), .IN3(n843), .QN(n589) );
  NAND2X0 U988 ( .IN1(n865), .IN2(prePredSamp[14]), .QN(n846) );
  NAND2X0 U989 ( .IN1(predictorSamp[14]), .IN2(n1358), .QN(n845) );
  NAND3X0 U990 ( .IN1(n868), .IN2(n846), .IN3(n845), .QN(n594) );
  NAND2X0 U991 ( .IN1(n865), .IN2(prePredSamp[2]), .QN(n848) );
  NAND2X0 U992 ( .IN1(predictorSamp[2]), .IN2(n1358), .QN(n847) );
  NAND3X0 U993 ( .IN1(n868), .IN2(n848), .IN3(n847), .QN(n582) );
  NAND2X0 U994 ( .IN1(n865), .IN2(prePredSamp[8]), .QN(n850) );
  NAND2X0 U995 ( .IN1(predictorSamp[8]), .IN2(n1358), .QN(n849) );
  NAND3X0 U996 ( .IN1(n868), .IN2(n850), .IN3(n849), .QN(n588) );
  NAND2X0 U997 ( .IN1(n865), .IN2(prePredSamp[16]), .QN(n852) );
  NAND2X0 U998 ( .IN1(predictorSamp[16]), .IN2(n1358), .QN(n851) );
  NAND3X0 U999 ( .IN1(n852), .IN2(n868), .IN3(n851), .QN(n596) );
  NAND2X0 U1000 ( .IN1(n865), .IN2(prePredSamp[1]), .QN(n854) );
  NAND2X0 U1001 ( .IN1(predictorSamp[1]), .IN2(n1358), .QN(n853) );
  NAND3X0 U1002 ( .IN1(n868), .IN2(n854), .IN3(n853), .QN(n581) );
  NAND2X0 U1003 ( .IN1(n865), .IN2(prePredSamp[11]), .QN(n856) );
  NAND2X0 U1004 ( .IN1(predictorSamp[11]), .IN2(n1358), .QN(n855) );
  NAND3X0 U1005 ( .IN1(n868), .IN2(n856), .IN3(n855), .QN(n591) );
  NAND2X0 U1006 ( .IN1(n865), .IN2(prePredSamp[0]), .QN(n858) );
  NAND2X0 U1007 ( .IN1(predictorSamp[0]), .IN2(n1358), .QN(n857) );
  NAND3X0 U1008 ( .IN1(n868), .IN2(n858), .IN3(n857), .QN(n598) );
  NAND2X0 U1009 ( .IN1(n865), .IN2(prePredSamp[7]), .QN(n860) );
  NAND2X0 U1010 ( .IN1(predictorSamp[7]), .IN2(n1358), .QN(n859) );
  NAND3X0 U1011 ( .IN1(n868), .IN2(n860), .IN3(n859), .QN(n587) );
  NAND2X0 U1012 ( .IN1(n865), .IN2(prePredSamp[15]), .QN(n862) );
  NAND2X0 U1013 ( .IN1(predictorSamp[15]), .IN2(n1358), .QN(n861) );
  NAND3X0 U1014 ( .IN1(n868), .IN2(n862), .IN3(n861), .QN(n595) );
  NAND2X0 U1015 ( .IN1(n865), .IN2(prePredSamp[5]), .QN(n864) );
  NAND2X0 U1016 ( .IN1(predictorSamp[5]), .IN2(n1358), .QN(n863) );
  NAND3X0 U1017 ( .IN1(n868), .IN2(n864), .IN3(n863), .QN(n585) );
  NAND2X0 U1018 ( .IN1(n865), .IN2(prePredSamp[12]), .QN(n867) );
  NAND2X0 U1019 ( .IN1(predictorSamp[12]), .IN2(n1358), .QN(n866) );
  NAND3X0 U1020 ( .IN1(n868), .IN2(n867), .IN3(n866), .QN(n592) );
  XOR2X1 U1021 ( .IN1(prePCM[3]), .IN2(dequantSamp[18]), .Q(
        \DP_OP_36J1_122_4812/n25 ) );
  MUX21X1 U1022 ( .IN1(n869), .IN2(prePCM[2]), .S(n1237), .Q(n533) );
  NOR2X0 U1023 ( .IN1(sampDiff[13]), .IN2(n1379), .QN(n887) );
  NOR2X0 U1024 ( .IN1(n1376), .IN2(stepSize[11]), .QN(n885) );
  NAND3X0 U1025 ( .IN1(sampDiff[11]), .IN2(n1372), .IN3(n870), .QN(n883) );
  OA21X1 U1026 ( .IN1(n1420), .IN2(n1385), .IN3(n985), .Q(n871) );
  OAI22X1 U1027 ( .IN1(sampDiff[2]), .IN2(n1385), .IN3(sampDiff[1]), .IN4(n871), .QN(n872) );
  AO222X1 U1028 ( .IN1(stepSize[2]), .IN2(n1375), .IN3(stepSize[2]), .IN4(n872), .IN5(n1375), .IN6(n872), .Q(n873) );
  AO222X1 U1029 ( .IN1(stepSize[3]), .IN2(n1377), .IN3(stepSize[3]), .IN4(n873), .IN5(n1377), .IN6(n873), .Q(n874) );
  AO222X1 U1030 ( .IN1(stepSize[4]), .IN2(n874), .IN3(stepSize[4]), .IN4(n1369), .IN5(n874), .IN6(n1369), .Q(n875) );
  AO222X1 U1031 ( .IN1(stepSize[5]), .IN2(n1378), .IN3(stepSize[5]), .IN4(n875), .IN5(n1378), .IN6(n875), .Q(n876) );
  AO222X1 U1032 ( .IN1(stepSize[6]), .IN2(n876), .IN3(stepSize[6]), .IN4(n1370), .IN5(n876), .IN6(n1370), .Q(n877) );
  AO222X1 U1033 ( .IN1(stepSize[7]), .IN2(n1384), .IN3(stepSize[7]), .IN4(n877), .IN5(n1384), .IN6(n877), .Q(n878) );
  AO222X1 U1034 ( .IN1(stepSize[8]), .IN2(n878), .IN3(stepSize[8]), .IN4(n1387), .IN5(n878), .IN6(n1387), .Q(n880) );
  OR2X1 U1035 ( .IN1(stepSize[9]), .IN2(n880), .Q(n881) );
  AO22X1 U1036 ( .IN1(stepSize[11]), .IN2(n1376), .IN3(stepSize[10]), .IN4(
        n1364), .Q(n879) );
  AO221X1 U1037 ( .IN1(n881), .IN2(n1399), .IN3(n880), .IN4(stepSize[9]), 
        .IN5(n879), .Q(n882) );
  NAND2X0 U1038 ( .IN1(n883), .IN2(n882), .QN(n884) );
  NOR2X0 U1039 ( .IN1(n885), .IN2(n884), .QN(n886) );
  OA222X1 U1040 ( .IN1(n1365), .IN2(stepSize[13]), .IN3(n1400), .IN4(
        stepSize[12]), .IN5(n887), .IN6(n886), .Q(n889) );
  AO22X1 U1041 ( .IN1(stepSize[14]), .IN2(n1373), .IN3(stepSize[13]), .IN4(
        n1365), .Q(n888) );
  OA22X1 U1042 ( .IN1(n889), .IN2(n888), .IN3(stepSize[14]), .IN4(n1373), .Q(
        n891) );
  NAND3X0 U1043 ( .IN1(n891), .IN2(n890), .IN3(n1389), .QN(n892) );
  NAND2X0 U1044 ( .IN1(n892), .IN2(n1238), .QN(n897) );
  AND4X1 U1045 ( .IN1(n1332), .IN2(n893), .IN3(n1241), .IN4(n897), .Q(n1234)
         );
  NOR2X0 U1046 ( .IN1(n894), .IN2(n1238), .QN(n1055) );
  NOR2X0 U1047 ( .IN1(n1234), .IN2(n1055), .QN(n1235) );
  AO22X1 U1048 ( .IN1(n1235), .IN2(\C42/DATA2_15 ), .IN3(n1234), .IN4(
        dequantSamp[15]), .Q(n565) );
  AO22X1 U1049 ( .IN1(n1235), .IN2(\C42/DATA2_16 ), .IN3(n1234), .IN4(
        dequantSamp[16]), .Q(n564) );
  AO22X1 U1050 ( .IN1(n1235), .IN2(\C42/DATA2_17 ), .IN3(n1234), .IN4(
        dequantSamp[17]), .Q(n563) );
  XOR2X1 U1051 ( .IN1(\DP_OP_73J1_125_3932/n1 ), .IN2(dequantSamp[18]), .Q(
        n895) );
  AO22X1 U1052 ( .IN1(n1235), .IN2(n895), .IN3(n1234), .IN4(dequantSamp[18]), 
        .Q(n601) );
  AO22X1 U1053 ( .IN1(n1240), .IN2(stepSize[14]), .IN3(stepSize[13]), .IN4(
        n1239), .Q(\C1/Z_16 ) );
  MUX21X1 U1054 ( .IN1(predictorSamp[18]), .IN2(n896), .S(n1353), .Q(n597) );
  OAI21X1 U1055 ( .IN1(n1238), .IN2(n1366), .IN3(n897), .QN(n535) );
  XOR2X1 U1056 ( .IN1(prePCM[3]), .IN2(\C42/DATA2_0 ), .Q(
        \DP_OP_36J1_122_4812/n43 ) );
  XOR2X1 U1057 ( .IN1(prePCM[3]), .IN2(dequantSamp[1]), .Q(
        \DP_OP_36J1_122_4812/n42 ) );
  XOR2X1 U1058 ( .IN1(prePCM[3]), .IN2(dequantSamp[2]), .Q(
        \DP_OP_36J1_122_4812/n41 ) );
  XOR2X1 U1059 ( .IN1(prePCM[3]), .IN2(dequantSamp[3]), .Q(
        \DP_OP_36J1_122_4812/n40 ) );
  XOR2X1 U1060 ( .IN1(prePCM[3]), .IN2(dequantSamp[4]), .Q(
        \DP_OP_36J1_122_4812/n39 ) );
  XOR2X1 U1061 ( .IN1(prePCM[3]), .IN2(dequantSamp[5]), .Q(
        \DP_OP_36J1_122_4812/n38 ) );
  XOR2X1 U1062 ( .IN1(prePCM[3]), .IN2(dequantSamp[6]), .Q(
        \DP_OP_36J1_122_4812/n37 ) );
  XOR2X1 U1063 ( .IN1(prePCM[3]), .IN2(dequantSamp[7]), .Q(
        \DP_OP_36J1_122_4812/n36 ) );
  XOR2X1 U1064 ( .IN1(prePCM[3]), .IN2(dequantSamp[8]), .Q(
        \DP_OP_36J1_122_4812/n35 ) );
  XOR2X1 U1065 ( .IN1(prePCM[3]), .IN2(dequantSamp[9]), .Q(
        \DP_OP_36J1_122_4812/n34 ) );
  XOR2X1 U1066 ( .IN1(prePCM[3]), .IN2(dequantSamp[10]), .Q(
        \DP_OP_36J1_122_4812/n33 ) );
  XOR2X1 U1067 ( .IN1(prePCM[3]), .IN2(dequantSamp[11]), .Q(
        \DP_OP_36J1_122_4812/n32 ) );
  XOR2X1 U1068 ( .IN1(prePCM[3]), .IN2(dequantSamp[12]), .Q(
        \DP_OP_36J1_122_4812/n31 ) );
  XOR2X1 U1069 ( .IN1(prePCM[3]), .IN2(dequantSamp[13]), .Q(
        \DP_OP_36J1_122_4812/n30 ) );
  XOR2X1 U1070 ( .IN1(prePCM[3]), .IN2(dequantSamp[14]), .Q(
        \DP_OP_36J1_122_4812/n29 ) );
  XOR2X1 U1071 ( .IN1(prePCM[3]), .IN2(dequantSamp[15]), .Q(
        \DP_OP_36J1_122_4812/n28 ) );
  XOR2X1 U1072 ( .IN1(prePCM[3]), .IN2(dequantSamp[16]), .Q(
        \DP_OP_36J1_122_4812/n27 ) );
  XOR2X1 U1073 ( .IN1(prePCM[3]), .IN2(dequantSamp[17]), .Q(
        \DP_OP_36J1_122_4812/n26 ) );
  MUX21X1 U1074 ( .IN1(n1418), .IN2(stepSize[14]), .S(n898), .Q(n910) );
  MUX21X1 U1075 ( .IN1(n1388), .IN2(stepSize[13]), .S(n899), .Q(n909) );
  AOI22X1 U1076 ( .IN1(n910), .IN2(n984), .IN3(n909), .IN4(n1340), .QN(n900)
         );
  AO21X1 U1077 ( .IN1(n900), .IN2(n1322), .IN3(n1389), .Q(n916) );
  INVX0 U1078 ( .INP(n905), .ZN(n906) );
  INVX0 U1079 ( .INP(n901), .ZN(n903) );
  NOR2X0 U1080 ( .IN1(n903), .IN2(n902), .QN(n904) );
  MUX21X1 U1081 ( .IN1(n906), .IN2(n905), .S(n904), .Q(n907) );
  NAND2X0 U1082 ( .IN1(n907), .IN2(n1349), .QN(n915) );
  OR2X1 U1083 ( .IN1(n908), .IN2(n1343), .Q(n913) );
  OA22X1 U1084 ( .IN1(n1320), .IN2(n910), .IN3(n1332), .IN4(n909), .Q(n911) );
  AO222X1 U1085 ( .IN1(sampDiff[16]), .IN2(n913), .IN3(sampDiff[16]), .IN4(
        n912), .IN5(n913), .IN6(n911), .Q(n914) );
  NAND3X0 U1086 ( .IN1(n916), .IN2(n915), .IN3(n914), .QN(n548) );
  MUX21X1 U1087 ( .IN1(n1403), .IN2(stepSize[7]), .S(n917), .Q(n928) );
  MUX21X1 U1088 ( .IN1(stepSize[8]), .IN2(n1390), .S(n918), .Q(n929) );
  AOI22X1 U1089 ( .IN1(n928), .IN2(n1340), .IN3(n984), .IN4(n929), .QN(n919)
         );
  AO21X1 U1090 ( .IN1(n919), .IN2(n1322), .IN3(n1399), .Q(n935) );
  INVX0 U1091 ( .INP(n924), .ZN(n925) );
  INVX0 U1092 ( .INP(n920), .ZN(n922) );
  NOR2X0 U1093 ( .IN1(n922), .IN2(n921), .QN(n923) );
  MUX21X1 U1094 ( .IN1(n925), .IN2(n924), .S(n923), .Q(n926) );
  NAND2X0 U1095 ( .IN1(n926), .IN2(n1349), .QN(n934) );
  OR2X1 U1096 ( .IN1(n927), .IN2(n1343), .Q(n932) );
  OA22X1 U1097 ( .IN1(n929), .IN2(n1320), .IN3(n1332), .IN4(n928), .Q(n930) );
  AO222X1 U1098 ( .IN1(sampDiff[10]), .IN2(n932), .IN3(sampDiff[10]), .IN4(
        n931), .IN5(n932), .IN6(n930), .Q(n933) );
  NAND3X0 U1099 ( .IN1(n935), .IN2(n934), .IN3(n933), .QN(n554) );
  MUX21X1 U1100 ( .IN1(n1392), .IN2(stepSize[6]), .S(n936), .Q(n947) );
  MUX21X1 U1101 ( .IN1(n1391), .IN2(stepSize[5]), .S(n937), .Q(n948) );
  AOI22X1 U1102 ( .IN1(n947), .IN2(n984), .IN3(n1340), .IN4(n948), .QN(n938)
         );
  AO21X1 U1103 ( .IN1(n938), .IN2(n1322), .IN3(n1384), .Q(n954) );
  INVX0 U1104 ( .INP(n943), .ZN(n944) );
  INVX0 U1105 ( .INP(n939), .ZN(n941) );
  NOR2X0 U1106 ( .IN1(n941), .IN2(n940), .QN(n942) );
  MUX21X1 U1107 ( .IN1(n944), .IN2(n943), .S(n942), .Q(n945) );
  NAND2X0 U1108 ( .IN1(n945), .IN2(n1349), .QN(n953) );
  OR2X1 U1109 ( .IN1(n946), .IN2(n1343), .Q(n951) );
  OA22X1 U1110 ( .IN1(n948), .IN2(n1319), .IN3(n1320), .IN4(n947), .Q(n949) );
  AO222X1 U1111 ( .IN1(sampDiff[8]), .IN2(n951), .IN3(sampDiff[8]), .IN4(n950), 
        .IN5(n951), .IN6(n949), .Q(n952) );
  NAND3X0 U1112 ( .IN1(n954), .IN2(n953), .IN3(n952), .QN(n556) );
  MUX21X1 U1113 ( .IN1(n1405), .IN2(stepSize[3]), .S(n955), .Q(n966) );
  MUX21X1 U1114 ( .IN1(n1406), .IN2(stepSize[4]), .S(n956), .Q(n967) );
  AOI22X1 U1115 ( .IN1(n966), .IN2(n1340), .IN3(n967), .IN4(n984), .QN(n957)
         );
  AO21X1 U1116 ( .IN1(n957), .IN2(n1322), .IN3(n1378), .Q(n973) );
  INVX0 U1117 ( .INP(n962), .ZN(n963) );
  INVX0 U1118 ( .INP(n958), .ZN(n960) );
  NOR2X0 U1119 ( .IN1(n960), .IN2(n959), .QN(n961) );
  MUX21X1 U1120 ( .IN1(n963), .IN2(n962), .S(n961), .Q(n964) );
  NAND2X0 U1121 ( .IN1(n964), .IN2(n1349), .QN(n972) );
  OR2X1 U1122 ( .IN1(n965), .IN2(n1343), .Q(n970) );
  OA22X1 U1123 ( .IN1(n1320), .IN2(n967), .IN3(n1319), .IN4(n966), .Q(n968) );
  AO222X1 U1124 ( .IN1(sampDiff[6]), .IN2(n970), .IN3(sampDiff[6]), .IN4(n969), 
        .IN5(n970), .IN6(n968), .Q(n971) );
  NAND3X0 U1125 ( .IN1(n973), .IN2(n972), .IN3(n971), .QN(n558) );
  NOR2X0 U1126 ( .IN1(n974), .IN2(n1319), .QN(n993) );
  INVX0 U1127 ( .INP(n975), .ZN(n978) );
  NOR2X0 U1128 ( .IN1(n986), .IN2(n1320), .QN(n977) );
  AO221X1 U1129 ( .IN1(stepSize[1]), .IN2(n978), .IN3(n1385), .IN4(n977), 
        .IN5(n976), .Q(n979) );
  OA221X1 U1130 ( .IN1(n979), .IN2(n1340), .IN3(n979), .IN4(n1420), .IN5(
        sampDiff[3]), .Q(n992) );
  FADDX1 U1131 ( .A(predictorSamp[3]), .B(n981), .CI(n980), .CO(n800), .S(n982) );
  NOR2X0 U1132 ( .IN1(n982), .IN2(n1355), .QN(n991) );
  AND2X1 U1133 ( .IN1(n1288), .IN2(n983), .Q(n989) );
  OA221X1 U1134 ( .IN1(n986), .IN2(stepSize[1]), .IN3(n985), .IN4(n1385), 
        .IN5(n984), .Q(n987) );
  AO222X1 U1135 ( .IN1(n989), .IN2(n1375), .IN3(n989), .IN4(n988), .IN5(n1375), 
        .IN6(n987), .Q(n990) );
  OR4X1 U1136 ( .IN1(n993), .IN2(n992), .IN3(n991), .IN4(n990), .Q(n561) );
  INVX0 U1137 ( .INP(n1354), .ZN(n994) );
  NOR2X0 U1138 ( .IN1(n995), .IN2(n994), .QN(n997) );
  NAND2X0 U1139 ( .IN1(predictorSamp[1]), .IN2(predictorSamp[0]), .QN(n996) );
  AO21X1 U1140 ( .IN1(sampDiff[1]), .IN2(N176), .IN3(n998), .Q(n999) );
  NAND2X0 U1141 ( .IN1(n1000), .IN2(n999), .QN(n1002) );
  MUX21X1 U1142 ( .IN1(n1002), .IN2(sampDiff[1]), .S(n1001), .Q(n536) );
  AO22X1 U1143 ( .IN1(n1349), .IN2(predictorSamp[0]), .IN3(N176), .IN4(n1355), 
        .Q(n537) );
  NAND2X0 U1144 ( .IN1(pcmSq[1]), .IN2(pcmSq[2]), .QN(n1057) );
  NOR2X0 U1145 ( .IN1(trojan_state[1]), .IN2(n1057), .QN(n1003) );
  MUX21X1 U1146 ( .IN1(n1003), .IN2(trojan_state[1]), .S(trojan_state[0]), .Q(
        n542) );
  NOR2X0 U1147 ( .IN1(trojan_state[0]), .IN2(n1422), .QN(n1004) );
  OR2X1 U1148 ( .IN1(n1004), .IN2(trojan_ena), .Q(n540) );
  MUX21X1 U1149 ( .IN1(prePCM[3]), .IN2(outPCM[3]), .S(n1358), .Q(n539) );
  MUX21X1 U1150 ( .IN1(prePCM[2]), .IN2(outPCM[2]), .S(n1358), .Q(n532) );
  MUX21X1 U1151 ( .IN1(prePCM[1]), .IN2(outPCM[1]), .S(n1358), .Q(n530) );
  MUX21X1 U1152 ( .IN1(prePCM[0]), .IN2(outPCM[0]), .S(n1358), .Q(n534) );
  OR2X1 U1153 ( .IN1(n1353), .IN2(trojan_ena), .Q(N429) );
  AO22X1 U1154 ( .IN1(n1240), .IN2(stepSize[0]), .IN3(n1238), .IN4(stepSize[1]), .Q(\C1/Z_2 ) );
  NAND2X0 U1155 ( .IN1(n1006), .IN2(n1005), .QN(n1356) );
  OAI22X1 U1156 ( .IN1(n1007), .IN2(n1356), .IN3(n1353), .IN4(n1371), .QN(n527) );
  FADDX1 U1157 ( .A(n1368), .B(n1009), .CI(n1008), .CO(n820), .S(n1010) );
  OAI22X1 U1158 ( .IN1(n1353), .IN2(n1368), .IN3(n1010), .IN4(n1356), .QN(n524) );
  INVX0 U1159 ( .INP(n1011), .ZN(n1357) );
  NOR2X0 U1160 ( .IN1(n1357), .IN2(n1012), .QN(n1013) );
  MUX21X1 U1161 ( .IN1(n1383), .IN2(outStepIndex[1]), .S(n1013), .Q(n1014) );
  OAI22X1 U1162 ( .IN1(n1353), .IN2(n1383), .IN3(n1356), .IN4(n1014), .QN(n523) );
  NAND2X0 U1163 ( .IN1(outStepIndex[1]), .IN2(outStepIndex[2]), .QN(n1162) );
  NOR2X0 U1164 ( .IN1(n1363), .IN2(n1162), .QN(n1108) );
  INVX0 U1165 ( .INP(n1108), .ZN(n1034) );
  NAND3X0 U1166 ( .IN1(outStepIndex[6]), .IN2(n1360), .IN3(n1361), .QN(n1161)
         );
  NOR2X0 U1167 ( .IN1(n1360), .IN2(n1362), .QN(n1145) );
  INVX0 U1168 ( .INP(n1145), .ZN(n1190) );
  NOR2X0 U1169 ( .IN1(n1162), .IN2(outStepIndex[0]), .QN(n1031) );
  INVX0 U1170 ( .INP(n1031), .ZN(n1189) );
  OA22X1 U1171 ( .IN1(n1034), .IN2(n1161), .IN3(n1190), .IN4(n1189), .Q(n1158)
         );
  NAND3X0 U1172 ( .IN1(outStepIndex[3]), .IN2(outStepIndex[4]), .IN3(
        outStepIndex[5]), .QN(n1172) );
  NAND2X0 U1173 ( .IN1(n1383), .IN2(outStepIndex[0]), .QN(n1123) );
  NOR2X0 U1174 ( .IN1(n1368), .IN2(n1123), .QN(n1191) );
  INVX0 U1175 ( .INP(n1191), .ZN(n1165) );
  NOR2X0 U1176 ( .IN1(outStepIndex[0]), .IN2(outStepIndex[1]), .QN(n1206) );
  NAND2X0 U1177 ( .IN1(outStepIndex[2]), .IN2(n1206), .QN(n1064) );
  NAND2X0 U1178 ( .IN1(n1361), .IN2(outStepIndex[5]), .QN(n1166) );
  NOR2X0 U1179 ( .IN1(n1360), .IN2(n1166), .QN(n1107) );
  INVX0 U1180 ( .INP(n1107), .ZN(n1220) );
  OA22X1 U1181 ( .IN1(n1172), .IN2(n1165), .IN3(n1064), .IN4(n1220), .Q(n1016)
         );
  NOR2X0 U1182 ( .IN1(n1383), .IN2(outStepIndex[2]), .QN(n1119) );
  INVX0 U1183 ( .INP(n1119), .ZN(n1096) );
  NOR2X0 U1184 ( .IN1(n1363), .IN2(n1096), .QN(n1217) );
  INVX0 U1185 ( .INP(n1217), .ZN(n1146) );
  AO21X1 U1186 ( .IN1(n1220), .IN2(n1161), .IN3(n1146), .Q(n1015) );
  NAND2X0 U1187 ( .IN1(outStepIndex[4]), .IN2(outStepIndex[6]), .QN(n1171) );
  INVX0 U1188 ( .INP(n1171), .ZN(n1192) );
  NAND2X0 U1189 ( .IN1(n1192), .IN2(n1031), .QN(n1213) );
  AND4X1 U1190 ( .IN1(n1158), .IN2(n1016), .IN3(n1015), .IN4(n1213), .Q(n1101)
         );
  NOR2X0 U1191 ( .IN1(n1220), .IN2(n1189), .QN(n1155) );
  NAND4X0 U1192 ( .IN1(outStepIndex[4]), .IN2(n1360), .IN3(n1371), .IN4(n1362), 
        .QN(n1136) );
  NOR2X0 U1193 ( .IN1(n1034), .IN2(n1136), .QN(n1018) );
  INVX0 U1194 ( .INP(n1064), .ZN(n1182) );
  NOR2X0 U1195 ( .IN1(n1108), .IN2(n1182), .QN(n1188) );
  NOR2X0 U1196 ( .IN1(n1188), .IN2(n1190), .QN(n1017) );
  OA22X1 U1197 ( .IN1(n1361), .IN2(n1190), .IN3(n1371), .IN4(n1362), .Q(n1074)
         );
  INVX0 U1198 ( .INP(n1074), .ZN(n1058) );
  NOR4X0 U1199 ( .IN1(n1155), .IN2(n1018), .IN3(n1017), .IN4(n1058), .QN(n1212) );
  NOR2X0 U1200 ( .IN1(outStepIndex[5]), .IN2(outStepIndex[6]), .QN(n1045) );
  NOR2X0 U1201 ( .IN1(n1361), .IN2(n1187), .QN(n1183) );
  OA21X1 U1202 ( .IN1(n1217), .IN2(n1206), .IN3(n1183), .Q(n1027) );
  NAND2X0 U1203 ( .IN1(n1363), .IN2(n1119), .QN(n1147) );
  INVX0 U1204 ( .INP(n1147), .ZN(n1194) );
  NOR2X0 U1205 ( .IN1(n1194), .IN2(n1108), .QN(n1019) );
  NOR2X0 U1206 ( .IN1(n1019), .IN2(n1171), .QN(n1026) );
  NOR2X0 U1207 ( .IN1(n1019), .IN2(n1172), .QN(n1020) );
  NOR2X0 U1208 ( .IN1(n1171), .IN2(n1146), .QN(n1036) );
  NOR2X0 U1209 ( .IN1(n1171), .IN2(n1064), .QN(n1122) );
  NOR2X0 U1210 ( .IN1(outStepIndex[1]), .IN2(outStepIndex[2]), .QN(n1103) );
  NAND2X0 U1211 ( .IN1(n1103), .IN2(n1363), .QN(n1135) );
  NOR2X0 U1212 ( .IN1(n1135), .IN2(n1190), .QN(n1038) );
  NOR4X0 U1213 ( .IN1(n1020), .IN2(n1036), .IN3(n1122), .IN4(n1038), .QN(n1089) );
  INVX0 U1214 ( .INP(n1123), .ZN(n1223) );
  NOR2X0 U1215 ( .IN1(n1194), .IN2(n1223), .QN(n1030) );
  INVX0 U1216 ( .INP(n1183), .ZN(n1221) );
  INVX0 U1217 ( .INP(n1166), .ZN(n1219) );
  NAND2X0 U1218 ( .IN1(n1360), .IN2(n1219), .QN(n1164) );
  OA21X1 U1219 ( .IN1(n1161), .IN2(n1135), .IN3(n1071), .Q(n1203) );
  OA221X1 U1220 ( .IN1(n1164), .IN2(n1146), .IN3(n1164), .IN4(n1165), .IN5(
        n1203), .Q(n1021) );
  OA21X1 U1221 ( .IN1(n1030), .IN2(n1221), .IN3(n1021), .Q(n1023) );
  NAND2X0 U1222 ( .IN1(n1103), .IN2(n1107), .QN(n1022) );
  INVX0 U1223 ( .INP(n1135), .ZN(n1225) );
  NAND3X0 U1224 ( .IN1(outStepIndex[4]), .IN2(outStepIndex[5]), .IN3(n1360), 
        .QN(n1160) );
  INVX0 U1225 ( .INP(n1160), .ZN(n1193) );
  NAND2X0 U1226 ( .IN1(n1225), .IN2(n1193), .QN(n1115) );
  NAND4X0 U1227 ( .IN1(n1089), .IN2(n1023), .IN3(n1022), .IN4(n1115), .QN(
        n1142) );
  NAND2X0 U1228 ( .IN1(n1119), .IN2(n1193), .QN(n1084) );
  INVX0 U1229 ( .INP(n1164), .ZN(n1144) );
  INVX0 U1230 ( .INP(n1172), .ZN(n1199) );
  NAND2X0 U1231 ( .IN1(n1199), .IN2(n1182), .QN(n1127) );
  INVX0 U1232 ( .INP(n1161), .ZN(n1086) );
  NAND2X0 U1233 ( .IN1(n1223), .IN2(n1086), .QN(n1024) );
  NAND4X0 U1234 ( .IN1(n1084), .IN2(n1114), .IN3(n1127), .IN4(n1024), .QN(
        n1025) );
  NOR4X0 U1235 ( .IN1(n1027), .IN2(n1026), .IN3(n1142), .IN4(n1025), .QN(n1028) );
  NAND3X0 U1236 ( .IN1(n1101), .IN2(n1212), .IN3(n1028), .QN(n606) );
  NOR2X0 U1237 ( .IN1(n1225), .IN2(n1191), .QN(n1029) );
  OA22X1 U1238 ( .IN1(n1030), .IN2(n1164), .IN3(n1029), .IN4(n1161), .Q(n1033)
         );
  NAND2X0 U1239 ( .IN1(n1199), .IN2(n1031), .QN(n1141) );
  NAND2X0 U1240 ( .IN1(n1182), .IN2(n1107), .QN(n1032) );
  AND3X1 U1241 ( .IN1(n1033), .IN2(n1141), .IN3(n1032), .Q(n1106) );
  NAND2X0 U1242 ( .IN1(outStepIndex[0]), .IN2(n1103), .QN(n1102) );
  OA22X1 U1243 ( .IN1(n1034), .IN2(n1221), .IN3(n1161), .IN4(n1102), .Q(n1044)
         );
  NOR2X0 U1244 ( .IN1(n1160), .IN2(n1102), .QN(n1154) );
  NAND2X0 U1245 ( .IN1(n1225), .IN2(n1144), .QN(n1140) );
  OA21X1 U1246 ( .IN1(n1165), .IN2(n1160), .IN3(n1140), .Q(n1110) );
  NOR2X0 U1247 ( .IN1(n1147), .IN2(n1160), .QN(n1035) );
  NOR2X0 U1248 ( .IN1(n1036), .IN2(n1035), .QN(n1133) );
  NOR2X0 U1249 ( .IN1(n1146), .IN2(n1161), .QN(n1037) );
  NOR2X0 U1250 ( .IN1(n1038), .IN2(n1037), .QN(n1066) );
  NAND3X0 U1251 ( .IN1(n1110), .IN2(n1133), .IN3(n1066), .QN(n1042) );
  INVX0 U1252 ( .INP(n1162), .ZN(n1109) );
  NOR2X0 U1253 ( .IN1(outStepIndex[4]), .IN2(n1187), .QN(n1218) );
  AO22X1 U1254 ( .IN1(n1109), .IN2(n1218), .IN3(n1192), .IN4(n1184), .Q(n1041)
         );
  INVX0 U1255 ( .INP(n1136), .ZN(n1205) );
  NAND3X0 U1256 ( .IN1(n1045), .IN2(n1360), .IN3(n1361), .QN(n1185) );
  INVX0 U1257 ( .INP(n1185), .ZN(n1216) );
  NOR2X0 U1258 ( .IN1(n1109), .IN2(n1191), .QN(n1063) );
  INVX0 U1259 ( .INP(n1063), .ZN(n1090) );
  AO22X1 U1260 ( .IN1(n1205), .IN2(n1039), .IN3(n1216), .IN4(n1090), .Q(n1040)
         );
  NOR4X0 U1261 ( .IN1(n1154), .IN2(n1042), .IN3(n1041), .IN4(n1040), .QN(n1043) );
  NAND4X0 U1262 ( .IN1(n1106), .IN2(n1044), .IN3(n1043), .IN4(n1071), .QN(
        n1175) );
  NAND3X0 U1263 ( .IN1(n1194), .IN2(outStepIndex[4]), .IN3(n1045), .QN(n1046)
         );
  OA221X1 U1264 ( .IN1(n1102), .IN2(n1172), .IN3(n1102), .IN4(n1185), .IN5(
        n1046), .Q(n1049) );
  INVX0 U1265 ( .INP(n1206), .ZN(n1186) );
  OA22X1 U1266 ( .IN1(n1186), .IN2(n1221), .IN3(n1064), .IN4(n1190), .Q(n1048)
         );
  NOR2X0 U1267 ( .IN1(n1119), .IN2(n1182), .QN(n1059) );
  INVX0 U1268 ( .INP(n1218), .ZN(n1163) );
  OA22X1 U1269 ( .IN1(n1059), .IN2(n1185), .IN3(n1165), .IN4(n1163), .Q(n1047)
         );
  NOR2X0 U1270 ( .IN1(n1147), .IN2(n1161), .QN(n1082) );
  INVX0 U1271 ( .INP(n1082), .ZN(n1150) );
  NAND4X0 U1272 ( .IN1(n1049), .IN2(n1048), .IN3(n1047), .IN4(n1150), .QN(
        n1051) );
  AO21X1 U1273 ( .IN1(n1194), .IN2(n1107), .IN3(n1058), .Q(n1153) );
  NAND2X0 U1274 ( .IN1(n1192), .IN2(n1225), .QN(n1139) );
  OA21X1 U1275 ( .IN1(n1190), .IN2(n1162), .IN3(n1139), .Q(n1068) );
  INVX0 U1276 ( .INP(n1068), .ZN(n1050) );
  OR4X1 U1277 ( .IN1(n1175), .IN2(n1051), .IN3(n1153), .IN4(n1050), .Q(n608)
         );
  NAND3X0 U1278 ( .IN1(predictorSamp[4]), .IN2(predictorSamp[2]), .IN3(
        predictorSamp[3]), .QN(n1254) );
  NOR2X0 U1279 ( .IN1(n1393), .IN2(n1254), .QN(n1253) );
  NOR2X0 U1280 ( .IN1(n1394), .IN2(n1252), .QN(n1251) );
  NAND2X0 U1281 ( .IN1(predictorSamp[8]), .IN2(n1251), .QN(n1250) );
  NOR2X0 U1282 ( .IN1(n1395), .IN2(n1250), .QN(n1249) );
  NAND2X0 U1283 ( .IN1(predictorSamp[10]), .IN2(n1249), .QN(n1248) );
  NOR2X0 U1284 ( .IN1(n1396), .IN2(n1248), .QN(n1247) );
  NAND2X0 U1285 ( .IN1(predictorSamp[12]), .IN2(n1247), .QN(n1246) );
  NOR2X0 U1286 ( .IN1(n1397), .IN2(n1246), .QN(n1245) );
  NAND2X0 U1287 ( .IN1(predictorSamp[14]), .IN2(n1245), .QN(n1244) );
  NOR2X0 U1288 ( .IN1(n1398), .IN2(n1244), .QN(n1243) );
  NAND2X0 U1289 ( .IN1(predictorSamp[16]), .IN2(n1243), .QN(n1242) );
  NOR2X0 U1290 ( .IN1(n1386), .IN2(n1242), .QN(n1052) );
  MUX21X1 U1291 ( .IN1(predictorSamp[18]), .IN2(n1415), .S(n1052), .Q(
        outPredictSamp[15]) );
  MUX21X1 U1292 ( .IN1(n1393), .IN2(predictorSamp[5]), .S(n1254), .Q(
        outPredictSamp[2]) );
  MUX21X1 U1293 ( .IN1(n1394), .IN2(predictorSamp[7]), .S(n1252), .Q(
        outPredictSamp[4]) );
  MUX21X1 U1294 ( .IN1(n1395), .IN2(predictorSamp[9]), .S(n1250), .Q(
        outPredictSamp[6]) );
  MUX21X1 U1295 ( .IN1(n1396), .IN2(predictorSamp[11]), .S(n1248), .Q(
        outPredictSamp[8]) );
  MUX21X1 U1296 ( .IN1(n1397), .IN2(predictorSamp[13]), .S(n1246), .Q(
        outPredictSamp[10]) );
  MUX21X1 U1297 ( .IN1(n1398), .IN2(predictorSamp[15]), .S(n1244), .Q(
        outPredictSamp[12]) );
  MUX21X1 U1298 ( .IN1(n1386), .IN2(predictorSamp[17]), .S(n1242), .Q(
        outPredictSamp[14]) );
  MUX21X1 U1299 ( .IN1(predictorSamp[2]), .IN2(n1402), .S(predictorSamp[3]), 
        .Q(outPredictSamp[0]) );
  NOR2X0 U1300 ( .IN1(n1053), .IN2(n1420), .QN(n1214) );
  AND2X1 U1301 ( .IN1(dequantSamp[1]), .IN2(n1214), .Q(n1401) );
  INVX0 U1302 ( .INP(inValid), .ZN(n1054) );
  NAND2X0 U1303 ( .IN1(n1055), .IN2(n1054), .QN(n1056) );
  AND3X1 U1304 ( .IN1(n1057), .IN2(n1416), .IN3(n1056), .Q(n545) );
  AO21X1 U1305 ( .IN1(n1135), .IN2(n1192), .IN3(n1058), .Q(n620) );
  AO222X1 U1306 ( .IN1(stepSize[14]), .IN2(n1236), .IN3(n1235), .IN4(
        \C42/DATA2_14 ), .IN5(n1234), .IN6(dequantSamp[14]), .Q(n566) );
  NOR2X0 U1307 ( .IN1(n1190), .IN2(n1059), .QN(n1061) );
  NAND3X0 U1308 ( .IN1(outStepIndex[0]), .IN2(outStepIndex[2]), .IN3(n1192), 
        .QN(n1126) );
  NOR2X0 U1309 ( .IN1(n1061), .IN2(n1060), .QN(n1062) );
  NAND4X0 U1310 ( .IN1(n1068), .IN2(n1062), .IN3(n1213), .IN4(n1071), .QN(n619) );
  AO222X1 U1311 ( .IN1(stepSize[13]), .IN2(n1236), .IN3(n1235), .IN4(
        \C42/DATA2_13 ), .IN5(n1234), .IN6(dequantSamp[13]), .Q(n567) );
  OA22X1 U1312 ( .IN1(n1188), .IN2(n1171), .IN3(n1063), .IN4(n1161), .Q(n1067)
         );
  NOR2X0 U1313 ( .IN1(n1064), .IN2(n1161), .QN(n1177) );
  INVX0 U1314 ( .INP(n1102), .ZN(n1118) );
  NAND2X0 U1315 ( .IN1(n1074), .IN2(n1069), .QN(n1176) );
  NOR2X0 U1316 ( .IN1(n1177), .IN2(n1176), .QN(n1065) );
  NAND4X0 U1317 ( .IN1(n1068), .IN2(n1067), .IN3(n1066), .IN4(n1065), .QN(n618) );
  AO222X1 U1318 ( .IN1(stepSize[12]), .IN2(n1236), .IN3(n1235), .IN4(
        \C42/DATA2_12 ), .IN5(n1234), .IN6(dequantSamp[12]), .Q(n568) );
  OA21X1 U1319 ( .IN1(n1190), .IN2(n1186), .IN3(n1069), .Q(n1070) );
  OA21X1 U1320 ( .IN1(n1368), .IN2(n1172), .IN3(n1070), .Q(n1072) );
  NAND4X0 U1321 ( .IN1(n1072), .IN2(n1071), .IN3(n1150), .IN4(n1213), .QN(
        n1113) );
  OA21X1 U1322 ( .IN1(n1108), .IN2(n1103), .IN3(n1086), .Q(n1073) );
  NOR2X0 U1323 ( .IN1(n1113), .IN2(n1073), .QN(n1076) );
  AO221X1 U1324 ( .IN1(n1171), .IN2(n1363), .IN3(n1171), .IN4(n1172), .IN5(
        n1096), .Q(n1075) );
  NAND4X0 U1325 ( .IN1(n1076), .IN2(n1075), .IN3(n1074), .IN4(n1139), .QN(n617) );
  AO222X1 U1326 ( .IN1(stepSize[11]), .IN2(n1236), .IN3(n1235), .IN4(
        \C42/DATA2_11 ), .IN5(n1234), .IN6(dequantSamp[11]), .Q(n569) );
  INVX0 U1327 ( .INP(n1176), .ZN(n1079) );
  NAND2X0 U1328 ( .IN1(n1086), .IN2(n1118), .QN(n1078) );
  AND4X1 U1329 ( .IN1(n1079), .IN2(n1078), .IN3(n1231), .IN4(n1077), .Q(n1093)
         );
  NAND2X0 U1330 ( .IN1(n1217), .IN2(n1145), .QN(n1138) );
  NOR2X0 U1331 ( .IN1(n1188), .IN2(n1160), .QN(n1081) );
  NAND2X0 U1332 ( .IN1(n1160), .IN2(n1161), .QN(n1080) );
  NOR2X0 U1333 ( .IN1(n1363), .IN2(n1383), .QN(n1204) );
  AO222X1 U1334 ( .IN1(n1184), .IN2(n1080), .IN3(n1204), .IN4(n1192), .IN5(
        n1199), .IN6(n1194), .Q(n1208) );
  NOR4X0 U1335 ( .IN1(n1122), .IN2(n1082), .IN3(n1081), .IN4(n1208), .QN(n1083) );
  NAND4X0 U1336 ( .IN1(n1093), .IN2(n1203), .IN3(n1138), .IN4(n1083), .QN(n616) );
  AO222X1 U1337 ( .IN1(stepSize[10]), .IN2(n1236), .IN3(n1235), .IN4(
        \C42/DATA2_10 ), .IN5(n1234), .IN6(dequantSamp[10]), .Q(n570) );
  INVX0 U1338 ( .INP(n1084), .ZN(n1085) );
  NOR2X0 U1339 ( .IN1(n1154), .IN2(n1085), .QN(n1088) );
  NAND3X0 U1340 ( .IN1(outStepIndex[1]), .IN2(n1086), .IN3(n1363), .QN(n1087)
         );
  NAND4X0 U1341 ( .IN1(n1089), .IN2(n1088), .IN3(n1087), .IN4(n1139), .QN(
        n1097) );
  AO21X1 U1342 ( .IN1(n1090), .IN2(n1107), .IN3(n1177), .Q(n1091) );
  NOR2X0 U1343 ( .IN1(n1097), .IN2(n1091), .QN(n1092) );
  NAND4X0 U1344 ( .IN1(n1093), .IN2(n1115), .IN3(n1092), .IN4(n1141), .QN(n612) );
  AO222X1 U1345 ( .IN1(stepSize[9]), .IN2(n1236), .IN3(n1235), .IN4(
        \C42/DATA2_9 ), .IN5(n1234), .IN6(dequantSamp[9]), .Q(n571) );
  NOR2X0 U1346 ( .IN1(n1162), .IN2(n1164), .QN(n1143) );
  AO22X1 U1347 ( .IN1(n1108), .IN2(n1193), .IN3(n1107), .IN4(n1118), .Q(n1094)
         );
  OR3X1 U1348 ( .IN1(n1143), .IN2(n1177), .IN3(n1094), .Q(n1196) );
  NOR2X0 U1349 ( .IN1(n1160), .IN2(n1189), .QN(n1095) );
  NOR2X0 U1350 ( .IN1(n1196), .IN2(n1095), .QN(n1100) );
  NOR2X0 U1351 ( .IN1(n1096), .IN2(n1190), .QN(n1170) );
  NOR2X0 U1352 ( .IN1(n1135), .IN2(n1220), .QN(n1098) );
  NOR4X0 U1353 ( .IN1(n1170), .IN2(n1098), .IN3(n1097), .IN4(n1153), .QN(n1099) );
  NAND4X0 U1354 ( .IN1(n1101), .IN2(n1100), .IN3(n1151), .IN4(n1099), .QN(n611) );
  AO222X1 U1355 ( .IN1(stepSize[8]), .IN2(n1236), .IN3(n1235), .IN4(
        \C42/DATA2_8 ), .IN5(n1234), .IN6(dequantSamp[8]), .Q(n572) );
  AOI22X1 U1356 ( .IN1(n1217), .IN2(n1219), .IN3(n1193), .IN4(n1204), .QN(
        n1117) );
  OA22X1 U1357 ( .IN1(n1147), .IN2(n1190), .IN3(n1172), .IN4(n1102), .Q(n1105)
         );
  NAND3X0 U1358 ( .IN1(n1106), .IN2(n1105), .IN3(n1104), .QN(n1129) );
  NAND2X0 U1359 ( .IN1(n1108), .IN2(n1107), .QN(n1149) );
  NAND2X0 U1360 ( .IN1(n1109), .IN2(n1183), .QN(n1111) );
  NAND3X0 U1361 ( .IN1(n1149), .IN2(n1111), .IN3(n1110), .QN(n1112) );
  NOR4X0 U1362 ( .IN1(n1153), .IN2(n1129), .IN3(n1113), .IN4(n1112), .QN(n1116) );
  NAND4X0 U1363 ( .IN1(n1117), .IN2(n1116), .IN3(n1115), .IN4(n1114), .QN(n610) );
  AO222X1 U1364 ( .IN1(stepSize[7]), .IN2(n1236), .IN3(n1235), .IN4(
        \C42/DATA2_7 ), .IN5(n1234), .IN6(dequantSamp[7]), .Q(n573) );
  AO222X1 U1365 ( .IN1(stepSize[6]), .IN2(n1236), .IN3(n1235), .IN4(
        \C42/DATA2_6 ), .IN5(n1234), .IN6(dequantSamp[6]), .Q(n574) );
  NOR2X0 U1366 ( .IN1(n1146), .IN2(n1221), .QN(n1121) );
  OA21X1 U1367 ( .IN1(n1119), .IN2(n1118), .IN3(n1205), .Q(n1120) );
  NOR4X0 U1368 ( .IN1(n1122), .IN2(n1121), .IN3(n1120), .IN4(n1176), .QN(n1233) );
  NOR2X0 U1369 ( .IN1(n1206), .IN2(n1184), .QN(n1124) );
  OA22X1 U1370 ( .IN1(n1124), .IN2(n1136), .IN3(n1123), .IN4(n1220), .Q(n1134)
         );
  NOR2X0 U1371 ( .IN1(n1188), .IN2(n1164), .QN(n1131) );
  NOR3X0 U1372 ( .IN1(n1368), .IN2(n1221), .IN3(outStepIndex[1]), .QN(n1130)
         );
  NAND2X0 U1373 ( .IN1(n1182), .IN2(n1193), .QN(n1125) );
  NAND4X0 U1374 ( .IN1(n1150), .IN2(n1127), .IN3(n1126), .IN4(n1125), .QN(
        n1128) );
  NOR4X0 U1375 ( .IN1(n1131), .IN2(n1130), .IN3(n1129), .IN4(n1128), .QN(n1132) );
  NAND4X0 U1376 ( .IN1(n1233), .IN2(n1134), .IN3(n1133), .IN4(n1132), .QN(n609) );
  AO222X1 U1377 ( .IN1(stepSize[5]), .IN2(n1236), .IN3(n1235), .IN4(
        \C42/DATA2_5 ), .IN5(n1234), .IN6(dequantSamp[5]), .Q(n575) );
  NOR2X0 U1378 ( .IN1(n1182), .IN2(n1184), .QN(n1137) );
  OA22X1 U1379 ( .IN1(n1137), .IN2(n1136), .IN3(n1172), .IN4(n1135), .Q(n1159)
         );
  NAND4X0 U1380 ( .IN1(n1141), .IN2(n1140), .IN3(n1139), .IN4(n1138), .QN(
        n1227) );
  NOR4X0 U1381 ( .IN1(n1143), .IN2(n1218), .IN3(n1142), .IN4(n1227), .QN(n1157) );
  NOR2X0 U1382 ( .IN1(n1145), .IN2(n1144), .QN(n1148) );
  OA22X1 U1383 ( .IN1(n1148), .IN2(n1147), .IN3(n1172), .IN4(n1146), .Q(n1152)
         );
  NAND4X0 U1384 ( .IN1(n1152), .IN2(n1151), .IN3(n1150), .IN4(n1149), .QN(
        n1209) );
  NOR4X0 U1385 ( .IN1(n1155), .IN2(n1154), .IN3(n1153), .IN4(n1209), .QN(n1156) );
  NAND4X0 U1386 ( .IN1(n1159), .IN2(n1158), .IN3(n1157), .IN4(n1156), .QN(n615) );
  AO222X1 U1387 ( .IN1(stepSize[4]), .IN2(n1236), .IN3(n1235), .IN4(
        \C42/DATA2_4 ), .IN5(n1234), .IN6(dequantSamp[4]), .Q(n576) );
  AO222X1 U1388 ( .IN1(stepSize[3]), .IN2(n1236), .IN3(n1235), .IN4(
        \C42/DATA2_3 ), .IN5(n1234), .IN6(dequantSamp[3]), .Q(n577) );
  OA22X1 U1389 ( .IN1(n1162), .IN2(n1161), .IN3(n1186), .IN4(n1160), .Q(n1181)
         );
  NAND2X0 U1390 ( .IN1(n1182), .IN2(n1222), .QN(n1180) );
  NOR2X0 U1391 ( .IN1(n1221), .IN2(n1165), .QN(n1169) );
  NOR2X0 U1392 ( .IN1(n1166), .IN2(n1189), .QN(n1168) );
  AO22X1 U1393 ( .IN1(n1217), .IN2(n1218), .IN3(n1223), .IN4(n1205), .Q(n1167)
         );
  NOR4X0 U1394 ( .IN1(n1170), .IN2(n1169), .IN3(n1168), .IN4(n1167), .QN(n1179) );
  NAND2X0 U1395 ( .IN1(n1172), .IN2(n1171), .QN(n1173) );
  AO22X1 U1396 ( .IN1(n1194), .IN2(n1173), .IN3(n1225), .IN4(n1216), .Q(n1174)
         );
  NOR4X0 U1397 ( .IN1(n1177), .IN2(n1176), .IN3(n1175), .IN4(n1174), .QN(n1178) );
  NAND4X0 U1398 ( .IN1(n1181), .IN2(n1180), .IN3(n1179), .IN4(n1178), .QN(n607) );
  AO222X1 U1399 ( .IN1(stepSize[2]), .IN2(n1236), .IN3(n1235), .IN4(
        \C42/DATA2_2 ), .IN5(n1234), .IN6(dequantSamp[2]), .Q(n578) );
  AOI22X1 U1400 ( .IN1(n1184), .IN2(n1183), .IN3(n1182), .IN4(n1219), .QN(
        n1211) );
  OA22X1 U1401 ( .IN1(n1188), .IN2(n1187), .IN3(n1186), .IN4(n1185), .Q(n1202)
         );
  NOR2X0 U1402 ( .IN1(n1190), .IN2(n1189), .QN(n1198) );
  OA21X1 U1403 ( .IN1(n1192), .IN2(n1205), .IN3(n1191), .Q(n1197) );
  AO22X1 U1404 ( .IN1(n1194), .IN2(n1218), .IN3(n1217), .IN4(n1193), .Q(n1195)
         );
  NOR4X0 U1405 ( .IN1(n1198), .IN2(n1197), .IN3(n1196), .IN4(n1195), .QN(n1201) );
  NAND4X0 U1406 ( .IN1(n1203), .IN2(n1202), .IN3(n1201), .IN4(n1200), .QN(
        n1228) );
  AO22X1 U1407 ( .IN1(n1206), .IN2(n1205), .IN3(n1216), .IN4(n1204), .Q(n1207)
         );
  NOR4X0 U1408 ( .IN1(n1209), .IN2(n1228), .IN3(n1208), .IN4(n1207), .QN(n1210) );
  NAND4X0 U1409 ( .IN1(n1213), .IN2(n1212), .IN3(n1211), .IN4(n1210), .QN(n614) );
  XOR2X1 U1410 ( .IN1(dequantSamp[1]), .IN2(n1214), .Q(n1215) );
  AO222X1 U1411 ( .IN1(stepSize[1]), .IN2(n1236), .IN3(n1235), .IN4(n1215), 
        .IN5(n1234), .IN6(dequantSamp[1]), .Q(n579) );
  NAND2X0 U1412 ( .IN1(n1216), .IN2(n1363), .QN(n1232) );
  OA21X1 U1413 ( .IN1(n1219), .IN2(n1218), .IN3(n1217), .Q(n1229) );
  AO22X1 U1414 ( .IN1(n1225), .IN2(n1224), .IN3(n1223), .IN4(n1222), .Q(n1226)
         );
  NOR4X0 U1415 ( .IN1(n1229), .IN2(n1228), .IN3(n1227), .IN4(n1226), .QN(n1230) );
  NAND4X0 U1416 ( .IN1(n1233), .IN2(n1232), .IN3(n1231), .IN4(n1230), .QN(n613) );
  AO222X1 U1417 ( .IN1(stepSize[0]), .IN2(n1236), .IN3(n1235), .IN4(
        \C42/DATA2_0 ), .IN5(n1234), .IN6(\C42/DATA2_0 ), .Q(n580) );
  NOR2X0 U1418 ( .IN1(n1418), .IN2(n1237), .QN(\C1/Z_17 ) );
  AO222X1 U1419 ( .IN1(n1240), .IN2(stepSize[13]), .IN3(n1238), .IN4(
        stepSize[14]), .IN5(n1239), .IN6(stepSize[12]), .Q(\C1/Z_15 ) );
  AO222X1 U1420 ( .IN1(n1240), .IN2(stepSize[12]), .IN3(n1238), .IN4(
        stepSize[13]), .IN5(n1239), .IN6(stepSize[11]), .Q(\C1/Z_14 ) );
  AO222X1 U1421 ( .IN1(n1240), .IN2(stepSize[11]), .IN3(n1239), .IN4(
        stepSize[10]), .IN5(n1238), .IN6(stepSize[12]), .Q(\C1/Z_13 ) );
  AO222X1 U1422 ( .IN1(n1240), .IN2(stepSize[10]), .IN3(n1239), .IN4(
        stepSize[9]), .IN5(n1238), .IN6(stepSize[11]), .Q(\C1/Z_12 ) );
  AO222X1 U1423 ( .IN1(n1240), .IN2(stepSize[9]), .IN3(n1239), .IN4(
        stepSize[8]), .IN5(n1238), .IN6(stepSize[10]), .Q(\C1/Z_11 ) );
  AO222X1 U1424 ( .IN1(n1240), .IN2(stepSize[8]), .IN3(n1239), .IN4(
        stepSize[7]), .IN5(n1238), .IN6(stepSize[9]), .Q(\C1/Z_10 ) );
  AO222X1 U1425 ( .IN1(n1240), .IN2(stepSize[7]), .IN3(n1239), .IN4(
        stepSize[6]), .IN5(n1238), .IN6(stepSize[8]), .Q(\C1/Z_9 ) );
  AO222X1 U1426 ( .IN1(n1240), .IN2(stepSize[6]), .IN3(n1239), .IN4(
        stepSize[5]), .IN5(n1238), .IN6(stepSize[7]), .Q(\C1/Z_8 ) );
  AO222X1 U1427 ( .IN1(n1240), .IN2(stepSize[5]), .IN3(n1239), .IN4(
        stepSize[4]), .IN5(n1238), .IN6(stepSize[6]), .Q(\C1/Z_7 ) );
  AO222X1 U1428 ( .IN1(n1240), .IN2(stepSize[4]), .IN3(n1239), .IN4(
        stepSize[3]), .IN5(n1238), .IN6(stepSize[5]), .Q(\C1/Z_6 ) );
  AO222X1 U1429 ( .IN1(n1240), .IN2(stepSize[3]), .IN3(n1239), .IN4(
        stepSize[2]), .IN5(n1238), .IN6(stepSize[4]), .Q(\C1/Z_5 ) );
  AO222X1 U1430 ( .IN1(n1240), .IN2(stepSize[2]), .IN3(n1239), .IN4(
        stepSize[1]), .IN5(n1238), .IN6(stepSize[3]), .Q(\C1/Z_4 ) );
  AO222X1 U1431 ( .IN1(n1240), .IN2(stepSize[1]), .IN3(n1239), .IN4(
        stepSize[0]), .IN5(n1238), .IN6(stepSize[2]), .Q(\C1/Z_3 ) );
  AO21X1 U1432 ( .IN1(prePCM[3]), .IN2(n1241), .IN3(n1288), .Q(n562) );
  OA21X1 U1433 ( .IN1(predictorSamp[16]), .IN2(n1243), .IN3(n1242), .Q(
        outPredictSamp[13]) );
  OA21X1 U1434 ( .IN1(predictorSamp[14]), .IN2(n1245), .IN3(n1244), .Q(
        outPredictSamp[11]) );
  OA21X1 U1435 ( .IN1(predictorSamp[12]), .IN2(n1247), .IN3(n1246), .Q(
        outPredictSamp[9]) );
  OA21X1 U1436 ( .IN1(predictorSamp[10]), .IN2(n1249), .IN3(n1248), .Q(
        outPredictSamp[7]) );
  OA21X1 U1437 ( .IN1(predictorSamp[8]), .IN2(n1251), .IN3(n1250), .Q(
        outPredictSamp[5]) );
  OA21X1 U1438 ( .IN1(predictorSamp[6]), .IN2(n1253), .IN3(n1252), .Q(
        outPredictSamp[3]) );
  AND2X1 U1439 ( .IN1(predictorSamp[2]), .IN2(predictorSamp[3]), .Q(n1255) );
  OA21X1 U1440 ( .IN1(predictorSamp[4]), .IN2(n1255), .IN3(n1254), .Q(
        outPredictSamp[1]) );
  OA22X1 U1441 ( .IN1(n1257), .IN2(n1256), .IN3(stepSize[14]), .IN4(n1374), 
        .Q(n1339) );
  OA22X1 U1442 ( .IN1(n1339), .IN2(n1332), .IN3(n1374), .IN4(n1320), .Q(n1258)
         );
  NOR2X0 U1443 ( .IN1(sampDiff[18]), .IN2(n1345), .QN(n1344) );
  AO22X1 U1444 ( .IN1(sampDiff[18]), .IN2(n1260), .IN3(n1288), .IN4(n1344), 
        .Q(n1264) );
  INVX0 U1445 ( .INP(inSamp[15]), .ZN(n1342) );
  AO222X1 U1446 ( .IN1(inSamp[14]), .IN2(n1386), .IN3(inSamp[14]), .IN4(n1261), 
        .IN5(n1386), .IN6(n1261), .Q(n1341) );
  NOR2X0 U1447 ( .IN1(n1262), .IN2(n1355), .QN(n1263) );
  AO221X1 U1448 ( .IN1(sampDiff[19]), .IN2(n1352), .IN3(sampDiff[19]), .IN4(
        n1264), .IN5(n1263), .Q(n599) );
  INVX0 U1449 ( .INP(n1265), .ZN(n1293) );
  NAND2X0 U1450 ( .IN1(n1293), .IN2(n1288), .QN(n1271) );
  MUX21X1 U1451 ( .IN1(stepSize[10]), .IN2(n1372), .S(n1266), .Q(n1273) );
  INVX0 U1452 ( .INP(n1273), .ZN(n1268) );
  MUX21X1 U1453 ( .IN1(n1382), .IN2(stepSize[9]), .S(n1282), .Q(n1267) );
  OA22X1 U1454 ( .IN1(n1320), .IN2(n1268), .IN3(n1319), .IN4(n1267), .Q(n1269)
         );
  AO222X1 U1455 ( .IN1(sampDiff[12]), .IN2(n1271), .IN3(sampDiff[12]), .IN4(
        n1270), .IN5(n1271), .IN6(n1269), .Q(n1287) );
  OA22X1 U1456 ( .IN1(n1273), .IN2(n1320), .IN3(n1332), .IN4(n1272), .Q(n1274)
         );
  AO21X1 U1457 ( .IN1(n1274), .IN2(n1322), .IN3(n1376), .Q(n1286) );
  INVX0 U1458 ( .INP(n1279), .ZN(n1280) );
  INVX0 U1459 ( .INP(n1275), .ZN(n1277) );
  NOR2X0 U1460 ( .IN1(n1277), .IN2(n1276), .QN(n1278) );
  MUX21X1 U1461 ( .IN1(n1280), .IN2(n1279), .S(n1278), .Q(n1281) );
  NAND2X0 U1462 ( .IN1(n1349), .IN2(n1281), .QN(n1285) );
  OR3X1 U1463 ( .IN1(n1283), .IN2(n1332), .IN3(n1282), .Q(n1284) );
  NAND4X0 U1464 ( .IN1(n1287), .IN2(n1286), .IN3(n1285), .IN4(n1284), .QN(n552) );
  NAND2X0 U1465 ( .IN1(n1288), .IN2(n1316), .QN(n1294) );
  MUX21X1 U1466 ( .IN1(stepSize[11]), .IN2(n1380), .S(n1289), .Q(n1296) );
  INVX0 U1467 ( .INP(n1296), .ZN(n1291) );
  MUX21X1 U1468 ( .IN1(n1372), .IN2(stepSize[10]), .S(n1298), .Q(n1290) );
  OA22X1 U1469 ( .IN1(n1291), .IN2(n1320), .IN3(n1332), .IN4(n1290), .Q(n1292)
         );
  AO222X1 U1470 ( .IN1(sampDiff[13]), .IN2(n1294), .IN3(sampDiff[13]), .IN4(
        n1293), .IN5(n1294), .IN6(n1292), .Q(n1310) );
  OA22X1 U1471 ( .IN1(n1320), .IN2(n1296), .IN3(n1319), .IN4(n1295), .Q(n1297)
         );
  AO21X1 U1472 ( .IN1(n1297), .IN2(n1322), .IN3(n1400), .Q(n1309) );
  OR3X1 U1473 ( .IN1(n1299), .IN2(n1332), .IN3(n1298), .Q(n1308) );
  INVX0 U1474 ( .INP(n1304), .ZN(n1305) );
  INVX0 U1475 ( .INP(n1300), .ZN(n1302) );
  NOR2X0 U1476 ( .IN1(n1302), .IN2(n1301), .QN(n1303) );
  MUX21X1 U1477 ( .IN1(n1305), .IN2(n1304), .S(n1303), .Q(n1306) );
  NAND2X0 U1478 ( .IN1(n1349), .IN2(n1306), .QN(n1307) );
  NAND4X0 U1479 ( .IN1(n1310), .IN2(n1309), .IN3(n1308), .IN4(n1307), .QN(n551) );
  OR2X1 U1480 ( .IN1(n1311), .IN2(n1343), .Q(n1317) );
  MUX21X1 U1481 ( .IN1(stepSize[12]), .IN2(n1379), .S(n1312), .Q(n1321) );
  INVX0 U1482 ( .INP(n1321), .ZN(n1314) );
  MUX21X1 U1483 ( .IN1(n1380), .IN2(stepSize[11]), .S(n1331), .Q(n1313) );
  OA22X1 U1484 ( .IN1(n1320), .IN2(n1314), .IN3(n1332), .IN4(n1313), .Q(n1315)
         );
  AO222X1 U1485 ( .IN1(sampDiff[14]), .IN2(n1317), .IN3(sampDiff[14]), .IN4(
        n1316), .IN5(n1317), .IN6(n1315), .Q(n1337) );
  OA22X1 U1486 ( .IN1(n1321), .IN2(n1320), .IN3(n1319), .IN4(n1318), .Q(n1323)
         );
  AO21X1 U1487 ( .IN1(n1323), .IN2(n1322), .IN3(n1365), .Q(n1336) );
  INVX0 U1488 ( .INP(n1328), .ZN(n1329) );
  INVX0 U1489 ( .INP(n1324), .ZN(n1326) );
  NOR2X0 U1490 ( .IN1(n1326), .IN2(n1325), .QN(n1327) );
  MUX21X1 U1491 ( .IN1(n1329), .IN2(n1328), .S(n1327), .Q(n1330) );
  OR3X1 U1492 ( .IN1(n1333), .IN2(n1332), .IN3(n1331), .Q(n1334) );
  NAND4X0 U1493 ( .IN1(n1337), .IN2(n1336), .IN3(n1335), .IN4(n1334), .QN(n550) );
  AO22X1 U1494 ( .IN1(n1340), .IN2(n1339), .IN3(n1338), .IN4(n1374), .Q(n1351)
         );
  FADDX1 U1495 ( .A(n1342), .B(predictorSamp[18]), .CI(n1341), .CO(n1262), .S(
        n1348) );
  NOR2X0 U1496 ( .IN1(n1344), .IN2(n1343), .QN(n1347) );
  NAND2X0 U1497 ( .IN1(sampDiff[18]), .IN2(n1345), .QN(n1346) );
  AO22X1 U1498 ( .IN1(n1349), .IN2(n1348), .IN3(n1347), .IN4(n1346), .Q(n1350)
         );
  AO221X1 U1499 ( .IN1(sampDiff[18]), .IN2(n1352), .IN3(n1421), .IN4(n1351), 
        .IN5(n1350), .Q(n546) );
  AO21X1 U1500 ( .IN1(trojan_state[0]), .IN2(n1354), .IN3(trojan_state[1]), 
        .Q(n541) );
  AO221X1 U1501 ( .IN1(n1355), .IN2(n1354), .IN3(n1355), .IN4(inReady), .IN5(
        n1353), .Q(n529) );
  NOR2X0 U1502 ( .IN1(n1357), .IN2(n1356), .QN(n1359) );
  AO222X1 U1503 ( .IN1(outStepIndex[0]), .IN2(n1359), .IN3(outStepIndex[0]), 
        .IN4(n1358), .IN5(n1359), .IN6(n1381), .Q(n522) );
endmodule

