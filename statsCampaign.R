
library(sf)
library(ggplot2)
library(gridExtra)    

# load points sampled from the different buffer distances and the poisson process
p5km <- read_sf('output/campaign/pc_5km_cur.gpkg')
p5km$radius <- "5 km"
p10km <- read_sf('output/campaign/pc_10km_cur.gpkg')
p10km$radius <- "10 km"
p20km <- read_sf('output/campaign/pc_20km_cur.gpkg')
p20km$radius <- "20 km"
ppoisson <- read_sf('output/campaign/random_100k_cur.gpkg')
ppoisson$radius <- "null hypothesis"

# reorder radius
pall <- rbind(p5km, p10km, p20km, ppoisson)   
pall$radius <- factor(pall$radius, levels=c("null hypothesis", "5 km", "10 km", "20 km"))

# show mean connectivity values 
aggregate(pall$tarraco_c~factor(pall$radius), FUN=mean)
aggregate(pall$emporion_c~factor(pall$radius), FUN=mean)     
aggregate(pall$massalia_c~factor(pall$radius), FUN=mean)     

## permutation test for 20km radius

# sample the poisson distribution to define 1000 datasets with the same size than the point dataset within 20 km of PC
nRuns <- 1000
run=rep(1:nRuns,each=nrow(p20km))

# massalia 
# for each of these points sample the connectivity from massalia
value=sample(ppoisson$massalia_c,replace=T, size=nRuns*nrow(p20km))
permutationTest=data.frame(run=run,value=value)

# compute mean value for each of the 1000 samples
aggMassalia <- aggregate(permutationTest$value~factor(permutationTest$run), FUN=mean)     
# compare highest 1% quantile of this poisson process vs mean connectivity value within 20 km of PC
quantile(aggMassalia$permutationTest, 0.99)
mean(p20km$massalia_c)
# expected result: ~ 96.59 for 1% quantile vs 129.69 for 20km radius from PC

# tarraco 
# for each of these points sample the connectivity from massalia
value=sample(ppoisson$tarraco_c,replace=T, size=nRuns*nrow(p20km))
permutationTest=data.frame(run=run,value=value)
# compute mean value for each of the 1000 samples
aggTarraco <- aggregate(permutationTest$value~factor(permutationTest$run), FUN=mean)     
# compare highest 1% quantile of this poisson process vs mean connectivity value within 20 km of PC
quantile(aggTarraco$permutationTest, 0.99)
mean(p20km$tarraco_c)    
# estimated result: ~ 6.26 for 1% quantile vs 3.89 for 20km radius from PC

# emporion    
# for each of these points sample the connectivity from massalia
value=sample(ppoisson$emporion_c,replace=T, size=nRuns*nrow(p20km))
permutationTest=data.frame(run=run,value=value)
# compute mean value for each of the 1000 samples
aggEmporion <- aggregate(permutationTest$value~factor(permutationTest$run), FUN=mean)
# compute mean value for each of the 1000 samples
quantile(aggEmporion$permutationTest, 0.99)
mean(p20km$emporion_c)
# estimated result: ~ 12.50 for 1% quantile vs 37.40 for 20km radius from PC


# box and whiskers plot comparing distributions

# get normalized values 0-1
pall$massalia_c_norm <-(pall$massalia_c-min(pall$massalia_c, na.rm=T))/(max(pall$massalia_c, na.rm=T)-min(pall$massalia_c, na.rm=T))
pall$tarraco_c_norm <-(pall$tarraco_c-min(pall$tarraco_c, na.rm=T))/(max(pall$tarraco_c, na.rm=T)-min(pall$tarraco_c, na.rm=T))
pall$emporion_c_norm <-(pall$emporion_c-min(pall$emporion_c, na.rm=T))/(max(pall$emporion_c, na.rm=T)-min(pall$emporion_c, na.rm=T))

### massalia 
massalia <- ggplot(pall, aes(x=radius, y=massalia_c_norm, fill=radius)) + geom_boxplot(outlier.shape=NA) + theme_bw() + xlab("radius") + ylab("connectivity") + ggtitle("Massalia-Ilerda") + theme(legend.position="none") + scale_fill_manual(name=element_text('sample'), values=c("indianred2","palegreen4","goldenrod2","skyblue3"))
# the extreme of the upper whisker will be the limit of the Y axis times 1.05
ylim1 = boxplot.stats(pall$massalia_c_norm)$stats[c(1, 5)]
# scale y limits based on ylim1
massalia = massalia  + coord_cartesian(ylim = ylim1*1.05)

### tarraco
tarraco <- ggplot(pall, aes(x=radius, y=tarraco_c_norm, fill=radius)) + geom_boxplot(outlier.shape=NA) + theme_bw() + xlab("radius") + ylab("connectivity") + ggtitle("Tarraco-Ilerda") + theme(legend.position="none") + scale_fill_manual(name=element_text('sample'), values=c("indianred2","palegreen4","goldenrod2","skyblue3"))
# the extreme of the upper whisker will be the limit of the Y axis times 1.05
ylim1 = boxplot.stats(pall$tarraco_c_norm)$stats[c(1, 5)]
# scale y limits based on ylim1
tarraco = tarraco  + coord_cartesian(ylim = ylim1*1.05)

### emporion
emporion <- ggplot(pall, aes(x=radius, y=emporion_c_norm, fill=radius)) + geom_boxplot(outlier.shape=NA) + theme_bw() + xlab("radius") + ylab("connectivity") + ggtitle("Emporion-Ilerda") + theme(legend.position="none") + scale_fill_manual(name=element_text('sample'), values=c("indianred2","palegreen4","goldenrod2","skyblue3"))
# the extreme of the upper whisker will be the limit of the Y axis times 1.05
ylim1 = boxplot.stats(pall$emporion_c_norm)$stats[c(1, 5)]
# scale y limits based on ylim1
emporion = emporion  + coord_cartesian(ylim = ylim1*1.05)

pdf("campaign_stats.pdf", width=4, height=6)
grid.arrange(massalia, tarraco, emporion, ncol=1)
dev.off()

