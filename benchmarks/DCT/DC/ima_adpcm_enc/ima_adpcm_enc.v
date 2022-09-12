/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP4
// Date      : Sat Jun 12 15:47:37 2021
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
  wire   N173, \C38/DATA2_0 , \C38/DATA2_2 , \C38/DATA2_3 , \C38/DATA2_4 ,
         \C38/DATA2_5 , \C38/DATA2_6 , \C38/DATA2_7 , \C38/DATA2_8 ,
         \C38/DATA2_9 , \C38/DATA2_10 , \C38/DATA2_11 , \C38/DATA2_12 ,
         \C38/DATA2_13 , \C38/DATA2_14 , \C38/DATA2_15 , \C38/DATA2_16 ,
         \C38/DATA2_17 , n517, n518, n519, n520, n521, n522, n523, n524, n525,
         n526, n527, n528, n529, n530, n531, n532, n533, n534, n535, n536,
         n537, n538, n539, n540, n541, n542, n543, n544, n545, n546, n547,
         n548, n549, n550, n551, n552, n553, n554, n555, n556, n557, n558,
         n559, n560, n561, n562, n563, n564, n565, n566, n567, n568, n569,
         n570, n571, n572, n573, n574, n575, n576, n577, n578, n579, n580,
         n581, n582, n583, n584, n585, n586, n587, n588, n589, n590, n591,
         n592, n593, n599, n600, n601, n602, n603, n604, n605, n606, n607,
         n608, n609, n610, n611, n612, n613, \C1/Z_17 , \C1/Z_16 , \C1/Z_15 ,
         \C1/Z_14 , \C1/Z_13 , \C1/Z_12 , \C1/Z_11 , \C1/Z_10 , \C1/Z_9 ,
         \C1/Z_8 , \C1/Z_7 , \C1/Z_6 , \C1/Z_5 , \C1/Z_4 , \C1/Z_3 , \C1/Z_2 ,
         \DP_OP_36J1_122_5288/n43 , \DP_OP_36J1_122_5288/n42 ,
         \DP_OP_36J1_122_5288/n41 , \DP_OP_36J1_122_5288/n40 ,
         \DP_OP_36J1_122_5288/n39 , \DP_OP_36J1_122_5288/n38 ,
         \DP_OP_36J1_122_5288/n37 , \DP_OP_36J1_122_5288/n36 ,
         \DP_OP_36J1_122_5288/n35 , \DP_OP_36J1_122_5288/n34 ,
         \DP_OP_36J1_122_5288/n33 , \DP_OP_36J1_122_5288/n32 ,
         \DP_OP_36J1_122_5288/n31 , \DP_OP_36J1_122_5288/n30 ,
         \DP_OP_36J1_122_5288/n29 , \DP_OP_36J1_122_5288/n28 ,
         \DP_OP_36J1_122_5288/n27 , \DP_OP_36J1_122_5288/n26 ,
         \DP_OP_36J1_122_5288/n25 , \DP_OP_36J1_122_5288/n20 ,
         \DP_OP_36J1_122_5288/n19 , \DP_OP_36J1_122_5288/n18 ,
         \DP_OP_36J1_122_5288/n17 , \DP_OP_36J1_122_5288/n16 ,
         \DP_OP_36J1_122_5288/n15 , \DP_OP_36J1_122_5288/n14 ,
         \DP_OP_36J1_122_5288/n13 , \DP_OP_36J1_122_5288/n12 ,
         \DP_OP_36J1_122_5288/n11 , \DP_OP_36J1_122_5288/n10 ,
         \DP_OP_36J1_122_5288/n9 , \DP_OP_36J1_122_5288/n8 ,
         \DP_OP_36J1_122_5288/n7 , \DP_OP_36J1_122_5288/n6 ,
         \DP_OP_36J1_122_5288/n5 , \DP_OP_36J1_122_5288/n4 ,
         \DP_OP_36J1_122_5288/n3 , \DP_OP_36J1_122_5288/n2 ,
         \DP_OP_67J1_125_4341/n16 , \DP_OP_67J1_125_4341/n15 ,
         \DP_OP_67J1_125_4341/n14 , \DP_OP_67J1_125_4341/n13 ,
         \DP_OP_67J1_125_4341/n12 , \DP_OP_67J1_125_4341/n11 ,
         \DP_OP_67J1_125_4341/n10 , \DP_OP_67J1_125_4341/n9 ,
         \DP_OP_67J1_125_4341/n8 , \DP_OP_67J1_125_4341/n7 ,
         \DP_OP_67J1_125_4341/n6 , \DP_OP_67J1_125_4341/n5 ,
         \DP_OP_67J1_125_4341/n4 , \DP_OP_67J1_125_4341/n3 ,
         \DP_OP_67J1_125_4341/n2 , \DP_OP_67J1_125_4341/n1 , n615, n616, n617,
         n618, n619, n620, n621, n622, n623, n624, n625, n626, n627, n628,
         n629, n630, n631, n632, n633, n634, n635, n636, n637, n638, n639,
         n640, n641, n642, n643, n644, n645, n646, n647, n648, n649, n650,
         n651, n652, n653, n654, n655, n656, n657, n658, n659, n660, n661,
         n662, n663, n664, n665, n666, n667, n668, n669, n670, n671, n672,
         n673, n674, n675, n676, n677, n678, n679, n680, n681, n682, n683,
         n684, n685, n686, n687, n688, n689, n690, n691, n692, n693, n694,
         n695, n696, n697, n698, n699, n700, n701, n702, n703, n704, n705,
         n706, n707, n708, n709, n710, n711, n712, n713, n714, n715, n716,
         n717, n718, n719, n720, n721, n722, n723, n724, n725, n726, n727,
         n728, n729, n730, n731, n732, n733, n734, n735, n736, n737, n738,
         n739, n740, n741, n742, n743, n744, n745, n746, n747, n748, n749,
         n750, n751, n752, n753, n754, n755, n756, n757, n758, n759, n760,
         n761, n762, n763, n764, n765, n766, n767, n768, n769, n770, n771,
         n772, n773, n774, n775, n776, n777, n778, n779, n780, n781, n782,
         n783, n784, n785, n786, n787, n788, n789, n790, n791, n792, n793,
         n794, n795, n796, n797, n798, n799, n800, n801, n802, n803, n804,
         n805, n806, n807, n808, n809, n810, n811, n812, n813, n814, n815,
         n816, n817, n818, n819, n820, n821, n822, n823, n824, n825, n826,
         n827, n828, n829, n830, n831, n832, n833, n834, n835, n836, n837,
         n838, n839, n840, n841, n842, n843, n844, n845, n846, n847, n848,
         n849, n850, n851, n852, n853, n854, n855, n856, n857, n858, n859,
         n860, n861, n862, n863, n864, n865, n866, n867, n868, n869, n870,
         n871, n872, n873, n874, n875, n876, n877, n878, n879, n880, n881,
         n882, n883, n884, n885, n886, n887, n888, n889, n890, n891, n892,
         n893, n894, n895, n896, n897, n898, n899, n900, n901, n902, n903,
         n904, n905, n906, n907, n908, n909, n910, n911, n912, n913, n914,
         n915, n916, n917, n918, n919, n920, n921, n922, n923, n924, n925,
         n926, n927, n928, n929, n930, n931, n932, n933, n934, n935, n936,
         n937, n938, n939, n940, n941, n942, n943, n944, n945, n946, n947,
         n948, n949, n950, n951, n952, n953, n954, n955, n956, n957, n958,
         n959, n960, n961, n962, n963, n964, n965, n966, n967, n968, n969,
         n970, n971, n972, n973, n974, n975, n976, n977, n978, n979, n980,
         n981, n982, n983, n984, n985, n986, n987, n988, n989, n990, n991,
         n992, n993, n994, n995, n996, n997, n998, n999, n1000, n1001, n1002,
         n1003, n1004, n1005, n1006, n1007, n1008, n1009, n1010, n1011, n1012,
         n1013, n1014, n1015, n1016, n1017, n1018, n1019, n1020, n1021, n1022,
         n1023, n1024, n1025, n1026, n1027, n1028, n1029, n1030, n1031, n1032,
         n1033, n1034, n1035, n1036, n1037, n1038, n1039, n1040, n1041, n1042,
         n1043, n1044, n1045, n1046, n1047, n1048, n1049, n1050, n1051, n1052,
         n1053, n1054, n1055, n1056, n1057, n1058, n1059, n1060, n1061, n1062,
         n1063, n1064, n1065, n1066, n1067, n1068, n1069, n1070, n1071, n1072,
         n1073, n1074, n1075, n1076, n1077, n1078, n1079, n1080, n1081, n1082,
         n1083, n1084, n1085, n1086, n1087, n1088, n1089, n1090, n1091, n1092,
         n1093, n1094, n1095, n1096, n1097, n1098, n1099, n1100, n1101, n1102,
         n1103, n1104, n1105, n1106, n1107, n1108, n1109, n1110, n1111, n1112,
         n1113, n1114, n1115, n1116, n1117, n1118, n1119, n1120, n1121, n1122,
         n1123, n1124, n1125, n1126, n1127, n1128, n1129, n1130, n1131, n1132,
         n1133, n1134, n1135, n1136, n1137, n1138, n1139, n1140, n1141, n1142,
         n1143, n1144, n1145, n1146, n1147, n1148, n1149, n1150, n1151, n1152,
         n1153, n1154, n1155, n1156, n1157, n1158, n1159, n1160, n1161, n1162,
         n1163, n1164, n1165, n1166, n1167, n1168, n1169, n1170, n1171, n1172,
         n1173, n1174, n1175, n1176, n1177, n1178, n1179, n1180, n1181, n1182,
         n1183, n1184, n1185, n1186, n1187, n1188, n1189, n1190, n1191, n1192,
         n1193, n1194, n1195, n1196, n1197, n1198, n1199, n1200, n1201, n1202,
         n1203, n1204, n1205, n1206, n1207, n1208, n1209, n1210, n1211, n1212,
         n1213, n1214, n1215, n1216, n1217, n1218, n1219, n1220, n1221, n1222,
         n1223, n1224, n1225, n1226, n1227, n1228, n1229, n1230, n1231, n1232,
         n1233, n1234, n1235, n1236, n1237, n1238, n1239, n1240, n1241, n1242,
         n1243, n1244, n1245, n1246, n1247, n1248, n1249, n1250, n1251, n1252,
         n1253, n1254, n1255, n1256, n1257, n1258, n1259, n1260, n1261, n1262,
         n1263, n1264, n1265, n1266, n1267, n1268, n1269, n1270, n1271, n1272,
         n1273, n1274, n1275, n1276, n1277, n1278, n1279, n1280, n1281, n1282,
         n1283, n1284, n1285, n1286, n1287, n1288, n1289, n1290, n1291, n1292,
         n1293, n1294, n1295, n1296, n1297, n1298, n1299, n1300, n1301, n1302,
         n1303, n1304, n1305, n1306, n1307, n1308, n1309, n1310, n1311, n1312,
         n1313, n1314, n1315, n1316, n1317, n1318, n1319, n1320, n1321, n1322,
         n1323, n1324, n1325, n1326, n1327, n1328, n1329, n1330, n1331, n1332,
         n1333, n1334, n1335, n1336, n1337, n1338, n1339, n1340, n1341, n1342,
         n1343, n1344, n1345, n1346, n1347, n1348, n1349, n1350, n1351, n1352,
         n1353, /*n1354, */n1355, n1356, n1357, n1358, n1359, n1360, n1361, n1362,
         n1363, n1364, n1365, n1366, n1367, n1368, n1369, n1370, n1371, n1372,
         n1373, n1374, n1375, n1376, n1377, n1378, n1379, n1380, n1381, n1382,
         n1383, n1384, n1385, n1386, n1387, n1388, n1389, n1390, n1391, n1392,
         n1393, n1394, n1395, n1396, n1397, n1398, n1399, n1400, n1401, n1402,
         /*n1403, */n1404, n1405, n1406, n1407, /*n1408, */n1409, n1410, n1411, n1412,
         n1413, n1414;
  wire   [18:0] predictorSamp;
  reg   [2:0] pcmSq/*verilator public*/;
  reg	n1354, n1403, n1408;
  wire   [19:0] sampDiff;
  wire   [14:0] stepSize;
  wire   [18:0] dequantSamp;
  wire   [19:0] prePredSamp;
  wire   [3:0] prePCM;

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
  pcmSq[0] = n537;
  n1408 = ~n537;
  pcmSq[1] = n536;
  n1354 = ~n536;
  pcmSq[2] = n535;
  n1403 = ~n535;
  end
end

  DFFARX1 \pcmSq_reg[0]  ( .D(n537), .CLK(clock), .RSTB(n1412), .Q(pcmSq[0]), .QN(n1408) );
  DFFARX1 \pcmSq_reg[1]  ( .D(n536), .CLK(clock), .RSTB(n1410), .Q(pcmSq[1]), .QN(n1354) );
  DFFARX1 \pcmSq_reg[2]  ( .D(n535), .CLK(clock), .RSTB(n1413), .Q(pcmSq[2]), .QN(n1403) );
  DFFARX1 \dequantSamp_reg[18]  ( .D(n593), .CLK(clock), .RSTB(n1409), .Q(
        dequantSamp[18]) );
  DFFARX1 \dequantSamp_reg[17]  ( .D(n555), .CLK(clock), .RSTB(n1412), .Q(
        dequantSamp[17]) );
  DFFARX1 \dequantSamp_reg[16]  ( .D(n556), .CLK(clock), .RSTB(n1412), .Q(
        dequantSamp[16]) );
  DFFARX1 \dequantSamp_reg[15]  ( .D(n557), .CLK(clock), .RSTB(n1412), .Q(
        dequantSamp[15]) );
  DFFARX1 \prePCM_reg[2]  ( .D(n530), .CLK(clock), .RSTB(n1409), .Q(prePCM[2]), 
        .QN(n1389) );
  DFFARX1 \prePCM_reg[1]  ( .D(n529), .CLK(clock), .RSTB(n1409), .Q(prePCM[1]), 
        .QN(n1405) );
  DFFARX1 \prePCM_reg[0]  ( .D(n531), .CLK(clock), .RSTB(n1409), .Q(prePCM[0]), 
        .QN(n1355) );
  DFFARX1 \predictorSamp_reg[18]  ( .D(n589), .CLK(clock), .RSTB(n1411), .Q(
        predictorSamp[18]), .QN(n1402) );
  DFFARX1 \predictorSamp_reg[17]  ( .D(n592), .CLK(clock), .RSTB(n1413), .Q(
        predictorSamp[17]), .QN(n1370) );
  DFFARX1 \predictorSamp_reg[16]  ( .D(n588), .CLK(clock), .RSTB(n1409), .Q(
        predictorSamp[16]), .QN(n1399) );
  DFFARX1 \predictorSamp_reg[15]  ( .D(n587), .CLK(clock), .RSTB(n1412), .Q(
        predictorSamp[15]), .QN(n1383) );
  DFFARX1 \predictorSamp_reg[14]  ( .D(n586), .CLK(clock), .RSTB(n1413), .Q(
        predictorSamp[14]), .QN(n1398) );
  DFFARX1 \predictorSamp_reg[13]  ( .D(n585), .CLK(clock), .RSTB(n1413), .Q(
        predictorSamp[13]), .QN(n1382) );
  DFFARX1 \predictorSamp_reg[12]  ( .D(n584), .CLK(clock), .RSTB(n1413), .Q(
        predictorSamp[12]), .QN(n1397) );
  DFFARX1 \predictorSamp_reg[11]  ( .D(n583), .CLK(clock), .RSTB(n1413), .Q(
        predictorSamp[11]), .QN(n1381) );
  DFFARX1 \predictorSamp_reg[10]  ( .D(n582), .CLK(clock), .RSTB(n1413), .Q(
        predictorSamp[10]), .QN(n1396) );
  DFFARX1 \predictorSamp_reg[9]  ( .D(n581), .CLK(clock), .RSTB(n1413), .Q(
        predictorSamp[9]), .QN(n1380) );
  DFFARX1 \predictorSamp_reg[8]  ( .D(n580), .CLK(clock), .RSTB(n1413), .Q(
        predictorSamp[8]), .QN(n1395) );
  DFFARX1 \predictorSamp_reg[7]  ( .D(n579), .CLK(clock), .RSTB(n1413), .Q(
        predictorSamp[7]), .QN(n1379) );
  DFFARX1 \predictorSamp_reg[6]  ( .D(n578), .CLK(clock), .RSTB(n1413), .Q(
        predictorSamp[6]), .QN(n1394) );
  DFFARX1 \predictorSamp_reg[5]  ( .D(n577), .CLK(clock), .RSTB(n1413), .Q(
        predictorSamp[5]), .QN(n1378) );
  DFFARX1 \predictorSamp_reg[4]  ( .D(n576), .CLK(clock), .RSTB(n1413), .Q(
        predictorSamp[4]), .QN(n1400) );
  DFFARX1 \predictorSamp_reg[3]  ( .D(n575), .CLK(clock), .RSTB(n1413), .Q(
        predictorSamp[3]) );
  DFFARX1 \predictorSamp_reg[2]  ( .D(n574), .CLK(clock), .RSTB(n1412), .Q(
        predictorSamp[2]), .QN(n1388) );
  DFFARX1 \predictorSamp_reg[1]  ( .D(n573), .CLK(clock), .RSTB(n1412), .Q(
        predictorSamp[1]) );
  DFFARX1 \predictorSamp_reg[0]  ( .D(n590), .CLK(clock), .RSTB(n1412), .Q(
        predictorSamp[0]) );
  DFFARX1 \sampDiff_reg[19]  ( .D(n591), .CLK(clock), .RSTB(n1409), .Q(
        sampDiff[19]) );
  DFFARX1 \prePCM_reg[3]  ( .D(n554), .CLK(clock), .RSTB(n1412), .Q(prePCM[3])
         );
  DFFARX1 \sampDiff_reg[18]  ( .D(n538), .CLK(clock), .RSTB(n1409), .Q(
        sampDiff[18]), .QN(n1407) );
  DFFARX1 \sampDiff_reg[17]  ( .D(n539), .CLK(clock), .RSTB(n1409), .Q(
        sampDiff[17]), .QN(n1362) );
  DFFARX1 \sampDiff_reg[16]  ( .D(n540), .CLK(clock), .RSTB(n1409), .Q(
        sampDiff[16]), .QN(n1374) );
  DFFARX1 \sampDiff_reg[15]  ( .D(n541), .CLK(clock), .RSTB(n1409), .Q(
        sampDiff[15]), .QN(n1361) );
  DFFARX1 \sampDiff_reg[14]  ( .D(n542), .CLK(clock), .RSTB(n1409), .Q(
        sampDiff[14]), .QN(n1353) );
  DFFARX1 \sampDiff_reg[13]  ( .D(n543), .CLK(clock), .RSTB(n1409), .Q(
        sampDiff[13]), .QN(n1386) );
  DFFARX1 \sampDiff_reg[12]  ( .D(n544), .CLK(clock), .RSTB(n1409), .Q(
        sampDiff[12]), .QN(n1364) );
  DFFARX1 \sampDiff_reg[11]  ( .D(n545), .CLK(clock), .RSTB(n1409), .Q(
        sampDiff[11]), .QN(n1351) );
  DFFARX1 \sampDiff_reg[10]  ( .D(n546), .CLK(clock), .RSTB(n1410), .Q(
        sampDiff[10]), .QN(n1385) );
  DFFARX1 \sampDiff_reg[9]  ( .D(n547), .CLK(clock), .RSTB(n1410), .Q(
        sampDiff[9]), .QN(n1371) );
  DFFARX1 \sampDiff_reg[8]  ( .D(n548), .CLK(clock), .RSTB(n1410), .Q(
        sampDiff[8]), .QN(n1369) );
  DFFARX1 \sampDiff_reg[7]  ( .D(n549), .CLK(clock), .RSTB(n1410), .Q(
        sampDiff[7]), .QN(n1358) );
  DFFARX1 \sampDiff_reg[6]  ( .D(n550), .CLK(clock), .RSTB(n1410), .Q(
        sampDiff[6]), .QN(n1365) );
  DFFARX1 \sampDiff_reg[5]  ( .D(n551), .CLK(clock), .RSTB(n1410), .Q(
        sampDiff[5]), .QN(n1357) );
  DFFARX1 \sampDiff_reg[4]  ( .D(n552), .CLK(clock), .RSTB(n1410), .Q(
        sampDiff[4]), .QN(n1352) );
  DFFARX1 \sampDiff_reg[3]  ( .D(n553), .CLK(clock), .RSTB(n1410), .Q(
        sampDiff[3]), .QN(n1363) );
  DFFARX1 \sampDiff_reg[2]  ( .D(n534), .CLK(clock), .RSTB(n1410), .Q(
        sampDiff[2]), .QN(n1401) );
  DFFARX1 \sampDiff_reg[1]  ( .D(n532), .CLK(clock), .RSTB(n1410), .Q(
        sampDiff[1]) );
  DFFARX1 \sampDiff_reg[0]  ( .D(n533), .CLK(clock), .RSTB(n1410), .Q(N173) );
  DFFARX1 inReady_reg ( .D(n528), .CLK(clock), .RSTB(n1410), .Q(inReady) );
  DFFARX1 outValid_reg ( .D(n1414), .CLK(clock), .RSTB(n1411), .Q(outValid) );
  DFFARX1 \dequantSamp_reg[14]  ( .D(n558), .CLK(clock), .RSTB(n1412), .Q(
        dequantSamp[14]) );
  DFFARX1 \dequantSamp_reg[13]  ( .D(n559), .CLK(clock), .RSTB(n1412), .Q(
        dequantSamp[13]) );
  DFFARX1 \dequantSamp_reg[12]  ( .D(n560), .CLK(clock), .RSTB(n1412), .Q(
        dequantSamp[12]) );
  DFFARX1 \dequantSamp_reg[11]  ( .D(n561), .CLK(clock), .RSTB(n1412), .Q(
        dequantSamp[11]) );
  DFFARX1 \dequantSamp_reg[10]  ( .D(n562), .CLK(clock), .RSTB(n1412), .Q(
        dequantSamp[10]) );
  DFFARX1 \dequantSamp_reg[9]  ( .D(n563), .CLK(clock), .RSTB(n1412), .Q(
        dequantSamp[9]) );
  DFFARX1 \dequantSamp_reg[8]  ( .D(n564), .CLK(clock), .RSTB(n1410), .Q(
        dequantSamp[8]) );
  DFFARX1 \dequantSamp_reg[7]  ( .D(n565), .CLK(clock), .RSTB(n1413), .Q(
        dequantSamp[7]) );
  DFFARX1 \dequantSamp_reg[6]  ( .D(n566), .CLK(clock), .RSTB(n1411), .Q(
        dequantSamp[6]) );
  DFFARX1 \dequantSamp_reg[5]  ( .D(n567), .CLK(clock), .RSTB(n1409), .Q(
        dequantSamp[5]) );
  DFFARX1 \dequantSamp_reg[4]  ( .D(n568), .CLK(clock), .RSTB(n1412), .Q(
        dequantSamp[4]) );
  DFFARX1 \dequantSamp_reg[3]  ( .D(n569), .CLK(clock), .RSTB(n1410), .Q(
        dequantSamp[3]) );
  DFFARX1 \dequantSamp_reg[2]  ( .D(n570), .CLK(clock), .RSTB(n1410), .Q(
        dequantSamp[2]) );
  DFFARX1 \dequantSamp_reg[1]  ( .D(n571), .CLK(clock), .RSTB(n1413), .Q(
        dequantSamp[1]) );
  DFFARX1 \dequantSamp_reg[0]  ( .D(n572), .CLK(clock), .RSTB(n1411), .Q(
        \C38/DATA2_0 ) );
  DFFARX1 \outPCM_reg[3]  ( .D(n527), .CLK(clock), .RSTB(n1411), .Q(outPCM[3])
         );
  DFFARX1 \outPCM_reg[2]  ( .D(n526), .CLK(clock), .RSTB(n1411), .Q(outPCM[2])
         );
  DFFARX1 \outPCM_reg[1]  ( .D(n525), .CLK(clock), .RSTB(n1411), .Q(outPCM[1])
         );
  DFFARX1 \outPCM_reg[0]  ( .D(n524), .CLK(clock), .RSTB(n1411), .Q(outPCM[0])
         );
  DFFARX1 \stepIndex_reg[6]  ( .D(n523), .CLK(clock), .RSTB(n1411), .Q(
        outStepIndex[6]), .QN(n1349) );
  DFFARX1 \stepIndex_reg[5]  ( .D(n522), .CLK(clock), .RSTB(n1411), .Q(
        outStepIndex[5]), .QN(n1359) );
  DFFARX1 \stepIndex_reg[4]  ( .D(n521), .CLK(clock), .RSTB(n1411), .Q(
        outStepIndex[4]), .QN(n1348) );
  DFFARX1 \stepIndex_reg[3]  ( .D(n520), .CLK(clock), .RSTB(n1411), .Q(
        outStepIndex[3]), .QN(n1347) );
  DFFARX1 \stepIndex_reg[2]  ( .D(n519), .CLK(clock), .RSTB(n1411), .Q(
        outStepIndex[2]), .QN(n1356) );
  DFFARX1 \stepIndex_reg[1]  ( .D(n518), .CLK(clock), .RSTB(n1411), .Q(
        outStepIndex[1]), .QN(n1373) );
  DFFARX1 \stepIndex_reg[0]  ( .D(n517), .CLK(clock), .RSTB(n1411), .Q(
        outStepIndex[0]), .QN(n1350) );
  DFFX1 \stepSize_reg[14]  ( .D(n613), .CLK(clock), .Q(stepSize[14]), .QN(
        n1404) );
  DFFX1 \stepSize_reg[13]  ( .D(n612), .CLK(clock), .Q(stepSize[13]), .QN(
        n1372) );
  DFFX1 \stepSize_reg[12]  ( .D(n611), .CLK(clock), .Q(stepSize[12]), .QN(
        n1366) );
  DFFX1 \stepSize_reg[11]  ( .D(n610), .CLK(clock), .Q(stepSize[11]), .QN(
        n1367) );
  DFFX1 \stepSize_reg[10]  ( .D(n609), .CLK(clock), .Q(stepSize[10]), .QN(
        n1360) );
  DFFX1 \stepSize_reg[9]  ( .D(n605), .CLK(clock), .Q(stepSize[9]), .QN(n1368)
         );
  DFFX1 \stepSize_reg[8]  ( .D(n604), .CLK(clock), .Q(stepSize[8]), .QN(n1375)
         );
  DFFX1 \stepSize_reg[7]  ( .D(n603), .CLK(clock), .Q(stepSize[7]), .QN(n1390)
         );
  DFFX1 \stepSize_reg[6]  ( .D(n599), .CLK(clock), .Q(stepSize[6]), .QN(n1377)
         );
  DFFX1 \stepSize_reg[5]  ( .D(n602), .CLK(clock), .Q(stepSize[5]), .QN(n1376)
         );
  DFFX1 \stepSize_reg[4]  ( .D(n608), .CLK(clock), .Q(stepSize[4]), .QN(n1392)
         );
  DFFX1 \stepSize_reg[3]  ( .D(n601), .CLK(clock), .Q(stepSize[3]), .QN(n1393)
         );
  DFFX1 \stepSize_reg[2]  ( .D(n600), .CLK(clock), .Q(stepSize[2]), .QN(n1391)
         );
  DFFX1 \stepSize_reg[1]  ( .D(n607), .CLK(clock), .Q(stepSize[1]), .QN(n1384)
         );
  DFFX1 \stepSize_reg[0]  ( .D(n606), .CLK(clock), .Q(stepSize[0]), .QN(n1406)
         );
  FADDX1 \DP_OP_36J1_122_5288/U21  ( .A(predictorSamp[0]), .B(prePCM[3]), .CI(
        \DP_OP_36J1_122_5288/n43 ), .CO(\DP_OP_36J1_122_5288/n20 ), .S(
        prePredSamp[0]) );
  FADDX1 \DP_OP_36J1_122_5288/U20  ( .A(\DP_OP_36J1_122_5288/n42 ), .B(
        predictorSamp[1]), .CI(\DP_OP_36J1_122_5288/n20 ), .CO(
        \DP_OP_36J1_122_5288/n19 ), .S(prePredSamp[1]) );
  FADDX1 \DP_OP_36J1_122_5288/U19  ( .A(\DP_OP_36J1_122_5288/n41 ), .B(
        predictorSamp[2]), .CI(\DP_OP_36J1_122_5288/n19 ), .CO(
        \DP_OP_36J1_122_5288/n18 ), .S(prePredSamp[2]) );
  FADDX1 \DP_OP_36J1_122_5288/U18  ( .A(\DP_OP_36J1_122_5288/n40 ), .B(
        predictorSamp[3]), .CI(\DP_OP_36J1_122_5288/n18 ), .CO(
        \DP_OP_36J1_122_5288/n17 ), .S(prePredSamp[3]) );
  FADDX1 \DP_OP_36J1_122_5288/U17  ( .A(\DP_OP_36J1_122_5288/n39 ), .B(
        predictorSamp[4]), .CI(\DP_OP_36J1_122_5288/n17 ), .CO(
        \DP_OP_36J1_122_5288/n16 ), .S(prePredSamp[4]) );
  FADDX1 \DP_OP_36J1_122_5288/U16  ( .A(\DP_OP_36J1_122_5288/n38 ), .B(
        predictorSamp[5]), .CI(\DP_OP_36J1_122_5288/n16 ), .CO(
        \DP_OP_36J1_122_5288/n15 ), .S(prePredSamp[5]) );
  FADDX1 \DP_OP_36J1_122_5288/U15  ( .A(\DP_OP_36J1_122_5288/n37 ), .B(
        predictorSamp[6]), .CI(\DP_OP_36J1_122_5288/n15 ), .CO(
        \DP_OP_36J1_122_5288/n14 ), .S(prePredSamp[6]) );
  FADDX1 \DP_OP_36J1_122_5288/U14  ( .A(\DP_OP_36J1_122_5288/n36 ), .B(
        predictorSamp[7]), .CI(\DP_OP_36J1_122_5288/n14 ), .CO(
        \DP_OP_36J1_122_5288/n13 ), .S(prePredSamp[7]) );
  FADDX1 \DP_OP_36J1_122_5288/U13  ( .A(\DP_OP_36J1_122_5288/n35 ), .B(
        predictorSamp[8]), .CI(\DP_OP_36J1_122_5288/n13 ), .CO(
        \DP_OP_36J1_122_5288/n12 ), .S(prePredSamp[8]) );
  FADDX1 \DP_OP_36J1_122_5288/U12  ( .A(\DP_OP_36J1_122_5288/n34 ), .B(
        predictorSamp[9]), .CI(\DP_OP_36J1_122_5288/n12 ), .CO(
        \DP_OP_36J1_122_5288/n11 ), .S(prePredSamp[9]) );
  FADDX1 \DP_OP_36J1_122_5288/U11  ( .A(\DP_OP_36J1_122_5288/n33 ), .B(
        predictorSamp[10]), .CI(\DP_OP_36J1_122_5288/n11 ), .CO(
        \DP_OP_36J1_122_5288/n10 ), .S(prePredSamp[10]) );
  FADDX1 \DP_OP_36J1_122_5288/U10  ( .A(\DP_OP_36J1_122_5288/n32 ), .B(
        predictorSamp[11]), .CI(\DP_OP_36J1_122_5288/n10 ), .CO(
        \DP_OP_36J1_122_5288/n9 ), .S(prePredSamp[11]) );
  FADDX1 \DP_OP_36J1_122_5288/U9  ( .A(\DP_OP_36J1_122_5288/n31 ), .B(
        predictorSamp[12]), .CI(\DP_OP_36J1_122_5288/n9 ), .CO(
        \DP_OP_36J1_122_5288/n8 ), .S(prePredSamp[12]) );
  FADDX1 \DP_OP_36J1_122_5288/U8  ( .A(\DP_OP_36J1_122_5288/n30 ), .B(
        predictorSamp[13]), .CI(\DP_OP_36J1_122_5288/n8 ), .CO(
        \DP_OP_36J1_122_5288/n7 ), .S(prePredSamp[13]) );
  FADDX1 \DP_OP_36J1_122_5288/U7  ( .A(\DP_OP_36J1_122_5288/n29 ), .B(
        predictorSamp[14]), .CI(\DP_OP_36J1_122_5288/n7 ), .CO(
        \DP_OP_36J1_122_5288/n6 ), .S(prePredSamp[14]) );
  FADDX1 \DP_OP_36J1_122_5288/U6  ( .A(\DP_OP_36J1_122_5288/n28 ), .B(
        predictorSamp[15]), .CI(\DP_OP_36J1_122_5288/n6 ), .CO(
        \DP_OP_36J1_122_5288/n5 ), .S(prePredSamp[15]) );
  FADDX1 \DP_OP_36J1_122_5288/U5  ( .A(\DP_OP_36J1_122_5288/n27 ), .B(
        predictorSamp[16]), .CI(\DP_OP_36J1_122_5288/n5 ), .CO(
        \DP_OP_36J1_122_5288/n4 ), .S(prePredSamp[16]) );
  FADDX1 \DP_OP_36J1_122_5288/U4  ( .A(\DP_OP_36J1_122_5288/n26 ), .B(
        predictorSamp[17]), .CI(\DP_OP_36J1_122_5288/n4 ), .CO(
        \DP_OP_36J1_122_5288/n3 ), .S(prePredSamp[17]) );
  FADDX1 \DP_OP_67J1_125_4341/U17  ( .A(dequantSamp[2]), .B(\C1/Z_2 ), .CI(
        n1387), .CO(\DP_OP_67J1_125_4341/n16 ), .S(\C38/DATA2_2 ) );
  FADDX1 \DP_OP_67J1_125_4341/U16  ( .A(dequantSamp[3]), .B(\C1/Z_3 ), .CI(
        \DP_OP_67J1_125_4341/n16 ), .CO(\DP_OP_67J1_125_4341/n15 ), .S(
        \C38/DATA2_3 ) );
  FADDX1 \DP_OP_67J1_125_4341/U15  ( .A(dequantSamp[4]), .B(\C1/Z_4 ), .CI(
        \DP_OP_67J1_125_4341/n15 ), .CO(\DP_OP_67J1_125_4341/n14 ), .S(
        \C38/DATA2_4 ) );
  FADDX1 \DP_OP_67J1_125_4341/U14  ( .A(dequantSamp[5]), .B(\C1/Z_5 ), .CI(
        \DP_OP_67J1_125_4341/n14 ), .CO(\DP_OP_67J1_125_4341/n13 ), .S(
        \C38/DATA2_5 ) );
  FADDX1 \DP_OP_67J1_125_4341/U13  ( .A(dequantSamp[6]), .B(\C1/Z_6 ), .CI(
        \DP_OP_67J1_125_4341/n13 ), .CO(\DP_OP_67J1_125_4341/n12 ), .S(
        \C38/DATA2_6 ) );
  FADDX1 \DP_OP_67J1_125_4341/U12  ( .A(dequantSamp[7]), .B(\C1/Z_7 ), .CI(
        \DP_OP_67J1_125_4341/n12 ), .CO(\DP_OP_67J1_125_4341/n11 ), .S(
        \C38/DATA2_7 ) );
  FADDX1 \DP_OP_67J1_125_4341/U11  ( .A(dequantSamp[8]), .B(\C1/Z_8 ), .CI(
        \DP_OP_67J1_125_4341/n11 ), .CO(\DP_OP_67J1_125_4341/n10 ), .S(
        \C38/DATA2_8 ) );
  FADDX1 \DP_OP_67J1_125_4341/U10  ( .A(dequantSamp[9]), .B(\C1/Z_9 ), .CI(
        \DP_OP_67J1_125_4341/n10 ), .CO(\DP_OP_67J1_125_4341/n9 ), .S(
        \C38/DATA2_9 ) );
  FADDX1 \DP_OP_67J1_125_4341/U9  ( .A(dequantSamp[10]), .B(\C1/Z_10 ), .CI(
        \DP_OP_67J1_125_4341/n9 ), .CO(\DP_OP_67J1_125_4341/n8 ), .S(
        \C38/DATA2_10 ) );
  FADDX1 \DP_OP_67J1_125_4341/U8  ( .A(dequantSamp[11]), .B(\C1/Z_11 ), .CI(
        \DP_OP_67J1_125_4341/n8 ), .CO(\DP_OP_67J1_125_4341/n7 ), .S(
        \C38/DATA2_11 ) );
  FADDX1 \DP_OP_67J1_125_4341/U7  ( .A(dequantSamp[12]), .B(\C1/Z_12 ), .CI(
        \DP_OP_67J1_125_4341/n7 ), .CO(\DP_OP_67J1_125_4341/n6 ), .S(
        \C38/DATA2_12 ) );
  FADDX1 \DP_OP_67J1_125_4341/U6  ( .A(dequantSamp[13]), .B(\C1/Z_13 ), .CI(
        \DP_OP_67J1_125_4341/n6 ), .CO(\DP_OP_67J1_125_4341/n5 ), .S(
        \C38/DATA2_13 ) );
  FADDX1 \DP_OP_67J1_125_4341/U5  ( .A(dequantSamp[14]), .B(\C1/Z_14 ), .CI(
        \DP_OP_67J1_125_4341/n5 ), .CO(\DP_OP_67J1_125_4341/n4 ), .S(
        \C38/DATA2_14 ) );
  FADDX1 \DP_OP_67J1_125_4341/U4  ( .A(dequantSamp[15]), .B(\C1/Z_15 ), .CI(
        \DP_OP_67J1_125_4341/n4 ), .CO(\DP_OP_67J1_125_4341/n3 ), .S(
        \C38/DATA2_15 ) );
  FADDX1 \DP_OP_67J1_125_4341/U3  ( .A(dequantSamp[16]), .B(\C1/Z_16 ), .CI(
        \DP_OP_67J1_125_4341/n3 ), .CO(\DP_OP_67J1_125_4341/n2 ), .S(
        \C38/DATA2_16 ) );
  FADDX1 \DP_OP_67J1_125_4341/U2  ( .A(dequantSamp[17]), .B(\C1/Z_17 ), .CI(
        \DP_OP_67J1_125_4341/n2 ), .CO(\DP_OP_67J1_125_4341/n1 ), .S(
        \C38/DATA2_17 ) );
  FADDX1 \DP_OP_36J1_122_5288/U3  ( .A(\DP_OP_36J1_122_5288/n25 ), .B(
        predictorSamp[18]), .CI(\DP_OP_36J1_122_5288/n3 ), .CO(
        \DP_OP_36J1_122_5288/n2 ), .S(prePredSamp[18]) );
  NOR4X1 U611 ( .IN1(n1339), .IN2(n1204), .IN3(n887), .IN4(n1337), .QN(n1202)
         );
  NAND2X0 U612 ( .IN1(sampDiff[8]), .IN2(n1376), .QN(n637) );
  NAND2X0 U613 ( .IN1(n637), .IN2(n929), .QN(n638) );
  NAND2X0 U614 ( .IN1(sampDiff[10]), .IN2(n1390), .QN(n640) );
  NAND2X0 U615 ( .IN1(stepSize[11]), .IN2(n1364), .QN(n863) );
  NAND2X0 U616 ( .IN1(n1351), .IN2(stepSize[9]), .QN(n665) );
  NAND2X0 U617 ( .IN1(stepSize[7]), .IN2(n619), .QN(n722) );
  NAND2X0 U618 ( .IN1(sampDiff[14]), .IN2(n1366), .QN(n627) );
  NAND2X0 U619 ( .IN1(n1114), .IN2(n1157), .QN(n1009) );
  NAND2X0 U620 ( .IN1(inSamp[1]), .IN2(n1400), .QN(n790) );
  NAND2X0 U621 ( .IN1(inSamp[3]), .IN2(n1394), .QN(n951) );
  NAND2X0 U622 ( .IN1(inSamp[7]), .IN2(n1396), .QN(n912) );
  NAND2X0 U623 ( .IN1(inSamp[9]), .IN2(n1397), .QN(n1258) );
  NAND2X0 U624 ( .IN1(inSamp[13]), .IN2(n1399), .QN(n893) );
  NAND2X0 U625 ( .IN1(n1189), .IN2(n1188), .QN(n1192) );
  NAND2X0 U626 ( .IN1(n1140), .IN2(n1139), .QN(n1141) );
  NAND2X0 U627 ( .IN1(n1191), .IN2(n1054), .QN(n994) );
  NAND2X0 U628 ( .IN1(n1128), .IN2(n1129), .QN(n1048) );
  NAND2X0 U629 ( .IN1(predictorSamp[1]), .IN2(predictorSamp[0]), .QN(n969) );
  NAND2X0 U630 ( .IN1(n1271), .IN2(n1234), .QN(n1235) );
  NAND2X0 U631 ( .IN1(stepSize[9]), .IN2(n1265), .QN(n1255) );
  NAND2X0 U632 ( .IN1(stepSize[10]), .IN2(n1281), .QN(n1278) );
  NAND2X0 U633 ( .IN1(n900), .IN2(n1362), .QN(n1327) );
  NAND2X0 U634 ( .IN1(sampDiff[16]), .IN2(n1404), .QN(n632) );
  NAND2X0 U635 ( .IN1(n1133), .IN2(n1157), .QN(n1152) );
  NAND2X0 U636 ( .IN1(n1167), .IN2(n1071), .QN(n1045) );
  NAND2X0 U637 ( .IN1(n1094), .IN2(n1042), .QN(n1028) );
  NAND2X0 U638 ( .IN1(n982), .IN2(n981), .QN(n983) );
  NAND2X0 U639 ( .IN1(sampDiff[19]), .IN2(n1204), .QN(n634) );
  NAND2X0 U640 ( .IN1(n1240), .IN2(n1363), .QN(n1234) );
  NAND2X0 U641 ( .IN1(n779), .IN2(n1357), .QN(n962) );
  NAND2X0 U642 ( .IN1(n938), .IN2(n1371), .QN(n923) );
  NAND2X0 U643 ( .IN1(n919), .IN2(n1351), .QN(n1253) );
  NAND2X0 U644 ( .IN1(n1248), .IN2(n1386), .QN(n1299) );
  NAND2X0 U645 ( .IN1(n1302), .IN2(n1314), .QN(n1227) );
  NAND2X0 U646 ( .IN1(n1076), .IN2(n1113), .QN(n1199) );
  NAND2X0 U647 ( .IN1(n1150), .IN2(n1190), .QN(n1148) );
  NAND2X0 U648 ( .IN1(n1150), .IN2(n1112), .QN(n1082) );
  NAND2X0 U649 ( .IN1(n1160), .IN2(n1193), .QN(n1107) );
  NAND2X0 U650 ( .IN1(n820), .IN2(n977), .QN(n821) );
  NAND2X0 U651 ( .IN1(n1341), .IN2(inValid), .QN(n1342) );
  NAND2X0 U652 ( .IN1(n1239), .IN2(n1322), .QN(n1246) );
  NAND2X0 U653 ( .IN1(n937), .IN2(n1331), .QN(n945) );
  NAND2X0 U654 ( .IN1(n1331), .IN2(n1312), .QN(n1317) );
  NAND2X0 U655 ( .IN1(n1226), .IN2(n1225), .QN(n1334) );
  NAND2X0 U656 ( .IN1(predictorSamp[5]), .IN2(n1345), .QN(n828) );
  NAND2X0 U657 ( .IN1(n858), .IN2(prePredSamp[12]), .QN(n833) );
  NAND2X0 U658 ( .IN1(predictorSamp[6]), .IN2(n1220), .QN(n1219) );
  NAND2X0 U659 ( .IN1(predictorSamp[14]), .IN2(n1212), .QN(n1211) );
  NAND2X0 U660 ( .IN1(n808), .IN2(n807), .QN(n534) );
  NAND2X0 U661 ( .IN1(n721), .IN2(n720), .QN(n545) );
  NAND2X0 U662 ( .IN1(n1338), .IN2(n1340), .QN(n535) );
  INVX0 U663 ( .INP(reset), .ZN(n1410) );
  INVX0 U664 ( .INP(reset), .ZN(n1413) );
  INVX0 U665 ( .INP(reset), .ZN(n1411) );
  INVX0 U666 ( .INP(reset), .ZN(n1409) );
  INVX0 U667 ( .INP(reset), .ZN(n1412) );
  NAND2X0 U668 ( .IN1(pcmSq[0]), .IN2(n1354), .QN(n615) );
  NOR2X0 U669 ( .IN1(n615), .IN2(n1403), .QN(n1414) );
  NAND3X0 U670 ( .IN1(pcmSq[2]), .IN2(n1354), .IN3(n1408), .QN(n1338) );
  NAND3X0 U671 ( .IN1(pcmSq[1]), .IN2(pcmSq[0]), .IN3(n1403), .QN(n1340) );
  OR2X1 U672 ( .IN1(pcmSq[2]), .IN2(pcmSq[0]), .Q(n1023) );
  NOR2X0 U673 ( .IN1(n1354), .IN2(n1023), .QN(n1208) );
  INVX0 U674 ( .INP(n1208), .ZN(n1205) );
  NOR2X0 U675 ( .IN1(pcmSq[2]), .IN2(n615), .QN(n1204) );
  INVX0 U676 ( .INP(n1204), .ZN(n800) );
  NAND2X0 U677 ( .IN1(n1205), .IN2(n800), .QN(n536) );
  NOR2X0 U678 ( .IN1(sampDiff[16]), .IN2(n1372), .QN(n657) );
  NOR2X0 U679 ( .IN1(n1366), .IN2(sampDiff[15]), .QN(n659) );
  NOR2X0 U680 ( .IN1(sampDiff[14]), .IN2(n1367), .QN(n618) );
  NOR2X0 U681 ( .IN1(sampDiff[13]), .IN2(n1360), .QN(n617) );
  NOR2X0 U682 ( .IN1(sampDiff[12]), .IN2(n1368), .QN(n616) );
  NOR2X0 U683 ( .IN1(n1375), .IN2(sampDiff[11]), .QN(n644) );
  NOR2X0 U684 ( .IN1(n1390), .IN2(sampDiff[10]), .QN(n643) );
  NOR2X0 U685 ( .IN1(sampDiff[9]), .IN2(n1377), .QN(n636) );
  NOR2X0 U686 ( .IN1(sampDiff[8]), .IN2(n1376), .QN(n635) );
  NAND2X0 U687 ( .IN1(n1363), .IN2(stepSize[0]), .QN(n786) );
  INVX0 U688 ( .INP(n786), .ZN(n1239) );
  AO222X1 U689 ( .IN1(stepSize[1]), .IN2(n1239), .IN3(stepSize[1]), .IN4(n1352), .IN5(n1239), .IN6(n1352), .Q(n761) );
  AO222X1 U690 ( .IN1(stepSize[2]), .IN2(n761), .IN3(stepSize[2]), .IN4(n1357), 
        .IN5(n761), .IN6(n1357), .Q(n947) );
  AO222X1 U691 ( .IN1(stepSize[3]), .IN2(n1365), .IN3(stepSize[3]), .IN4(n947), 
        .IN5(n1365), .IN6(n947), .Q(n743) );
  AO222X1 U692 ( .IN1(stepSize[4]), .IN2(n1358), .IN3(stepSize[4]), .IN4(n743), 
        .IN5(n1358), .IN6(n743), .Q(n929) );
  OA22X1 U693 ( .IN1(stepSize[5]), .IN2(n1369), .IN3(n635), .IN4(n929), .Q(
        n725) );
  OA22X1 U694 ( .IN1(n636), .IN2(n725), .IN3(stepSize[6]), .IN4(n1371), .Q(
        n909) );
  OA22X1 U695 ( .IN1(stepSize[7]), .IN2(n1385), .IN3(n643), .IN4(n909), .Q(
        n705) );
  OA22X1 U696 ( .IN1(n644), .IN2(n705), .IN3(stepSize[8]), .IN4(n1351), .Q(
        n1265) );
  NAND2X0 U697 ( .IN1(n1368), .IN2(sampDiff[12]), .QN(n1266) );
  OA21X1 U698 ( .IN1(n616), .IN2(n1265), .IN3(n1266), .Q(n1281) );
  NAND2X0 U699 ( .IN1(n1360), .IN2(sampDiff[13]), .QN(n1282) );
  OA21X1 U700 ( .IN1(n617), .IN2(n1281), .IN3(n1282), .Q(n1313) );
  NAND2X0 U701 ( .IN1(n1367), .IN2(sampDiff[14]), .QN(n1315) );
  OA21X1 U702 ( .IN1(n618), .IN2(n1313), .IN3(n1315), .Q(n687) );
  OA22X1 U703 ( .IN1(n659), .IN2(n687), .IN3(stepSize[12]), .IN4(n1361), .Q(
        n891) );
  OA22X1 U704 ( .IN1(n657), .IN2(n891), .IN3(stepSize[13]), .IN4(n1374), .Q(
        n1223) );
  MUX21X1 U705 ( .IN1(stepSize[14]), .IN2(n1404), .S(n1223), .Q(n677) );
  NOR2X0 U706 ( .IN1(n1360), .IN2(sampDiff[12]), .QN(n621) );
  NAND2X0 U707 ( .IN1(n1401), .IN2(stepSize[0]), .QN(n1232) );
  INVX0 U708 ( .INP(n1232), .ZN(n864) );
  AO222X1 U709 ( .IN1(n864), .IN2(stepSize[1]), .IN3(n864), .IN4(n1363), .IN5(
        stepSize[1]), .IN6(n1363), .Q(n780) );
  AO222X1 U710 ( .IN1(stepSize[2]), .IN2(n780), .IN3(stepSize[2]), .IN4(n1352), 
        .IN5(n780), .IN6(n1352), .Q(n760) );
  AO222X1 U711 ( .IN1(n760), .IN2(stepSize[3]), .IN3(n760), .IN4(n1357), .IN5(
        stepSize[3]), .IN6(n1357), .Q(n948) );
  AO222X1 U712 ( .IN1(stepSize[4]), .IN2(n948), .IN3(stepSize[4]), .IN4(n1365), 
        .IN5(n948), .IN6(n1365), .Q(n742) );
  AO222X1 U713 ( .IN1(stepSize[5]), .IN2(n742), .IN3(stepSize[5]), .IN4(n1358), 
        .IN5(n742), .IN6(n1358), .Q(n928) );
  AO222X1 U714 ( .IN1(stepSize[6]), .IN2(n928), .IN3(stepSize[6]), .IN4(n1369), 
        .IN5(n928), .IN6(n1369), .Q(n619) );
  NOR2X0 U715 ( .IN1(stepSize[7]), .IN2(n619), .QN(n723) );
  OA21X1 U716 ( .IN1(sampDiff[9]), .IN2(n723), .IN3(n722), .Q(n910) );
  OA21X1 U717 ( .IN1(sampDiff[10]), .IN2(n1375), .IN3(n910), .Q(n667) );
  NAND2X0 U718 ( .IN1(n665), .IN2(n667), .QN(n620) );
  NOR2X0 U719 ( .IN1(n621), .IN2(n620), .QN(n625) );
  NAND2X0 U720 ( .IN1(stepSize[10]), .IN2(n1364), .QN(n623) );
  NOR2X0 U721 ( .IN1(stepSize[8]), .IN2(n1385), .QN(n666) );
  AO22X1 U722 ( .IN1(sampDiff[11]), .IN2(n1368), .IN3(n666), .IN4(n665), .Q(
        n622) );
  NOR2X0 U723 ( .IN1(n1386), .IN2(stepSize[11]), .QN(n669) );
  AO221X1 U724 ( .IN1(n1360), .IN2(sampDiff[12]), .IN3(n623), .IN4(n622), 
        .IN5(n669), .Q(n624) );
  NOR2X0 U725 ( .IN1(n625), .IN2(n624), .QN(n626) );
  NOR2X0 U726 ( .IN1(sampDiff[13]), .IN2(n1367), .QN(n671) );
  NOR2X0 U727 ( .IN1(sampDiff[14]), .IN2(n1366), .QN(n672) );
  OR3X1 U728 ( .IN1(n626), .IN2(n671), .IN3(n672), .Q(n629) );
  NAND2X0 U729 ( .IN1(sampDiff[15]), .IN2(n1372), .QN(n628) );
  AND3X1 U730 ( .IN1(n629), .IN2(n628), .IN3(n627), .Q(n630) );
  NOR2X0 U731 ( .IN1(sampDiff[16]), .IN2(n1404), .QN(n674) );
  NOR2X0 U732 ( .IN1(sampDiff[15]), .IN2(n1372), .QN(n673) );
  OR3X1 U733 ( .IN1(n630), .IN2(n674), .IN3(n673), .Q(n631) );
  NOR3X0 U734 ( .IN1(sampDiff[17]), .IN2(sampDiff[19]), .IN3(sampDiff[18]), 
        .QN(n885) );
  AND3X1 U735 ( .IN1(n632), .IN2(n631), .IN3(n885), .Q(n633) );
  NOR2X0 U736 ( .IN1(n633), .IN2(n1340), .QN(n1339) );
  NOR2X0 U737 ( .IN1(pcmSq[1]), .IN2(n1023), .QN(n1341) );
  NAND2X0 U738 ( .IN1(n1342), .IN2(n634), .QN(n1335) );
  NOR2X0 U739 ( .IN1(n1339), .IN2(n1335), .QN(n803) );
  INVX0 U740 ( .INP(n803), .ZN(n804) );
  INVX0 U741 ( .INP(n1315), .ZN(n654) );
  INVX0 U742 ( .INP(n1282), .ZN(n652) );
  INVX0 U743 ( .INP(n1266), .ZN(n650) );
  NOR2X0 U744 ( .IN1(stepSize[8]), .IN2(n1351), .QN(n648) );
  NOR2X0 U745 ( .IN1(n636), .IN2(n635), .QN(n639) );
  NAND2X0 U746 ( .IN1(n639), .IN2(n638), .QN(n642) );
  NAND2X0 U747 ( .IN1(sampDiff[9]), .IN2(n1377), .QN(n641) );
  NAND3X0 U748 ( .IN1(n642), .IN2(n641), .IN3(n640), .QN(n647) );
  INVX0 U749 ( .INP(n643), .ZN(n646) );
  INVX0 U750 ( .INP(n644), .ZN(n645) );
  OA221X1 U751 ( .IN1(n648), .IN2(n647), .IN3(n648), .IN4(n646), .IN5(n645), 
        .Q(n649) );
  OA22X1 U752 ( .IN1(n650), .IN2(n649), .IN3(sampDiff[12]), .IN4(n1368), .Q(
        n651) );
  OA22X1 U753 ( .IN1(n652), .IN2(n651), .IN3(sampDiff[13]), .IN4(n1360), .Q(
        n653) );
  OA22X1 U754 ( .IN1(sampDiff[14]), .IN2(n1367), .IN3(n654), .IN4(n653), .Q(
        n656) );
  NOR2X0 U755 ( .IN1(stepSize[12]), .IN2(n1361), .QN(n655) );
  NOR2X0 U756 ( .IN1(n1374), .IN2(stepSize[13]), .QN(n663) );
  NOR3X0 U757 ( .IN1(n656), .IN2(n655), .IN3(n663), .QN(n658) );
  NOR2X0 U758 ( .IN1(sampDiff[17]), .IN2(n1404), .QN(n1224) );
  NOR3X0 U759 ( .IN1(n658), .IN2(n657), .IN3(n1224), .QN(n664) );
  INVX0 U760 ( .INP(n659), .ZN(n662) );
  NOR2X0 U761 ( .IN1(stepSize[14]), .IN2(n1362), .QN(n660) );
  OR3X1 U762 ( .IN1(sampDiff[19]), .IN2(sampDiff[18]), .IN3(n660), .Q(n661) );
  AO221X1 U763 ( .IN1(n664), .IN2(n663), .IN3(n664), .IN4(n662), .IN5(n661), 
        .Q(n888) );
  AND2X1 U764 ( .IN1(n1208), .IN2(n888), .Q(n887) );
  NOR2X0 U765 ( .IN1(n804), .IN2(n887), .QN(n763) );
  NOR2X0 U766 ( .IN1(n1205), .IN2(n763), .QN(n1322) );
  INVX0 U767 ( .INP(n1322), .ZN(n1314) );
  INVX0 U768 ( .INP(n665), .ZN(n668) );
  NOR2X0 U769 ( .IN1(n667), .IN2(n666), .QN(n704) );
  OA22X1 U770 ( .IN1(stepSize[9]), .IN2(n1351), .IN3(n668), .IN4(n704), .Q(
        n1249) );
  AO222X1 U771 ( .IN1(stepSize[10]), .IN2(n1249), .IN3(stepSize[10]), .IN4(
        n1364), .IN5(n1249), .IN6(n1364), .Q(n1272) );
  INVX0 U772 ( .INP(n669), .ZN(n670) );
  OA21X1 U773 ( .IN1(n671), .IN2(n1272), .IN3(n670), .Q(n1295) );
  OA22X1 U774 ( .IN1(stepSize[12]), .IN2(n1353), .IN3(n672), .IN4(n1295), .Q(
        n686) );
  OA22X1 U775 ( .IN1(n673), .IN2(n686), .IN3(stepSize[13]), .IN4(n1361), .Q(
        n890) );
  OA22X1 U776 ( .IN1(stepSize[14]), .IN2(n1374), .IN3(n674), .IN4(n890), .Q(
        n676) );
  NOR2X0 U777 ( .IN1(n1340), .IN2(n763), .QN(n949) );
  INVX0 U778 ( .INP(n949), .ZN(n1302) );
  INVX0 U779 ( .INP(n763), .ZN(n1304) );
  OA21X1 U780 ( .IN1(n676), .IN2(n1302), .IN3(n1304), .Q(n1226) );
  OA21X1 U781 ( .IN1(n677), .IN2(n1314), .IN3(n1226), .Q(n675) );
  NOR2X0 U782 ( .IN1(n675), .IN2(n1362), .QN(n681) );
  NAND2X0 U783 ( .IN1(n1304), .IN2(n1204), .QN(n1325) );
  INVX0 U784 ( .INP(n1325), .ZN(n1271) );
  OR2X1 U785 ( .IN1(sampDiff[1]), .IN2(N173), .Q(n801) );
  NOR2X0 U786 ( .IN1(sampDiff[2]), .IN2(n801), .QN(n1240) );
  NOR2X0 U787 ( .IN1(sampDiff[4]), .IN2(n1234), .QN(n779) );
  NOR2X0 U788 ( .IN1(sampDiff[6]), .IN2(n962), .QN(n958) );
  NAND2X0 U789 ( .IN1(n958), .IN2(n1358), .QN(n942) );
  NOR2X0 U790 ( .IN1(sampDiff[8]), .IN2(n942), .QN(n938) );
  NOR2X0 U791 ( .IN1(sampDiff[10]), .IN2(n923), .QN(n919) );
  NOR2X0 U792 ( .IN1(sampDiff[12]), .IN2(n1253), .QN(n1248) );
  NOR2X0 U793 ( .IN1(sampDiff[14]), .IN2(n1299), .QN(n1294) );
  NAND2X0 U794 ( .IN1(n1294), .IN2(n1361), .QN(n904) );
  NOR2X0 U795 ( .IN1(sampDiff[16]), .IN2(n904), .QN(n900) );
  AND2X1 U796 ( .IN1(n1271), .IN2(n1327), .Q(n679) );
  AND2X1 U797 ( .IN1(n676), .IN2(n949), .Q(n1320) );
  AO21X1 U798 ( .IN1(n1322), .IN2(n677), .IN3(n1320), .Q(n678) );
  AO222X1 U799 ( .IN1(n679), .IN2(n1362), .IN3(n679), .IN4(n900), .IN5(n1362), 
        .IN6(n678), .Q(n680) );
  NOR2X0 U800 ( .IN1(n681), .IN2(n680), .QN(n685) );
  INVX0 U801 ( .INP(n1342), .ZN(n1331) );
  MUX21X1 U802 ( .IN1(n1370), .IN2(predictorSamp[17]), .S(inSamp[14]), .Q(n682) );
  NOR2X0 U803 ( .IN1(inSamp[13]), .IN2(n1399), .QN(n894) );
  NOR2X0 U804 ( .IN1(inSamp[12]), .IN2(n1383), .QN(n696) );
  NOR2X0 U805 ( .IN1(inSamp[11]), .IN2(n1398), .QN(n1307) );
  NOR2X0 U806 ( .IN1(inSamp[10]), .IN2(n1382), .QN(n1284) );
  NOR2X0 U807 ( .IN1(inSamp[9]), .IN2(n1397), .QN(n1259) );
  NOR2X0 U808 ( .IN1(inSamp[8]), .IN2(n1381), .QN(n714) );
  NOR2X0 U809 ( .IN1(inSamp[7]), .IN2(n1396), .QN(n913) );
  NOR2X0 U810 ( .IN1(inSamp[6]), .IN2(n1380), .QN(n734) );
  NOR2X0 U811 ( .IN1(inSamp[5]), .IN2(n1395), .QN(n932) );
  NOR2X0 U812 ( .IN1(inSamp[4]), .IN2(n1379), .QN(n752) );
  NOR2X0 U813 ( .IN1(inSamp[3]), .IN2(n1394), .QN(n952) );
  NOR2X0 U814 ( .IN1(inSamp[2]), .IN2(n1378), .QN(n771) );
  NOR2X0 U815 ( .IN1(inSamp[1]), .IN2(n1400), .QN(n791) );
  INVX0 U816 ( .INP(inSamp[0]), .ZN(n1242) );
  NOR2X0 U817 ( .IN1(predictorSamp[1]), .IN2(predictorSamp[0]), .QN(n968) );
  NAND2X0 U818 ( .IN1(n968), .IN2(n1388), .QN(n1241) );
  OA21X1 U819 ( .IN1(n791), .IN2(n795), .IN3(n790), .Q(n774) );
  NAND2X0 U820 ( .IN1(inSamp[2]), .IN2(n1378), .QN(n770) );
  OA21X1 U821 ( .IN1(n771), .IN2(n774), .IN3(n770), .Q(n955) );
  OA21X1 U822 ( .IN1(n952), .IN2(n955), .IN3(n951), .Q(n755) );
  NAND2X0 U823 ( .IN1(inSamp[4]), .IN2(n1379), .QN(n751) );
  OA21X1 U824 ( .IN1(n752), .IN2(n755), .IN3(n751), .Q(n935) );
  NAND2X0 U825 ( .IN1(inSamp[5]), .IN2(n1395), .QN(n931) );
  OA21X1 U826 ( .IN1(n932), .IN2(n935), .IN3(n931), .Q(n737) );
  NAND2X0 U827 ( .IN1(inSamp[6]), .IN2(n1380), .QN(n733) );
  OA21X1 U828 ( .IN1(n734), .IN2(n737), .IN3(n733), .Q(n916) );
  OA21X1 U829 ( .IN1(n913), .IN2(n916), .IN3(n912), .Q(n717) );
  NAND2X0 U830 ( .IN1(inSamp[8]), .IN2(n1381), .QN(n713) );
  OA21X1 U831 ( .IN1(n714), .IN2(n717), .IN3(n713), .Q(n1262) );
  OA21X1 U832 ( .IN1(n1259), .IN2(n1262), .IN3(n1258), .Q(n1287) );
  NAND2X0 U833 ( .IN1(inSamp[10]), .IN2(n1382), .QN(n1283) );
  OA21X1 U834 ( .IN1(n1284), .IN2(n1287), .IN3(n1283), .Q(n1310) );
  NAND2X0 U835 ( .IN1(inSamp[11]), .IN2(n1398), .QN(n1306) );
  OA21X1 U836 ( .IN1(n1307), .IN2(n1310), .IN3(n1306), .Q(n699) );
  NAND2X0 U837 ( .IN1(inSamp[12]), .IN2(n1383), .QN(n695) );
  OA21X1 U838 ( .IN1(n696), .IN2(n699), .IN3(n695), .Q(n897) );
  OAI21X1 U839 ( .IN1(n894), .IN2(n897), .IN3(n893), .QN(n1228) );
  XOR2X1 U840 ( .IN1(n682), .IN2(n1228), .Q(n683) );
  NAND2X0 U841 ( .IN1(n1331), .IN2(n683), .QN(n684) );
  NAND2X0 U842 ( .IN1(n685), .IN2(n684), .QN(n539) );
  MUX21X1 U843 ( .IN1(stepSize[13]), .IN2(n1372), .S(n686), .Q(n690) );
  MUX21X1 U844 ( .IN1(stepSize[12]), .IN2(n1366), .S(n687), .Q(n689) );
  OAI22X1 U845 ( .IN1(n1302), .IN2(n690), .IN3(n1314), .IN4(n689), .QN(n688)
         );
  OA21X1 U846 ( .IN1(n763), .IN2(n688), .IN3(sampDiff[15]), .Q(n694) );
  AND2X1 U847 ( .IN1(n1271), .IN2(n904), .Q(n692) );
  AO22X1 U848 ( .IN1(n949), .IN2(n690), .IN3(n1322), .IN4(n689), .Q(n691) );
  AO222X1 U849 ( .IN1(n692), .IN2(n1361), .IN3(n692), .IN4(n1294), .IN5(n1361), 
        .IN6(n691), .Q(n693) );
  NOR2X0 U850 ( .IN1(n694), .IN2(n693), .QN(n703) );
  INVX0 U851 ( .INP(n699), .ZN(n700) );
  INVX0 U852 ( .INP(n695), .ZN(n697) );
  NOR2X0 U853 ( .IN1(n697), .IN2(n696), .QN(n698) );
  MUX21X1 U854 ( .IN1(n700), .IN2(n699), .S(n698), .Q(n701) );
  NAND2X0 U855 ( .IN1(n1331), .IN2(n701), .QN(n702) );
  NAND2X0 U856 ( .IN1(n703), .IN2(n702), .QN(n541) );
  MUX21X1 U857 ( .IN1(stepSize[9]), .IN2(n1368), .S(n704), .Q(n708) );
  MUX21X1 U858 ( .IN1(stepSize[8]), .IN2(n1375), .S(n705), .Q(n707) );
  OAI22X1 U859 ( .IN1(n1302), .IN2(n708), .IN3(n1314), .IN4(n707), .QN(n706)
         );
  OA21X1 U860 ( .IN1(n763), .IN2(n706), .IN3(sampDiff[11]), .Q(n712) );
  AND2X1 U861 ( .IN1(n1271), .IN2(n1253), .Q(n710) );
  AO22X1 U862 ( .IN1(n949), .IN2(n708), .IN3(n1322), .IN4(n707), .Q(n709) );
  AO222X1 U863 ( .IN1(n710), .IN2(n1351), .IN3(n710), .IN4(n919), .IN5(n1351), 
        .IN6(n709), .Q(n711) );
  NOR2X0 U864 ( .IN1(n712), .IN2(n711), .QN(n721) );
  INVX0 U865 ( .INP(n717), .ZN(n718) );
  INVX0 U866 ( .INP(n713), .ZN(n715) );
  NOR2X0 U867 ( .IN1(n715), .IN2(n714), .QN(n716) );
  MUX21X1 U868 ( .IN1(n718), .IN2(n717), .S(n716), .Q(n719) );
  NAND2X0 U869 ( .IN1(n1331), .IN2(n719), .QN(n720) );
  INVX0 U870 ( .INP(n722), .ZN(n724) );
  NOR2X0 U871 ( .IN1(n724), .IN2(n723), .QN(n728) );
  MUX21X1 U872 ( .IN1(stepSize[6]), .IN2(n1377), .S(n725), .Q(n727) );
  OAI22X1 U873 ( .IN1(n1302), .IN2(n728), .IN3(n1314), .IN4(n727), .QN(n726)
         );
  OA21X1 U874 ( .IN1(n763), .IN2(n726), .IN3(sampDiff[9]), .Q(n732) );
  AND2X1 U875 ( .IN1(n1271), .IN2(n923), .Q(n730) );
  AO22X1 U876 ( .IN1(n949), .IN2(n728), .IN3(n1322), .IN4(n727), .Q(n729) );
  AO222X1 U877 ( .IN1(n730), .IN2(n1371), .IN3(n730), .IN4(n938), .IN5(n1371), 
        .IN6(n729), .Q(n731) );
  NOR2X0 U878 ( .IN1(n732), .IN2(n731), .QN(n741) );
  INVX0 U879 ( .INP(n737), .ZN(n738) );
  INVX0 U880 ( .INP(n733), .ZN(n735) );
  NOR2X0 U881 ( .IN1(n735), .IN2(n734), .QN(n736) );
  MUX21X1 U882 ( .IN1(n738), .IN2(n737), .S(n736), .Q(n739) );
  NAND2X0 U883 ( .IN1(n1331), .IN2(n739), .QN(n740) );
  NAND2X0 U884 ( .IN1(n741), .IN2(n740), .QN(n547) );
  MUX21X1 U885 ( .IN1(stepSize[5]), .IN2(n1376), .S(n742), .Q(n746) );
  MUX21X1 U886 ( .IN1(stepSize[4]), .IN2(n1392), .S(n743), .Q(n745) );
  OAI22X1 U887 ( .IN1(n1302), .IN2(n746), .IN3(n1314), .IN4(n745), .QN(n744)
         );
  OA21X1 U888 ( .IN1(n763), .IN2(n744), .IN3(sampDiff[7]), .Q(n750) );
  AND2X1 U889 ( .IN1(n1271), .IN2(n942), .Q(n748) );
  AO22X1 U890 ( .IN1(n949), .IN2(n746), .IN3(n1322), .IN4(n745), .Q(n747) );
  AO222X1 U891 ( .IN1(n748), .IN2(n1358), .IN3(n748), .IN4(n958), .IN5(n1358), 
        .IN6(n747), .Q(n749) );
  NOR2X0 U892 ( .IN1(n750), .IN2(n749), .QN(n759) );
  INVX0 U893 ( .INP(n755), .ZN(n756) );
  INVX0 U894 ( .INP(n751), .ZN(n753) );
  NOR2X0 U895 ( .IN1(n753), .IN2(n752), .QN(n754) );
  MUX21X1 U896 ( .IN1(n756), .IN2(n755), .S(n754), .Q(n757) );
  NAND2X0 U897 ( .IN1(n1331), .IN2(n757), .QN(n758) );
  NAND2X0 U898 ( .IN1(n759), .IN2(n758), .QN(n549) );
  MUX21X1 U899 ( .IN1(stepSize[3]), .IN2(n1393), .S(n760), .Q(n765) );
  MUX21X1 U900 ( .IN1(stepSize[2]), .IN2(n1391), .S(n761), .Q(n764) );
  OAI22X1 U901 ( .IN1(n1302), .IN2(n765), .IN3(n1314), .IN4(n764), .QN(n762)
         );
  OA21X1 U902 ( .IN1(n763), .IN2(n762), .IN3(sampDiff[5]), .Q(n769) );
  AND2X1 U903 ( .IN1(n1271), .IN2(n962), .Q(n767) );
  AO22X1 U904 ( .IN1(n949), .IN2(n765), .IN3(n1322), .IN4(n764), .Q(n766) );
  AO222X1 U905 ( .IN1(n767), .IN2(n1357), .IN3(n767), .IN4(n779), .IN5(n1357), 
        .IN6(n766), .Q(n768) );
  NOR2X0 U906 ( .IN1(n769), .IN2(n768), .QN(n778) );
  INVX0 U907 ( .INP(n774), .ZN(n775) );
  INVX0 U908 ( .INP(n770), .ZN(n772) );
  NOR2X0 U909 ( .IN1(n772), .IN2(n771), .QN(n773) );
  MUX21X1 U910 ( .IN1(n775), .IN2(n774), .S(n773), .Q(n776) );
  NAND2X0 U911 ( .IN1(n1331), .IN2(n776), .QN(n777) );
  NAND2X0 U912 ( .IN1(n778), .IN2(n777), .QN(n551) );
  OR2X1 U913 ( .IN1(n779), .IN2(n1325), .Q(n784) );
  MUX21X1 U914 ( .IN1(stepSize[2]), .IN2(n1391), .S(n780), .Q(n785) );
  INVX0 U915 ( .INP(n785), .ZN(n782) );
  AO221X1 U916 ( .IN1(n1239), .IN2(stepSize[1]), .IN3(n786), .IN4(n1384), 
        .IN5(n1314), .Q(n781) );
  OA21X1 U917 ( .IN1(n1302), .IN2(n782), .IN3(n781), .Q(n783) );
  AO222X1 U918 ( .IN1(sampDiff[4]), .IN2(n784), .IN3(sampDiff[4]), .IN4(n1234), 
        .IN5(n784), .IN6(n783), .Q(n799) );
  NOR2X0 U919 ( .IN1(n1340), .IN2(n785), .QN(n789) );
  AO221X1 U920 ( .IN1(n1239), .IN2(n1384), .IN3(n786), .IN4(stepSize[1]), 
        .IN5(n1314), .Q(n787) );
  NAND2X0 U921 ( .IN1(n1304), .IN2(n787), .QN(n788) );
  NOR2X0 U922 ( .IN1(n789), .IN2(n788), .QN(n797) );
  INVX0 U923 ( .INP(n795), .ZN(n794) );
  INVX0 U924 ( .INP(n790), .ZN(n792) );
  NOR2X0 U925 ( .IN1(n792), .IN2(n791), .QN(n793) );
  MUX21X1 U926 ( .IN1(n795), .IN2(n794), .S(n793), .Q(n796) );
  OA22X1 U927 ( .IN1(n797), .IN2(n1352), .IN3(n1342), .IN4(n796), .Q(n798) );
  NAND2X0 U928 ( .IN1(n799), .IN2(n798), .QN(n552) );
  OA22X1 U929 ( .IN1(stepSize[0]), .IN2(n1340), .IN3(n800), .IN4(n801), .Q(
        n805) );
  NAND2X0 U930 ( .IN1(n1204), .IN2(n801), .QN(n971) );
  OA22X1 U931 ( .IN1(sampDiff[2]), .IN2(n971), .IN3(n1340), .IN4(n1232), .Q(
        n802) );
  OA222X1 U932 ( .IN1(n1401), .IN2(n805), .IN3(n1401), .IN4(n804), .IN5(n803), 
        .IN6(n802), .Q(n808) );
  OR2X1 U933 ( .IN1(n1388), .IN2(n968), .Q(n806) );
  NAND3X0 U934 ( .IN1(n1331), .IN2(n1241), .IN3(n806), .QN(n807) );
  OA21X1 U935 ( .IN1(n1405), .IN2(n1355), .IN3(prePCM[2]), .Q(n816) );
  OA221X1 U936 ( .IN1(prePCM[1]), .IN2(n1355), .IN3(n1405), .IN4(prePCM[0]), 
        .IN5(prePCM[2]), .Q(n976) );
  NAND2X0 U937 ( .IN1(prePCM[2]), .IN2(prePCM[0]), .QN(n981) );
  NOR2X0 U938 ( .IN1(n1350), .IN2(prePCM[2]), .QN(n1344) );
  AOI21X1 U939 ( .IN1(outStepIndex[1]), .IN2(n981), .IN3(n1344), .QN(n975) );
  INVX0 U940 ( .INP(n817), .ZN(n812) );
  FADDX1 U941 ( .A(prePCM[2]), .B(n1349), .CI(n809), .CO(n810), .S(n817) );
  INVX0 U942 ( .INP(n810), .ZN(n811) );
  OA221X1 U943 ( .IN1(prePCM[2]), .IN2(n811), .IN3(n1389), .IN4(n810), .IN5(
        n1414), .Q(n978) );
  INVX0 U944 ( .INP(n1414), .ZN(n1345) );
  AO22X1 U945 ( .IN1(n812), .IN2(n978), .IN3(n1345), .IN4(outStepIndex[6]), 
        .Q(n523) );
  FADDX1 U946 ( .A(prePCM[2]), .B(n1348), .CI(n813), .CO(n814), .S(n818) );
  FADDX1 U947 ( .A(prePCM[2]), .B(n1359), .CI(n814), .CO(n809), .S(n980) );
  FADDX1 U948 ( .A(n1347), .B(n816), .CI(n815), .CO(n813), .S(n820) );
  AO221X1 U949 ( .IN1(n980), .IN2(n818), .IN3(n980), .IN4(n820), .IN5(n817), 
        .Q(n977) );
  NAND2X0 U950 ( .IN1(n818), .IN2(n977), .QN(n819) );
  AO22X1 U951 ( .IN1(outStepIndex[4]), .IN2(n1345), .IN3(n978), .IN4(n819), 
        .Q(n521) );
  AO22X1 U952 ( .IN1(outStepIndex[3]), .IN2(n1345), .IN3(n978), .IN4(n821), 
        .Q(n520) );
  XOR2X1 U953 ( .IN1(predictorSamp[18]), .IN2(prePCM[3]), .Q(n822) );
  XOR2X1 U954 ( .IN1(\DP_OP_36J1_122_5288/n2 ), .IN2(n822), .Q(n862) );
  INVX0 U955 ( .INP(n862), .ZN(n823) );
  NAND3X0 U956 ( .IN1(prePredSamp[18]), .IN2(n1414), .IN3(n823), .QN(n861) );
  OA21X1 U957 ( .IN1(prePredSamp[18]), .IN2(n823), .IN3(n1414), .Q(n858) );
  NAND2X0 U958 ( .IN1(n858), .IN2(prePredSamp[10]), .QN(n825) );
  NAND2X0 U959 ( .IN1(predictorSamp[10]), .IN2(n1345), .QN(n824) );
  NAND3X0 U960 ( .IN1(n861), .IN2(n825), .IN3(n824), .QN(n582) );
  NAND2X0 U961 ( .IN1(n858), .IN2(prePredSamp[11]), .QN(n827) );
  NAND2X0 U962 ( .IN1(predictorSamp[11]), .IN2(n1345), .QN(n826) );
  NAND3X0 U963 ( .IN1(n861), .IN2(n827), .IN3(n826), .QN(n583) );
  NAND2X0 U964 ( .IN1(n858), .IN2(prePredSamp[5]), .QN(n829) );
  NAND3X0 U965 ( .IN1(n861), .IN2(n829), .IN3(n828), .QN(n577) );
  NAND2X0 U966 ( .IN1(n858), .IN2(prePredSamp[8]), .QN(n831) );
  NAND2X0 U967 ( .IN1(predictorSamp[8]), .IN2(n1345), .QN(n830) );
  NAND3X0 U968 ( .IN1(n861), .IN2(n831), .IN3(n830), .QN(n580) );
  NAND2X0 U969 ( .IN1(predictorSamp[12]), .IN2(n1345), .QN(n832) );
  NAND3X0 U970 ( .IN1(n861), .IN2(n833), .IN3(n832), .QN(n584) );
  NAND2X0 U971 ( .IN1(n858), .IN2(prePredSamp[6]), .QN(n835) );
  NAND2X0 U972 ( .IN1(predictorSamp[6]), .IN2(n1345), .QN(n834) );
  NAND3X0 U973 ( .IN1(n861), .IN2(n835), .IN3(n834), .QN(n578) );
  NAND2X0 U974 ( .IN1(n858), .IN2(prePredSamp[7]), .QN(n837) );
  NAND2X0 U975 ( .IN1(predictorSamp[7]), .IN2(n1345), .QN(n836) );
  NAND3X0 U976 ( .IN1(n861), .IN2(n837), .IN3(n836), .QN(n579) );
  NAND2X0 U977 ( .IN1(n858), .IN2(prePredSamp[9]), .QN(n839) );
  NAND2X0 U978 ( .IN1(predictorSamp[9]), .IN2(n1345), .QN(n838) );
  NAND3X0 U979 ( .IN1(n861), .IN2(n839), .IN3(n838), .QN(n581) );
  NAND2X0 U980 ( .IN1(n858), .IN2(prePredSamp[17]), .QN(n841) );
  NAND2X0 U981 ( .IN1(predictorSamp[17]), .IN2(n1345), .QN(n840) );
  NAND3X0 U982 ( .IN1(n861), .IN2(n841), .IN3(n840), .QN(n592) );
  NAND2X0 U983 ( .IN1(n858), .IN2(prePredSamp[2]), .QN(n843) );
  NAND2X0 U984 ( .IN1(predictorSamp[2]), .IN2(n1345), .QN(n842) );
  NAND3X0 U985 ( .IN1(n861), .IN2(n843), .IN3(n842), .QN(n574) );
  NAND2X0 U986 ( .IN1(n858), .IN2(prePredSamp[3]), .QN(n845) );
  NAND2X0 U987 ( .IN1(predictorSamp[3]), .IN2(n1345), .QN(n844) );
  NAND3X0 U988 ( .IN1(n861), .IN2(n845), .IN3(n844), .QN(n575) );
  NAND2X0 U989 ( .IN1(n858), .IN2(prePredSamp[4]), .QN(n847) );
  NAND2X0 U990 ( .IN1(predictorSamp[4]), .IN2(n1345), .QN(n846) );
  NAND3X0 U991 ( .IN1(n861), .IN2(n847), .IN3(n846), .QN(n576) );
  NAND2X0 U992 ( .IN1(n858), .IN2(prePredSamp[1]), .QN(n849) );
  NAND2X0 U993 ( .IN1(predictorSamp[1]), .IN2(n1345), .QN(n848) );
  NAND3X0 U994 ( .IN1(n861), .IN2(n849), .IN3(n848), .QN(n573) );
  NAND2X0 U995 ( .IN1(n858), .IN2(prePredSamp[15]), .QN(n851) );
  NAND2X0 U996 ( .IN1(predictorSamp[15]), .IN2(n1345), .QN(n850) );
  NAND3X0 U997 ( .IN1(n861), .IN2(n851), .IN3(n850), .QN(n587) );
  NAND2X0 U998 ( .IN1(n858), .IN2(prePredSamp[0]), .QN(n853) );
  NAND2X0 U999 ( .IN1(predictorSamp[0]), .IN2(n1345), .QN(n852) );
  NAND3X0 U1000 ( .IN1(n861), .IN2(n853), .IN3(n852), .QN(n590) );
  NAND2X0 U1001 ( .IN1(n858), .IN2(prePredSamp[16]), .QN(n855) );
  NAND2X0 U1002 ( .IN1(predictorSamp[16]), .IN2(n1345), .QN(n854) );
  NAND3X0 U1003 ( .IN1(n855), .IN2(n861), .IN3(n854), .QN(n588) );
  NAND2X0 U1004 ( .IN1(n858), .IN2(prePredSamp[14]), .QN(n857) );
  NAND2X0 U1005 ( .IN1(predictorSamp[14]), .IN2(n1345), .QN(n856) );
  NAND3X0 U1006 ( .IN1(n861), .IN2(n857), .IN3(n856), .QN(n586) );
  NAND2X0 U1007 ( .IN1(n858), .IN2(prePredSamp[13]), .QN(n860) );
  NAND2X0 U1008 ( .IN1(predictorSamp[13]), .IN2(n1345), .QN(n859) );
  NAND3X0 U1009 ( .IN1(n861), .IN2(n860), .IN3(n859), .QN(n585) );
  XOR2X1 U1010 ( .IN1(prePCM[3]), .IN2(dequantSamp[18]), .Q(
        \DP_OP_36J1_122_5288/n25 ) );
  MUX21X1 U1011 ( .IN1(predictorSamp[18]), .IN2(n862), .S(n1414), .Q(n589) );
  NOR2X0 U1012 ( .IN1(n1208), .IN2(n535), .QN(n1025) );
  NOR2X0 U1013 ( .IN1(sampDiff[13]), .IN2(n1366), .QN(n881) );
  NOR2X0 U1014 ( .IN1(n1364), .IN2(stepSize[11]), .QN(n879) );
  NAND3X0 U1015 ( .IN1(sampDiff[11]), .IN2(n1360), .IN3(n863), .QN(n877) );
  AOI21X1 U1016 ( .IN1(stepSize[0]), .IN2(stepSize[1]), .IN3(n864), .QN(n865)
         );
  OAI22X1 U1017 ( .IN1(sampDiff[2]), .IN2(n1384), .IN3(sampDiff[1]), .IN4(n865), .QN(n866) );
  AO222X1 U1018 ( .IN1(stepSize[2]), .IN2(n1363), .IN3(stepSize[2]), .IN4(n866), .IN5(n1363), .IN6(n866), .Q(n867) );
  AO222X1 U1019 ( .IN1(stepSize[3]), .IN2(n1352), .IN3(stepSize[3]), .IN4(n867), .IN5(n1352), .IN6(n867), .Q(n868) );
  AO222X1 U1020 ( .IN1(stepSize[4]), .IN2(n868), .IN3(stepSize[4]), .IN4(n1357), .IN5(n868), .IN6(n1357), .Q(n869) );
  AO222X1 U1021 ( .IN1(stepSize[5]), .IN2(n1365), .IN3(stepSize[5]), .IN4(n869), .IN5(n1365), .IN6(n869), .Q(n870) );
  AO222X1 U1022 ( .IN1(stepSize[6]), .IN2(n870), .IN3(stepSize[6]), .IN4(n1358), .IN5(n870), .IN6(n1358), .Q(n871) );
  AO222X1 U1023 ( .IN1(stepSize[7]), .IN2(n1369), .IN3(stepSize[7]), .IN4(n871), .IN5(n1369), .IN6(n871), .Q(n872) );
  AO222X1 U1024 ( .IN1(stepSize[8]), .IN2(n872), .IN3(stepSize[8]), .IN4(n1371), .IN5(n872), .IN6(n1371), .Q(n874) );
  OR2X1 U1025 ( .IN1(stepSize[9]), .IN2(n874), .Q(n875) );
  AO22X1 U1026 ( .IN1(stepSize[11]), .IN2(n1364), .IN3(stepSize[10]), .IN4(
        n1351), .Q(n873) );
  AO221X1 U1027 ( .IN1(n875), .IN2(n1385), .IN3(n874), .IN4(stepSize[9]), 
        .IN5(n873), .Q(n876) );
  NAND2X0 U1028 ( .IN1(n877), .IN2(n876), .QN(n878) );
  NOR2X0 U1029 ( .IN1(n879), .IN2(n878), .QN(n880) );
  OA222X1 U1030 ( .IN1(n1386), .IN2(stepSize[12]), .IN3(n1353), .IN4(
        stepSize[13]), .IN5(n881), .IN6(n880), .Q(n883) );
  AO22X1 U1031 ( .IN1(stepSize[14]), .IN2(n1361), .IN3(stepSize[13]), .IN4(
        n1353), .Q(n882) );
  OA22X1 U1032 ( .IN1(stepSize[14]), .IN2(n1361), .IN3(n883), .IN4(n882), .Q(
        n884) );
  AND3X1 U1033 ( .IN1(n1374), .IN2(n885), .IN3(n884), .Q(n886) );
  NOR2X0 U1034 ( .IN1(n886), .IN2(n1338), .QN(n1337) );
  NOR2X0 U1035 ( .IN1(n1025), .IN2(n1202), .QN(n1203) );
  AO22X1 U1036 ( .IN1(n1203), .IN2(\C38/DATA2_16 ), .IN3(n1202), .IN4(
        dequantSamp[16]), .Q(n556) );
  AO22X1 U1037 ( .IN1(n1203), .IN2(\C38/DATA2_17 ), .IN3(n1202), .IN4(
        dequantSamp[17]), .Q(n555) );
  MUX21X1 U1038 ( .IN1(n888), .IN2(prePCM[2]), .S(n1205), .Q(n530) );
  XOR2X1 U1039 ( .IN1(\DP_OP_67J1_125_4341/n1 ), .IN2(dequantSamp[18]), .Q(
        n889) );
  AO22X1 U1040 ( .IN1(n1203), .IN2(n889), .IN3(n1202), .IN4(dequantSamp[18]), 
        .Q(n593) );
  INVX0 U1041 ( .INP(n1340), .ZN(n1207) );
  AO22X1 U1042 ( .IN1(n1208), .IN2(stepSize[13]), .IN3(stepSize[14]), .IN4(
        n1207), .Q(\C1/Z_16 ) );
  AO22X1 U1043 ( .IN1(n1203), .IN2(\C38/DATA2_15 ), .IN3(n1202), .IN4(
        dequantSamp[15]), .Q(n557) );
  MUX21X1 U1044 ( .IN1(prePCM[3]), .IN2(sampDiff[19]), .S(n1204), .Q(n554) );
  XOR2X1 U1045 ( .IN1(prePCM[3]), .IN2(\C38/DATA2_0 ), .Q(
        \DP_OP_36J1_122_5288/n43 ) );
  XOR2X1 U1046 ( .IN1(prePCM[3]), .IN2(dequantSamp[1]), .Q(
        \DP_OP_36J1_122_5288/n42 ) );
  XOR2X1 U1047 ( .IN1(prePCM[3]), .IN2(dequantSamp[2]), .Q(
        \DP_OP_36J1_122_5288/n41 ) );
  XOR2X1 U1048 ( .IN1(prePCM[3]), .IN2(dequantSamp[3]), .Q(
        \DP_OP_36J1_122_5288/n40 ) );
  XOR2X1 U1049 ( .IN1(prePCM[3]), .IN2(dequantSamp[4]), .Q(
        \DP_OP_36J1_122_5288/n39 ) );
  XOR2X1 U1050 ( .IN1(prePCM[3]), .IN2(dequantSamp[5]), .Q(
        \DP_OP_36J1_122_5288/n38 ) );
  XOR2X1 U1051 ( .IN1(prePCM[3]), .IN2(dequantSamp[6]), .Q(
        \DP_OP_36J1_122_5288/n37 ) );
  XOR2X1 U1052 ( .IN1(prePCM[3]), .IN2(dequantSamp[7]), .Q(
        \DP_OP_36J1_122_5288/n36 ) );
  XOR2X1 U1053 ( .IN1(prePCM[3]), .IN2(dequantSamp[8]), .Q(
        \DP_OP_36J1_122_5288/n35 ) );
  XOR2X1 U1054 ( .IN1(prePCM[3]), .IN2(dequantSamp[9]), .Q(
        \DP_OP_36J1_122_5288/n34 ) );
  XOR2X1 U1055 ( .IN1(prePCM[3]), .IN2(dequantSamp[10]), .Q(
        \DP_OP_36J1_122_5288/n33 ) );
  XOR2X1 U1056 ( .IN1(prePCM[3]), .IN2(dequantSamp[11]), .Q(
        \DP_OP_36J1_122_5288/n32 ) );
  XOR2X1 U1057 ( .IN1(prePCM[3]), .IN2(dequantSamp[12]), .Q(
        \DP_OP_36J1_122_5288/n31 ) );
  XOR2X1 U1058 ( .IN1(prePCM[3]), .IN2(dequantSamp[13]), .Q(
        \DP_OP_36J1_122_5288/n30 ) );
  XOR2X1 U1059 ( .IN1(prePCM[3]), .IN2(dequantSamp[14]), .Q(
        \DP_OP_36J1_122_5288/n29 ) );
  XOR2X1 U1060 ( .IN1(prePCM[3]), .IN2(dequantSamp[15]), .Q(
        \DP_OP_36J1_122_5288/n28 ) );
  XOR2X1 U1061 ( .IN1(prePCM[3]), .IN2(dequantSamp[16]), .Q(
        \DP_OP_36J1_122_5288/n27 ) );
  XOR2X1 U1062 ( .IN1(prePCM[3]), .IN2(dequantSamp[17]), .Q(
        \DP_OP_36J1_122_5288/n26 ) );
  MUX21X1 U1063 ( .IN1(n1404), .IN2(stepSize[14]), .S(n890), .Q(n902) );
  MUX21X1 U1064 ( .IN1(n1372), .IN2(stepSize[13]), .S(n891), .Q(n901) );
  AOI22X1 U1065 ( .IN1(n902), .IN2(n949), .IN3(n901), .IN4(n1322), .QN(n892)
         );
  AO21X1 U1066 ( .IN1(n892), .IN2(n1304), .IN3(n1374), .Q(n908) );
  INVX0 U1067 ( .INP(n897), .ZN(n898) );
  INVX0 U1068 ( .INP(n893), .ZN(n895) );
  NOR2X0 U1069 ( .IN1(n895), .IN2(n894), .QN(n896) );
  MUX21X1 U1070 ( .IN1(n898), .IN2(n897), .S(n896), .Q(n899) );
  NAND2X0 U1071 ( .IN1(n899), .IN2(n1331), .QN(n907) );
  OR2X1 U1072 ( .IN1(n900), .IN2(n1325), .Q(n905) );
  OA22X1 U1073 ( .IN1(n1302), .IN2(n902), .IN3(n1314), .IN4(n901), .Q(n903) );
  AO222X1 U1074 ( .IN1(sampDiff[16]), .IN2(n905), .IN3(sampDiff[16]), .IN4(
        n904), .IN5(n905), .IN6(n903), .Q(n906) );
  NAND3X0 U1075 ( .IN1(n908), .IN2(n907), .IN3(n906), .QN(n540) );
  MUX21X1 U1076 ( .IN1(n1390), .IN2(stepSize[7]), .S(n909), .Q(n920) );
  MUX21X1 U1077 ( .IN1(stepSize[8]), .IN2(n1375), .S(n910), .Q(n921) );
  AOI22X1 U1078 ( .IN1(n920), .IN2(n1322), .IN3(n949), .IN4(n921), .QN(n911)
         );
  AO21X1 U1079 ( .IN1(n911), .IN2(n1304), .IN3(n1385), .Q(n927) );
  INVX0 U1080 ( .INP(n916), .ZN(n917) );
  INVX0 U1081 ( .INP(n912), .ZN(n914) );
  NOR2X0 U1082 ( .IN1(n914), .IN2(n913), .QN(n915) );
  MUX21X1 U1083 ( .IN1(n917), .IN2(n916), .S(n915), .Q(n918) );
  NAND2X0 U1084 ( .IN1(n918), .IN2(n1331), .QN(n926) );
  OR2X1 U1085 ( .IN1(n919), .IN2(n1325), .Q(n924) );
  OA22X1 U1086 ( .IN1(n921), .IN2(n1302), .IN3(n1314), .IN4(n920), .Q(n922) );
  AO222X1 U1087 ( .IN1(sampDiff[10]), .IN2(n924), .IN3(sampDiff[10]), .IN4(
        n923), .IN5(n924), .IN6(n922), .Q(n925) );
  NAND3X0 U1088 ( .IN1(n927), .IN2(n926), .IN3(n925), .QN(n546) );
  MUX21X1 U1089 ( .IN1(n1377), .IN2(stepSize[6]), .S(n928), .Q(n939) );
  MUX21X1 U1090 ( .IN1(n1376), .IN2(stepSize[5]), .S(n929), .Q(n940) );
  AOI22X1 U1091 ( .IN1(n939), .IN2(n949), .IN3(n1322), .IN4(n940), .QN(n930)
         );
  AO21X1 U1092 ( .IN1(n930), .IN2(n1304), .IN3(n1369), .Q(n946) );
  INVX0 U1093 ( .INP(n935), .ZN(n936) );
  INVX0 U1094 ( .INP(n931), .ZN(n933) );
  NOR2X0 U1095 ( .IN1(n933), .IN2(n932), .QN(n934) );
  MUX21X1 U1096 ( .IN1(n936), .IN2(n935), .S(n934), .Q(n937) );
  OR2X1 U1097 ( .IN1(n938), .IN2(n1325), .Q(n943) );
  OA22X1 U1098 ( .IN1(n940), .IN2(n1314), .IN3(n1302), .IN4(n939), .Q(n941) );
  AO222X1 U1099 ( .IN1(sampDiff[8]), .IN2(n943), .IN3(sampDiff[8]), .IN4(n942), 
        .IN5(n943), .IN6(n941), .Q(n944) );
  NAND3X0 U1100 ( .IN1(n946), .IN2(n945), .IN3(n944), .QN(n548) );
  MUX21X1 U1101 ( .IN1(n1393), .IN2(stepSize[3]), .S(n947), .Q(n959) );
  MUX21X1 U1102 ( .IN1(n1392), .IN2(stepSize[4]), .S(n948), .Q(n960) );
  AOI22X1 U1103 ( .IN1(n959), .IN2(n1322), .IN3(n960), .IN4(n949), .QN(n950)
         );
  AO21X1 U1104 ( .IN1(n950), .IN2(n1304), .IN3(n1365), .Q(n966) );
  INVX0 U1105 ( .INP(n955), .ZN(n956) );
  INVX0 U1106 ( .INP(n951), .ZN(n953) );
  NOR2X0 U1107 ( .IN1(n953), .IN2(n952), .QN(n954) );
  MUX21X1 U1108 ( .IN1(n956), .IN2(n955), .S(n954), .Q(n957) );
  NAND2X0 U1109 ( .IN1(n957), .IN2(n1331), .QN(n965) );
  OR2X1 U1110 ( .IN1(n958), .IN2(n1325), .Q(n963) );
  OA22X1 U1111 ( .IN1(n1302), .IN2(n960), .IN3(n1314), .IN4(n959), .Q(n961) );
  AO222X1 U1112 ( .IN1(sampDiff[6]), .IN2(n963), .IN3(sampDiff[6]), .IN4(n962), 
        .IN5(n963), .IN6(n961), .Q(n964) );
  NAND3X0 U1113 ( .IN1(n966), .IN2(n965), .IN3(n964), .QN(n550) );
  INVX0 U1114 ( .INP(n1341), .ZN(n967) );
  NOR2X0 U1115 ( .IN1(n968), .IN2(n967), .QN(n970) );
  NAND2X0 U1116 ( .IN1(n970), .IN2(n969), .QN(n973) );
  AO21X1 U1117 ( .IN1(sampDiff[1]), .IN2(N173), .IN3(n971), .Q(n972) );
  NAND2X0 U1118 ( .IN1(n973), .IN2(n972), .QN(n974) );
  MUX21X1 U1119 ( .IN1(sampDiff[1]), .IN2(n974), .S(n1335), .Q(n532) );
  FADDX1 U1120 ( .A(n1356), .B(n976), .CI(n975), .CO(n815), .S(n979) );
  NAND2X0 U1121 ( .IN1(n978), .IN2(n977), .QN(n1343) );
  OAI22X1 U1122 ( .IN1(n1414), .IN2(n1356), .IN3(n979), .IN4(n1343), .QN(n519)
         );
  INVX0 U1123 ( .INP(n1338), .ZN(n1206) );
  AO22X1 U1124 ( .IN1(n1206), .IN2(stepSize[1]), .IN3(n1207), .IN4(stepSize[0]), .Q(\C1/Z_2 ) );
  MUX21X1 U1125 ( .IN1(prePCM[3]), .IN2(outPCM[3]), .S(n1345), .Q(n527) );
  MUX21X1 U1126 ( .IN1(prePCM[2]), .IN2(outPCM[2]), .S(n1345), .Q(n526) );
  MUX21X1 U1127 ( .IN1(prePCM[1]), .IN2(outPCM[1]), .S(n1345), .Q(n525) );
  MUX21X1 U1128 ( .IN1(prePCM[0]), .IN2(outPCM[0]), .S(n1345), .Q(n524) );
  OAI22X1 U1129 ( .IN1(n980), .IN2(n1343), .IN3(n1414), .IN4(n1359), .QN(n522)
         );
  INVX0 U1130 ( .INP(n1344), .ZN(n982) );
  MUX21X1 U1131 ( .IN1(outStepIndex[1]), .IN2(n1373), .S(n983), .Q(n984) );
  OAI22X1 U1132 ( .IN1(n1414), .IN2(n1373), .IN3(n1343), .IN4(n984), .QN(n518)
         );
  NAND2X0 U1133 ( .IN1(outStepIndex[1]), .IN2(outStepIndex[2]), .QN(n1130) );
  NOR2X0 U1134 ( .IN1(n1350), .IN2(n1130), .QN(n1076) );
  INVX0 U1135 ( .INP(n1076), .ZN(n1004) );
  NAND3X0 U1136 ( .IN1(outStepIndex[6]), .IN2(n1347), .IN3(n1348), .QN(n1129)
         );
  NOR2X0 U1137 ( .IN1(n1347), .IN2(n1349), .QN(n1113) );
  INVX0 U1138 ( .INP(n1113), .ZN(n1158) );
  NOR2X0 U1139 ( .IN1(n1130), .IN2(outStepIndex[0]), .QN(n1001) );
  INVX0 U1140 ( .INP(n1001), .ZN(n1157) );
  OA22X1 U1141 ( .IN1(n1004), .IN2(n1129), .IN3(n1158), .IN4(n1157), .Q(n1126)
         );
  NAND3X0 U1142 ( .IN1(outStepIndex[3]), .IN2(outStepIndex[4]), .IN3(
        outStepIndex[5]), .QN(n1140) );
  NAND2X0 U1143 ( .IN1(n1373), .IN2(outStepIndex[0]), .QN(n1091) );
  NOR2X0 U1144 ( .IN1(n1356), .IN2(n1091), .QN(n1159) );
  INVX0 U1145 ( .INP(n1159), .ZN(n1133) );
  NOR2X0 U1146 ( .IN1(outStepIndex[0]), .IN2(outStepIndex[1]), .QN(n1174) );
  NAND2X0 U1147 ( .IN1(outStepIndex[2]), .IN2(n1174), .QN(n1032) );
  NAND2X0 U1148 ( .IN1(n1348), .IN2(outStepIndex[5]), .QN(n1134) );
  NOR2X0 U1149 ( .IN1(n1347), .IN2(n1134), .QN(n1075) );
  INVX0 U1150 ( .INP(n1075), .ZN(n1188) );
  OA22X1 U1151 ( .IN1(n1140), .IN2(n1133), .IN3(n1032), .IN4(n1188), .Q(n986)
         );
  NOR2X0 U1152 ( .IN1(n1373), .IN2(outStepIndex[2]), .QN(n1087) );
  INVX0 U1153 ( .INP(n1087), .ZN(n1064) );
  NOR2X0 U1154 ( .IN1(n1350), .IN2(n1064), .QN(n1185) );
  INVX0 U1155 ( .INP(n1185), .ZN(n1114) );
  AO21X1 U1156 ( .IN1(n1188), .IN2(n1129), .IN3(n1114), .Q(n985) );
  NAND2X0 U1157 ( .IN1(outStepIndex[4]), .IN2(outStepIndex[6]), .QN(n1139) );
  INVX0 U1158 ( .INP(n1139), .ZN(n1160) );
  NAND2X0 U1159 ( .IN1(n1160), .IN2(n1001), .QN(n1181) );
  AND4X1 U1160 ( .IN1(n1126), .IN2(n986), .IN3(n985), .IN4(n1181), .Q(n1069)
         );
  NOR2X0 U1161 ( .IN1(n1188), .IN2(n1157), .QN(n1123) );
  NAND4X0 U1162 ( .IN1(outStepIndex[4]), .IN2(n1347), .IN3(n1359), .IN4(n1349), 
        .QN(n1104) );
  NOR2X0 U1163 ( .IN1(n1004), .IN2(n1104), .QN(n988) );
  INVX0 U1164 ( .INP(n1032), .ZN(n1150) );
  NOR2X0 U1165 ( .IN1(n1076), .IN2(n1150), .QN(n1156) );
  NOR2X0 U1166 ( .IN1(n1156), .IN2(n1158), .QN(n987) );
  OA22X1 U1167 ( .IN1(n1348), .IN2(n1158), .IN3(n1359), .IN4(n1349), .Q(n1042)
         );
  INVX0 U1168 ( .INP(n1042), .ZN(n1026) );
  NOR4X0 U1169 ( .IN1(n1123), .IN2(n988), .IN3(n987), .IN4(n1026), .QN(n1180)
         );
  NOR2X0 U1170 ( .IN1(outStepIndex[5]), .IN2(outStepIndex[6]), .QN(n1015) );
  NAND2X0 U1171 ( .IN1(outStepIndex[3]), .IN2(n1015), .QN(n1155) );
  NOR2X0 U1172 ( .IN1(n1348), .IN2(n1155), .QN(n1151) );
  OA21X1 U1173 ( .IN1(n1185), .IN2(n1174), .IN3(n1151), .Q(n997) );
  NAND2X0 U1174 ( .IN1(n1350), .IN2(n1087), .QN(n1115) );
  INVX0 U1175 ( .INP(n1115), .ZN(n1162) );
  NOR2X0 U1176 ( .IN1(n1162), .IN2(n1076), .QN(n989) );
  NOR2X0 U1177 ( .IN1(n989), .IN2(n1139), .QN(n996) );
  NOR2X0 U1178 ( .IN1(n989), .IN2(n1140), .QN(n990) );
  NOR2X0 U1179 ( .IN1(n1139), .IN2(n1114), .QN(n1006) );
  NOR2X0 U1180 ( .IN1(n1139), .IN2(n1032), .QN(n1090) );
  NOR2X0 U1181 ( .IN1(outStepIndex[1]), .IN2(outStepIndex[2]), .QN(n1071) );
  NAND2X0 U1182 ( .IN1(n1071), .IN2(n1350), .QN(n1103) );
  NOR2X0 U1183 ( .IN1(n1103), .IN2(n1158), .QN(n1008) );
  NOR4X0 U1184 ( .IN1(n990), .IN2(n1006), .IN3(n1090), .IN4(n1008), .QN(n1057)
         );
  INVX0 U1185 ( .INP(n1091), .ZN(n1191) );
  NOR2X0 U1186 ( .IN1(n1162), .IN2(n1191), .QN(n1000) );
  INVX0 U1187 ( .INP(n1151), .ZN(n1189) );
  INVX0 U1188 ( .INP(n1134), .ZN(n1187) );
  NAND2X0 U1189 ( .IN1(n1347), .IN2(n1187), .QN(n1132) );
  NAND2X0 U1190 ( .IN1(n1113), .IN2(n1159), .QN(n1039) );
  OA21X1 U1191 ( .IN1(n1129), .IN2(n1103), .IN3(n1039), .Q(n1171) );
  OA221X1 U1192 ( .IN1(n1132), .IN2(n1114), .IN3(n1132), .IN4(n1133), .IN5(
        n1171), .Q(n991) );
  OA21X1 U1193 ( .IN1(n1000), .IN2(n1189), .IN3(n991), .Q(n993) );
  NAND2X0 U1194 ( .IN1(n1071), .IN2(n1075), .QN(n992) );
  INVX0 U1195 ( .INP(n1103), .ZN(n1193) );
  NAND3X0 U1196 ( .IN1(outStepIndex[4]), .IN2(outStepIndex[5]), .IN3(n1347), 
        .QN(n1128) );
  INVX0 U1197 ( .INP(n1128), .ZN(n1161) );
  NAND2X0 U1198 ( .IN1(n1193), .IN2(n1161), .QN(n1083) );
  NAND4X0 U1199 ( .IN1(n1057), .IN2(n993), .IN3(n992), .IN4(n1083), .QN(n1110)
         );
  NAND2X0 U1200 ( .IN1(n1087), .IN2(n1161), .QN(n1052) );
  INVX0 U1201 ( .INP(n1132), .ZN(n1112) );
  INVX0 U1202 ( .INP(n1140), .ZN(n1167) );
  NAND2X0 U1203 ( .IN1(n1167), .IN2(n1150), .QN(n1095) );
  INVX0 U1204 ( .INP(n1129), .ZN(n1054) );
  NAND4X0 U1205 ( .IN1(n1052), .IN2(n1082), .IN3(n1095), .IN4(n994), .QN(n995)
         );
  NOR4X0 U1206 ( .IN1(n997), .IN2(n996), .IN3(n1110), .IN4(n995), .QN(n998) );
  NAND3X0 U1207 ( .IN1(n1069), .IN2(n1180), .IN3(n998), .QN(n599) );
  NOR2X0 U1208 ( .IN1(n1193), .IN2(n1159), .QN(n999) );
  OA22X1 U1209 ( .IN1(n1000), .IN2(n1132), .IN3(n999), .IN4(n1129), .Q(n1003)
         );
  NAND2X0 U1210 ( .IN1(n1167), .IN2(n1001), .QN(n1109) );
  NAND2X0 U1211 ( .IN1(n1150), .IN2(n1075), .QN(n1002) );
  AND3X1 U1212 ( .IN1(n1003), .IN2(n1109), .IN3(n1002), .Q(n1074) );
  NAND2X0 U1213 ( .IN1(outStepIndex[0]), .IN2(n1071), .QN(n1070) );
  OA22X1 U1214 ( .IN1(n1004), .IN2(n1189), .IN3(n1129), .IN4(n1070), .Q(n1014)
         );
  NOR2X0 U1215 ( .IN1(n1128), .IN2(n1070), .QN(n1122) );
  NAND2X0 U1216 ( .IN1(n1193), .IN2(n1112), .QN(n1108) );
  OA21X1 U1217 ( .IN1(n1133), .IN2(n1128), .IN3(n1108), .Q(n1078) );
  NOR2X0 U1218 ( .IN1(n1115), .IN2(n1128), .QN(n1005) );
  NOR2X0 U1219 ( .IN1(n1006), .IN2(n1005), .QN(n1101) );
  NOR2X0 U1220 ( .IN1(n1114), .IN2(n1129), .QN(n1007) );
  NOR2X0 U1221 ( .IN1(n1008), .IN2(n1007), .QN(n1034) );
  NAND3X0 U1222 ( .IN1(n1078), .IN2(n1101), .IN3(n1034), .QN(n1012) );
  INVX0 U1223 ( .INP(n1130), .ZN(n1077) );
  NOR2X0 U1224 ( .IN1(outStepIndex[4]), .IN2(n1155), .QN(n1186) );
  AO22X1 U1225 ( .IN1(n1077), .IN2(n1186), .IN3(n1160), .IN4(n1152), .Q(n1011)
         );
  INVX0 U1226 ( .INP(n1104), .ZN(n1173) );
  NAND3X0 U1227 ( .IN1(n1015), .IN2(n1347), .IN3(n1348), .QN(n1153) );
  INVX0 U1228 ( .INP(n1153), .ZN(n1184) );
  NOR2X0 U1229 ( .IN1(n1077), .IN2(n1159), .QN(n1031) );
  INVX0 U1230 ( .INP(n1031), .ZN(n1058) );
  AO22X1 U1231 ( .IN1(n1173), .IN2(n1009), .IN3(n1184), .IN4(n1058), .Q(n1010)
         );
  NOR4X0 U1232 ( .IN1(n1122), .IN2(n1012), .IN3(n1011), .IN4(n1010), .QN(n1013) );
  NAND4X0 U1233 ( .IN1(n1074), .IN2(n1014), .IN3(n1013), .IN4(n1039), .QN(
        n1143) );
  NAND3X0 U1234 ( .IN1(n1162), .IN2(outStepIndex[4]), .IN3(n1015), .QN(n1016)
         );
  OA221X1 U1235 ( .IN1(n1070), .IN2(n1140), .IN3(n1070), .IN4(n1153), .IN5(
        n1016), .Q(n1019) );
  INVX0 U1236 ( .INP(n1174), .ZN(n1154) );
  OA22X1 U1237 ( .IN1(n1154), .IN2(n1189), .IN3(n1032), .IN4(n1158), .Q(n1018)
         );
  NOR2X0 U1238 ( .IN1(n1087), .IN2(n1150), .QN(n1027) );
  INVX0 U1239 ( .INP(n1186), .ZN(n1131) );
  OA22X1 U1240 ( .IN1(n1027), .IN2(n1153), .IN3(n1133), .IN4(n1131), .Q(n1017)
         );
  NOR2X0 U1241 ( .IN1(n1115), .IN2(n1129), .QN(n1050) );
  INVX0 U1242 ( .INP(n1050), .ZN(n1118) );
  NAND4X0 U1243 ( .IN1(n1019), .IN2(n1018), .IN3(n1017), .IN4(n1118), .QN(
        n1021) );
  AO21X1 U1244 ( .IN1(n1162), .IN2(n1075), .IN3(n1026), .Q(n1121) );
  OA21X1 U1245 ( .IN1(n1158), .IN2(n1130), .IN3(n1107), .Q(n1036) );
  INVX0 U1246 ( .INP(n1036), .ZN(n1020) );
  OR4X1 U1247 ( .IN1(n1143), .IN2(n1021), .IN3(n1121), .IN4(n1020), .Q(n601)
         );
  NAND3X0 U1248 ( .IN1(predictorSamp[4]), .IN2(predictorSamp[2]), .IN3(
        predictorSamp[3]), .QN(n1221) );
  NOR2X0 U1249 ( .IN1(n1378), .IN2(n1221), .QN(n1220) );
  NOR2X0 U1250 ( .IN1(n1379), .IN2(n1219), .QN(n1218) );
  NAND2X0 U1251 ( .IN1(predictorSamp[8]), .IN2(n1218), .QN(n1217) );
  NOR2X0 U1252 ( .IN1(n1380), .IN2(n1217), .QN(n1216) );
  NAND2X0 U1253 ( .IN1(predictorSamp[10]), .IN2(n1216), .QN(n1215) );
  NOR2X0 U1254 ( .IN1(n1381), .IN2(n1215), .QN(n1214) );
  NAND2X0 U1255 ( .IN1(predictorSamp[12]), .IN2(n1214), .QN(n1213) );
  NOR2X0 U1256 ( .IN1(n1382), .IN2(n1213), .QN(n1212) );
  NOR2X0 U1257 ( .IN1(n1383), .IN2(n1211), .QN(n1210) );
  NAND2X0 U1258 ( .IN1(predictorSamp[16]), .IN2(n1210), .QN(n1209) );
  NOR2X0 U1259 ( .IN1(n1370), .IN2(n1209), .QN(n1022) );
  MUX21X1 U1260 ( .IN1(predictorSamp[18]), .IN2(n1402), .S(n1022), .Q(
        outPredictSamp[15]) );
  MUX21X1 U1261 ( .IN1(n1378), .IN2(predictorSamp[5]), .S(n1221), .Q(
        outPredictSamp[2]) );
  MUX21X1 U1262 ( .IN1(n1379), .IN2(predictorSamp[7]), .S(n1219), .Q(
        outPredictSamp[4]) );
  MUX21X1 U1263 ( .IN1(n1380), .IN2(predictorSamp[9]), .S(n1217), .Q(
        outPredictSamp[6]) );
  MUX21X1 U1264 ( .IN1(n1381), .IN2(predictorSamp[11]), .S(n1215), .Q(
        outPredictSamp[8]) );
  MUX21X1 U1265 ( .IN1(n1382), .IN2(predictorSamp[13]), .S(n1213), .Q(
        outPredictSamp[10]) );
  MUX21X1 U1266 ( .IN1(n1383), .IN2(predictorSamp[15]), .S(n1211), .Q(
        outPredictSamp[12]) );
  MUX21X1 U1267 ( .IN1(n1370), .IN2(predictorSamp[17]), .S(n1209), .Q(
        outPredictSamp[14]) );
  MUX21X1 U1268 ( .IN1(predictorSamp[2]), .IN2(n1388), .S(predictorSamp[3]), 
        .Q(outPredictSamp[0]) );
  NOR2X0 U1269 ( .IN1(n1338), .IN2(n1406), .QN(n1182) );
  AND2X1 U1270 ( .IN1(dequantSamp[1]), .IN2(n1182), .Q(n1387) );
  INVX0 U1271 ( .INP(inValid), .ZN(n1024) );
  AOI22X1 U1272 ( .IN1(n1025), .IN2(n1024), .IN3(n1023), .IN4(n1338), .QN(n537) );
  AO21X1 U1273 ( .IN1(n1103), .IN2(n1160), .IN3(n1026), .Q(n613) );
  AO222X1 U1274 ( .IN1(stepSize[14]), .IN2(n1204), .IN3(n1203), .IN4(
        \C38/DATA2_14 ), .IN5(n1202), .IN6(dequantSamp[14]), .Q(n558) );
  NOR2X0 U1275 ( .IN1(n1158), .IN2(n1027), .QN(n1029) );
  NAND3X0 U1276 ( .IN1(outStepIndex[0]), .IN2(outStepIndex[2]), .IN3(n1160), 
        .QN(n1094) );
  NOR2X0 U1277 ( .IN1(n1029), .IN2(n1028), .QN(n1030) );
  NAND4X0 U1278 ( .IN1(n1036), .IN2(n1030), .IN3(n1181), .IN4(n1039), .QN(n612) );
  AO222X1 U1279 ( .IN1(stepSize[13]), .IN2(n1204), .IN3(n1203), .IN4(
        \C38/DATA2_13 ), .IN5(n1202), .IN6(dequantSamp[13]), .Q(n559) );
  OA22X1 U1280 ( .IN1(n1156), .IN2(n1139), .IN3(n1031), .IN4(n1129), .Q(n1035)
         );
  NOR2X0 U1281 ( .IN1(n1032), .IN2(n1129), .QN(n1145) );
  INVX0 U1282 ( .INP(n1070), .ZN(n1086) );
  NAND2X0 U1283 ( .IN1(n1113), .IN2(n1086), .QN(n1037) );
  NAND2X0 U1284 ( .IN1(n1042), .IN2(n1037), .QN(n1144) );
  NOR2X0 U1285 ( .IN1(n1145), .IN2(n1144), .QN(n1033) );
  NAND4X0 U1286 ( .IN1(n1036), .IN2(n1035), .IN3(n1034), .IN4(n1033), .QN(n611) );
  AO222X1 U1287 ( .IN1(stepSize[12]), .IN2(n1204), .IN3(n1203), .IN4(
        \C38/DATA2_12 ), .IN5(n1202), .IN6(dequantSamp[12]), .Q(n560) );
  OA21X1 U1288 ( .IN1(n1158), .IN2(n1154), .IN3(n1037), .Q(n1038) );
  OA21X1 U1289 ( .IN1(n1356), .IN2(n1140), .IN3(n1038), .Q(n1040) );
  NAND4X0 U1290 ( .IN1(n1040), .IN2(n1039), .IN3(n1118), .IN4(n1181), .QN(
        n1081) );
  OA21X1 U1291 ( .IN1(n1076), .IN2(n1071), .IN3(n1054), .Q(n1041) );
  NOR2X0 U1292 ( .IN1(n1081), .IN2(n1041), .QN(n1044) );
  AO221X1 U1293 ( .IN1(n1139), .IN2(n1350), .IN3(n1139), .IN4(n1140), .IN5(
        n1064), .Q(n1043) );
  NAND4X0 U1294 ( .IN1(n1044), .IN2(n1043), .IN3(n1042), .IN4(n1107), .QN(n610) );
  AO222X1 U1295 ( .IN1(stepSize[11]), .IN2(n1204), .IN3(n1203), .IN4(
        \C38/DATA2_11 ), .IN5(n1202), .IN6(dequantSamp[11]), .Q(n561) );
  INVX0 U1296 ( .INP(n1144), .ZN(n1047) );
  NAND2X0 U1297 ( .IN1(n1054), .IN2(n1086), .QN(n1046) );
  AND4X1 U1298 ( .IN1(n1047), .IN2(n1046), .IN3(n1199), .IN4(n1045), .Q(n1061)
         );
  NAND2X0 U1299 ( .IN1(n1185), .IN2(n1113), .QN(n1106) );
  NOR2X0 U1300 ( .IN1(n1156), .IN2(n1128), .QN(n1049) );
  NOR2X0 U1301 ( .IN1(n1350), .IN2(n1373), .QN(n1172) );
  AO222X1 U1302 ( .IN1(n1152), .IN2(n1048), .IN3(n1172), .IN4(n1160), .IN5(
        n1167), .IN6(n1162), .Q(n1176) );
  NOR4X0 U1303 ( .IN1(n1090), .IN2(n1050), .IN3(n1049), .IN4(n1176), .QN(n1051) );
  NAND4X0 U1304 ( .IN1(n1061), .IN2(n1171), .IN3(n1106), .IN4(n1051), .QN(n609) );
  AO222X1 U1305 ( .IN1(stepSize[10]), .IN2(n1204), .IN3(n1203), .IN4(
        \C38/DATA2_10 ), .IN5(n1202), .IN6(dequantSamp[10]), .Q(n562) );
  INVX0 U1306 ( .INP(n1052), .ZN(n1053) );
  NOR2X0 U1307 ( .IN1(n1122), .IN2(n1053), .QN(n1056) );
  NAND3X0 U1308 ( .IN1(outStepIndex[1]), .IN2(n1054), .IN3(n1350), .QN(n1055)
         );
  NAND4X0 U1309 ( .IN1(n1057), .IN2(n1056), .IN3(n1055), .IN4(n1107), .QN(
        n1065) );
  AO21X1 U1310 ( .IN1(n1058), .IN2(n1075), .IN3(n1145), .Q(n1059) );
  NOR2X0 U1311 ( .IN1(n1065), .IN2(n1059), .QN(n1060) );
  NAND4X0 U1312 ( .IN1(n1061), .IN2(n1083), .IN3(n1060), .IN4(n1109), .QN(n605) );
  AO222X1 U1313 ( .IN1(stepSize[9]), .IN2(n1204), .IN3(n1203), .IN4(
        \C38/DATA2_9 ), .IN5(n1202), .IN6(dequantSamp[9]), .Q(n563) );
  NOR2X0 U1314 ( .IN1(n1130), .IN2(n1132), .QN(n1111) );
  AO22X1 U1315 ( .IN1(n1076), .IN2(n1161), .IN3(n1075), .IN4(n1086), .Q(n1062)
         );
  OR3X1 U1316 ( .IN1(n1111), .IN2(n1145), .IN3(n1062), .Q(n1164) );
  NOR2X0 U1317 ( .IN1(n1128), .IN2(n1157), .QN(n1063) );
  NOR2X0 U1318 ( .IN1(n1164), .IN2(n1063), .QN(n1068) );
  NAND2X0 U1319 ( .IN1(n1160), .IN2(n1086), .QN(n1119) );
  NOR2X0 U1320 ( .IN1(n1064), .IN2(n1158), .QN(n1138) );
  NOR2X0 U1321 ( .IN1(n1103), .IN2(n1188), .QN(n1066) );
  NOR4X0 U1322 ( .IN1(n1138), .IN2(n1066), .IN3(n1065), .IN4(n1121), .QN(n1067) );
  NAND4X0 U1323 ( .IN1(n1069), .IN2(n1068), .IN3(n1119), .IN4(n1067), .QN(n604) );
  AO222X1 U1324 ( .IN1(stepSize[8]), .IN2(n1204), .IN3(n1203), .IN4(
        \C38/DATA2_8 ), .IN5(n1202), .IN6(dequantSamp[8]), .Q(n564) );
  AOI22X1 U1325 ( .IN1(n1185), .IN2(n1187), .IN3(n1161), .IN4(n1172), .QN(
        n1085) );
  OA22X1 U1326 ( .IN1(n1115), .IN2(n1158), .IN3(n1140), .IN4(n1070), .Q(n1073)
         );
  NAND2X0 U1327 ( .IN1(n1160), .IN2(n1071), .QN(n1072) );
  NAND3X0 U1328 ( .IN1(n1074), .IN2(n1073), .IN3(n1072), .QN(n1097) );
  NAND2X0 U1329 ( .IN1(n1076), .IN2(n1075), .QN(n1117) );
  NAND2X0 U1330 ( .IN1(n1077), .IN2(n1151), .QN(n1079) );
  NAND3X0 U1331 ( .IN1(n1117), .IN2(n1079), .IN3(n1078), .QN(n1080) );
  NOR4X0 U1332 ( .IN1(n1121), .IN2(n1097), .IN3(n1081), .IN4(n1080), .QN(n1084) );
  NAND4X0 U1333 ( .IN1(n1085), .IN2(n1084), .IN3(n1083), .IN4(n1082), .QN(n603) );
  AO222X1 U1334 ( .IN1(stepSize[7]), .IN2(n1204), .IN3(n1203), .IN4(
        \C38/DATA2_7 ), .IN5(n1202), .IN6(dequantSamp[7]), .Q(n565) );
  AO222X1 U1335 ( .IN1(stepSize[6]), .IN2(n1204), .IN3(n1203), .IN4(
        \C38/DATA2_6 ), .IN5(n1202), .IN6(dequantSamp[6]), .Q(n566) );
  NOR2X0 U1336 ( .IN1(n1114), .IN2(n1189), .QN(n1089) );
  OA21X1 U1337 ( .IN1(n1087), .IN2(n1086), .IN3(n1173), .Q(n1088) );
  NOR4X0 U1338 ( .IN1(n1090), .IN2(n1089), .IN3(n1088), .IN4(n1144), .QN(n1201) );
  NOR2X0 U1339 ( .IN1(n1174), .IN2(n1152), .QN(n1092) );
  OA22X1 U1340 ( .IN1(n1092), .IN2(n1104), .IN3(n1091), .IN4(n1188), .Q(n1102)
         );
  NOR2X0 U1341 ( .IN1(n1156), .IN2(n1132), .QN(n1099) );
  NOR3X0 U1342 ( .IN1(n1356), .IN2(n1189), .IN3(outStepIndex[1]), .QN(n1098)
         );
  NAND2X0 U1343 ( .IN1(n1150), .IN2(n1161), .QN(n1093) );
  NAND4X0 U1344 ( .IN1(n1118), .IN2(n1095), .IN3(n1094), .IN4(n1093), .QN(
        n1096) );
  NOR4X0 U1345 ( .IN1(n1099), .IN2(n1098), .IN3(n1097), .IN4(n1096), .QN(n1100) );
  NAND4X0 U1346 ( .IN1(n1201), .IN2(n1102), .IN3(n1101), .IN4(n1100), .QN(n602) );
  AO222X1 U1347 ( .IN1(stepSize[5]), .IN2(n1204), .IN3(n1203), .IN4(
        \C38/DATA2_5 ), .IN5(n1202), .IN6(dequantSamp[5]), .Q(n567) );
  NOR2X0 U1348 ( .IN1(n1150), .IN2(n1152), .QN(n1105) );
  OA22X1 U1349 ( .IN1(n1105), .IN2(n1104), .IN3(n1140), .IN4(n1103), .Q(n1127)
         );
  NAND4X0 U1350 ( .IN1(n1109), .IN2(n1108), .IN3(n1107), .IN4(n1106), .QN(
        n1195) );
  NOR4X0 U1351 ( .IN1(n1111), .IN2(n1186), .IN3(n1110), .IN4(n1195), .QN(n1125) );
  NOR2X0 U1352 ( .IN1(n1113), .IN2(n1112), .QN(n1116) );
  OA22X1 U1353 ( .IN1(n1116), .IN2(n1115), .IN3(n1140), .IN4(n1114), .Q(n1120)
         );
  NAND4X0 U1354 ( .IN1(n1120), .IN2(n1119), .IN3(n1118), .IN4(n1117), .QN(
        n1177) );
  NOR4X0 U1355 ( .IN1(n1123), .IN2(n1122), .IN3(n1121), .IN4(n1177), .QN(n1124) );
  NAND4X0 U1356 ( .IN1(n1127), .IN2(n1126), .IN3(n1125), .IN4(n1124), .QN(n608) );
  AO222X1 U1357 ( .IN1(stepSize[4]), .IN2(n1204), .IN3(n1203), .IN4(
        \C38/DATA2_4 ), .IN5(n1202), .IN6(dequantSamp[4]), .Q(n568) );
  AO222X1 U1358 ( .IN1(stepSize[3]), .IN2(n1204), .IN3(n1203), .IN4(
        \C38/DATA2_3 ), .IN5(n1202), .IN6(dequantSamp[3]), .Q(n569) );
  OA22X1 U1359 ( .IN1(n1130), .IN2(n1129), .IN3(n1154), .IN4(n1128), .Q(n1149)
         );
  NAND2X0 U1360 ( .IN1(n1132), .IN2(n1131), .QN(n1190) );
  NOR2X0 U1361 ( .IN1(n1189), .IN2(n1133), .QN(n1137) );
  NOR2X0 U1362 ( .IN1(n1134), .IN2(n1157), .QN(n1136) );
  AO22X1 U1363 ( .IN1(n1185), .IN2(n1186), .IN3(n1191), .IN4(n1173), .Q(n1135)
         );
  NOR4X0 U1364 ( .IN1(n1138), .IN2(n1137), .IN3(n1136), .IN4(n1135), .QN(n1147) );
  AO22X1 U1365 ( .IN1(n1162), .IN2(n1141), .IN3(n1193), .IN4(n1184), .Q(n1142)
         );
  NOR4X0 U1366 ( .IN1(n1145), .IN2(n1144), .IN3(n1143), .IN4(n1142), .QN(n1146) );
  NAND4X0 U1367 ( .IN1(n1149), .IN2(n1148), .IN3(n1147), .IN4(n1146), .QN(n600) );
  AO222X1 U1368 ( .IN1(stepSize[2]), .IN2(n1204), .IN3(n1203), .IN4(
        \C38/DATA2_2 ), .IN5(n1202), .IN6(dequantSamp[2]), .Q(n570) );
  AOI22X1 U1369 ( .IN1(n1152), .IN2(n1151), .IN3(n1150), .IN4(n1187), .QN(
        n1179) );
  OA22X1 U1370 ( .IN1(n1156), .IN2(n1155), .IN3(n1154), .IN4(n1153), .Q(n1170)
         );
  NOR2X0 U1371 ( .IN1(n1158), .IN2(n1157), .QN(n1166) );
  OA21X1 U1372 ( .IN1(n1160), .IN2(n1173), .IN3(n1159), .Q(n1165) );
  AO22X1 U1373 ( .IN1(n1162), .IN2(n1186), .IN3(n1185), .IN4(n1161), .Q(n1163)
         );
  NOR4X0 U1374 ( .IN1(n1166), .IN2(n1165), .IN3(n1164), .IN4(n1163), .QN(n1169) );
  NAND2X0 U1375 ( .IN1(n1167), .IN2(n1191), .QN(n1168) );
  NAND4X0 U1376 ( .IN1(n1171), .IN2(n1170), .IN3(n1169), .IN4(n1168), .QN(
        n1196) );
  AO22X1 U1377 ( .IN1(n1174), .IN2(n1173), .IN3(n1184), .IN4(n1172), .Q(n1175)
         );
  NOR4X0 U1378 ( .IN1(n1177), .IN2(n1196), .IN3(n1176), .IN4(n1175), .QN(n1178) );
  NAND4X0 U1379 ( .IN1(n1181), .IN2(n1180), .IN3(n1179), .IN4(n1178), .QN(n607) );
  XOR2X1 U1380 ( .IN1(dequantSamp[1]), .IN2(n1182), .Q(n1183) );
  AO222X1 U1381 ( .IN1(stepSize[1]), .IN2(n1204), .IN3(n1203), .IN4(n1183), 
        .IN5(n1202), .IN6(dequantSamp[1]), .Q(n571) );
  NAND2X0 U1382 ( .IN1(n1184), .IN2(n1350), .QN(n1200) );
  OA21X1 U1383 ( .IN1(n1187), .IN2(n1186), .IN3(n1185), .Q(n1197) );
  AO22X1 U1384 ( .IN1(n1193), .IN2(n1192), .IN3(n1191), .IN4(n1190), .Q(n1194)
         );
  NOR4X0 U1385 ( .IN1(n1197), .IN2(n1196), .IN3(n1195), .IN4(n1194), .QN(n1198) );
  NAND4X0 U1386 ( .IN1(n1201), .IN2(n1200), .IN3(n1199), .IN4(n1198), .QN(n606) );
  AO222X1 U1387 ( .IN1(stepSize[0]), .IN2(n1204), .IN3(n1203), .IN4(
        \C38/DATA2_0 ), .IN5(n1202), .IN6(\C38/DATA2_0 ), .Q(n572) );
  NOR2X0 U1388 ( .IN1(n1205), .IN2(n1404), .QN(\C1/Z_17 ) );
  AO222X1 U1389 ( .IN1(n1208), .IN2(stepSize[12]), .IN3(n1206), .IN4(
        stepSize[14]), .IN5(n1207), .IN6(stepSize[13]), .Q(\C1/Z_15 ) );
  AO222X1 U1390 ( .IN1(n1208), .IN2(stepSize[11]), .IN3(n1206), .IN4(
        stepSize[13]), .IN5(n1207), .IN6(stepSize[12]), .Q(\C1/Z_14 ) );
  AO222X1 U1391 ( .IN1(n1208), .IN2(stepSize[10]), .IN3(n1206), .IN4(
        stepSize[12]), .IN5(stepSize[11]), .IN6(n1207), .Q(\C1/Z_13 ) );
  AO222X1 U1392 ( .IN1(n1208), .IN2(stepSize[9]), .IN3(n1207), .IN4(
        stepSize[10]), .IN5(stepSize[11]), .IN6(n1206), .Q(\C1/Z_12 ) );
  AO222X1 U1393 ( .IN1(n1208), .IN2(stepSize[8]), .IN3(n1207), .IN4(
        stepSize[9]), .IN5(stepSize[10]), .IN6(n1206), .Q(\C1/Z_11 ) );
  AO222X1 U1394 ( .IN1(n1208), .IN2(stepSize[7]), .IN3(n1207), .IN4(
        stepSize[8]), .IN5(stepSize[9]), .IN6(n1206), .Q(\C1/Z_10 ) );
  AO222X1 U1395 ( .IN1(n1208), .IN2(stepSize[6]), .IN3(n1207), .IN4(
        stepSize[7]), .IN5(stepSize[8]), .IN6(n1206), .Q(\C1/Z_9 ) );
  AO222X1 U1396 ( .IN1(n1208), .IN2(stepSize[5]), .IN3(n1207), .IN4(
        stepSize[6]), .IN5(stepSize[7]), .IN6(n1206), .Q(\C1/Z_8 ) );
  AO222X1 U1397 ( .IN1(n1208), .IN2(stepSize[4]), .IN3(n1207), .IN4(
        stepSize[5]), .IN5(stepSize[6]), .IN6(n1206), .Q(\C1/Z_7 ) );
  AO222X1 U1398 ( .IN1(n1208), .IN2(stepSize[3]), .IN3(n1207), .IN4(
        stepSize[4]), .IN5(stepSize[5]), .IN6(n1206), .Q(\C1/Z_6 ) );
  AO222X1 U1399 ( .IN1(n1208), .IN2(stepSize[2]), .IN3(n1207), .IN4(
        stepSize[3]), .IN5(stepSize[4]), .IN6(n1206), .Q(\C1/Z_5 ) );
  AO222X1 U1400 ( .IN1(n1208), .IN2(stepSize[1]), .IN3(n1207), .IN4(
        stepSize[2]), .IN5(stepSize[3]), .IN6(n1206), .Q(\C1/Z_4 ) );
  AO222X1 U1401 ( .IN1(n1208), .IN2(stepSize[0]), .IN3(n1207), .IN4(
        stepSize[1]), .IN5(stepSize[2]), .IN6(n1206), .Q(\C1/Z_3 ) );
  OA21X1 U1402 ( .IN1(predictorSamp[16]), .IN2(n1210), .IN3(n1209), .Q(
        outPredictSamp[13]) );
  OA21X1 U1403 ( .IN1(predictorSamp[14]), .IN2(n1212), .IN3(n1211), .Q(
        outPredictSamp[11]) );
  OA21X1 U1404 ( .IN1(predictorSamp[12]), .IN2(n1214), .IN3(n1213), .Q(
        outPredictSamp[9]) );
  OA21X1 U1405 ( .IN1(predictorSamp[10]), .IN2(n1216), .IN3(n1215), .Q(
        outPredictSamp[7]) );
  OA21X1 U1406 ( .IN1(predictorSamp[8]), .IN2(n1218), .IN3(n1217), .Q(
        outPredictSamp[5]) );
  OA21X1 U1407 ( .IN1(predictorSamp[6]), .IN2(n1220), .IN3(n1219), .Q(
        outPredictSamp[3]) );
  AND2X1 U1408 ( .IN1(predictorSamp[2]), .IN2(predictorSamp[3]), .Q(n1222) );
  OA21X1 U1409 ( .IN1(predictorSamp[4]), .IN2(n1222), .IN3(n1221), .Q(
        outPredictSamp[1]) );
  OA22X1 U1410 ( .IN1(n1224), .IN2(n1223), .IN3(stepSize[14]), .IN4(n1362), 
        .Q(n1321) );
  OA22X1 U1411 ( .IN1(n1321), .IN2(n1314), .IN3(n1362), .IN4(n1302), .Q(n1225)
         );
  NOR2X0 U1412 ( .IN1(sampDiff[18]), .IN2(n1327), .QN(n1326) );
  AO22X1 U1413 ( .IN1(sampDiff[18]), .IN2(n1227), .IN3(n1271), .IN4(n1326), 
        .Q(n1231) );
  INVX0 U1414 ( .INP(inSamp[15]), .ZN(n1324) );
  AO222X1 U1415 ( .IN1(inSamp[14]), .IN2(n1370), .IN3(inSamp[14]), .IN4(n1228), 
        .IN5(n1370), .IN6(n1228), .Q(n1323) );
  NOR2X0 U1416 ( .IN1(n1229), .IN2(n1342), .QN(n1230) );
  AO221X1 U1417 ( .IN1(sampDiff[19]), .IN2(n1334), .IN3(sampDiff[19]), .IN4(
        n1231), .IN5(n1230), .Q(n591) );
  MUX21X1 U1418 ( .IN1(n1384), .IN2(stepSize[1]), .S(n1232), .Q(n1233) );
  OA22X1 U1419 ( .IN1(stepSize[0]), .IN2(n1314), .IN3(n1233), .IN4(n1302), .Q(
        n1238) );
  INVX0 U1420 ( .INP(n1233), .ZN(n1236) );
  OA21X1 U1421 ( .IN1(n1302), .IN2(n1236), .IN3(n1235), .Q(n1237) );
  OA222X1 U1422 ( .IN1(n1363), .IN2(n1238), .IN3(n1363), .IN4(n1304), .IN5(
        sampDiff[3]), .IN6(n1237), .Q(n1247) );
  NAND3X0 U1423 ( .IN1(sampDiff[3]), .IN2(n1271), .IN3(n1240), .QN(n1245) );
  FADDX1 U1424 ( .A(predictorSamp[3]), .B(n1242), .CI(n1241), .CO(n795), .S(
        n1243) );
  OR2X1 U1425 ( .IN1(n1243), .IN2(n1342), .Q(n1244) );
  NAND4X0 U1426 ( .IN1(n1247), .IN2(n1246), .IN3(n1245), .IN4(n1244), .QN(n553) );
  INVX0 U1427 ( .INP(n1248), .ZN(n1276) );
  NAND2X0 U1428 ( .IN1(n1276), .IN2(n1271), .QN(n1254) );
  MUX21X1 U1429 ( .IN1(stepSize[10]), .IN2(n1360), .S(n1249), .Q(n1256) );
  INVX0 U1430 ( .INP(n1256), .ZN(n1251) );
  MUX21X1 U1431 ( .IN1(n1368), .IN2(stepSize[9]), .S(n1265), .Q(n1250) );
  OA22X1 U1432 ( .IN1(n1302), .IN2(n1251), .IN3(n1314), .IN4(n1250), .Q(n1252)
         );
  AO222X1 U1433 ( .IN1(sampDiff[12]), .IN2(n1254), .IN3(sampDiff[12]), .IN4(
        n1253), .IN5(n1254), .IN6(n1252), .Q(n1270) );
  OA22X1 U1434 ( .IN1(n1256), .IN2(n1302), .IN3(n1314), .IN4(n1255), .Q(n1257)
         );
  AO21X1 U1435 ( .IN1(n1257), .IN2(n1304), .IN3(n1364), .Q(n1269) );
  INVX0 U1436 ( .INP(n1262), .ZN(n1263) );
  INVX0 U1437 ( .INP(n1258), .ZN(n1260) );
  NOR2X0 U1438 ( .IN1(n1260), .IN2(n1259), .QN(n1261) );
  MUX21X1 U1439 ( .IN1(n1263), .IN2(n1262), .S(n1261), .Q(n1264) );
  NAND2X0 U1440 ( .IN1(n1331), .IN2(n1264), .QN(n1268) );
  OR3X1 U1441 ( .IN1(n1266), .IN2(n1314), .IN3(n1265), .Q(n1267) );
  NAND4X0 U1442 ( .IN1(n1270), .IN2(n1269), .IN3(n1268), .IN4(n1267), .QN(n544) );
  NAND2X0 U1443 ( .IN1(n1271), .IN2(n1299), .QN(n1277) );
  MUX21X1 U1444 ( .IN1(stepSize[11]), .IN2(n1367), .S(n1272), .Q(n1279) );
  INVX0 U1445 ( .INP(n1279), .ZN(n1274) );
  MUX21X1 U1446 ( .IN1(n1360), .IN2(stepSize[10]), .S(n1281), .Q(n1273) );
  OA22X1 U1447 ( .IN1(n1274), .IN2(n1302), .IN3(n1314), .IN4(n1273), .Q(n1275)
         );
  AO222X1 U1448 ( .IN1(sampDiff[13]), .IN2(n1277), .IN3(sampDiff[13]), .IN4(
        n1276), .IN5(n1277), .IN6(n1275), .Q(n1293) );
  OA22X1 U1449 ( .IN1(n1302), .IN2(n1279), .IN3(n1314), .IN4(n1278), .Q(n1280)
         );
  AO21X1 U1450 ( .IN1(n1280), .IN2(n1304), .IN3(n1386), .Q(n1292) );
  OR3X1 U1451 ( .IN1(n1282), .IN2(n1314), .IN3(n1281), .Q(n1291) );
  INVX0 U1452 ( .INP(n1287), .ZN(n1288) );
  INVX0 U1453 ( .INP(n1283), .ZN(n1285) );
  NOR2X0 U1454 ( .IN1(n1285), .IN2(n1284), .QN(n1286) );
  MUX21X1 U1455 ( .IN1(n1288), .IN2(n1287), .S(n1286), .Q(n1289) );
  NAND2X0 U1456 ( .IN1(n1331), .IN2(n1289), .QN(n1290) );
  NAND4X0 U1457 ( .IN1(n1293), .IN2(n1292), .IN3(n1291), .IN4(n1290), .QN(n543) );
  OR2X1 U1458 ( .IN1(n1294), .IN2(n1325), .Q(n1300) );
  MUX21X1 U1459 ( .IN1(stepSize[12]), .IN2(n1366), .S(n1295), .Q(n1303) );
  INVX0 U1460 ( .INP(n1303), .ZN(n1297) );
  MUX21X1 U1461 ( .IN1(n1367), .IN2(stepSize[11]), .S(n1313), .Q(n1296) );
  OA22X1 U1462 ( .IN1(n1302), .IN2(n1297), .IN3(n1314), .IN4(n1296), .Q(n1298)
         );
  AO222X1 U1463 ( .IN1(sampDiff[14]), .IN2(n1300), .IN3(sampDiff[14]), .IN4(
        n1299), .IN5(n1300), .IN6(n1298), .Q(n1319) );
  NAND2X0 U1464 ( .IN1(stepSize[11]), .IN2(n1313), .QN(n1301) );
  OA22X1 U1465 ( .IN1(n1303), .IN2(n1302), .IN3(n1314), .IN4(n1301), .Q(n1305)
         );
  AO21X1 U1466 ( .IN1(n1305), .IN2(n1304), .IN3(n1353), .Q(n1318) );
  INVX0 U1467 ( .INP(n1310), .ZN(n1311) );
  INVX0 U1468 ( .INP(n1306), .ZN(n1308) );
  NOR2X0 U1469 ( .IN1(n1308), .IN2(n1307), .QN(n1309) );
  MUX21X1 U1470 ( .IN1(n1311), .IN2(n1310), .S(n1309), .Q(n1312) );
  OR3X1 U1471 ( .IN1(n1315), .IN2(n1314), .IN3(n1313), .Q(n1316) );
  NAND4X0 U1472 ( .IN1(n1319), .IN2(n1318), .IN3(n1317), .IN4(n1316), .QN(n542) );
  AO22X1 U1473 ( .IN1(n1322), .IN2(n1321), .IN3(n1320), .IN4(n1362), .Q(n1333)
         );
  FADDX1 U1474 ( .A(n1324), .B(predictorSamp[18]), .CI(n1323), .CO(n1229), .S(
        n1330) );
  NOR2X0 U1475 ( .IN1(n1326), .IN2(n1325), .QN(n1329) );
  NAND2X0 U1476 ( .IN1(sampDiff[18]), .IN2(n1327), .QN(n1328) );
  AO22X1 U1477 ( .IN1(n1331), .IN2(n1330), .IN3(n1329), .IN4(n1328), .Q(n1332)
         );
  AO221X1 U1478 ( .IN1(sampDiff[18]), .IN2(n1334), .IN3(n1407), .IN4(n1333), 
        .IN5(n1332), .Q(n538) );
  AND3X1 U1479 ( .IN1(n1341), .IN2(predictorSamp[0]), .IN3(n1335), .Q(n1336)
         );
  AO21X1 U1480 ( .IN1(N173), .IN2(n1342), .IN3(n1336), .Q(n533) );
  AO21X1 U1481 ( .IN1(prePCM[0]), .IN2(n1338), .IN3(n1337), .Q(n531) );
  AO21X1 U1482 ( .IN1(prePCM[1]), .IN2(n1340), .IN3(n1339), .Q(n529) );
  AO221X1 U1483 ( .IN1(n1342), .IN2(n1341), .IN3(n1342), .IN4(inReady), .IN5(
        n1414), .Q(n528) );
  NOR2X0 U1484 ( .IN1(n1344), .IN2(n1343), .QN(n1346) );
  AO222X1 U1485 ( .IN1(outStepIndex[0]), .IN2(n1346), .IN3(outStepIndex[0]), 
        .IN4(n1345), .IN5(n1346), .IN6(n1389), .Q(n517) );
endmodule

