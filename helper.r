#### NOT IN

'%!in%' <- function(x,y)!('%in%'(x,y)) #not in

#### random section of matrix random version of head() or tail()

rand <- function(matrix,n=6){ # random version of head
  seed <- sample(1:dim(matrix)[1],1)
  xx <- matrix[seed:(seed+n),]
  rownames(xx) <- seed:(seed+n)
  xx
} 

############### apply tapply to a matrix
tapply.matrix <- function(mat,index,funct){ #tapply on matrix mckFUNCTIONS
  apply(mat,2,function(x){ tapply(x,index,funct,na.rm=T)})  
}

#short as .numeric
a.n <- function(x){as.numeric(x)}#short as.numeric

#short as.character
a.c <- function(x){as.character(x)}#short as.character

##shorten Length
len <- function(x){length(x)}

#return last value
last <- function(vec){rev(vec)[1]}

#split vector string and return matrix
unlistSplit = function(vec,sep="-"){
  matrix(unlist(strsplit(vec,split=sep)),nrow = length(vec),ncol=str_count(vec[1],sep)+1,byrow=T)
}

#turns ones to zeros zeros to ones
invert <- function(x){
  whr = which(x == 1)
  x[x == 0] = 1
  x[whr] = 0
  x
}

#proper predictive score
getScoreNorm <- function(x,mu,xvar){
  # Gneiting and Raferty's proper scoring rule
  # outcome x, prediction mean and variance (mu, xvar)
  #higher scores are better
  - ( (x - mu)^2)/xvar - log(xvar)
}

#
# Splining a polygon.
#
#   The rows of 'xy' give coordinates of the boundary vertices, in order.
#   'vertices' is the number of spline vertices to create.
#   'k' is the number of points to wrap around the ends to obtain
#       a smooth periodic spline.
#
#   Returns an array of points. 
# 
spline.poly <- function(xy, vertices, k=3, ...) {
  # Assert: xy is an n by 2 matrix with n >= k.
  
  # Wrap k vertices around each end.
  n <- dim(xy)[1]
  if (k >= 1) {
    data <- rbind(xy[(n-k+1):n,], xy, xy[1:k, ])
  } else {
    data <- xy
  }
  
  # Spline the x and y coordinates.
  data.spline <- spline(1:(n+2*k), data[,1], n=vertices, ...)
  x <- data.spline$x
  x1 <- data.spline$y
  x2 <- spline(1:(n+2*k), data[,2], n=vertices, ...)$y
  
  # Retain only the middle part.
  cbind(x1, x2)[k < x & x <= n+k, ]
}

#distance between (x,y) and (x,y) matrix
distance = function(valM,M){
  
  sqrt((M[,1]-valM[1])^2 + (M[,2]-valM[2])^2) 
  
}

#angle in degrees between (x,y) and (x,y) matrix from the x-axis -90 to 90 and indicators(tx,ty) of quadrants
angleTo <- function(valM,M){ #output in degrees
  #valM: (x,y) angles calculated from
  #M: (x,y) matrix angles calculated to
  #output:
    #ang: angle in degrees
    #tx -1 or 1 = left of valM or right of valM
    #ty -1 or 1 = below valM or above valM
  tx = M[,1]-valM[1]
  ty = M[,2]-valM[2]
  ang = atan(ty/tx) * 360/(2*pi)
  tx = (tx > 0) - (tx < 0) 
  ty = (ty > 0) - (ty < 0) 
  list(ang = ang,tx=tx,ty=ty)
}

#calculate the a quantile in 2D at binned angles from the median
spatialQuant = function(xyMat,nbrks = 10,quants = c(.025,.975)){
#xyMat: matrix of [x,y]
#nbrks: number of breaks to split angle up by
#quants: c(lower,upper) quantile to use
  stdX = sd(xyMat[,1],na.rm=T)
  stdY = sd(xyMat[,2],na.rm=T)
  
  
  xyMat[,1] = (xyMat[,1]) /stdX
  xyMat[,2] = (xyMat[,2]) /stdY
  
  mx = median(xyMat[,1])
  my = median(xyMat[,2])
  
  tmp = angleTo(c(mx,my),xyMat)
  angs = tmp$ang
  tx = tmp$tx
  ty = tmp$ty
  quad = rep(0,len(tx))
  quad[tx ==  1 & ty ==  1] = 1
  quad[tx ==  1 & ty == -1] = 1
  quad[tx == -1 & ty == -1] = -1
  quad[tx == -1 & ty ==  1] = -1
  
  dis = distance(c(mx,my),xyMat)
  
  
  breaks <- seq(-90,90,length = nbrks)
  bins <- cut(angs,breaks = breaks)
  
  iBin = sort(unique(bins))
  tmp = matrix(NA,len(iBin),3)
  tmp[,1] = breaks[-1] - diff(breaks)[1]/2
  for(i in 1:len(iBin)){
    whr = which(bins == iBin[i])
    tmp[i,c(2,3)] = quantile(dis[whr] * quad[whr],quants)
  }
  xs = (cos(c(tmp[,1],tmp[,1])*2*pi/360)*c(tmp[,2],tmp[,3]) + mx)*stdX 
  ys = (sin(c(tmp[,1],tmp[,1])*2*pi/360)*c(tmp[,2],tmp[,3]) + my)*stdY 
  cbind(xs,ys)
}


###Fuzzy MATCH 
fuzWHICH <- function(DFwant, DFref){  #Fuzzy match
#DFwant: value to match
#DFref: values to match to
  if(length(DFwant) == 1){
    whichTIME <- which((abs(DFwant - DFref)) == min(abs(DFref - DFwant))) 
    out = whichTIME[1]
  }else{
    out = numeric()
    for(i in 1:length(DFwant)){
    out <- c(out,which((abs(DFwant[i] - DFref)) == min(abs(DFref - DFwant[i])))[1]) 
    out
    }
  }
  return(out)
}
##


#####
#### this function returns the index of max ormin 'which.max' number needs to be middle of odd roll num
localMS <- function(inDATA,period,MorM ='MAX'){ #find local min or max
	#inDATA: data
	#period give time period to find extrem values
	#MorM: find MIN or MAX
	require(zoo)
	if(period%%2 == 0)stop('Period must be odd')
	useDATA <- c(inDATA,rep(mean(inDATA,na.rm=T),period))
	if(MorM == 'MAX'){xz <- as.zoo(useDATA)
		rxz <- rollapply(xz, period, function(useDATA) which.max(useDATA)==quantile(1:period,.5))
		}
	if(MorM == 'MIN'){xz <- as.zoo(useDATA)
		rxz <- rollapply(xz, period, function(useDATA) which.min(useDATA)==quantile(1:period,.5))
		}
	
	index(rxz)[coredata(rxz)] 
}

######## turns in z-scores, use 2 stds to compare between covariates and factors(Gelman)

zScore <- function(xXx,numSTDS = 1){ #z-scores mckFUNCTIONS
  #xXx: matrix or vector to be converted
  #numSTDS: number of stds 
  dimxXx = length(dim(rep(1,10)))
  if(dimxXx == 0){ cen <- xXx - mean(xXx,na.rm=T) 
    if(numSTDS != 0){ cen <- cen/(numSTDS*sd(xXx,na.rm=T)) }
  }
  if(dimxXx > 1){
    xmean <- apply(xXx,2,mean,na.rm=T) 
    xsd <- numSTDS*apply(xXx,2,sd,na.rm=T)
    cen <- (xXx - matrix(xmean,nrow(xXx),ncol(xXx),byrow=T) )
    if(numSTDS != 0){
      cen <- cen/(matrix(xsd,nrow(xXx),ncol(xXx),byrow=T) )
    }
  }
  cen
} 

###
##factor to a dummy variable
facTOdummy <- function(fact, firstZERO = T){ #makes dummy variables
  #fact: factor
  #firstZERO: make the first factor zero if factor has four levels 3 columns are created
  if(firstZERO == T){
  is <- sort(unique(fact))
  numIS <- length(is)
  dumbMAT <- matrix(0,length(fact),(numIS-1))
  
  for(i in 2:numIS){
    dumbMAT[which(fact == is[i]),i-1] <- 1
  }
  colnames(dumbMAT) <- is[-1]
  }
  
  if(firstZERO == F){
    is <- sort(unique(fact))
    numIS <- length(is)
    dumbMAT <- matrix(0,length(fact),(numIS))
    
    for(i in 1:numIS){
      dumbMAT[which(fact == is[i]),i] <- 1
    }
    colnames(dumbMAT) <- is
  }
  
  dumbMAT
}

#####find mode
my.mode <- function(x) { #find mode
  #x: data
  d <- density(x)
  d$x[which.max(d$y)]
}

#####progress bar
progress = function(count, total = null, interval = 1){ #progress bar
  #count: counter of loop
  #total: number when loop completes
  #interval: interval to update counter
  width = getOption("width")/2 - 4
  if(count%%interval == 0){
    Ltotal = nchar(total)
    Lcount = nchar(count)
    cat("\r",paste(count, rep(" ",Ltotal-Lcount),
                   " [",
                   paste(rep("~",floor(width*count/total)),collapse = ""),
                   paste(rep(" ",ceiling(width*(1-(count/total)))),collapse = ""),
                   "] ",round(100*count/total,2),"%",sep=""))
    flush.console()
  }
  if(count == total){cat("\n Complete \n")}
}

