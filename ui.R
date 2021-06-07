## ui.R for LLNsim
##
## 2021-06-04 Yuki Yanai

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    theme = bslib::bs_theme(bootswatch = "sandstone"),

    titlePanel("大数の法則のシミュレーション"),
    
    fluidRow(
        column(1),
        column(2,
               br(),
               img(src = "yanai_lab_logo.png", height = 120),
               br(),
               br()),
        column(9)
    ),

    sidebarLayout(
        sidebarPanel(
            sliderInput("theta",
                        "1度のコイントスで表が出る確率",
                        value = 0.5,
                        min = 0,
                        max = 1,
                        step = 0.01),
            numericInput("trials",
                         "コイントスの繰り返し回数",
                         value = 100,
                         min = 10,
                         max = 1000),
            actionButton("simulate", "シミュレート!"),
            br(),
            br(),
            actionButton("reset", "リセット")
         ),

        mainPanel(
            plotOutput("cumProp")
        )
    )
))
