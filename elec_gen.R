library('tidyverse')
elec_gen <- read_csv('data/net_gen_for_all_sectors_annual.csv', skip = 4)
source('theme_fig.R')

elec_gen_wide <- elec_gen %>%
  gather(key = source, value = generation, 
         `United States : geothermal thousand megawatthours`:`United States : other thousand megawatthours`)

elec_gen_wide <- elec_gen_wide %>%
  mutate(source = str_extract(source, '(?<=: )[a-z\\s]*(?= th)')) %>%
  mutate(source = str_replace(source, 'conventional hydroelectric', 'hydropower')) %>%
  filter(!source %in% c('other', 'geothermal' ))

elec_gen_future <- read_csv('data/net_gen_future_base_case_aeo_2018.csv', skip = 4)

elec_gen_wide_future <-  elec_gen_future %>%
  gather(key = source, value = generation, `Coal BkWh`:`Renewable Sources BkWh`)

elec_gen_renew_future <- read_csv('data/net_gen_future_renewable_base_case_aeo_2018.csv', skip = 4)


elec_gen_renew_future <- elec_gen_renew_future %>%
  mutate(`biomass BkWh` = `Wood and Other Biomass BkWh`,
         `all solar BkWh` = rowSums(.[6:7])) %>%
  select(-c(`Solar Thermal BkWh`, `Solar Photovoltaic BkWh`, `Wood and Other Biomass BkWh`))

elec_gen_renew_wide_future <- elec_gen_renew_future %>%
  gather(key = source, value = generation, `Hydropower BkWh`:`all solar BkWh`) #%>%

elec_gen_wide_future <- elec_gen_wide_future %>%
  bind_rows(elec_gen_renew_wide_future) %>%
  mutate(source = tolower(str_extract(source, '[A-Za-z\\s]*(?= BkWh)'))) %>%
  filter(!source %in% c('renewable sources', 'other', 'biogenic municipal waste', 'petroleum', 'geothermal' ))


elec_gen.plot <- elec_gen_wide %>%
  ggplot(aes(x = Year, color = fct_relevel(source, 'coal', 'natural gas'))) +
  geom_path(aes(y = generation / 1e3),
            size = 2) +
  geom_path(data = elec_gen_wide_future,
            aes(y = generation),
            size = 2,
            linetype = '2121') +
  scale_x_continuous(breaks = seq(2000, 2050, 10),
                     labels = seq(2000, 2050, 10),
                     limits = c(2000, 2050),
                     expand = c(0,0)) +
  scale_y_continuous(breaks = seq(0, 2000, 500),
                     labels = c(0,seq(500, 2000, 500)),
                     limits = c(0, 2050),
                     expand = c(0,0)) +
  scale_color_brewer(palette = 'Paired',
                     name = 'source') +
  labs(
    x = 'Year',
    y = 'Generation (GWh)'
  ) +
  theme_fig()

elec_gen.plot

ggsave(elec_gen.plot, filename = 'elec_gen.plot.svg', width = 6, height = 4, units = 'in')
  