#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) {
	msg <- "
	usage:
	  render-demo.R <demo> <package>
  
	This utility will render the code and figures from a given package as a PDF
	and place them into a directory called `<demo>-generated_files`. This requires
	knitr, rmarkdown and LaTeX to be installed on your system.
	
	Example:
	  render-demo.R epiflows-overview epiflows
	"
	stop(msg)
}
the_package <- args[2]
the_base <- args[1]
the_demo <- paste(the_base, "R", sep = ".")
overview <- system.file("demo", the_demo, package = the_package)
tmpdir <- tempdir()
tmp    <- file.path(tmpdir, the_demo)
file.copy(overview, tmp)
res <- knitr::spin(hair = tmp, format = "Rmd", knit = FALSE)
rmarkdown::render(res, output_format = rmarkdown::latex_fragment())
gf <- paste(the_base, "generated_files", sep = "-")
message("The files are in ", tmpdir)
# ans <- readline("Move these files to your current wd? [Y/n]")
# if (ans == "" || toupper(ans) == "Y") {
  files <- list.files(tmpdir, pattern = the_base, recursive = TRUE, full.names = TRUE)
  imgs  <- list.files(file.path(tmpdir, paste0(the_base, "_files")), recursive = TRUE, full.names = TRUE)
  dir.create(gf)
  file.copy(c(imgs, files), 
            file.path(gf, basename(c(imgs, files))))
# }

