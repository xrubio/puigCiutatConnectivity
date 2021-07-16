
library(sf)
library(ggplot2)
library(gridExtra)    

# load points sampled from the different buffer distances and the poisson process
p5km <- read_sf('../campaign/sampling/pc_5km.shp')
p5km$radius <- "5 km"
p10km <- read_sf('../campaign/sampling/pc_10km.shp')
p10km$radius <- "10 km"
p20km <- read_sf('../campaign/sampling/pc_20km.shp')
p20km$radius <- "20 km"
ppoisson <- read_sf('../campaign/sampling/random_100k.shp')
ppoisson$radius <- "random"

# reorder radius
pall <- rbind(p5km, p10km, p20km, ppoisson)
pall$radius <- factor(pall$radius, levels=c("random", "5 km", "10 km", "20 km"))

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
# expected result: ~ 94.45 for 1% quantile vs 104.4 for 20km radius from PC

# tarraco 
# for each of these points sample the connectivity from massalia
value=sample(ppoisson$tarraco_c,replace=T, size=nRuns*nrow(p20km))
permutationTest=data.frame(run=run,value=value)
# compute mean value for each of the 1000 samples
aggTarraco <- aggregate(permutationTest$value~factor(permutationTest$run), FUN=mean)     
# compare highest 1% quantile of this poisson process vs mean connectivity value within 20 km of PC
quantile(aggTarraco$permutationTest, 0.99)
mean(p20km$tarraco_c)    
# estimated result: ~ 6.34 for 1% quantile vs 4.12 for 20km radius from PC

# emporion    
# for each of these points sample the connectivity from massalia
value=sample(ppoisson$emporion_c,replace=T, size=nRuns*nrow(p20km))
permutationTest=data.frame(run=run,value=value)
# compute mean value for each of the 1000 samples
aggEmporion <- aggregate(permutationTest$value~factor(permutationTest$run), FUN=mean)
# compute mean value for each of the 1000 samples
quantile(aggEmporion$permutationTest, 0.99)
mean(p20km$emporion_c)
# estimated result: ~ 12.68 for 1% quantile vs 32.63 for 20km radius from PC


# box and whiskers plot comparing distributions

### massalia 
massalia <- ggplot(pall, aes(x=radius, y=massalia_c, fill=radius)) + geom_boxplot(outlier.shape=NA) + theme_bw() + xlab("radius") + ylab("connectivity") + ggtitle("massalia-ilerda") + theme(legend.position="none") + scale_fill_manual(name=element_text('sample'), values=c("indianred2","palegreen4","goldenrod2","skyblue3"))

ylim1 = boxplot.stats(pall$massalia_c)$stats[c(1, 5)]
# scale y limits based on ylim1
massalia = massalia  + coord_cartesian(ylim = ylim1*1.05)

### tarraco
tarraco <- ggplot(pall, aes(x=radius, y=tarraco_c, fill=radius)) + geom_boxplot(outlier.shape=NA) + theme_bw() + xlab("radius") + ylab("connectivity") + ggtitle("tarraco-ilerda") + theme(legend.position="none") + scale_fill_manual(name=element_text('sample'), values=c("indianred2","palegreen4","goldenrod2","skyblue3"))

ylim1 = boxplot.stats(pall$tarraco_c)$stats[c(1, 5)]
# scale y limits based on ylim1
tarraco = tarraco  + coord_cartesian(ylim = ylim1*1.05)

### emporion
emporion <- ggplot(pall, aes(x=radius, y=emporion_c, fill=radius)) + geom_boxplot(outlier.shape=NA) + theme_bw() + xlab("radius") + ylab("connectivity") + ggtitle("emporion-ilerda") + theme(legend.position="none") + scale_fill_manual(name=element_text('sample'), values=c("indianred2","palegreen4","goldenrod2","skyblue3"))

ylim1 = boxplot.stats(pall$emporion_c)$stats[c(1, 5)]
# scale y limits based on ylim1
emporion = emporion  + coord_cartesian(ylim = ylim1*1.05)

pdf("campaign_stats.pdf", width=4, height=6)
grid.arrange(massalia, tarraco, emporion, ncol=1)
dev.off()

