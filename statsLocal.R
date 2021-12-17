library(sf)
library(ggplot2)
library(gridExtra)    

# load the three datasets of points
visible <- read_sf('output/local/visible.gpkg')
visible$area <- "visible <10km"

nonVisible <- read_sf('output/local/nonVisible.gpkg')
nonVisible$area <- "non visible <10km"

random<- read_sf('output/local/random.gpkg')
random$area <- "random"

# aggregated the 3 datasets
vall <- rbind(visible, nonVisible, random)
vall$area <- as.factor(vall$area)
vall$area <- factor(vall$area, levels=c("visible <10km","non visible <10km", "random"))

# Kolmogorov-Smirnov test for each

ksVisRandom <- ks.test(visible$local_c, random$local_c)
ksNonVisRandom <- ks.test(nonVisible$local_c, random$local_c)
ksVisNonVis <- ks.test(visible$local_c, nonVisible$local_c)

# Bonferroni correction to multiple hypothesis testing    
p.adjust(c(ksVisRandom$p.value, ksNonVisRandom$p.value,ksVisNonVis$p.value), method="bonferroni")

# get normalized values 0-1
vall$local_c_norm <-(vall$local_c-min(vall$local_c, na.rm=T))/(max(vall$local_c, na.rm=T)-min(vall$local_c, na.rm=T))

pdf("local_stats.pdf", width=4, height=4)
ggplot(vall, aes(x=local_c_norm, col=area, fill=area)) + geom_density(alpha=0.5) + facet_wrap(~area, ncol=1) +  theme_bw() + xlab("connectivity") + theme(legend.position="none") + scale_fill_manual(values=c("skyblue3", "indianred2", "white")) + scale_colour_manual(values=c("skyblue3","indianred2","black")) 
dev.off()

