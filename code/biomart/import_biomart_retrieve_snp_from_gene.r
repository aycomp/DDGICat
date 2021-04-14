library(biomaRt)
library(DBI)
con1 = NULL; resultset = NULL; data = NULL;
con1 <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con1,"SELECT DISTINCT(snp_id) AS snp FROM drug_snp");
dbDisconnect(con1)

con2 <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="BioMart")

snpmart = useEnsembl(biomart = "snp", dataset="hsapiens_snp")
attrlist = listAttributes(snpmart)
attrlist = attrlist[1:8,]

for (i in 1:nrow(data)){
  flag <- TRUE
  tryCatch({
    resultset <- getBM(
      attributes=c(attrlist$name), 
      filters = c('snp_filter', 'variation_source'),
      values = list(data[i,], 'dbSNP'), 
      mart = snpmart,
      uniqueRows=TRUE)
    
    if(i < 2){
      dbWriteTable(con2, "snpb", resultset)  
    } else {
      dbWriteTable(con2, "snpb", resultset, append = TRUE, row.names = FALSE) }
    
  }, warning = function(cond) {
    flag<<-FALSE
    message(cond)
  }, error = function(cond) {
    flag<<-FALSE
    message(cond)
  }, finally={
    message(paste("--> Record: ", i, " SNP:", data[i, ]))
  })
  if (!flag) next()
}

dbDisconnect(con2)




"
OUTPUT:
--> Record:  1621  SNP: rs11677416
--> Record:  1622  SNP: rs11933890
--> Record:  1623  SNP: rs121909567
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  1624  SNP: rs3130501
--> Record:  1625  SNP: rs3787140
--> Record:  1626  SNP: CYP2C9*1, CYP2C9*3
--> Record:  1627  SNP: rs3957357
--> Record:  1628  SNP: rs2725252
--> Record:  1629  SNP: rs2301339
--> Record:  1630  SNP: rs61692318
--> Record:  1631  SNP: rs6787801
--> Record:  1632  SNP: rs8192675
--> Record:  1633  SNP: rs58597806
--> Record:  1634  SNP: rs76387818
--> Record:  1635  SNP: rs2205986
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  1636  SNP: rs28935490
--> Record:  1637  SNP: rs553050853
--> Record:  1638  SNP: rs115457081
--> Record:  1639  SNP: rs773123
--> Record:  1640  SNP: rs7787082
--> Record:  1641  SNP: rs2233678
--> Record:  1642  SNP: rs397508288
--> Record:  1643  SNP: rs12364283
--> Record:  1644  SNP: CYP3A4*1, CYP3A4*18B
--> Record:  1645  SNP: rs11568626
--> Record:  1646  SNP: rs10511905
--> Record:  1647  SNP: rs3732359
--> Record:  1648  SNP: rs334558
--> Record:  1649  SNP: rs3093105
--> Record:  1650  SNP: rs1801274
--> Record:  1651  SNP: rs193922525
--> Record:  1652  SNP: HLA-B*38:02:01
--> Record:  1653  SNP: rs2168631
--> Record:  1654  SNP: rs2070959
--> Record:  1655  SNP: rs1870377
--> Record:  1656  SNP: CYP2D6*1, CYP2D6*29
--> Record:  1657  SNP: rs362267
--> Record:  1658  SNP: rs9402944
--> Record:  1659  SNP: rs12050587
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  1660  SNP: rs367398
--> Record:  1661  SNP: rs1042640
--> Record:  1662  SNP: rs12459249
--> Record:  1663  SNP: rs6072262
--> Record:  1664  SNP: rs2742417
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  1665  SNP: rs1042136
--> Record:  1666  SNP: rs10432303
--> Record:  1667  SNP: rs3761847
--> Record:  1668  SNP: rs3825876
--> Record:  1669  SNP: rs4678145
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  1670  SNP: rs12153855
--> Record:  1671  SNP: rs12720441
--> Record:  1672  SNP: rs201045130
--> Record:  1673  SNP: rs225440
--> Record:  1674  SNP: rs880054
--> Record:  1675  SNP: rs594709
--> Record:  1676  SNP: rs61311738
--> Record:  1677  SNP: rs28929495
--> Record:  1678  SNP: rs2306744
--> Record:  1679  SNP: rs2242446
--> Record:  1680  SNP: rs13125415
--> Record:  1681  SNP: rs17021408
--> Record:  1682  SNP: rs56022120
--> Record:  1683  SNP: rs61908406
--> Record:  1684  SNP: rs716274
--> Record:  1685  SNP: rs10267099
--> Record:  1686  SNP: rs9389568
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR16_1_CTG3_1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR16_1_CTG3_1"
--> Record:  1687  SNP: rs8192935
--> Record:  1688  SNP: rs4135385
--> Record:  1689  SNP: rs7748401
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  1690  SNP: rs869312146
--> Record:  1691  SNP: rs183205964
--> Record:  1692  SNP: CYP2D6*1, CYP2D6*38, CYP2D6*4, CYP2D6*5, CYP2D6*9
--> Record:  1693  SNP: rs10929302
--> Record:  1694  SNP: rs2013169
--> Record:  1695  SNP: rs10517
--> Record:  1696  SNP: rs2251214
--> Record:  1697  SNP: rs2108622
--> Record:  1698  SNP: rs2230806
--> Record:  1699  SNP: rs17060812
--> Record:  1700  SNP: rs3770102
--> Record:  1701  SNP: rs2069502
--> Record:  1702  SNP: rs1293732453
--> Record:  1703  SNP: HLA-DRB1*13:02:01
--> Record:  1704  SNP: rs3135506
--> Record:  1705  SNP: rs3087403
--> Record:  1706  SNP: rs17135437
--> Record:  1707  SNP: rs1335150891
--> Record:  1708  SNP: rs1076560
--> Record:  1709  SNP: rs79206939
--> Record:  1710  SNP: GSTM1 non-null, GSTM1 null
--> Record:  1711  SNP: rs10224002
--> Record:  1712  SNP: rs1521470
--> Record:  1713  SNP: HLA-B*27:09
--> Record:  1714  SNP: rs7395555
--> Record:  1715  SNP: rs879825
--> Record:  1716  SNP: rs11969064
--> Record:  1717  SNP: rs1381376
--> Record:  1718  SNP: rs1522113
--> Record:  1719  SNP: rs2076828
--> Record:  1720  SNP: G6PD A- 202A_376G, G6PD B (wildtype), G6PD Mediterranean, Dallas, Panama' Sassari, Cagliari, Birmingham
--> Record:  1721  SNP: rs2742390
--> Record:  1722  SNP: rs397508510
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR22_8_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR22_8_CTG1"
--> Record:  1723  SNP: rs76088846
--> Record:  1724  SNP: rs2070676
--> Record:  1725  SNP: rs7349683
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR22_1_CTG5"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR22_1_CTG5"
--> Record:  1726  SNP: rs1883112
--> Record:  1727  SNP: rs3766951
--> Record:  1728  SNP: SLCO1B1*1, SLCO1B1*15
--> Record:  1729  SNP: rs4149081
--> Record:  1730  SNP: rs10948059
--> Record:  1731  SNP: rs10423928
--> Record:  1732  SNP: rs76979899
--> Record:  1733  SNP: rs45445694
--> Record:  1734  SNP: rs17109924
--> Record:  1735  SNP: HLA-C*14:03
--> Record:  1736  SNP: rs1783835
--> Record:  1737  SNP: rs1799853
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR19LRC_PGF2_CTG3_1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR19LRC_PGF2_CTG3_1"
--> Record:  1738  SNP: rs1613662
--> Record:  1739  SNP: rs9996584
--> Record:  1740  SNP: rs510432
--> Record:  1741  SNP: rs3210967
--> Record:  1742  SNP: UGT1A1*1, UGT1A1*27, UGT1A1*28, UGT1A1*6
--> Record:  1743  SNP: rs10879346
--> Record:  1744  SNP: rs10741657
--> Record:  1745  SNP: rs795484
--> Record:  1746  SNP: rs7853758
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HG1815_PATCH"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HG1815_PATCH"
--> Record:  1747  SNP: rs1006737
--> Record:  1748  SNP: rs2273697
--> Record:  1749  SNP: rs11185648
--> Record:  1750  SNP: CYP3A7*1A, CYP3A7*1C
--> Record:  1751  SNP: rs118192122
--> Record:  1752  SNP: rs12118636
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  1753  SNP: rs104894827
--> Record:  1754  SNP: rs1142345
--> Record:  1755  SNP: rs3212986
--> Record:  1756  SNP: rs113095083
--> Record:  1757  SNP: rs72558187
--> Record:  1758  SNP: rs324650
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  1759  SNP: rs2497538
--> Record:  1760  SNP: rs1695
--> Record:  1761  SNP: rs2233406
--> Record:  1762  SNP: rs4086116
--> Record:  1763  SNP: rs13429709
--> Record:  1764  SNP: rs11503014
--> Record:  1765  SNP: rs35864111
--> Record:  1766  SNP: SLC6A4 HTTLPR long form (L allele), SLC6A4 HTTLPR short form (S allele)
--> Record:  1767  SNP: rs6130615
--> Record:  1768  SNP: rs1983023
--> Record:  1769  SNP: UGT1A1*1, UGT1A1*28, UGT1A1*37, UGT1A1*6
--> Record:  1770  SNP: rs637137
--> Record:  1771  SNP: rs1360780
--> Record:  1772  SNP: rs7968606
--> Record:  1773  SNP: rs6504649
--> Record:  1774  SNP: rs1044457
--> Record:  1775  SNP: HLA-DPB1*04:01:01:01
--> Record:  1776  SNP: rs142244113
--> Record:  1777  SNP: rs1800035
--> Record:  1778  SNP: rs11553441
--> Record:  1779  SNP: rs3919583
--> Record:  1780  SNP: rs11580409
--> Record:  1781  SNP: rs12657120
--> Record:  1782  SNP: rs77010898
--> Record:  1783  SNP: rs17724464
--> Record:  1784  SNP: rs1143623
--> Record:  1785  SNP: rs1703794
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HG76_PATCH"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HG76_PATCH"
--> Record:  1786  SNP: rs4841588
--> Record:  1787  SNP: rs10419980
--> Record:  1788  SNP: CYP2C9*1, CYP2C9*13, CYP2C9*3
--> Record:  1789  SNP: rs3815459
--> Record:  1790  SNP: CYP2D6*1, CYP2D6*10, CYP2D6*17, CYP2D6*3, CYP2D6*4, CYP2D6*5, CYP2D6*6
--> Record:  1791  SNP: rs72549306
--> Record:  1792  SNP: rs112563513
--> Record:  1793  SNP: rs6813183
--> Record:  1794  SNP: rs5985
--> Record:  1795  SNP: rs4523
--> Record:  1796  SNP: rs6269
--> Record:  1797  SNP: rs4148943
--> Record:  1798  SNP: rs757573592
--> Record:  1799  SNP: rs113993958
--> Record:  1800  SNP: rs3764043
--> Record:  1801  SNP: rs12721627
--> Record:  1802  SNP: rs2228570
--> Record:  1803  SNP: rs4646427
--> Record:  1804  SNP: rs1056827
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_MCF_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_MCF_CTG1"
--> Record:  1805  SNP: rs371194629
--> Record:  1806  SNP: rs953977
--> Record:  1807  SNP: rs4775936
--> Record:  1808  SNP: rs5370
--> Record:  1809  SNP: rs61908410
--> Record:  1810  SNP: rs17376019
--> Record:  1811  SNP: rs2742435
--> Record:  1812  SNP: rs7572857
--> Record:  1813  SNP: rs2242046
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  1814  SNP: rs3761555
--> Record:  1815  SNP: rs34911792
--> Record:  1816  SNP: rs1709083
--> Record:  1817  SNP: rs3778156
--> Record:  1818  SNP: rs7439366
--> Record:  1819  SNP: rs118192163
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR22_8_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR22_8_CTG1"
--> Record:  1820  SNP: rs1080985
--> Record:  1821  SNP: rs4654327
--> Record:  1822  SNP: rs12119882
--> Record:  1823  SNP: rs5219
--> Record:  1824  SNP: rs3749438
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR4_1_CTG9"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR4_1_CTG9"
--> Record:  1825  SNP: rs112561475
--> Record:  1826  SNP: rs797397
--> Record:  1827  SNP: rs3828743
--> Record:  1828  SNP: rs9384169
--> Record:  1829  SNP: rs63749869
--> Record:  1830  SNP: rs13093500
--> Record:  1831  SNP: rs1353295
--> Record:  1832  SNP: rs2378676
--> Record:  1833  SNP: rs204047
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  1834  SNP: rs3099844
--> Record:  1835  SNP: rs1801131
--> Record:  1836  SNP: HLA-DQB1*05:02:01
--> Record:  1837  SNP: rs6702335
--> Record:  1838  SNP: rs10771997
--> Record:  1839  SNP: rs2234753
--> Record:  1840  SNP: rs4343
--> Record:  1841  SNP: rs4648287
--> Record:  1842  SNP: rs2031920
--> Record:  1843  SNP: rs2740574
--> Record:  1844  SNP: TPMT*1, TPMT*2, TPMT*3A, TPMT*3B, TPMT*3C, TPMT*4
--> Record:  1845  SNP: rs9351963
--> Record:  1846  SNP: rs1800100
--> Record:  1847  SNP: rs2295490
--> Record:  1848  SNP: HLA-B*56:02
--> Record:  1849  SNP: rs4646437
--> Record:  1850  SNP: rs104894540
--> Record:  1851  SNP: rs17878544
--> Record:  1852  SNP: rs115545701
--> Record:  1853  SNP: rs1448673
--> Record:  1854  SNP: rs2236947
--> Record:  1855  SNP: rs1778929
--> Record:  1856  SNP: rs2207396
--> Record:  1857  SNP: rs1062535
--> Record:  1858  SNP: rs1105525
--> Record:  1859  SNP: rs9923231
--> Record:  1860  SNP: rs28933389
--> Record:  1861  SNP: rs4148945
--> Record:  1862  SNP: rs10792367
--> Record:  1863  SNP: rs12720067
--> Record:  1864  SNP: rs11543791
--> Record:  1865  SNP: HLA-B*59:01:01:01
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  1866  SNP: rs3815087
--> Record:  1867  SNP: rs724226
--> Record:  1868  SNP: rs2470890
--> Record:  1869  SNP: rs2741171
--> Record:  1870  SNP: rs12708954
--> Record:  1871  SNP: rs17626122
--> Record:  1872  SNP: rs10509680
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR16_1_CTG3_1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR16_1_CTG3_1"
--> Record:  1873  SNP: rs8192950
--> Record:  1874  SNP: rs5030843
--> Record:  1875  SNP: rs4982133
--> Record:  1876  SNP: rs12505410
--> Record:  1877  SNP: rs224534
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR16_1_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR16_1_CTG1"
--> Record:  1878  SNP: rs3784864
--> Record:  1879  SNP: rs5051
--> Record:  1880  SNP: rs4492666
--> Record:  1881  SNP: HLA-B*40:01:01
--> Record:  1882  SNP: rs4627790
--> Record:  1883  SNP: rs730720
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR16_1_CTG3_1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR16_1_CTG3_1"
--> Record:  1884  SNP: rs2244613
--> Record:  1885  SNP: rs55881666
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR22_8_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR22_8_CTG1"
--> Record:  1886  SNP: rs16947
--> Record:  1887  SNP: CYP2D6*1, CYP2D6*24
--> Record:  1888  SNP: rs11045819
--> Record:  1889  SNP: rs9981861
--> Record:  1890  SNP: rs5751876
--> Record:  1891  SNP: rs2071421
--> Record:  1892  SNP: HLA-B*44:02:01:01
--> Record:  1893  SNP: rs328
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  1894  SNP: rs6318
--> Record:  1895  SNP: HLA-A*33:03
--> Record:  1896  SNP: rs1433099
--> Record:  1897  SNP: rs2303377
--> Record:  1898  SNP: rs2857657
--> Record:  1899  SNP: rs1801249
--> Record:  1900  SNP: rs767455
--> Record:  1901  SNP: rs117101815
--> Record:  1902  SNP: rs3778148
--> Record:  1903  SNP: rs135543
--> Record:  1904  SNP: rs135550
--> Record:  1905  SNP: rs12418
--> Record:  1906  SNP: rs658903
--> Record:  1907  SNP: rs2784917
--> Record:  1908  SNP: CYP2D6*1, CYP2D6*10, CYP2D6*14, CYP2D6*1xN, CYP2D6*3, CYP2D6*4, CYP2D6*5, CYP2D6*6
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  1909  SNP: rs3761554
--> Record:  1910  SNP: rs34650714
--> Record:  1911  SNP: rs17421511
--> Record:  1912  SNP: rs4148738
--> Record:  1913  SNP: rs75995567
--> Record:  1914  SNP: rs80223967
--> Record:  1915  SNP: rs4790694
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  1916  SNP: rs1264511
--> Record:  1917  SNP: rs10994982
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  1918  SNP: rs104894828
--> Record:  1919  SNP: rs72558186
--> Record:  1920  SNP: rs8103142
--> Record:  1921  SNP: rs16944
--> Record:  1922  SNP: rs577001
--> Record:  1923  SNP: rs1052536
--> Record:  1924  SNP: rs7301582
--> Record:  1925  SNP: rs1799735
--> Record:  1926  SNP: rs12046844
--> Record:  1927  SNP: rs3761422
--> Record:  1928  SNP: CYP2D6*1, CYP2D6*3, CYP2D6*4
--> Record:  1929  SNP: rs1042858
--> Record:  1930  SNP: rs1561876
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR16_3_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR16_3_CTG1"
--> Record:  1931  SNP: rs3810818
--> Record:  1932  SNP: rs2518224
--> Record:  1933  SNP: rs4570625
--> Record:  1934  SNP: rs1976391
--> Record:  1935  SNP: rs77932196
--> Record:  1936  SNP: rs2419128
--> Record:  1937  SNP: G6PD A- 202A_376G, G6PD B (wildtype)
--> Record:  1938  SNP: rs2075797
--> Record:  1939  SNP: rs846908
--> Record:  1940  SNP: rs11065987
--> Record:  1941  SNP: rs1135989
--> Record:  1942  SNP: rs5441
--> Record:  1943  SNP: SLCO1B1*15, SLCO1B1*1B
--> Record:  1944  SNP: rs35599367
--> Record:  1945  SNP: rs3762555
--> Record:  1946  SNP: CYP2D6*1, CYP2D6*10, CYP2D6*18, CYP2D6*2, CYP2D6*21, CYP2D6*44, CYP2D6*5
--> Record:  1947  SNP: rs11212617
--> Record:  1948  SNP: rs11940316
--> Record:  1949  SNP: rs1805087
--> Record:  1950  SNP: rs7856096
--> Record:  1951  SNP: CYP2C8*1A, CYP2C8*3, CYP2C8*4
--> Record:  1952  SNP: rs4791040
--> Record:  1953  SNP: rs6051702
--> Record:  1954  SNP: rs2235015
--> Record:  1955  SNP: rs3594
--> Record:  1956  SNP: rs508448
--> Record:  1957  SNP: rs9824595
--> Record:  1958  SNP: rs4987161
--> Record:  1959  SNP: rs397508139
--> Record:  1960  SNP: rs7699188
--> Record:  1961  SNP: rs9380524
--> Record:  1962  SNP: rs56113850
--> Record:  1963  SNP: G6PD A- 202A_376G
--> Record:  1964  SNP: rs1042008
--> Record:  1965  SNP: rs740406
--> Record:  1966  SNP: rs6413432
--> Record:  1967  SNP: rs1042919
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  1968  SNP: rs1800629
--> Record:  1969  SNP: rs800292
--> Record:  1970  SNP: rs2835859
--> Record:  1971  SNP: rs61908411
--> Record:  1972  SNP: rs10811661
--> Record:  1973  SNP: rs56005131
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  1974  SNP: rs2734583
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  1975  SNP: rs179008
--> Record:  1976  SNP: rs4968187
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  1977  SNP: rs3115672
--> Record:  1978  SNP: rs16909440
--> Record:  1979  SNP: rs10413455
--> Record:  1980  SNP: rs1470579
--> Record:  1981  SNP: rs7089580
--> Record:  1982  SNP: rs12806698
--> Record:  1983  SNP: rs36029
--> Record:  1984  SNP: rs2290573
--> Record:  1985  SNP: rs12132152
--> Record:  1986  SNP: rs2869950
--> Record:  1987  SNP: TPMT*1, TPMT*2, TPMT*3A, TPMT*3B, TPMT*3C
--> Record:  1988  SNP: rs193922809
--> Record:  1989  SNP: rs193922762
--> Record:  1990  SNP: rs1042714
--> Record:  1991  SNP: HLA-A*24:02:01:01
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  1992  SNP: rs3130690
--> Record:  1993  SNP: rs28933390
--> Record:  1994  SNP: rs57449396
--> Record:  1995  SNP: rs35068180
--> Record:  1996  SNP: rs4550690
--> Record:  1997  SNP: rs2304429
--> Record:  1998  SNP: rs2076369
--> Record:  1999  SNP: rs1800470
--> Record:  2000  SNP: rs7164594
--> Record:  2001  SNP: rs5030849
--> Record:  2002  SNP: rs1277441
--> Record:  2003  SNP: rs2151222
--> Record:  2004  SNP: rs2832407
--> Record:  2005  SNP: rs9806699
--> Record:  2006  SNP: rs10509373
--> Record:  2007  SNP: CYP2D6*1, CYP2D6*17, CYP2D6*2, CYP2D6*4, CYP2D6*41, CYP2D6*5
--> Record:  2008  SNP: rs2314339
--> Record:  2009  SNP: rs11039149
--> Record:  2010  SNP: rs4533622
--> Record:  2011  SNP: rs118192177
--> Record:  2012  SNP: rs9590353
--> Record:  2013  SNP: rs1801368
--> Record:  2014  SNP: rs7858
--> Record:  2015  SNP: rs1872328
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  2016  SNP: rs506770
--> Record:  2017  SNP: rs7472
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  2018  SNP: rs1043620
--> Record:  2019  SNP: rs6002674
--> Record:  2020  SNP: rs4799915
--> Record:  2021  SNP: rs3806596
--> Record:  2022  SNP: rs7551789
--> Record:  2023  SNP: rs1127354
--> Record:  2024  SNP: rs622342
--> Record:  2025  SNP: rs4795893
--> Record:  2026  SNP: rs881152
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  2027  SNP: rs398123223
--> Record:  2028  SNP: rs12201199
--> Record:  2029  SNP: rs8099917
--> Record:  2030  SNP: rs13181
--> Record:  2031  SNP: CYP2D6*1, CYP2D6*1xN
--> Record:  2032  SNP: rs2734842
--> Record:  2033  SNP: rs104894541
--> Record:  2034  SNP: rs4823613
--> Record:  2035  SNP: rs3931660
--> Record:  2036  SNP: UGT1A6*2a
--> Record:  2037  SNP: rs290487
--> Record:  2038  SNP: rs4818
--> Record:  2039  SNP: rs1800888
--> Record:  2040  SNP: rs4291
--> Record:  2041  SNP: rs4271002
--> Record:  2042  SNP: rs4292394
--> Record:  2043  SNP: rs1800532
--> Record:  2044  SNP: rs846910
--> Record:  2045  SNP: rs7973796
--> Record:  2046  SNP: rs1061735
--> Record:  2047  SNP: rs165599
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR22_8_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR22_8_CTG1"
--> Record:  2048  SNP: rs28371733
--> Record:  2049  SNP: rs1378942
--> Record:  2050  SNP: rs10919035
--> Record:  2051  SNP: rs4917639
--> Record:  2052  SNP: rs148994843
--> Record:  2053  SNP: rs56038477
--> Record:  2054  SNP: rs2236196
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  2055  SNP: rs3130907
--> Record:  2056  SNP: rs684513
--> Record:  2057  SNP: rs1799793
--> Record:  2058  SNP: rs11574077
--> Record:  2059  SNP: rs7178270
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  2060  SNP: rs869312138
--> Record:  2061  SNP: rs3192723
--> Record:  2062  SNP: rs6467136
--> Record:  2063  SNP: rs232043
--> Record:  2064  SNP: rs118192167
--> Record:  2065  SNP: rs4858478
--> Record:  2066  SNP: rs11188072
--> Record:  2067  SNP: rs11231825
--> Record:  2068  SNP: rs1800462
--> Record:  2069  SNP: rs4870061
--> Record:  2070  SNP: rs1265138
--> Record:  2071  SNP: rs7643645
--> Record:  2072  SNP: rs10500565
--> Record:  2073  SNP: TPMT*1, TPMT*5, TPMT*10, TPMT*13, TPMT*15, TPMT*19, TPMT*24, TPMT*25, TPMT*26, TPMT*27, TPMT*28, TPMT*30, TPMT*31, TPMT*32, TPMT*33, TPMT*34, TPMT*37
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  2074  SNP: rs4273729
--> Record:  2075  SNP: rs1801516
--> Record:  2076  SNP: CYP2C8*1A, CYP2C8*3
--> Record:  2077  SNP: rs201376588
--> Record:  2078  SNP: rs12083537
--> Record:  2079  SNP: rs6305
--> Record:  2080  SNP: rs1176744
--> Record:  2081  SNP: rs130058
--> Record:  2082  SNP: G6PD B (wildtype), G6PD Mediterranean, Dallas, Panama' Sassari, Cagliari, Birmingham
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  2083  SNP: rs3129294
--> Record:  2084  SNP: rs9322335
COPY returned error: ERROR:  invalid input syntax for integer: "MT"
CONTEXT:  COPY snpb, line 1, column chr_name: "MT"
--> Record:  2085  SNP: rs267606617
--> Record:  2086  SNP: rs4948496
--> Record:  2087  SNP: rs11710163
--> Record:  2088  SNP: rs12436663
--> Record:  2089  SNP: rs5746136
--> Record:  2090  SNP: rs7317112
--> Record:  2091  SNP: rs578427
--> Record:  2092  SNP: rs2770296
--> Record:  2093  SNP: rs875858
--> Record:  2094  SNP: rs1801159
--> Record:  2095  SNP: rs16886403
--> Record:  2096  SNP: CYP2C9*1, CYP2C9*13, CYP2C9*14, CYP2C9*16, CYP2C9*19, CYP2C9*27, CYP2C9*29, CYP2C9*31, CYP2C9*33, CYP2C9*36, CYP2C9*37, CYP2C9*39, CYP2C9*40, CYP2C9*41, CYP2C9*42, CYP2C9*43, CYP2C9*45, CYP2C9*47, CYP2C9*49, CYP2C9*50, CYP2C9*51, CYP2C9*52, CYP2C9*53, CYP2C9*54, CYP2C9*55, CYP2C9*56, CYP2C9*8
--> Record:  2097  SNP: rs11252394
--> Record:  2098  SNP: HLA-DRB1*01:01:01, HLA-DRB1*04:06:01
--> Record:  2099  SNP: rs1805128
--> Record:  2100  SNP: rs16964189
--> Record:  2101  SNP: rs1786929
--> Record:  2102  SNP: rs7194667
--> Record:  2103  SNP: rs1155463
--> Record:  2104  SNP: rs17742120
--> Record:  2105  SNP: rs11052877
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  2106  SNP: rs1050828
--> Record:  2107  SNP: CYP2D6*1, CYP2D6*3, CYP2D6*36, CYP2D6*4, CYP2D6*40, CYP2D6*42, CYP2D6*4xN, CYP2D6*56
--> Record:  2108  SNP: rs4149036
--> Record:  2109  SNP: rs8050894
--> Record:  2110  SNP: rs6421482
--> Record:  2111  SNP: rs16973225
--> Record:  2112  SNP: rs10457090
--> Record:  2113  SNP: rs2069521
--> Record:  2114  SNP: rs73450548
--> Record:  2115  SNP: CYP3A5*1, CYP3A5*3
--> Record:  2116  SNP: rs760370
--> Record:  2117  SNP: rs17701271
--> Record:  2118  SNP: rs10835210
--> Record:  2119  SNP: rs17614642
--> Record:  2120  SNP: rs6092
--> Record:  2121  SNP: rs35112940
--> Record:  2122  SNP: rs1801252
--> Record:  2123  SNP: rs2227631
--> Record:  2124  SNP: rs699517
--> Record:  2125  SNP: CYP2C19*1, CYP2C19*17, CYP2C19*2, CYP2C19*3, CYP2C19*8, CYP2C19*9
--> Record:  2126  SNP: rs6728642
--> Record:  2127  SNP: rs75193786
--> Record:  2128  SNP: rs2291078
--> Record:  2129  SNP: rs2612091
--> Record:  2130  SNP: rs9316233
--> Record:  2131  SNP: rs104894539
--> Record:  2132  SNP: rs7200749
--> Record:  2133  SNP: rs2228479
--> Record:  2134  SNP: CYP2D6*1, CYP2D6*10, CYP2D6*17, CYP2D6*1xN, CYP2D6*2, CYP2D6*3, CYP2D6*4, CYP2D6*41, CYP2D6*5, CYP2D6*6, CYP2D6*9
--> Record:  2135  SNP: rs2514218
--> Record:  2136  SNP: rs2276706
--> Record:  2137  SNP: rs3792269
--> Record:  2138  SNP: rs932764
--> Record:  2139  SNP: rs7929521
--> Record:  2140  SNP: rs3846662
--> Record:  2141  SNP: rs10157410
--> Record:  2142  SNP: rs6759892
--> Record:  2143  SNP: rs2695121
--> Record:  2144  SNP: rs714368
--> Record:  2145  SNP: rs4877900
--> Record:  2146  SNP: rs148013902
--> Record:  2147  SNP: HLA-C*03:02
--> Record:  2148  SNP: rs3133084
--> Record:  2149  SNP: rs11854484
--> Record:  2150  SNP: rs62471956
--> Record:  2151  SNP: rs267606723
--> Record:  2152  SNP: rs2592551
--> Record:  2153  SNP: rs3778150
--> Record:  2154  SNP: rs6600880
--> Record:  2155  SNP: rs1800460
--> Record:  2156  SNP: rs9361233
--> Record:  2157  SNP: rs1184321568
--> Record:  2158  SNP: rs1801157
--> Record:  2159  SNP: rs4386686
--> Record:  2160  SNP: rs520210
--> Record:  2161  SNP: rs2276302
--> Record:  2162  SNP: rs8008020
--> Record:  2163  SNP: rs3732219
--> Record:  2164  SNP: rs1801160
--> Record:  2165  SNP: rs6848893
--> Record:  2166  SNP: HLA-B*46:01:01
--> Record:  2167  SNP: rs145623321
--> Record:  2168  SNP: rs4149178
--> Record:  2169  SNP: rs1643650
--> Record:  2170  SNP: rs12505746
--> Record:  2171  SNP: rs4149015
--> Record:  2172  SNP: rs11265618
--> Record:  2173  SNP: rs2284449
--> Record:  2174  SNP: rs11042725
--> Record:  2175  SNP: rs2758339
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR22_8_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR22_8_CTG1"
--> Record:  2176  SNP: rs3892097
--> Record:  2177  SNP: rs17309872
--> Record:  2178  SNP: rs13104811
--> Record:  2179  SNP: rs578776
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  2180  SNP: rs398123217
--> Record:  2181  SNP: rs2501873
--> Record:  2182  SNP: rs55781567
--> Record:  2183  SNP: CYP2C9*1, CYP2C9*13, CYP2C9*2, CYP2C9*3
--> Record:  2184  SNP: rs7574865
--> Record:  2185  SNP: rs11983225
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  2186  SNP: rs2233980
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  2187  SNP: rs3097671
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR4_1_CTG9"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR4_1_CTG9"
--> Record:  2188  SNP: rs1902023
--> Record:  2189  SNP: rs184199168
--> Record:  2190  SNP: rs2177370
--> Record:  2191  SNP: rs61123830
--> Record:  2192  SNP: rs11227247
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  2193  SNP: rs372966991
--> Record:  2194  SNP: rs2291075
--> Record:  2195  SNP: CYP2D6*1, CYP2D6*10, CYP2D6*114, CYP2D6*2, CYP2D6*3, CYP2D6*4, CYP2D6*41, CYP2D6*4xN, CYP2D6*5, CYP2D6*6
--> Record:  2196  SNP: rs1048786
--> Record:  2197  SNP: CYP2D6*1, CYP2D6*1xN, CYP2D6*2, CYP2D6*2xN, CYP2D6*3, CYP2D6*4, CYP2D6*5, CYP2D6*6
--> Record:  2198  SNP: rs3758785
--> Record:  2199  SNP: rs2231135
--> Record:  2200  SNP: rs6506569
--> Record:  2201  SNP: rs11568820
--> Record:  2202  SNP: rs3856806
--> Record:  2203  SNP: rs712829
--> Record:  2204  SNP: rs3213094
--> Record:  2205  SNP: rs11649514
--> Record:  2206  SNP: rs193922832
--> Record:  2207  SNP: rs17839843
--> Record:  2208  SNP: rs696692
--> Record:  2209  SNP: rs6688363
--> Record:  2210  SNP: rs193922876
--> Record:  2211  SNP: rs324899
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR17_3_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR17_3_CTG1"
--> Record:  2212  SNP: rs12603700
--> Record:  2213  SNP: rs2276307
--> Record:  2214  SNP: rs11706052
--> Record:  2215  SNP: rs12595802
--> Record:  2216  SNP: rs4774388
--> Record:  2217  SNP: rs2010963
--> Record:  2218  SNP: rs10193126
--> Record:  2219  SNP: rs854560
--> Record:  2220  SNP: rs2873804
--> Record:  2221  SNP: rs10760397
--> Record:  2222  SNP: rs3215400
--> Record:  2223  SNP: rs2359612
--> Record:  2224  SNP: rs3732759
--> Record:  2225  SNP: rs73748206
--> Record:  2226  SNP: rs2734841
--> Record:  2227  SNP: rs1042028
--> Record:  2228  SNP: rs1050152
--> Record:  2229  SNP: rs2585428
--> Record:  2230  SNP: rs7877
--> Record:  2231  SNP: rs7604115
--> Record:  2232  SNP: rs34743033
--> Record:  2233  SNP: rs1048101
--> Record:  2234  SNP: rs12233719
--> Record:  2235  SNP: rs1663332
--> Record:  2236  SNP: rs28399504
--> Record:  2237  SNP: rs2071303
--> Record:  2238  SNP: rs58818712
--> Record:  2239  SNP: rs11563250
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR22_8_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR22_8_CTG1"
--> Record:  2240  SNP: rs28360521
--> Record:  2241  SNP: rs1042927
--> Record:  2242  SNP: rs66486766
--> Record:  2243  SNP: rs6311
--> Record:  2244  SNP: rs1663330
--> Record:  2245  SNP: rs429358
--> Record:  2246  SNP: rs7142881
--> Record:  2247  SNP: rs1800111
--> Record:  2248  SNP: rs11572078
--> Record:  2249  SNP: rs75114882
--> Record:  2250  SNP: rs10771998
--> Record:  2251  SNP: rs11600347
--> Record:  2252  SNP: CYP2D6*1, CYP2D6*10, CYP2D6*17, CYP2D6*2, CYP2D6*29, CYP2D6*3, CYP2D6*31, CYP2D6*35, CYP2D6*4, CYP2D6*41, CYP2D6*45, CYP2D6*46, CYP2D6*5, CYP2D6*6, CYP2D6*9
--> Record:  2253  SNP: rs12143842
--> Record:  2254  SNP: rs2298805
--> Record:  2255  SNP: CYP2C19*1, CYP2C19*16, CYP2C19*2
--> Record:  2256  SNP: rs2368564
--> Record:  2257  SNP: rs10121600
--> Record:  2258  SNP: rs446112
--> Record:  2259  SNP: rs1800795
--> Record:  2260  SNP: rs822441
--> Record:  2261  SNP: rs2854744
--> Record:  2262  SNP: rs10161126
--> Record:  2263  SNP: rs60369023
--> Record:  2264  SNP: rs3793790
--> Record:  2265  SNP: rs2251954
--> Record:  2266  SNP: rs4431329
--> Record:  2267  SNP: rs726501
--> Record:  2268  SNP: rs1212037891
--> Record:  2269  SNP: rs61767420
--> Record:  2270  SNP: HLA-DRB1*07:01:01:01
--> Record:  2271  SNP: rs370457585
--> Record:  2272  SNP: rs2228246
--> Record:  2273  SNP: rs2760118
--> Record:  2274  SNP: rs17731538
--> Record:  2275  SNP: rs2266782
--> Record:  2276  SNP: rs2272733
--> Record:  2277  SNP: rs1150226
--> Record:  2278  SNP: rs12209447
--> Record:  2279  SNP: CYP1A2*1A, CYP1A2*1F
--> Record:  2280  SNP: rs4148416
--> Record:  2281  SNP: rs548646
--> Record:  2282  SNP: rs3750920
--> Record:  2283  SNP: rs2297595
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR6_MHC_COX_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR6_MHC_COX_CTG1"
--> Record:  2284  SNP: rs361525
--> Record:  2285  SNP: rs2229046
--> Record:  2286  SNP: CYP3A4*1, CYP3A4*20
--> Record:  2287  SNP: rs11587213
--> Record:  2288  SNP: rs193922768
--> Record:  2289  SNP: rs2241883
--> Record:  2290  SNP: rs9906827
--> Record:  2291  SNP: rs3826041
--> Record:  2292  SNP: rs397508602
--> Record:  2293  SNP: rs757978
--> Record:  2294  SNP: rs1059513
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR16_1_CTG3_1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR16_1_CTG3_1"
--> Record:  2295  SNP: rs3217164
--> Record:  2296  SNP: rs17222723
--> Record:  2297  SNP: rs193922803
--> Record:  2298  SNP: rs2306283
--> Record:  2299  SNP: rs121908753
--> Record:  2300  SNP: rs11676382
--> Record:  2301  SNP: rs7184292
--> Record:  2302  SNP: rs12721655
--> Record:  2303  SNP: rs1065776
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR22_8_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR22_8_CTG1"
--> Record:  2304  SNP: rs1065852
--> Record:  2305  SNP: rs117951771
--> Record:  2306  SNP: rs2847153
--> Record:  2307  SNP: rs7306991
--> Record:  2308  SNP: rs9915451
--> Record:  2309  SNP: rs962369
--> Record:  2310  SNP: rs3213422
--> Record:  2311  SNP: rs4149601
--> Record:  2312  SNP: rs41291556
--> Record:  2313  SNP: rs10124893
--> Record:  2314  SNP: rs12409352
--> Record:  2315  SNP: rs1801268
--> Record:  2316  SNP: rs12720462
--> Record:  2317  SNP: rs2515641
--> Record:  2318  SNP: rs1801394
--> Record:  2319  SNP: rs1801266
--> Record:  2320  SNP: CYP2D6*1, CYP2D6*10, CYP2D6*2, CYP2D6*3, CYP2D6*4, CYP2D6*41, CYP2D6*5, CYP2D6*6
--> Record:  2321  SNP: rs4646
--> Record:  2322  SNP: rs2071427
--> Record:  2323  SNP: rs5744174
--> Record:  2324  SNP: rs28374453
--> Record:  2325  SNP: rs2246709
--> Record:  2326  SNP: rs9901673
--> Record:  2327  SNP: HLA-B*15:18:01, HLA-B*40:01:01
--> Record:  2328  SNP: rs80338792
--> Record:  2329  SNP: rs1065634
--> Record:  2330  SNP: rs2270860
--> Record:  2331  SNP: rs17160359
--> Record:  2332  SNP: rs1947275
--> Record:  2333  SNP: rs34231037
--> Record:  2334  SNP: rs2302489
--> Record:  2335  SNP: rs1800471
--> Record:  2336  SNP: rs6923761
--> Record:  2337  SNP: rs78132896
--> Record:  2338  SNP: rs13137622
--> Record:  2339  SNP: rs4815273
--> Record:  2340  SNP: rs11023197
--> Record:  2341  SNP: rs62435418
--> Record:  2342  SNP: rs10538494
--> Record:  2343  SNP: rs10975641
--> Record:  2344  SNP: rs3091244
--> Record:  2345  SNP: rs2011425
--> Record:  2346  SNP: rs118192116
--> Record:  2347  SNP: rs2289669
--> Record:  2348  SNP: rs78428806
--> Record:  2349  SNP: rs10305420
--> Record:  2350  SNP: rs7248668
--> Record:  2351  SNP: rs6127921
--> Record:  2352  SNP: rs1049305
--> Record:  2353  SNP: rs7179742
--> Record:  2354  SNP: rs1202283
--> Record:  2355  SNP: CYP4F2*1, CYP4F2*3
--> Record:  2356  SNP: rs3814637
--> Record:  2357  SNP: rs1051685
--> Record:  2358  SNP: rs870995
--> Record:  2359  SNP: rs4532
--> Record:  2360  SNP: rs679899
--> Record:  2361  SNP: rs2281617
--> Record:  2362  SNP: rs532545
--> Record:  2363  SNP: rs2235067
--> Record:  2364  SNP: rs9828223
--> Record:  2365  SNP: rs78060119
--> Record:  2366  SNP: rs2075685
--> Record:  2367  SNP: rs144928727
--> Record:  2368  SNP: rs1934969
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR16_1_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR16_1_CTG1"
--> Record:  2369  SNP: rs28364006
--> Record:  2370  SNP: rs3834939
--> Record:  2371  SNP: rs4986790
--> Record:  2372  SNP: rs183484
--> Record:  2373  SNP: rs834576
--> Record:  2374  SNP: rs4148324
--> Record:  2375  SNP: CYP2D6*1, CYP2D6*11, CYP2D6*12, CYP2D6*4, CYP2D6*41, CYP2D6*5, CYP2D6*59, CYP2D6*62, CYP2D6*7, CYP2D6*8
--> Record:  2376  SNP: rs17587029
--> Record:  2377  SNP: rs2472297
--> Record:  2378  SNP: rs1805054
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR16_1_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR16_1_CTG1"
--> Record:  2379  SNP: rs35592
--> Record:  2380  SNP: rs6479008
--> Record:  2381  SNP: rs12630569
--> Record:  2382  SNP: rs6021191
--> Record:  2383  SNP: rs9282564
--> Record:  2384  SNP: rs4844880
--> Record:  2385  SNP: rs967676
--> Record:  2386  SNP: rs12142086
--> Record:  2387  SNP: rs10932125
--> Record:  2388  SNP: rs114202595
--> Record:  2389  SNP: rs116855232
--> Record:  2390  SNP: rs61886492
--> Record:  2391  SNP: rs1570360
--> Record:  2392  SNP: HLA-B*39:01:01:01
--> Record:  2393  SNP: rs1126757
--> Record:  2394  SNP: HLA-A*02:01
--> Record:  2395  SNP: rs14158
--> Record:  2396  SNP: rs75222709
--> Record:  2397  SNP: rs7387065
--> Record:  2398  SNP: rs563649
--> Record:  2399  SNP: rs7867504
--> Record:  2400  SNP: HLA-B*15:11:01
--> Record:  2401  SNP: rs79430272
--> Record:  2402  SNP: HLA-B*57:01:01
--> Record:  2403  SNP: rs4731426
--> Record:  2404  SNP: rs1056836
--> Record:  2405  SNP: rs12762549
--> Record:  2406  SNP: rs10995311
--> Record:  2407  SNP: rs735482
--> Record:  2408  SNP: CYP2D6*1, CYP2D6*10, CYP2D6*2, CYP2D6*4, CYP2D6*5
--> Record:  2409  SNP: rs145119820
--> Record:  2410  SNP: rs17655652
--> Record:  2411  SNP: rs12721226
--> Record:  2412  SNP: rs1799998
--> Record:  2413  SNP: CYP2D6*1, CYP2D6*10, CYP2D6*2, CYP2D6*4, CYP2D6*41, CYP2D6*5, CYP2D6*6
--> Record:  2414  SNP: rs1130214
--> Record:  2415  SNP: rs776746
--> Record:  2416  SNP: rs7653345
--> Record:  2417  SNP: rs1799722
--> Record:  2418  SNP: rs11264359
--> Record:  2419  SNP: rs10011796
--> Record:  2420  SNP: rs2571598
--> Record:  2421  SNP: CYP2D6*1, CYP2D6*1xN, CYP2D6*4, CYP2D6*41
--> Record:  2422  SNP: rs397508442
--> Record:  2423  SNP: rs933271
--> Record:  2424  SNP: rs5918
--> Record:  2425  SNP: rs6296
--> Record:  2426  SNP: CYP2D6*1, CYP2D6*1xN, CYP2D6*3, CYP2D6*4, CYP2D6*41, CYP2D6*5, CYP2D6*6
--> Record:  2427  SNP: rs10802887
--> Record:  2428  SNP: rs6413517
--> Record:  2429  SNP: rs118192176
--> Record:  2430  SNP: rs112783657
--> Record:  2431  SNP: rs193922764
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR22_8_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR22_8_CTG1"
--> Record:  2432  SNP: rs35742686
--> Record:  2433  SNP: rs765399160
--> Record:  2434  SNP: rs10012
--> Record:  2435  SNP: rs1891059
--> Record:  2436  SNP: rs4506565
--> Record:  2437  SNP: rs8109525
--> Record:  2438  SNP: HLA-B*48:04
--> Record:  2439  SNP: rs7668258
--> Record:  2440  SNP: rs138809906
--> Record:  2441  SNP: HLA-B*15:01:01:01
--> Record:  2442  SNP: rs2229109
--> Record:  2443  SNP: rs708272
--> Record:  2444  SNP: rs3218592
--> Record:  2445  SNP: rs2228478
--> Record:  2446  SNP: rs28365062
--> Record:  2447  SNP: rs9332239
--> Record:  2448  SNP: rs2266780
--> Record:  2449  SNP: CYP3A4*1A, CYP3A4*1B
--> Record:  2450  SNP: rs7325568
--> Record:  2451  SNP: rs1048977
--> Record:  2452  SNP: rs10052999
--> Record:  2453  SNP: rs7903146
--> Record:  2454  SNP: rs2661319
--> Record:  2455  SNP: rs305968
--> Record:  2456  SNP: rs1801058
--> Record:  2457  SNP: CYP2C8*1A, CYP2C8*2, CYP2C8*3
--> Record:  2458  SNP: rs2189784
--> Record:  2459  SNP: rs3808607
--> Record:  2460  SNP: HLA-B*48:01
--> Record:  2461  SNP: rs10752271
--> Record:  2462  SNP: rs6313
--> Record:  2463  SNP: rs6118
--> Record:  2464  SNP: rs1799931
--> Record:  2465  SNP: rs2069514
--> Record:  2466  SNP: rs2292997
--> Record:  2467  SNP: CYP3A5*1, CYP3A5*3, CYP3A5*6, CYP3A5*7
--> Record:  2468  SNP: rs1136201
COPY returned error: ERROR:  invalid input syntax for integer: "X"
CONTEXT:  COPY snpb, line 1, column chr_name: "X"
--> Record:  2469  SNP: rs727505292
--> Record:  2470  SNP: HLA-B*44:03:01
--> Record:  2471  SNP: rs2636719
--> Record:  2472  SNP: rs4680
--> Record:  2473  SNP: rs11231809
--> Record:  2474  SNP: rs2392165
--> Record:  2475  SNP: CYP2C19*1, CYP2C19*10, CYP2C19*17, CYP2C19*2, CYP2C19*24, CYP2C19*26, CYP2C19*3, CYP2C19*9
--> Record:  2476  SNP: rs75039782
--> Record:  2477  SNP: rs1045642
--> Record:  2478  SNP: rs809736
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR10_1_CTG2"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR10_1_CTG2"
--> Record:  2479  SNP: rs2115819
--> Record:  2480  SNP: rs7569963
--> Record:  2481  SNP: rs3753380
--> Record:  2482  SNP: rs72551344
--> Record:  2483  SNP: rs1801260
--> Record:  2484  SNP: CYP2A6*15, CYP2A6*1A, CYP2A6*21, CYP2A6*22
--> Record:  2485  SNP: CYP2D6*1, CYP2D6*10, CYP2D6*2, CYP2D6*3, CYP2D6*4, CYP2D6*5
--> Record:  2486  SNP: rs12979860
--> Record:  2487  SNP: rs780801862
--> Record:  2488  SNP: rs742105
--> Record:  2489  SNP: CYP2C19*1, CYP2C19*17, CYP2C19*2, CYP2C19*3
--> Record:  2490  SNP: rs2230808
COPY returned error: ERROR:  invalid input syntax for integer: "CHR_HSCHR17_3_CTG1"
CONTEXT:  COPY snpb, line 2, column chr_name: "CHR_HSCHR17_3_CTG1"
--> Record:  2491  SNP: rs56355515
--> Record:  2492  SNP: rs6589386
--> Record:  2493  SNP: rs6025211
--> Record:  2494  SNP: rs2273618
--> Record:  2495  SNP: rs2228014
--> Record:  2496  SNP: rs7270101
> 
> dbDisconnect(con2)
> 

"
