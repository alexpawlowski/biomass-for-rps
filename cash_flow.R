library(tidyverse)
library(svglite)
library(readxl)
cash_flow_raw <- read_excel('budget.xlsx')
source('theme_fig.R')

cash_flow <- cash_flow_raw %>%
  select(-c(Dole_to_Plants:USDA__1)) %>%
  gather(Revenue_Developers:USDA, key = 'Source', value = 'Revenue')

grants_col <- c(
  'State_Pot' = '#7fbf7b',
  'Grants_Plants' = '#e7d4e8',
  'Grants_States' = '#af8dc3',
  'USDA' = '#762a83'
)

grants_lab <- c(
  'State_Pot' = 'States',
  'Grants_Plants' = 'Plants',
  'Grants_States' = 'States',
  'USDA' = 'USDA'
)


cash_flow.plot <- cash_flow %>%
  filter(sign(Revenue) == -1) %>%
  ggplot(aes(x = Year, y = Revenue / 1e6)) +
  geom_col(aes(fill = Source),
           position = 'dodge') +
  geom_col(data =  cash_flow %>% filter(Source == 'State_Pot'),
           aes(fill = Source)) +
  geom_path(data =  cash_flow %>% filter(Source == 'Revenue_Developers'),
            size = 1,
            aes(color = Source)) +
  geom_hline(yintercept = 0,
             size = 1,
             color = 'black') +
  annotate("text", x = 5, y = -150, label = 'Grants') +
  annotate("text", x = 5, y = 150, label = 'Revenue') +
  scale_color_manual(values = c('Revenue_Developers' = '#1b7837'), labels = c('Tax'),
                     name = NULL) +
  scale_fill_manual(values = grants_col, labels = grants_lab, name = NULL) +
  scale_x_continuous(breaks = seq(0,10,2),
                     labels = seq(0,10,2),
                     limits = c(-0.5,10.5)) +
  scale_y_continuous(breaks = seq(-150,150,50),
                     labels = seq(-150,150,50),
                     limits = c(-150,150)) +
  labs(
    x = 'Fiscal Year',
    y = 'Millions USD'
  ) +
  theme_fig()

cash_flow.plot

ggsave(cash_flow.plot, filename = 'cash_flow.plot.svg', width = 4, height = 4, units = 'in')
