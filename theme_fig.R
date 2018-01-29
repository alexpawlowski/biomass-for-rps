theme_fig <- function(base_size = 12) {
  text_scaling = 1.25
  theme_grey(base_size = base_size) %+replace% # base_family = base_family
    theme(
      panel.background = element_blank(),
      panel.border = element_rect(color="black", size = 1, fill = NA),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank(),
      panel.grid.major.y = element_blank(),
      panel.grid.minor.y = element_blank(),
      
      axis.text.y  = element_text(color="black", size = 3/4*base_size*text_scaling, margin = margin(l = -7, r = 6, unit = "pt")),
      axis.text.x  = element_text(color="black", size = 3/4*base_size*text_scaling, margin = margin(t = 6, b = -7, unit = "pt")),
      axis.title.y = element_text(color="black", size = 5/6*base_size*text_scaling, margin = margin(l = -1, r = 8, unit = "pt"), angle = 90),
      axis.title.x = element_text(color="black", size = 5/6*base_size*text_scaling, margin = margin(t = 8, b = -1, unit = "pt")),
      axis.ticks.y = element_line(color="black", size = 1),
      axis.ticks.x = element_line(color="black", size = 1),
      axis.ticks.length = unit(-0.3, "lines"),
      
      plot.margin = margin(t = 10, r = 12, b = 7, l = 7, unit = "pt"),
      
      strip.text = element_text(color="black", size = 5/6*base_size*text_scaling),
      strip.background = element_blank(),
      
      legend.position = "bottom",
      legend.text = element_text(color="black", size = 5/6*base_size*text_scaling),
      legend.key.height = unit(base_size, "pt"),
      legend.key.width = unit(4/3*base_size, "pt"),
      legend.margin = margin(0, unit = "pt")
    )
}