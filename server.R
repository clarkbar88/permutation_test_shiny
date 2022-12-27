library(shiny)
data1<-data.frame(A=c(100,120,125,130,151,222));data1$B=data1$A+2*rnorm(6)+1 
server=function(input,output){
output$plot1<-renderPlot({
    if(is.null(input$file1)) {data<-data1
    }else data<-read.csv(input$file1$datapath)


data$Diff<-data[,1]-data[,2]

ave.diff<-mean(data$Diff)


ave.out<-vector()
for(i in 1:input$nsim){
  perm.out<-data$Diff*sample(c(-1,1),length(data$Diff),replace=T)
  ave.out[i]<-mean(perm.out)
}

  pdens<-density(ave.out)
  hist(ave.out,freq=FALSE,xlim=range(pdens$x))
  lines(pdens)
q025 <- quantile(ave.out, ifelse(input$sided=='two',.025,.05))
q975 <- quantile(ave.out, ifelse(input$sided=='two',.975,.95))
x1 <- min(which(pdens$x >= q975))
xmax <- max(which(pdens$x >= q975))
x2 <- max(which(pdens$x <  q025))
xmin <- min(which(pdens$x <  q025))
if(input$sided %in% c('one_right','two')) with(pdens, polygon(x=c(x[c(x1,x1:xmax,xmax)]), 
                                                             y= c(0,y[x1:xmax], 0), col="gray"))
if(input$sided %in% c('one_left','two'))with(pdens, polygon(x=c(x[c(x2,x2:xmin,xmin)]), 
                                                             y= c(0,y[x2:xmin], 0), col="gray"))
#abline(v=quantile(ave.out(),c(.025,.975)),col='red',lwd=2)
abline(v=ave.diff,lwd=2,col='blue')
observe({
p_stat<-ifelse(input$sided=='two',length(which(abs(ave.out)>abs(ave.diff))),
               ifelse(input$sided=='one_left',length(which(ave.out<ave.diff)),
                  length(which(ave.out>ave.diff))))
output$pvalue<-renderText(paste0('p=',round(p_stat/as.numeric(input$nsim),4)))
})

})

}