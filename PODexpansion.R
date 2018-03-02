##########################################################
#                *** POD EXPANSION ***                   #
#    MADE BY CHIH-LI and SIMON ON 9/19/2017              #
#    NOTE: PLEASE READ THE APPENDIX A.2 POD expansion    #
##########################################################

cat("POD expansion ...\n")
###     Step 0: setting
if(!dir.exists(paste0(output.folder.path, "/POD_expansion"))) # for storing the POD modes and coefficients 
  dir.create(paste0(output.folder.path, "/POD_expansion"))
for(r in 1:R){
  if(!dir.exists(paste0(output.folder.path, "/POD_expansion/", Response.ColumnIndex[r])))
    dir.create(paste0(output.folder.path, "/POD_expansion/", Response.ColumnIndex[r]))
}
K <- rep(0, R)  # record the number of modes

for(r in 1:R){
  response.index <- Response.ColumnIndex[r]
  cat("   response.index = ", response.index, "\n")
  ###     Step 1: compute inner-product matrix
  ###            See Appendix A.2.1.
  Q <- foreach(count = 1:n^2, .combine = "+", .packages = c("bigmemory", "InjectorEmulationHelper")) %dopar% {
    Q.tmp <- matrix(0, nrow = N, ncol = N)
    i <- ceiling(count/n)
    j <- count %% n
    if(j == 0) j <- n
    if(j >= i){
      # computing inner product
      Yi <- attach.big.matrix(paste0(output.folder.path, "/flow_commongrid/", response.index, "/Y_", i, ".dsc"))
      Yj <- attach.big.matrix(paste0(output.folder.path, "/flow_commongrid/", response.index, "/Y_", j, ".dsc"))
      Q.tmp[((i-1)* TT + 1) : (i * TT),
            ((j-1) * TT + 1) : (j * TT)] <- bigInnerProd2(Yi@address,Yj@address)
      if(i != j) Q.tmp[ ((j-1)* TT + 1):(j * TT),
                        ((i-1) * TT + 1):(i * TT)] <- t(Q.tmp[ ((i-1)* TT + 1) : (i * TT), ((j-1) * TT + 1) : (j * TT) ])
    }
    return(Q.tmp)
  }

  ### Eigendecomposition: we employed a variant of the implicitly restarted Arnoldi method
  ### (Lehoucq et al., 1998), which can efficiently approximate leading eigenvalues and eigenvectors.
  if(N > 5000) eigensystem <- eigs_sym(Q, round(ncol(Q)/10))
  else         eigensystem <- eigen(Q)
  ### trucate at energy at POD.energy
  energy <- cumsum(eigensystem$values) / sum(diag(Q))
  Kr <- min(which(energy - POD.energy > 0))
  K[r] <- Kr
  cat("   ", Kr, "modes are needed to capture", POD.energy * 100, "% of the total flow energy\n")
  
  ###     Step 2: compute POD modes
  ###             See Appendix A.2.2.

  mode.phi <- foreach(i = 1:n, .combine = "+", .packages = "bigmemory") %dopar% {
    Yi  <- attach.big.matrix(paste0(output.folder.path, "/flow_commongrid/", response.index, "/Y_", i, ".dsc"))
    return(Yi[] %*% eigensystem$vector[((i-1) * TT + 1):(i * TT), 1:Kr])
  }
  mode.phi <- t(t(mode.phi) / apply(mode.phi, 2, FUN = function(x) sqrt(sum(x^2))))  # Normalization
  save(mode.phi, file = paste0(output.folder.path, "/POD_expansion/", response.index, "/mode.phi.RData"))
  
  ###     Step 3: compute POD coefficients
  ###             See Appendix A.2.3.
  # store mode.phi by bigmemory for computational ease
  Phi  <- as.big.matrix(mode.phi, 
                        backingpath = paste0(output.folder.path, "/POD_expansion/", response.index), 
                        backingfile = "mode.phi.bck",
                        descriptorfile = "mode.phi.dsc")
  mode.B <- foreach(i = 1:n, .combine = rbind, .packages = c("bigmemory", "InjectorEmulationHelper")) %dopar% {
    Yi  <- attach.big.matrix(paste0(output.folder.path, "/flow_commongrid/", response.index, "/Y_", i, ".dsc"))
    phi <- attach.big.matrix(paste0(output.folder.path, "/POD_expansion/", response.index, "/mode.phi.dsc"))
    return(bigInnerProd2(Yi@address, phi@address))
  }
  # remove the bigmemory files of mode.phi
  unlink("Phi")
  remove.out <- file.remove(paste0(output.folder.path, "/POD_expansion/", response.index, c("/mode.phi.bck", "/mode.phi.dsc")))

  save(mode.B, file = paste0(output.folder.path, "/POD_expansion/", response.index, "/mode.B.RData"))
}
cat("\n")