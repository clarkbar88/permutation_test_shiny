library(shiny)

pageWithSidebar(
  headerPanel('Permutation Test'),
  sidebarPanel(
    fileInput("file1", "Choose CSV File",
                multiple = F,
                accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),
    selectInput('sided', 'One or Two Sided', choices=c('One (Alt: Diff>0)'='one_right','One (Alt: Diff<0)'='one_left',
                                                       'Two'='two'),selected='two'),
    selectInput('nsim', 'Number of Permutations', c(10,100,1000,10^4,10^5),selected=1000)
  ),
  mainPanel(
    plotOutput('plot1'),
    textOutput('pvalue')
  )
)