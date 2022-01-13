
library(caret)
library(randomForest)

#### parsing data
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("USAGE: Rscript hw3_109258025.R --fold <K> --input input file --output out.csv", call.=FALSE)
}

for(i in (1:length(args))){
  
  if(args[i] == "--fold"){
    
    foldNum <- args[i + 1]
    
  }else if(args[i] == "--train"){
    
    train_file<- args[i + 1]
    
  }else if(args[i] == "--test"){
    
    test_file <- args[i+1]
    
  }else if(args[i] == "--report"){
    
    performance_path <- args[i+1]
    
  }else if(args[i] == "--predict"){
    
    predict_path<-args[i + 1]
  }
}

foldNum <- as.numeric(foldNum)


print(paste("N - Fold :", foldNum))
print(paste("Training Data:", train_file))
print(paste("Testing Data:", test_file))
print(paste("performance:", performance_path))
print(paste("prediction:", predict_path))




#####Data pre-process
data <- read.csv(train_file, header = TRUE)

###skewness
data$crim <- log(data$crim)


### corr

data <- data[c('lstat', 'rm', 'dis', 'crim', 'nox', 'indus', 'ptratio', 'age', 'tax','black','rad', 'medv')]
df <- data

### data split

fractionTraining   <- (foldNum- 2)/foldNum
fractionValidation <- 1/foldNum
fractionTest       <- 1/foldNum

sampleSizeTraining   <- floor(fractionTraining   * nrow(df))
sampleSizeValidation <- floor(fractionValidation * nrow(df))
sampleSizeTest       <- floor(fractionTest       * nrow(df))


dataspilt <- function(s){
  
  
  set.seed(s) 
  indicesTraining    <- sort(sample(seq_len(nrow(df)), size=sampleSizeTraining))
  indicesNotTraining <- setdiff(seq_len(nrow(df)), indicesTraining)
  indicesValidation  <- sort(sample(indicesNotTraining, size=sampleSizeValidation))
  indicesTest        <- setdiff(indicesNotTraining, indicesValidation)
  
  
  dfTraining   <- df[indicesTraining, ]
  dfValidation <- df[indicesValidation, ]
  dfTest       <- df[indicesTest, ]
  
  
  eachFold <- rbind(dfTraining, dfValidation, dfTest)
  return(eachFold)
}



####Training Model
foldNames <- c()
rmse_train <- c()
rmse_validate <- c()
rmse_test <- c()

for(k in 1:foldNum){
  
  foldNames <- c(foldNames,noquote(paste("fold", k)))
  
  train_data <- dataspilt(k)[(1:sampleSizeTraining), ]
  validate_data <- dataspilt(k)[(sampleSizeTraining + 1):(sampleSizeTraining + sampleSizeValidation), ]
  test_data <-  dataspilt(k)[(sampleSizeTraining + sampleSizeValidation +1):(sampleSizeTraining + sampleSizeValidation +sampleSizeTest), ]
  
  
  
 
  model <- train(medv~., data = train_data, method = "rf")
  
  
  pd_train <- predict(model, newdata = train_data)
  pd_validate <- predict(model, newdata = validate_data)
  pd_test <- predict(model, newdata = test_data)
  
 
  
  rmse_train_output <- RMSE(pd_train, train_data$medv)
  rmse_validate_output <- RMSE(pd_validate, validate_data$medv)
  rmse_test_output <- RMSE(pd_test, test_data$medv)
  
  
  
  rmse_train <- c(rmse_train, round(as.numeric(rmse_train_output), 2))
  rmse_validate <- c(rmse_validate, round(as.numeric(rmse_validate_output), 2))
  rmse_test <- c(rmse_test,round(as.numeric(rmse_test_output), 2))
  
}

####Performance Output 
performance_frame <- data.frame( set = foldNames, training = rmse_train, validation = rmse_validate, testing = rmse_test, stringsAsFactors =  FALSE)

average_func <- function(r){
  mean(r)
}
aves <- round(sapply(performance_frame[,c("training", "validation", "testing")], average_func), 2)

performance_frame <- rbind(performance_frame,c(as.character("ave."), array(aves)))

if( dir.exists(dirname(performance_path)) == TRUE){
  
  write.csv(performance_frame, file = performance_path, row.names = F, quote = F)
}else{
  dir.create(dirname(performance_path))
  write.csv(final_frame, file=out_path, row.names = F, quote = F)
}





### test data prediction
data_test <- read.csv(test_file, header = TRUE)

data_predict <- data_test[c('lstat', 'rm', 'dis', 'crim', 'nox', 'indus', 'ptratio', 'age', 'tax','black', 'rad')]

test_pd <- predict(model, newdata = data_predict)

out_frame <- data.frame('ID' =data_test$ID , medv = test_pd)



#### Prediction output


if( dir.exists(dirname(predict_path)) == TRUE){
  
  write.csv(out_frame, file = predict_path, row.names = F, quote = F)
}else{
  dir.create(dirname(predict_path))
  write.csv(out_frame, file = predict_path, row.names = F, quote = F)
}


