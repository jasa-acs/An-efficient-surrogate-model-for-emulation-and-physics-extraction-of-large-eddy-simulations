############################################################
#              *** VALIDATION ***                          #
#    MADE BY CHIH-LI and SIMON ON 9/19/2017                #
#    NOTE: PLOT COMPARISON FIGURE OF TEMPERATURE FLOW      #
#          AT TIME T = 21.75, 23.25 AND 24.75 MS           #
#          (FIGURE 7)                                      #
############################################################

###     Step 0: setting
if(!dir.exists(paste0(output.folder.path, "/validation/comparison"))) # for storing the validation results
  dir.create(paste0(output.folder.path, "/validation/comparison"))


r <- 5 # temperature
numCol <- 1000
colors <- matlab.like(numCol+1)

for(i in n.newx){
  Coordinate <- CommonCoord.new[[i]]
  for(tt in 2:4){  # time-step 725, 775, 825 = time 21.75ms, 23.25ms, 24.75ms 
    Range <- c(20, 280)
    png(paste0(output.folder.path, "/validation/comparison/i", i, "-t", tt, "-r", r, ".png"), width = 600, height = 400)
    Y.hat <- read.table(paste0(output.folder.path, "/prediction/newX", i, "/pred_", tt,'.dat'), header = TRUE)
    if(r == 4) Y.hat[,r+2] <- Y.hat[,r+2]*1e3   ## unit is different when r = pressure
    zcolor <- rep(0, nrow(Y.hat))
    zcolor[Y.hat[,r+2] < Range[1]] <-  colors[1]
    zcolor[Y.hat[,r+2] > Range[2]] <-  colors[numCol+1]
    select.fg <- Y.hat[,r+2] > Range[1] & Y.hat[,r+2] < Range[2]
    zcolor[select.fg] <- colors[(Y.hat[select.fg,r+2] - Range[1])/diff(Range)*numCol + 1] 
    Coordinate <- Y.hat[,1:2]
    plot(Coordinate[,1], Coordinate[,2], col = zcolor, pch=15, cex=1.2,
         xlab = 'x (m)', ylab = 'y (m)', main = paste0("Emulated (upper) and Simulated (lower) flow i", i, "-t", tt, "-r", r), 
         ylim = c(-max(Coordinate[,2]), max(Coordinate[,2]))) 
    
    Y.true <- attach.big.matrix(paste0(output.folder.path, "/validation/", Response.ColumnIndex[r], "/Ytest_", i, ".dsc"))
    zcolor <- rep(0, nrow(Y.true))
    zcolor[Y.true[,tt] < Range[1]] <-  colors[1]
    zcolor[Y.true[,tt] > Range[2]] <-  colors[numCol+1]
    select.fg <- Y.true[,tt] > Range[1] & Y.true[,tt] < Range[2]
    zcolor[select.fg] <- colors[(Y.true[select.fg,tt] - Range[1])/diff(Range)*numCol + 1] 
    points(Coordinate[,1], -Coordinate[,2], col = zcolor, pch=15, cex=1.2,
           xlab = 'x (m)', ylab = 'y (m)') 
    colorlegend(col = colors, zlim=range(Range))
    dev.off()
  }
}

