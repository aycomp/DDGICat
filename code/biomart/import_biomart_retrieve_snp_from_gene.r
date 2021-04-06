library(biomaRt)
library(DBI)
con = NULL; resultset = NULL; data = NULL;
con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="BioMart")
data <- dbGetQuery(con,"
            SELECT DISTINCT(chromosome_name || start_position || end_position), 
            	chromosome_name AS chr,	start_position AS start, end_position AS end
            FROM gene ORDER BY chr, start_position, end_position");

snpmart = useEnsembl(biomart = "snp", dataset="hsapiens_snp")

for (i in 1:nrow(data)){
    flag <- TRUE
    tryCatch({
      result  <- getBM(
        attributes=c( 'refsnp_id','refsnp_source', 'chr_name','chrom_start','chrom_end'), 
        filters = c('chr_name','start','end'), 
        values = list(data$chr[i], data$start[i], data$end[i]), 
        mart = snpmart,
        uniqueRows=TRUE)
      
      if(i < 2){
        dbWriteTable(con, "snpb", result)  
      } else {
        dbWriteTable(con, "snpb", result, append = TRUE, row.names = FALSE) }
      
    }, warning = function(cond) {
      flag<<-FALSE
      message(cond)
    }, error = function(cond) {
      flag<<-FALSE
      message(cond)
    }, finally={
      message(paste("Record:", i, " Chromosome:", data$chr[i], "  Start:", data$start[i], "  End:", data$end[i]))
    })
    if (!flag) next()
}
dbDisconnect(con)



"OUTPUT

Record: 1  Chromosome: 1   Start: 11845780   End: 11866977
Record: 2  Chromosome: 1   Start: 11905766   End: 11908402
Timeout was reached: [www.ensembl.org:443] Operation timed out after 300000 milliseconds with 1970500 bytes receivedRecord: 3  Chromosome: 1   Start: 97543299   End: 98386605
Record: 4  Chromosome: 1   Start: 110230436   End: 110251661
Record: 5  Chromosome: 1   Start: 161475220   End: 161493803
Record: 6  Chromosome: 1   Start: 161511549   End: 161600917
Record: 7  Chromosome: 1   Start: 169483404   End: 169555826
Record: 8  Chromosome: 1   Start: 173872947   End: 173886516
Record: 9  Chromosome: 1   Start: 206643791   End: 206670223
Record: 10  Chromosome: 10   Start: 96447911   End: 96613017
Record: 11  Chromosome: 10   Start: 96698415   End: 96749147
Record: 12  Chromosome: 10   Start: 101542489   End: 101611949
Record: 13  Chromosome: 10   Start: 115803806   End: 115806667
Record: 14  Chromosome: 11   Start: 4115937   End: 4160106
Record: 15  Chromosome: 11   Start: 67351066   End: 67354131
Record: 16  Chromosome: 11   Start: 113280318   End: 113346413
Timeout was reached: [www.ensembl.org:443] Operation timed out after 300001 milliseconds with 2125817 bytes receivedRecord: 17  Chromosome: 11   Start: 120382468   End: 120859613
Record: 18  Chromosome: 12   Start: 6949118   End: 6956557
Record: 19  Chromosome: 12   Start: 21284136   End: 21392180
Record: 20  Chromosome: 12   Start: 53604354   End: 53626764
Record: 21  Chromosome: 13   Start: 47405685   End: 47471169
Record: 22  Chromosome: 15   Start: 75041185   End: 75048543
Record: 23  Chromosome: 15   Start: 89859534   End: 89878092
Record: 24  Chromosome: 16   Start: 31102163   End: 31107301
Record: 25  Chromosome: 17   Start: 28521337   End: 28563020
Record: 26  Chromosome: 17   Start: 28575218   End: 28619074
Record: 27  Chromosome: 17   Start: 37844167   End: 37886679
Record: 28  Chromosome: 17   Start: 45331212   End: 45421658
Record: 29  Chromosome: 17   Start: 45810610   End: 45823485
Record: 30  Chromosome: 17   Start: 61554422   End: 61599205
Record: 31  Chromosome: 18   Start: 657604   End: 673578
Record: 32  Chromosome: 19   Start: 39734246   End: 39735646
Record: 33  Chromosome: 19   Start: 41497204   End: 41524303
Record: 34  Chromosome: 2   Start: 38294116   End: 38337044
Record: 35  Chromosome: 2   Start: 166845670   End: 166984523
Timeout was reached: [www.ensembl.org:443] Operation timed out after 300000 milliseconds with 1037719 bytes receivedRecord: 36  Chromosome: 2   Start: 169983619   End: 170219195
Record: 37  Chromosome: 2   Start: 208394461   End: 208468155
Record: 38  Chromosome: 2   Start: 234590584   End: 234681945
Record: 39  Chromosome: 2   Start: 234600253   End: 234681946
Record: 40  Chromosome: 2   Start: 234668894   End: 234681945
Record: 41  Chromosome: 20   Start: 4201329   End: 4229721
Record: 42  Chromosome: 22   Start: 19929130   End: 19957498
Record: 43  Chromosome: 22   Start: 30843946   End: 30868036
Record: 44  Chromosome: 22   Start: 38452318   End: 38471708
Record: 45  Chromosome: 22   Start: 42522501   End: 42526908
Record: 46  Chromosome: 3   Start: 14186647   End: 14220283
Record: 47  Chromosome: 4   Start: 83273651   End: 83295656
Record: 48  Chromosome: 4   Start: 89011416   End: 89152474
Record: 49  Chromosome: 5   Start: 63256183   End: 63258334
Record: 50  Chromosome: 5   Start: 74632154   End: 74657929
Record: 51  Chromosome: 5   Start: 179220981   End: 179223648
Record: 52  Chromosome: 6   Start: 18128542   End: 18155305
Record: 53  Chromosome: 6   Start: 29909037   End: 29913661
Record: 54  Chromosome: 6   Start: 30695486   End: 30710510
Record: 55  Chromosome: 6   Start: 30951495   End: 30957680
Record: 56  Chromosome: 6   Start: 31321649   End: 31324965
Record: 57  Chromosome: 6   Start: 31368479   End: 31445283
Record: 58  Chromosome: 6   Start: 31777396   End: 31783437
Record: 59  Chromosome: 6   Start: 31783291   End: 31785723
Record: 60  Chromosome: 6   Start: 32008931   End: 32083111
Record: 61  Chromosome: 6   Start: 32546546   End: 32557625
Record: 62  Chromosome: 6   Start: 32595956   End: 32614839
Record: 63  Chromosome: 6   Start: 32627244   End: 32636160
Record: 64  Chromosome: 6   Start: 33762450   End: 33771788
Timeout was reached: [www.ensembl.org:443] Operation timed out after 300000 milliseconds with 3187197 bytes receivedRecord: 65  Chromosome: 6   Start: 39297766   End: 39693181
Timeout was reached: [www.ensembl.org:443] Operation timed out after 300000 milliseconds with 4102015 bytes receivedRecord: 66  Chromosome: 6   Start: 101846664   End: 102517958
Timeout was reached: [www.ensembl.org:443] Operation timed out after 300001 milliseconds with 2068034 bytes receivedRecord: 67  Chromosome: 6   Start: 154331631   End: 154568001
Timeout was reached: [www.ensembl.org:443] Operation timed out after 300001 milliseconds with 2100302 bytes receivedRecord: 68  Chromosome: 7   Start: 55086714   End: 55324313
Timeout was reached: [www.ensembl.org:443] Operation timed out after 300000 milliseconds with 1880233 bytes receivedRecord: 69  Chromosome: 7   Start: 87133175   End: 87342611
Record: 70  Chromosome: 7   Start: 99245817   End: 99277621
Record: 71  Chromosome: 7   Start: 99354604   End: 99381888
Record: 72  Chromosome: 7   Start: 117105838   End: 117356025
Record: 73  Chromosome: 7   Start: 150642049   End: 150675403
Record: 74  Chromosome: 9   Start: 86890372   End: 86955672
Record: 75  Chromosome: HG1293_PATCH   Start: 206534037   End: 206560450
Record: 76  Chromosome: HG344_PATCH   Start: 6949118   End: 6956557
Record: 77  Chromosome: HSCHR22_2_CTG1   Start: 42534642   End: 42539049
Record: 78  Chromosome: HSCHR6_MHC_APD   Start: 29845529   End: 29850151
Record: 79  Chromosome: HSCHR6_MHC_APD   Start: 30703731   End: 30706525
Record: 80  Chromosome: HSCHR6_MHC_APD   Start: 31788760   End: 31794206
Record: 81  Chromosome: HSCHR6_MHC_APD   Start: 31794605   End: 31797087
Record: 82  Chromosome: HSCHR6_MHC_APD   Start: 32052787   End: 32065237
Record: 83  Chromosome: HSCHR6_MHC_COX   Start: 29898587   End: 29903209
Record: 84  Chromosome: HSCHR6_MHC_COX   Start: 30685348   End: 30700375
Record: 85  Chromosome: HSCHR6_MHC_COX   Start: 31312134   End: 31315506
Record: 86  Chromosome: HSCHR6_MHC_COX   Start: 31418402   End: 31421036
Record: 87  Chromosome: HSCHR6_MHC_COX   Start: 31764773   End: 31770218
Record: 88  Chromosome: HSCHR6_MHC_COX   Start: 31770617   End: 31773099
Record: 89  Chromosome: HSCHR6_MHC_COX   Start: 31957379   End: 32033845
Record: 90  Chromosome: HSCHR6_MHC_COX   Start: 32475947   End: 32506554
Record: 91  Chromosome: HSCHR6_MHC_COX   Start: 32550273   End: 32557884
Record: 92  Chromosome: HSCHR6_MHC_DBB   Start: 29899000   End: 29903640
Record: 93  Chromosome: HSCHR6_MHC_DBB   Start: 30685747   End: 30700772
Record: 94  Chromosome: HSCHR6_MHC_DBB   Start: 31759586   End: 31765032
Record: 95  Chromosome: HSCHR6_MHC_DBB   Start: 31765431   End: 31767913
Record: 96  Chromosome: HSCHR6_MHC_DBB   Start: 31984751   End: 32061164
Record: 97  Chromosome: HSCHR6_MHC_DBB   Start: 32516731   End: 32550833
Record: 98  Chromosome: HSCHR6_MHC_DBB   Start: 32574291   End: 32596644
Record: 99  Chromosome: HSCHR6_MHC_DBB   Start: 32602484   End: 32612425
Record: 100  Chromosome: HSCHR6_MHC_MANN   Start: 29898024   End: 29902665
Record: 101  Chromosome: HSCHR6_MHC_MANN   Start: 30740183   End: 30755207
Record: 102  Chromosome: HSCHR6_MHC_MANN   Start: 31364707   End: 31368080
Record: 103  Chromosome: HSCHR6_MHC_MANN   Start: 32072022   End: 32105429
Record: 104  Chromosome: HSCHR6_MHC_MANN   Start: 32691166   End: 32725266
Record: 105  Chromosome: HSCHR6_MHC_MANN   Start: 32748724   End: 32771089
Record: 106  Chromosome: HSCHR6_MHC_MANN   Start: 32779140   End: 32788434
Record: 107  Chromosome: HSCHR6_MHC_MCF   Start: 29846763   End: 29992167
Record: 108  Chromosome: HSCHR6_MHC_MCF   Start: 30773972   End: 30787802
Record: 109  Chromosome: HSCHR6_MHC_MCF   Start: 31398032   End: 31401418
Record: 110  Chromosome: HSCHR6_MHC_MCF   Start: 31508507   End: 31509970
Record: 111  Chromosome: HSCHR6_MHC_MCF   Start: 32085376   End: 32161818
Record: 112  Chromosome: HSCHR6_MHC_MCF   Start: 32631439   End: 32652184
Record: 113  Chromosome: HSCHR6_MHC_MCF   Start: 32658022   End: 32667070
Record: 114  Chromosome: HSCHR6_MHC_QBL   Start: 29898417   End: 29903057
Record: 115  Chromosome: HSCHR6_MHC_QBL   Start: 30685021   End: 30700042
Record: 116  Chromosome: HSCHR6_MHC_QBL   Start: 31311768   End: 31315097
Record: 117  Chromosome: HSCHR6_MHC_QBL   Start: 31767647   End: 31773092
Record: 118  Chromosome: HSCHR6_MHC_QBL   Start: 31773491   End: 31775973
Record: 119  Chromosome: HSCHR6_MHC_QBL   Start: 31966588   End: 32011521
Record: 120  Chromosome: HSCHR6_MHC_QBL   Start: 32481203   End: 32511820
Record: 121  Chromosome: HSCHR6_MHC_QBL   Start: 32538584   End: 32544863
Record: 122  Chromosome: HSCHR6_MHC_QBL   Start: 32555534   End: 32563145
Record: 123  Chromosome: HSCHR6_MHC_SSTO   Start: 29897513   End: 29902154
Record: 124  Chromosome: HSCHR6_MHC_SSTO   Start: 30686935   End: 30701969
Record: 125  Chromosome: HSCHR6_MHC_SSTO   Start: 31314550   End: 31317907
Record: 126  Chromosome: HSCHR6_MHC_SSTO   Start: 31420864   End: 31423498
Record: 127  Chromosome: HSCHR6_MHC_SSTO   Start: 32000781   End: 32027628
Record: 128  Chromosome: HSCHR6_MHC_SSTO   Start: 32637568   End: 32670792
Record: 129  Chromosome: HSCHR6_MHC_SSTO   Start: 32697728   End: 32726026
Record: 130  Chromosome: HSCHR6_MHC_SSTO   Start: 32715138   End: 32722385
Timeout was reached: [www.ensembl.org:443] Operation timed out after 300000 milliseconds with 2072730 bytes receivedRecord: 131  Chromosome: X   Start: 122318006   End: 122624766

"
