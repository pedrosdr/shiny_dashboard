source('util.R')

header = dashboardHeader(title='Automóveis')

sidebar = dashboardSidebar()

body = dashboardBody(
  fluidRow(
    column(width=12,
        infoBox(
          title='Número de Registros', 
          subtitle=paste('registros de um total de', nrow(data)), 
          value=textOutput('registros'), 
          color='navy'
        )
    )
  ),
  # Filter line
  box(width='100%',
    fluidRow( 
      column(width=6,
             selectInput("idModelos",
                         label = 'Modelo:',
                         choices = data$MODELO %>% unique() %>% sort(),
                         selected = 'corolla xei 16v')
      ),
      column(width=6,
             selectizeInput("idUf",
                            label = 'UF:',
                            choices = data$UF %>% unique() %>% sort(),
                            options = list(maxItems = 3),
                            selected = 'df')
      )
    ),
    fluidRow(
      column(width=6,
             sliderInput("idAno",
                         "Ano do automóvel:",
                         min = min(data$ANO),
                         max = max(data$ANO),
                         value = (mean(data$ANO) + sd(data$ANO)) %>% ceiling(),
                         sep=''),
             checkboxInput('idMostrarTodosAnos', 'Mostrar todos os anos: ', TRUE)
      ),
      column(width=6,
             checkboxGroupInput('idOpcionais',
                                "opcionais: ",
                                choices = colnames(data)[27:36],
                                inline = 4)
      )
    ),
    actionButton('idExecutar', 'Consultar', class='btn btn-primary btn-lg'),
  ), # End Filter line
  
  # Charts line
  box(width='100%',
    fluidRow(
      column(width=7,
             plotlyOutput('mediana_valor')
      ),
      column(width=5,
             plotlyOutput('boxplot_preco'))
    ),
    
    fluidRow(
      column(width=7,
             plotlyOutput('km_valor')
      ),
      column(width=5,
             plotlyOutput('grafico_tipo_anuncio')
      )
    ),
    
    fluidRow(
      column(width=3,
            plotlyOutput('pie_cambio')
      ),
      column(width=3,
             plotlyOutput('pie_direcao')
      ),
      column(width=6,
             plotlyOutput('quantidade_por_cor')
      )
    )
  ) # End Charts line
)

dashboardPage(header=header, sidebar=sidebar, body=body)