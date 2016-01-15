times <- data.frame(Time=as.POSIXct(strftime(s$Timestamp, format="%H:%M:%S"), format="%H:%M:%S"))
ggplot(times, aes(x=Time)) + geom_histogram()


sd$Count <- 1
sdm <- aggregate(. ~ Teacher, sd, sum)[c("Teacher", "Count")]
t$Count <- 1
sdc <- aggregate(. ~ Teacher, t, sum)[c("Teacher", "Count")]

timespe <- aggregate(. ~ Teacher, d, sum)
timespe$TimeSpentHours <- timespe$TimeSpent / 60 /60
timespe[order(-timespe$TimeSpentHours),]


library(wesanderson)
library(ggplot2)

teacherdates <- read.csv("teacherdates.txt", header=FALSE)
studentdates <- read.csv("studentdates.txt", header=FALSE)

teachersessiondates <- read.csv("inforum-teacherdates-sessions.txt", header=FALSE)

tsdates <- function (a) {
    dates <- c()
    names <- c()
    for (index in 1:dim(a)[1]) {
        b <- a[index, 2]
        c <- unlist(strsplit(as.character(b), "\t"))
        dates <- append(dates, c)
        names <- append(names, rep(as.character(a[index, 1]), length(c)))
    }
    dates <- strptime(dates, format="%Y-%m-%d %H:%M:%S")
    names <- factor(names)
    f <- data.frame(Timestamp = dates, Teacher = names)
    return(f);
}

session <- function (a) {
    dates <- c()
    names <- c()
    for (index in 1:dim(a)[1]) {
        b <- a[index, 2]
        c <- unlist(strsplit(as.character(b), "\t"))
        dates <- append(dates, c)
        names <- append(names, rep(as.character(a[index, 1]), length(c)))
    }
    dates <- as.numeric(dates)
    names <- factor(names)
    f <- data.frame(TimeSpent = dates, Teacher = names)
    return(f);
}


t <- tsdates(teacherdates)
s <- tsdates(studentdates)
sd <- s[!is.na(s$Teacher), ]
d <- session(teachersessiondates)

ggplot(t, aes(x=Timestamp)) +
  geom_histogram(bins=90, fill="red", alpha=0.2) +
  geom_histogram(data=sd, bins=90, fill="blue", alpha=0.2) +
  coord_cartesian(ylim = c(0, 400)) +
  facet_wrap(~Teacher, ncol=3, scales="free_x")

ggsave(filename="histogram_prispevky_opravy_podzim2015.png", width=12, height=30)


ggplot(sd, aes(x=Timestamp)) +
  geom_histogram(bins=90, fill="blue", alpha=0.2) +
  geom_histogram(data=t, bins=90, fill="red", alpha=0.2)
  
ggsave(filename="histogram_prispevky_opravy_souhrn-podzim2015.png", width=8, height=6)

# https://kohske.wordpress.com/2010/12/29/faq-how-to-order-the-factor-variables-in-ggplot2/
o <- d
o$o <- reorder(o$Teacher, o$TimeSpent, median)

# http://zevross.com/blog/2014/08/04/beautiful-plotting-in-r-a-ggplot2-cheatsheet-3/
ggplot(o, aes(x=o, y=TimeSpent)) +
        #geom_histogram(binwidth=1) +
        #coord_cartesian(xlim = c(0, 500)) +
        scale_y_continuous(breaks=seq(0, 60*30, 60)) +
        geom_jitter(alpha=0.5, aes(color=Teacher), position = position_jitter(width = 1)) +
        geom_boxplot(alpha=0, outlier.shape = NA) +
        
        #geom_jitter(aes(color="black"), position = position_jitter(width = 1)) +
        #geom_boxplot(alpha=0, outlier.shape = NA) +
        
        #geom_violin(alpha=0.2, color="gray") +
        #scale_y_sqrt() +
        coord_flip()
        
ggsave(filename="inforum-violin_doba_opravy-nezoomed.png", width=12, height=20)

ggplot(o, aes(x=o, y=TimeSpent)) +
        #geom_histogram(binwidth=1) +
        scale_y_continuous(breaks=seq(0, 60*15, 60)) +
        geom_jitter(alpha=0.5, aes(color=Teacher), position = position_jitter(width = 1)) +
        geom_boxplot(aes(group=NA), outlier.shape = NA, color="red", alpha=0.5) +
        geom_boxplot(alpha=0.1, outlier.shape = NA) +
        #geom_violin(alpha=0.2, color="gray") +
        coord_flip(ylim = c(0, 900)) + theme(legend.position="none")
        
ggsave(filename="box-doba_opravy_podzim2015.png", width=12, height=20)

#http://novyden.blogspot.cz/2013/09/how-to-expand-color-palette-with-ggplot.html
colorCount <- 23
ggplot(d, aes(x=TimeSpent)) +
    geom_histogram(binwidth=5, aes(fill=Teacher)) +
    coord_cartesian(xlim = c(0, 500)) +
    scale_x_continuous(breaks=seq(0, 60*30, 60)) +
    theme(legend.position="bottom")
    
    #scale_fill_manual(values = colorRampPalette(brewer.pal(8, "Set3"))(colorCount)) +
  
    #scale_fill_brewer(type="seq", palette="Set2")
ggsave(filename="histogram-doba_opravy_podzim2015.png", width=12, height=8)

last <- function(x) { tail(x, n = 1) }
for (teacher in levels(d$Teacher)) {
    ggplot(d, aes(x=TimeSpent)) +
        geom_histogram(binwidth=1) +
        coord_cartesian(xlim = c(0, 500)) +
        scale_x_continuous(breaks=seq(0, 60*30, 60)) +
        scale_y_sqrt() +
        #geom_histogram(binwidth=1, data=, alpha=0.2, aes(fill=Teacher))
        geom_histogram(binwidth=1, data=d[d$Teacher == teacher, ], fill="red", alpha=0.8)
    surname <- last(unlist(strsplit(as.character(teacher), " ")))
    ggsave(filename=paste("inforum-histogram_doba_opravy_for_", surname, ".png", sep=""), width=12, height=8)
}

ggplot(d, aes(x=TimeSpent)) +
    scale_x_continuous(breaks=seq(0, 60*30, 60)) +
    geom_histogram(binwidth=10) +
    coord_cartesian(xlim = c(0, 500)) +
    facet_wrap(~Teacher, scales="free", ncol = 3)

ggsave(filename="histogram_doba_opravy_facet-podzim2015.png", width=12, height=30)

b <- a[4, 2]
c <- unlist(strsplit(as.character(b), "\t"))
d <- strptime(c, format="%Y-%m-%d %H:%M:%S")
f <- data.frame(Date = d)

b <- a[1, 2]
c <- unlist(strsplit(as.character(b), "\t"))
d <- strptime(c, format="%Y-%m-%d %H:%M:%S")
g <- data.frame(Date = d)


  



d <- as.character(unlist(c))
e <- lapply(d, function(x){strptime(x, format="%Y-%m-%d %H:%M:%S")})
unname(e, force=TRUE)
f <- data.frame(time = e)



b <- 





> d <- lapply(t(strsplit(b[1,2], "\t")), function(x){strptime(x, format="%Y-%m-%d %H:%M:%S")})

e <- unname(d, force=TRUE)
f <- data.frame(e)

d <- lapply(strsplit(b[1,2], "\t"), function(x){as.Date(x, format="%Y-%m-%d %H:%M:%S")})


a <- "1, 2, 3, 4, 4, 4, 4, 4, 4"
b <- strsplit(a, ", ")
c <- lapply(b, as