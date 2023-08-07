source('util.R')

function(input, output, session) {
  s = eventReactive(input$idExecutar,
    {
      result = data %>% filter(UF == input$idUf &
                                 MODELO == input$idModelos)
      if(!input$idMostrarTodosAnos)
        result = result %>% filter(ANO == input$idAno)
      
      # optional features
      if('AIR_BAG' %in%  input$idOpcionais)
        result = result %>% filter(AIR_BAG == 1)
      if('ALARME' %in%  input$idOpcionais)
        result = result %>% filter(ALARME == 1)
      if('AR.CONDICIONADO' %in%  input$idOpcionais)
        result = result %>% filter(AR_CONDICIONADO == 1)
      if('BLINDADO' %in%  input$idOpcionais)
        result = result %>% filter(BLINDADO == 1)
      if('CAMERA_DE_RE' %in%  input$idOpcionais)
        result = result %>% filter(CAMERA_DE_RE == 1)
      if('DIRECAO_HIDRAULICA' %in%  input$idOpcionais)
        result = result %>% filter(DIRECAO_HIDRAULICA == 1)
      if('SENSOR_DE_RE' %in%  input$idOpcionais)
        result = result %>% filter(SENSOR_DE_RE == 1)
      if('SOM' %in%  input$idOpcionais)
        result = result %>% filter(SOM == 1)
      if('TRAVA_ELETRICA' %in%  input$idOpcionais)
        result = result %>% filter(TRAVA_ELETRICA == 1)
      if('VIDRO_ELETRICO' %in%  input$idOpcionais)
        result = result %>% filter(VIDRO_ELETRICO == 1)
      
      
      result$VALOR = as.numeric(result$VALOR)
      
      result
    }, ignoreNULL=FALSE
  )
  
  output$registros = renderText({
    nrow(s())
  })
  
  output$mediana_valor = renderPlotly({
      mediana_data <- s()  %>%
        group_by(DATA_COLETA_METADADOS, UF) %>%
        summarise(MEDIANA = median(VALOR))
      
      ggplotly(
        mediana_data %>%
          ggplot(aes(x=DATA_COLETA_METADADOS, y = MEDIANA, group=UF, color=UF,
                     text=paste('Data: ', DATA_COLETA_METADADOS, '\nValor: ', MEDIANA)),
                 size=1) +
          geom_line() +
          ggtitle('Mediana do valor') +
          scale_color_brewer(palette = 'Dark2'),
        tooltip = c('text')
      )
  })
  
  output$boxplot_preco = renderPlotly({
      ggplotly(
        s() %>%
          ggplot() +
          geom_boxplot(aes(y = VALOR, x=UF, fill = UF)) +
          ggtitle('Variação do preço por UF') +
          scale_fill_brewer(palette = 'Set1') +
          theme(legend.position = "none")
      )
  })
  
  output$km_valor = renderPlotly({
    ggplotly(
      s() %>%
        ggplot() +
        geom_point(aes(x=QUILOMETRAGEM, y=VALOR, color=UF)) +
        ggtitle('Distribuição do valor e quilometragem por UF') +
        scale_color_brewer(palette = 'Set1')
    )
  })
  
  output$grafico_tipo_anuncio = renderPlotly({
    ggplotly(
      s() %>%
        ggplot(aes(x=TIPO_ANUNCIO, y=VALOR, fill=UF)) +
        geom_boxplot() +
        xlab('TIPO DE ANÚNCIO') +
        ggtitle('Variação de preço por tipo de anúncio') +
        scale_fill_brewer(palette = 'Set1')
    ) %>% layout(boxmode = 'group')
  })
  
  output$pie_cambio = renderPlotly({
    
    freq_cambio = s() %>%
      group_by(CAMBIO) %>%
      summarise(QTD = n()) %>%
      mutate(PROP = QTD / sum(QTD)) %>%
      mutate(YPOS = cumsum(PROP) - 0.5 * PROP)
    
    plot_ly(freq_cambio, labels = ~CAMBIO, values = ~PROP,
            type = 'pie', textinfo = 'label+percent', showlegend = FALSE) %>%
      layout(title = 'Frequência por câmbio')
  })
  
  output$pie_direcao = renderPlotly({
    
    freq_direcao <- s() %>%
      group_by(DIRECAO) %>%
      summarise(QTD = n()) %>%
      mutate(PROP = QTD / sum(QTD)) %>%
      mutate(YPOS = cumsum(PROP) - 0.5 * PROP)
    
    plot_ly(freq_direcao, labels = ~DIRECAO, values = ~PROP,
            type = 'pie', showlegend=FALSE) %>%
      layout(title='Frequência por direção')
  })
  
  output$quantidade_por_cor = renderPlotly({
    ggplotly(
      s() %>%
        group_by(COR) %>%
        summarise(QTD = n()) %>%
        ggplot(aes(x = reorder(COR, -QTD), y = QTD, fill=-QTD,
                   text=paste('Cor: ', COR, '\nQtd.: ', QTD))) +
        geom_col() +
        xlab('COR') +
        ggtitle('Quantidade por cor') +
        theme(legend.position = "none"),
      tooltip = c('text')
    )
  })
}
