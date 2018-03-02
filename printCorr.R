############################################################
#              *** VALIDATION ***                          #
#    MADE BY CHIH-LI and SIMON ON 9/19/2017                #
#    NOTE: PRINT SIGNIFICANT CORRELATIONS AT T = 15MS      #
#          (FIGURE 14)                                     #
############################################################

getResp <- function(r){
  if (r == 1){
    return("u")
  }
  else if (r == 2){
    return("v")
  }
  else if (r == 3){
    return("w")
  }
  else if (r == 4){
    return("P")
  }
  else if (r == 5){
    return("T")
  }
  else{
    return("rho")
  }
}

getMode <- function(r){
  bool <- T;
  cs <- cumsum(K)
  nn <- length(K)
  ii <- 1 #This will be the response
  while ((bool) && (ii<=nn)){
    if (r > cs[ii]){
      ii = ii + 1
    }else{
      bool = F
    }
  }
  #Mode number
  if (ii == 1){
    num <- r
  }else{
    num <- r - cs[ii-1] 
  }
  return(list(ii, num))
}


tt <- 1  # time-step 500 = time 15ms 
load(paste0(output.folder.path, "/estimation/allparams_t", tt, ".RData"))
idxnz <- params$idxnz
for (k in 1:nrow(idxnz)){
  tmp1 <- getMode(idxnz[k,1])
  tmp2 <- getMode(idxnz[k,2])
  if (tmp1[[1]] != tmp2[[1]] & tmp2[[2]] <= 3 & tmp1[[2]] <= 3){    ### only print first 3 modes
    print( paste0( getResp(tmp1[[1]])," - Mode ",tmp1[[2]],
                   " <=> ",
                   getResp(tmp2[[1]])," - Mode ",tmp2[[2]] ) )
  }
}
