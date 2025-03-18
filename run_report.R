# run_report.R
start_time <- Sys.time()

setwd("/Users/mattcolao/Documents/unemployment-analysis")
readRenviron(".Renviron")

library(rmarkdown)
library(git2r)
library(fredr)

tryCatch(
  {
    if (!dir.exists("reports")) dir.create("reports")
    output_file <- paste0("reports/NJ_Unemployment_", Sys.Date(), ".html")
    rmarkdown::render("NJ_UnemploymentRate.Rmd", output_file = output_file)
    
    # Git operations
    repo <- repository(".")
    add(repo, ".")  # Stage ALL files
    commit(repo, message = paste("Automated report update:", Sys.Date()))
    
   
    # Log success
    cat(paste(Sys.time(), "Success\n"), file = "automation.log", append = TRUE)
  },
  error = function(e) {
    cat(paste(Sys.time(), "ERROR:", e$message, "\n"), file = "automation.log", append = TRUE)
  }
)
system("git add reports/NJ_Unemployment_$(date +%Y-%m-%d).html")
system("git commit -m 'Automated update for unemployment report on $(date +%Y-%m-%d)'")
system("git push origin main")
end_time <- Sys.time()
runtime <- end_time - start_time
cat("Report generation runtime:", runtime, "\n")
upload_start <- Sys.time()
system("git push origin main")
upload_end <- Sys.time()
upload_time <- upload_end - upload_start
cat("Upload time:", upload_time, "\n")

