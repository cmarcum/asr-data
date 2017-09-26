######American Sociological Review 2007-2017 Dataset#######
#Dataset was imported "RAW" from WoS on 6/9/2017          #  
#Author: Christopher Steven Marcum <cmarcum@uci.edu>      #  
#Last modified: 9/26/2017                                 #
###########################################################


#Raw dataset was converted to DF object using the bibliometrix package
#Full DF is stored in r1.df object, raw data is in r1

#The allwk.sf object contains just the keyword columns (ID and DE)
# this has been cleaned of punctionuation and special characters 
# and put into lowercase.

load("ASR.Rdata")

#Initial cleaning missed weird hyphenations
allkw.sf<-gsub("-"," ",allkw.sf)

#Top 50 algorithm 

b1<-sort(table(allkw.sf),decreasing=TRUE)
b1<-b1[-which(names(b1)%in%c("united states","sociology"))]
b1[which(names(b1)%in%c("social networks")]<-sum(b1[which(names(b1)%in%c("networks","social networks"))])
b1[which(names(b1)=="social networks")]<-sum(b1[which(names(b1)%in%c("networks","social networks"))])
b1<-b1[-which(names(b1)=="networks")]
b1[which(names(b1)=="labor markets")]<-sum(b1[which(names(b1)%in%c("labor market","labor markets"))])
b1<-b1[-which(names(b1)=="labor market")]
b1<-sort(b1,decreasing=TRUE)
b1[which(names(b1)=="inequality")]<-sum(b1[which(names(b1)%in%c("inequality","income inequality"))])
b1<-b1[-which(names(b1)=="income inequality")]
b1<-sort(b1,decreasing=TRUE)
b1[which(names(b1)=="gender")]<-sum(b1[which(names(b1)%in%c("gender","women"))])
b1<-b1[-which(names(b1)=="women")]
b1[which(names(b1)=="work")]<-sum(b1[which(names(b1)%in%c("work","labor"))])
b1<-b1[-which(names(b1)=="labor")]
b1<-sort(b1,decreasing=TRUE)

#Check which falls in the top 98%, truncate to least-nearest tie in figure
ecdf(b1)(1:60)

png("asrkw.png",width=1200,height=900,res=100,pointsize=18)
par(mar=c(8,4,4,0))
barplot(b1[1:48],las=2,ylab="f(x)",main="Most Frequently Occurring Keywords from ASR Articles \n (recoded quantile 98.2%, published 2007-2017)",ylim=c(0,100),col=rep(c("cornflowerblue","coral"),24))
dev.off()

#Extra fun stuff depends on network and bibliometrix packages
#Extract collaboration network
library(bibliometrix)
library(network)

g2<-cocMatrix(r1.df,type="matrix")
g2.net<-as.network(t(g2)%*%g2,directed=FALSE)
set.vertex.attribute(g2.net,"vertex.names",colnames(g2))
set.edge.value(g2.net,"freq",t(g2)%*%g2)

#Now, induce subgraphs from each component, dropping isolates
# ten were randomly spot-checked in WoS and were accurate
TheIsos<-(g2.net%v%"vertex.names")[isolates(g2.net)]
delete.vertices(g2.net,isolates(g2.net))
	
g2.comps<-list()
nc<-components(g2.net)
g2.cd<-component.dist(g2.net)
g2.net%v%"color"<-rainbow(nc)[g2.cd$membership]

for(i in 1:nc){
 g2.comps[[i]]<-get.inducedSubgraph(g2.net,v=which(g2.cd$membership%in%i))
}

g2.cg2<-g2.comps[order(sapply(g2.comps,network.size),decreasing=TRUE)]

#Write out the pdf
pdf("ASRNets.pdf",width=12,height=10,pointsize=12)
par(mar=c(1.75,1.75,1.75,1.75),xpd=TRUE)
gplot(g2.net,vertex.col=g2.net%v%"color",usearrows=FALSE)
par(mfrow=c(mfrow=c(2,2)))
gplot(g2.cg2[[1]],vertex.col=g2.cg2[[1]]%v%"color",usearrows=FALSE,displaylabels=TRUE,edge.col="gray")
gplot(g2.cg2[[2]],vertex.col=g2.cg2[[2]]%v%"color",usearrows=FALSE,displaylabels=TRUE,edge.col="gray")
gplot(g2.cg2[[3]],vertex.col=g2.cg2[[3]]%v%"color",usearrows=FALSE,displaylabels=TRUE,edge.col="gray")
gplot(g2.cg2[[4]],vertex.col=g2.cg2[[4]]%v%"color",usearrows=FALSE,displaylabels=TRUE,edge.col="gray")
par(mfrow=c(1,1))
for(i in 1:length(g2.cg2[which(sapply(g2.cg2,network.size)>4)])){
gplot(g2.cg2[[i]],vertex.col=g2.cg2[[i]]%v%"color",usearrows=FALSE,displaylabels=TRUE,edge.col="gray")
}
par(mfrow=c(6,4),xpd=TRUE)
for(i in 1:length(g2.cg2[which(sapply(g2.cg2,network.size)==4)])){
gplot(g2.cg2[which(sapply(g2.cg2,network.size)==4)][[i]],vertex.col=g2.cg2[which(sapply(g2.cg2,network.size)==4)][[i]]%v%"color",usearrows=FALSE,displaylabels=TRUE,edge.col="gray")
}

par(mfrow=c(6,7),xpd=TRUE)
for(i in 1:length(g2.cg2[which(sapply(g2.cg2,network.size)==3)])){
gplot(g2.cg2[which(sapply(g2.cg2,network.size)==3)][[i]],vertex.col=g2.cg2[which(sapply(g2.cg2,network.size)==3)][[i]]%v%"color",usearrows=FALSE,displaylabels=TRUE,edge.col="gray")
}

par(mfrow=c(10,9),xpd=TRUE)
for(i in 1:length(g2.cg2[which(sapply(g2.cg2,network.size)==2)])){
gplot(g2.cg2[which(sapply(g2.cg2,network.size)==2)][[i]],vertex.col=g2.cg2[which(sapply(g2.cg2,network.size)==2)][[i]]%v%"color",usearrows=FALSE,displaylabels=TRUE,edge.col="gray")
}

dev.off()

#Next two lines of code assume one has command line privs and 
# pdftk + imagemagick installed
system("pdftk ASRNets.pdf burst")
system("convert -alpha off -delay 80 pg_*.pdf asra.gif")
savehistory("ARS.R")
