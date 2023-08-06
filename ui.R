source('util.R')

header = dashboardHeader(title='Vendas Automóveis')

sidebar = dashboardSidebar()

body = dashboardBody(
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
      column(width=6,
             plotlyOutput('mediana_valor')
      ),
      column(width=6,
             plotlyOutput('boxplot_preco'))
    )
  ) # End Charts line
)

dashboardPage(header=header, sidebar=sidebar, body=body)