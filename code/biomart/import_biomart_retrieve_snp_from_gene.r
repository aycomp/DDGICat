library(biomaRt)
library(DBI)
con = NULL; resultset = NULL; data = NULL;
con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,"
            SELECT DISTINCT(chromosome_name || start_position || end_position), 
            	chromosome_name AS chr,	start_position AS start, end_position AS end
            FROM gene ORDER BY chr, start_position, end_position");

snpmart = useEnsembl(biomart = "snp", dataset="hsapiens_snp")

for (i in 1:nrow(data)){
    flag <- TRUE
    tryCatch({
      message("Chromosome: " || data$chr[i] || "  Start: " || data$start[i] || "  End: " || data$end[i])
      result  <- getBM(
        attributes=c( 'refsnp_id','refsnp_source', 'chr_name','chrom_start','chrom_end'), 
        filters = c('chr_name','start','end'), 
        values = list(data$chr[i], data$start[i], data$end[i]), 
        mart = snpmart,
        uniqueRows=TRUE)
      
      if(i < 2){
        dbWriteTable(con, "snp", result)  
      } else {
        dbWriteTable(con, "snp", result, append = TRUE, row.names = FALSE) }
      
    }, warning = function(cond) {
      flag<<-FALSE
      message(cond)
    }, error = function(cond) {
      flag<<-FALSE
      message(cond)
    }, finally={
      message(i)
    })
    if (!flag) next()
}
dbDisconnect(con)
