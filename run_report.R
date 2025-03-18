# run_report.R
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
    
    # Push via SSH
    system("eval \"$(ssh-agent -s)\"")
    system("ssh-add ~/.ssh/id_ed25519")
    push(repo, credentials = cred_user_pass("", ""))  # Empty strings for SSH
    
    # Log success
    cat(paste(Sys.time(), "Success\n"), file = "automation.log", append = TRUE)
  },
  error = function(e) {
    cat(paste(Sys.time(), "ERROR:", e$message, "\n"), file = "automation.log", append = TRUE)
  }
)