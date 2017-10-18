args=commandArgs(trailingOnly=TRUE)
if (args[1] %in% c("-h", "--help")) {
  message("
Script that converts txt tables to LaTeX tables

Usage: 

Rscript txtTable.R input [output] [header] [caption] [label]
- input: path of the input txt file formatted with tabs
- output: path of the output tex file (default is 'tab.tex')
- header: t/true or f/false if table has headers(default true)
- caption: caption of the table (default is omitted)
- label: label for the table (default is omitted)
          
Rscript txtTable.R -h
Shows this help

Rscript txtTable.R --help
Shows this help          
")
  } else {
  outputFile="tab.tex"
  if (length(args)==0) {
    stop("At least one argument must be supplied (input file)", call.=FALSE)
  } else if (length(args)>1) {
    outputFile=args[2]
  }
  inputFile=args[1]
  headerText=args[3]
  h=TRUE
  if (toupper(headerText) %in% c("F","FALSE"))
	h=FALSE
  inputTable=read.delim(inputFile, header = h, sep = "\t", dec=".")
  library(xtable)

  addtorow=list()
  addtorow$pos=list()
  addtorow$pos[[1]]=c(0)
  addtorow$command=c(paste("\\hline \n",
                           "\\endhead \n",
                           "\\hline \n",
                           "{\\footnotesize Continued on next page} \n",
                           "\\endfoot \n",
                           "\\endlastfoot \n",sep=""))

  if (length(args)==5) {
    print(xtable(inputTable, type = "latex", caption=args[4], label=args[5]),
          tabular.environment="longtable", floating = FALSE, file=outputFile,
	  include.rownames = FALSE, add.to.row = addtorow, hline.after=c(-1))
  }else if (length(args)==4) {
    print(xtable(inputTable, type = "latex", caption=args[4]),
          tabular.environment="longtable", floating = FALSE, file=outputFile,
	  include.rownames = FALSE, add.to.row = addtorow, hline.after=c(-1))
  } else {
    print(xtable(inputTable, file=outputFile), tabular.environment="longtable", 
	floating = FALSE, file = outputFile, include.rownames = FALSE, 
        add.to.row = addtorow, hline.after=c(-1))
  }
}
