############################################################
#              *** VALIDATION ***                          #
#    MADE BY CHIH-LI and SIMON ON 9/19/2017                #
#    NOTE: PLOT CI WIDTH OF X-VELOCITY AT T = 15MS         #
#          (FIGURE 11)                                     #
############################################################

###     Step 0: setting
if(!dir.exists(paste0(output.folder.path, "/validation/CIwidth"))) # for storing the validation results
  dir.create(paste0(output.folder.path, "/validation/CIwidth"))

r <- 1  ## x-velocity
numCol <- 1000
colors <- matlab.like(numCol+1)

for(i in n.newx){
  Coordinate <- CommonCoord.new[[i]]
  for(tt in 1){  # time-step 500 = time 15ms 
    Range <- c(5, 60)
    png(paste0(output.folder.path, "/validation/CIwidth/i", i, "-t", tt, "-r", r, ".png"), width = 600, height = 800)
    par(mfrow=c(2,1))
    ### plot absolute prediction error
    # prediction flow
    Y.hat <- read.table(paste0(output.folder.path, "/prediction/newX", i, "/pred_", tt,'.dat'), header = TRUE)
    # true flow
    Y.true <- attach.big.matrix(paste0(output.folder.path, "/validation/", Response.ColumnIndex[r], "/Ytest_", i, ".dsc"))
    absdiff.y <- abs(Y.hat[,r+2] - Y.true[,tt])
    zcolor <- rep(0, nrow(Y.true))
    zcolor[absdiff.y < Range[1]] <-  colors[1]
    zcolor[absdiff.y > Range[2]] <-  colors[numCol+1]
    select.fg <- absdiff.y > Range[1] & absdiff.y < Range[2]
    zcolor[select.fg] <- colors[(absdiff.y[select.fg] - Range[1])/diff(Range)*numCol + 1] 
    plot(Coordinate[,1], Coordinate[,2], col = zcolor, pch=15, cex=1.2,
         xlab = 'x (m)', ylab = 'y (m)', main = paste0("Abs diff flow i", i, "-t", tt, "-r", r)) 
    colorlegend(col = colors, zlim=range(Range))
    
    ### plot pointwise CI width
    CI.width <- read.table(paste0(output.folder.path, "/prediction/newX", i, "/uq_", tt,'.dat'), header = TRUE)
    zcolor <- rep(0, nrow(CI.width))
    zcolor[CI.width[,r+2] < Range[1]] <-  colors[1]
    zcolor[CI.width[,r+2] > Range[2]] <-  colors[numCol+1]
    select.fg <- CI.width[,r+2] > Range[1] & CI.width[,r+2] < Range[2]
    zcolor[select.fg] <- colors[(CI.width[select.fg,r+2] - Range[1])/diff(Range)*numCol + 1] 
    plot(Coordinate[,1], Coordinate[,2], col = zcolor, pch=15, cex=1.2,
         xlab = 'x (m)', ylab = 'y (m)', main = paste0("CI width flow i", i, "-t", tt, "-r", r))
    colorlegend(col = colors, zlim=range(Range))
    dev.off()
  }
}
