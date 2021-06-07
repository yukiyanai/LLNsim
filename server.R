## server.R for LLNsim
##
## 2021-06-04 Yuki Yanai


pacman::p_load(shiny,
               tidyverse,
               thematic)
if (.Platform$OS.type == "windows") { 
    if (require(fontregisterer)) {
        my_font <- "Yu Gothic"
    } else {
        my_font <- "Japan1"
    }
} else if (capabilities("aqua")) {
    my_font <- "HiraginoSans-W3"
} else {
    my_font <- "IPAexGothic"
}
theme_set(theme_gray(base_size   = 9,
                     base_family = my_font))


shinyServer(function(input, output) {
    
    counter <- reactiveValues(count = 0)
    
    dat <- reactiveValues(
        x = NULL,
        y = NULL,
        gr = NULL
    )
 
    observeEvent(input$simulate, {
        counter$count <- counter$count + 1
        dat$x <- c(dat$x, 1:input$trials)
        res <- rbinom(n = input$trials, size = 1, prob = input$theta)
        dat$y <- c(dat$y, cumsum(res) / 1:input$trials)
        dat$gr <- c(dat$gr, rep(counter$count, input$trials))
    })

    observeEvent(input$reset, {
        dat$x <- NULL
        dat$y <- NULL
        dat$gr <- NULL
        counter$count <- 0
    })
    
    observeEvent(input$theta, {
        dat$x <- NULL
        dat$y <- NULL
        dat$gr <- NULL
        counter$count <- 0
    })
    
    output$cumProp <- renderPlot({
        p <- tibble(x = dat$x,
                    y = dat$y,
                    gr = factor(dat$gr)) %>% 
            ggplot() +
            geom_hline(yintercept = input$theta,
                       color = "darkgray",
                       linetype = "dashed") +
            geom_line(aes(x = x, y = y, color = gr)) +
            xlim(0, input$trials) +
            ylim(0, 1) +
            scale_color_discrete(name = "実験#") +
            labs(x = "コイントスの回数", 
                 y = "表の割合")
        plot(p)
    }, res = 96)

})
