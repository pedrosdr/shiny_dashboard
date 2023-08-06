library(shiny)
library(dplyr)
library(data.table)
library(plotly)
library(ggplot2)
library(shinydashboard)

data = read.csv('data.csv') %>%
  rename(CAMBIO='CÂMBIO') %>% 
  rename(DIRECAO='DIREÇÃO') %>%
  rename(CAMERA_DE_RE='CÂMERA.DE.RÉ') %>%
  rename(DIRECAO_HIDRAULICA='DIREÇÃO.HIDRÁULICA') %>%
  rename(SENSOR_DE_RE='SENSOR.DE.RÉ') %>%
  rename(TRAVA_ELETRICA='TRAVA.ELÉTRICA') %>%
  rename(VIDRO_ELETRICO='VIDRO.ELÉTRICO') %>%
  rename(AR_CONDICIONADO='AR.CONDICIONADO') %>%
  rename(AIR_BAG = 'AIR.BAG')

theme_set(theme_bw())
