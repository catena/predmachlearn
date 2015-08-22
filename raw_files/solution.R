
source("scratch.R")

## for submission
testFile <- "data/pml-testing.csv"
testing <- read.csv(testFile, na.strings = c("NA", "#DIV/0!"))

solution <- predict(modelFit, newdata = testing)

pml_write_files = function(x) {
    n = length(x)
    for(i in 1:n){
        filename = paste0("soln/problem_id_",i,".txt")
        write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
    }
}
pml_write_files(solution)
