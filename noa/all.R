library('readxl')


#if "missing" then that means totcheck didnt have a value
#if * that means the rows didnt add up to totcheck
checkN = function(im){
  rows = rowSums(im[, 8:16], na.rm=TRUE)
  im$invalidN = -1
  for (i in 1:length(rows)){
    if (is.na(im$Totcheck[i])){
      im$invalidN[i] = "missing"
    }
    else if (rows[i] != im$Totcheck[i]){
      im$invalidN[i] = "*"
    }
  }
  return(im)
}

findDupcliates = function(im){
  #checks to see if the dates are sorted
  #assuming duplicates occur if the dates are the same
  im$Date = as.Date(im$Date)
  sum(im$Date == sort(im$Date)) == length(im$Date)
  
  #possdups is a list with the indices of the rows that have the same date
  possDups = which(duplicated(im[c('Date')]),) 
  
  im$duplicate = -1
  
  #for loop goes through and sees which values  are not the same for the ones with the same date
  #for example - if it says varname that means house and N  are the same but varnames differs
  #if the value for im$duplicate is a number that isn't -1 then all three values are the same
  for (i in 1:length(possDups)){
    same = 0
    
    differences = c()
    
    if (im$Varname[possDups[i]] == im$Varname[possDups[i] - 1]){
      same = same + 1
    }
    else {
      differences = c(differences, "varname")
    }
    
    if (im$House[possDups[i]] == im$House[possDups[i] - 1]){
      same = same + 1
    }
    else{
      differences = c(differences, "house")
    }
    
    if (im$N[possDups[i]] == im$N[possDups[i] - 1]){
      same = same + 1
    }
    else{
      differences = c(differences, "size")
    }
    
    if (same == 3){
      im$duplicate[possDups[i]] = possDups[i] - 1
    }
    else {
      #print(paste(differences),  collapse=',' )
      im$duplicate[possDups[i]] = paste(differences,  collapse=',' )
    }
  }
  return(im)
}


im = read_excel("CleanPolling/Mood2014_by_issue.xlsx", "immigration") 
im = checkN(im)
im = findDupcliates(im)

ssm = read_excel("CleanPolling/Mood2014_by_issue.xlsx", "ssm") 
ssm = checkN(ssm)
ssm = findDupcliates(ssm)

gc = read_excel("CleanPolling/Mood2014_by_issue.xlsx", "guncontrol") 
gc = checkN(gc)
gc = findDupcliates(gc)

dp = read_excel("CleanPolling/Mood2014_by_issue.xlsx", "deathpenalty") 
dp = checkN(dp)
dp = findDupcliates(dp)

