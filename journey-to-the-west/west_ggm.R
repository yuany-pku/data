library(Libra)
library(igraph)
library(huge)
library(clime)
data(west10)

X <- as.matrix(2*west10-1);
obj = ggm(X,1,alpha = 0.01,nt=1000,trate=100)
g<-graph.adjacency(obj$path[,,720],mode="undirected",weighted=TRUE,diag=FALSE)
E(g)[E(g)$weight<0]$color<-"red"
E(g)[E(g)$weight>0]$color<-"green"
V(g)$name<-attributes(west10)$names
plot(g,vertex.shape="rectangle",vertex.size=35,vertex.label=V(g)$name,
edge.width=2*abs(E(g)$weight),main="GGM (LB): sparsity=0.51")

obj2<- huge(as.matrix(west10), method = "glasso")
obj2.select = huge.select(obj2,criterion = "ebic")
g2<-graph.adjacency(as.matrix(obj2.select$opt.icov),mode="plus",weighted=TRUE,diag=FALSE)
E(g2)[E(g2)$weight<0]$color<-"red"
E(g2)[E(g2)$weight>0]$color<-"green"
V(g2)$name<-attributes(west10)$names
plot(g2,vertex.shape="rectangle",vertex.size=35,edge.width=2*abs(E(g2)$weight),vertex.label=V(g2)$name,main="Graphical LASSO: sparsity=0.51")

obj3<- clime(as.matrix(west10),linsolver = "simplex")
g3<-graph.adjacency(as.matrix(obj3$Omegalist[[70]]),mode="plus",weighted=TRUE,diag=FALSE)
E(g3)[E(g3)$weight<0]$color<-"red"
E(g3)[E(g3)$weight>0]$color<-"green"
V(g3)$name<-attributes(west10)$names
plot(g3,vertex.shape="rectangle",vertex.size=35,edge.width=2*abs(E(g3)$weight),vertex.label=V(g3)$name,main="CLIME: sparsity=0.51")
