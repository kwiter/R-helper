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



