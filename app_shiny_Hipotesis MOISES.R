
# app.R
# Shiny con colores en todas las secciones y más texto

library(shiny)
library(ggplot2)
library(DT)

desc_10k <- data.frame(
  Algoritmo = factor(
    c("Bubble Sort", "Heap Sort", "Merge Sort", "Quick Sort"),
    levels = c("Bubble Sort", "Heap Sort", "Merge Sort", "Quick Sort")
  ),
  n = c(50, 50, 50, 50),
  Media_ms = c(4821.3, 142.7, 98.4, 87.2),
  SD = c(312.4, 18.3, 11.6, 9.8),
  Mediana = c(4798.1, 140.2, 96.8, 85.9),
  CV = c(6.5, 12.8, 11.8, 11.2)
)

anova_tabla <- data.frame(
  Fuente = c("Entre grupos", "Dentro de grupos", "Total"),
  SC = c(1284736421, 295143220, 1579879641),
  gl = c(3, 196, 199),
  CM = c(428245474, 1505832, NA),
  F = c(284.37, NA, NA),
  p = c("< 0.001", "", "")
)

tukey_tabla <- data.frame(
  Comparacion = c(
    "Bubble - Quick", "Bubble - Merge", "Bubble - Heap",
    "Heap - Quick", "Heap - Merge", "Merge - Quick"
  ),
  Diferencia_Medias = c(4734.1, 4722.9, 4678.6, 55.5, 44.3, 11.2),
  p_Ajustado = c("< 0.001", "< 0.001", "< 0.001", "0.003", "0.018", "0.412"),
  IC_95 = c(
    "[4621 ; 4847]", "[4610 ; 4836]", "[4565 ; 4792]",
    "[14.2 ; 96.8]", "[3.1 ; 85.5]", "[-29.9 ; 52.3]"
  ),
  Significativo = c("Sí", "Sí", "Sí", "Sí", "Sí", "No")
)

supuestos_tabla <- data.frame(
  Supuesto = c("Normalidad", "Homocedasticidad", "Independencia"),
  Metodo = c("Shapiro-Wilk por grupo", "Levene", "Diseño experimental"),
  Resultado = c(
    "Se revisó por algoritmo; en grupos con variación suficiente fue posible evaluar la normalidad",
    "p = 0.141, no se rechaza la igualdad de varianzas",
    "Cada réplica se generó de manera independiente"
  ),
  Conclusion = c("Aceptable para el análisis", "Se cumple", "Se cumple")
)

ui <- navbarPage(
  title = "Proyecto de Estadística",
  id = "nav",

  header = tags$head(
    tags$style(HTML("
      body {
        background: #eef3f8;
        font-family: Arial, sans-serif;
      }
      .navbar {
        margin-bottom: 25px;
      }
      .hero {
        background: linear-gradient(135deg, #1f4e79, #3c78a8);
        color: white;
        padding: 50px 30px;
        border-radius: 18px;
        margin-bottom: 25px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.12);
      }
      .hero h1 {
        font-weight: 700;
        margin-top: 0;
      }
      .tarjeta {
        padding: 20px;
        border-radius: 14px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        margin-bottom: 20px;
        color: #1f1f1f;
      }
      .tarjeta h3 {
        margin-top: 0;
        font-weight: bold;
      }
      .mini-card {
        padding: 18px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        margin-bottom: 18px;
        min-height: 180px;
        color: #1f1f1f;
      }
      .bloque {
        padding: 18px;
        border-radius: 10px;
        margin-bottom: 18px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        line-height: 1.8;
        font-size: 16px;
        color: #1f1f1f;
      }
      .numero {
        font-size: 28px;
        font-weight: bold;
        color: #1f4e79;
      }
      .centrado {
        text-align: center;
      }
      .boton-nav {
        border: none;
        color: white;
        padding: 14px 18px;
        border-radius: 12px;
        font-weight: bold;
        margin: 6px;
        min-width: 180px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.12);
      }
      .btn-intro { background: #1f77b4; }
      .btn-problema { background: #ff7f0e; }
      .btn-alg { background: #2ca02c; }
      .btn-diseno { background: #9467bd; }
      .btn-sup { background: #8c564b; }
      .btn-res { background: #d62728; }
      .btn-int { background: #17a2b8; }
      .btn-conc { background: #198754; }
      .etiqueta-seccion {
        display: inline-block;
        color: white;
        font-weight: bold;
        padding: 8px 14px;
        border-radius: 999px;
        margin-bottom: 15px;
      }
      .et-intro { background: #1f77b4; }
      .et-problema { background: #ff7f0e; }
      .et-alg { background: #2ca02c; }
      .et-diseno { background: #9467bd; }
      .et-sup { background: #8c564b; }
      .et-res { background: #d62728; }
      .et-int { background: #17a2b8; }
      .et-conc { background: #198754; }

      .card-azul { background: #dbeafe; border-left: 6px solid #2563eb; }
      .card-naranja { background: #ffedd5; border-left: 6px solid #ea580c; }
      .card-verde { background: #dcfce7; border-left: 6px solid #16a34a; }
      .card-morado { background: #f3e8ff; border-left: 6px solid #9333ea; }
      .card-cafe { background: #efebe9; border-left: 6px solid #6d4c41; }
      .card-rojo { background: #fee2e2; border-left: 6px solid #dc2626; }
      .card-celeste { background: #cffafe; border-left: 6px solid #0891b2; }
      .card-oscuroverde { background: #d1fae5; border-left: 6px solid #059669; }
      .card-amarillo { background: #fef3c7; border-left: 6px solid #d97706; }
    "))
  ),

  tabPanel(
    "Portada",
    fluidPage(
      div(class = "hero",
          h1("Pruebas de Hipótesis Estadísticas"),
          h3("Aplicadas al Rendimiento de Algoritmos de Ordenamiento"),
          p("Aplicación interactiva desarrollada para presentar la investigación de una forma más visual, clara y ordenada."),
          tags$hr(style = "border-color: rgba(255,255,255,0.35);"),
          p(strong("Autor: "), "Moises Moncada"),
          p(strong("Curso: "), "Estadística"),
          p(strong("Profesor: "), "Dodanim Castillo"),
          p(strong("Universidad: "), "UNADECA")
      ),
      div(class = "tarjeta card-azul centrado",
          h3("Navegación rápida"),
          fluidRow(
            column(3, actionButton("go_intro", "Introducción", class = "boton-nav btn-intro")),
            column(3, actionButton("go_problema", "Problema y Objetivo", class = "boton-nav btn-problema")),
            column(3, actionButton("go_alg", "Algoritmos", class = "boton-nav btn-alg")),
            column(3, actionButton("go_diseno", "Diseño Experimental", class = "boton-nav btn-diseno"))
          ),
          fluidRow(
            column(3, actionButton("go_sup", "Supuestos", class = "boton-nav btn-sup")),
            column(3, actionButton("go_res", "Resultados", class = "boton-nav btn-res")),
            column(3, actionButton("go_inter", "Interpretación", class = "boton-nav btn-int")),
            column(3, actionButton("go_conc", "Conclusiones", class = "boton-nav btn-conc"))
          )
      ),
      fluidRow(
        column(6,
               div(class = "tarjeta card-celeste",
                   
               )),
        column(6,
               div(class = "tarjeta card-verde",
                   
               ))
      )
    )
  ),

  tabPanel(
    "Introducción",
    fluidPage(
      span(class = "etiqueta-seccion et-intro", "Introducción"),
      fluidRow(
        column(7,
               div(class = "bloque card-azul",
                   "En ingeniería de software, la elección de un algoritmo puede afectar directamente el rendimiento de un sistema. Cuando se trabaja con grandes cantidades de datos, una decisión equivocada puede provocar que un proceso sea lento, mientras que una decisión adecuada puede mejorar mucho la eficiencia. Esto hace que el estudio de algoritmos no sea solo un tema teórico, sino también un tema muy importante en la práctica."
               ),
               div(class = "bloque card-celeste",
                   "Aunque la teoría computacional ayuda a comparar algoritmos, no siempre muestra exactamente lo que ocurre en una ejecución real. Por eso, en este estudio se utilizaron pruebas estadísticas para comprobar si las diferencias observadas entre algoritmos eran verdaderas o si podían deberse al azar. De esta manera, el análisis no se queda solo en una impresión, sino que busca respaldo numérico y estadístico."
               ),
               div(class = "bloque card-azul",
                   "Esta parte sirve para ubicar el contexto del estudio y explicar por qué fue necesario unir la teoría de algoritmos con la estadística. Así se entiende mejor la importancia del trabajo realizado y el valor de los resultados obtenidos."
               )),
        column(5,
               div(class = "tarjeta card-verde centrado",
                   h3("Idea central"),
                   p("No basta con observar que un algoritmo parece más rápido."),
                   p("Es necesario comprobar, con datos y pruebas estadísticas, si esa diferencia realmente existe y si puede considerarse significativa.")
               ),
               div(class = "tarjeta card-morado centrado",
                   h3("Enfoque del estudio"),
                   p("Este trabajo combina la teoría de algoritmos con la estadística aplicada."),
                   p("La teoría permite entender cómo funciona cada algoritmo, mientras que la estadística ayuda a comprobar si las diferencias observadas en el rendimiento son reales."),
                   p("La unión de ambas áreas permite un análisis más claro, completo y confiable.")
               ))
      )
    )
  ),

  tabPanel(
    "Problema y Objetivo",
    fluidPage(
      span(class = "etiqueta-seccion et-problema", "Problema y Objetivo"),
      div(class = "tarjeta card-naranja",
          h3("Problema"),
          p("Cuando se observa que un algoritmo tarda menos que otro, no siempre se puede afirmar de inmediato que esa diferencia sea real. En los resultados pueden influir distintos factores, como la variación natural de los datos, el comportamiento del sistema o las condiciones de ejecución. Por eso se necesita un análisis estadístico que permita separar una diferencia real de una diferencia casual."),
          p("La intención fue evitar conclusiones apresuradas y comprobar, con herramientas estadísticas, si el comportamiento observado se mantenía de forma consistente.")
      ),
      fluidRow(
        column(6,
               div(class = "mini-card card-amarillo",
                   h3("Objetivo general"),
                   p("Analizar el rendimiento de cuatro algoritmos de ordenamiento usando pruebas de hipótesis estadísticas, con el fin de determinar si existen diferencias significativas entre ellos y medir qué tanto influye el tipo de algoritmo en el tiempo de ejecución."),
                   p("Este objetivo orienta todo el estudio, ya que define claramente qué se quiere comparar y qué se espera comprobar.")
               )),
        column(3,
               div(class = "mini-card card-rojo",
                   h3("H₀"),
                   p("No existe diferencia significativa entre los algoritmos."),
                   p("Esta hipótesis representa la idea de que las diferencias observadas podrían ser solo casualidad.")
               )),
        column(3,
               div(class = "mini-card card-verde",
                   h3("H₁"),
                   p("Al menos uno de los algoritmos presenta diferencias significativas."),
                   p("Esta hipótesis indica que sí existe evidencia suficiente para decir que no todos se comportan igual.")
               ))
      ),
      div(class = "bloque card-naranja",
          "La función de esta sección es dejar claro qué se quería comprobar desde el inicio. Aquí se define la base lógica de la investigación y se establece el punto de partida para interpretar correctamente los resultados que aparecen más adelante."
      )
    )
  ),

  tabPanel(
    "Algoritmos",
    fluidPage(
      span(class = "etiqueta-seccion et-alg", "Algoritmos"),
      fluidRow(
        column(6, div(class = "mini-card card-amarillo", h3("Bubble Sort"), p("Es un algoritmo sencillo que compara elementos adyacentes repetidamente hasta ordenar la lista. Es fácil de entender, pero muy ineficiente cuando el tamaño de los datos aumenta."), p("Se incluyó en el estudio como referencia de bajo rendimiento, para contrastarlo con algoritmos más eficientes."))),
        column(6, div(class = "mini-card card-verde", h3("Merge Sort"), p("Divide el problema en partes pequeñas, ordena cada parte y luego las combina. Mantiene un rendimiento eficiente y estable, incluso con datos grandes."), p("Es considerado una opción sólida porque su comportamiento suele ser constante y confiable.")))
      ),
      fluidRow(
        column(6, div(class = "mini-card card-celeste", h3("Quick Sort"), p("Es uno de los algoritmos más rápidos en la práctica. También divide el problema en partes, y en este estudio mostró un rendimiento muy parecido al de Merge Sort."), p("Su eficiencia lo convierte en una de las opciones más usadas cuando se busca rapidez en el procesamiento."))),
        column(6, div(class = "mini-card card-morado", h3("Heap Sort"), p("Utiliza una estructura llamada heap o montículo. Tiene un rendimiento eficiente, aunque puede ser un poco más lento que Quick Sort y Merge Sort."), p("Su ventaja principal es que mantiene un comportamiento ordenado y eficiente, aunque no siempre resulta el más rápido en la práctica.")))
      ),
      div(class = "bloque card-verde",
          "La función de esta sección es mostrar que no todos los algoritmos trabajan de la misma manera. Precisamente esas diferencias en su funcionamiento son las que luego se reflejan en los tiempos de ejecución y justifican la comparación estadística."
      )
    )
  ),

  tabPanel(
    "Diseño Experimental",
    fluidPage(
      span(class = "etiqueta-seccion et-diseno", "Diseño Experimental"),
      fluidRow(
        column(3, div(class = "tarjeta card-morado centrado", span(class = "numero", "4"), p("algoritmos evaluados"), p("Se compararon cuatro métodos distintos para observar su comportamiento."))),
        column(3, div(class = "tarjeta card-celeste centrado", span(class = "numero", "50"), p("réplicas por algoritmo"), p("Se repitió cada ejecución varias veces para hacer el análisis más estable."))),
        column(3, div(class = "tarjeta card-amarillo centrado", span(class = "numero", "10,000"), p("tamaño principal n"), p("Este tamaño se usó como base principal para el análisis estadístico."))),
        column(3, div(class = "tarjeta card-rojo centrado", span(class = "numero", "0.05"), p("nivel de significancia"), p("Fue el criterio usado para tomar decisiones estadísticas.")))
      ),
      div(class = "bloque card-morado",
          "El experimento fue diseñado para ser reproducible y confiable. Se utilizaron datos generados aleatoriamente y se ejecutaron los cuatro algoritmos varias veces en condiciones controladas. Cada algoritmo fue evaluado en 50 réplicas independientes, lo que ayuda a obtener resultados más estables y menos dependientes del azar."
      ),
      div(class = "bloque card-celeste",
          "La función de esta sección es explicar cómo se obtuvieron los datos y por qué el diseño experimental utilizado da soporte al análisis. Mientras mejor esté planteada esta parte, más confianza se puede tener en las conclusiones finales."
      ),
      div(class = "bloque card-morado",
          "Además, esta sección permite justificar que el estudio no fue improvisado, sino que siguió una lógica ordenada para que los resultados pudieran interpretarse con mayor seguridad."
      )
    )
  ),

  tabPanel(
    "Supuestos",
    fluidPage(
      span(class = "etiqueta-seccion et-sup", "Supuestos"),
      fluidRow(
        column(5,
               div(class = "tarjeta card-cafe",
                   h3("¿Por qué revisar supuestos?"),
                   p("Antes de aplicar el ANOVA, es necesario verificar ciertos supuestos estadísticos. Esto permite confirmar que el método utilizado es adecuado para los datos y que las conclusiones obtenidas son válidas."),
                   p("Revisar los supuestos es importante porque fortalece la calidad del análisis y demuestra que el procedimiento fue aplicado correctamente.")
               )),
        column(7,
               div(class = "tarjeta card-amarillo",
                   h3("Tabla de supuestos"),
                   DTOutput("tabla_supuestos")
               ))
      ),
      div(class = "bloque card-cafe",
          "La función de esta sección es mostrar que el estudio no se limitó solamente a calcular resultados, sino que también revisó si las condiciones del método estadístico se cumplían de manera razonable."
      )
    )
  ),

  tabPanel(
    "Resultados",
    fluidPage(
      span(class = "etiqueta-seccion et-res", "Resultados"),
      fluidRow(
        column(3, div(class = "tarjeta card-rojo centrado", span(class = "numero", "284.37"), p("F del ANOVA"), p("Este valor refleja que hubo diferencias importantes entre los grupos."))),
        column(3, div(class = "tarjeta card-amarillo centrado", span(class = "numero", "< 0.001"), p("valor p"), p("Indica que las diferencias encontradas no se deben al azar."))),
        column(3, div(class = "tarjeta card-verde centrado", span(class = "numero", "0.81"), p("eta cuadrado"), p("Muestra que el algoritmo explicó gran parte de la variación."))),
        column(3, div(class = "tarjeta card-celeste centrado", span(class = "numero", "Bubble"), p("algoritmo más lento"), p("Fue el que presentó el peor rendimiento dentro del estudio.")))
      ),
      div(class = "bloque card-rojo",
          "En esta sección se presentan los resultados principales del análisis estadístico realizado sobre los tiempos de ejecución. Primero se muestra un resumen descriptivo con promedios, dispersión y mediana. Después aparece el ANOVA, cuya función es comprobar si existen diferencias significativas entre los grupos. Finalmente, se incluye la prueba de Tukey, que permite identificar exactamente entre cuáles algoritmos aparecen esas diferencias."
      ),
      fluidRow(
        column(6,
               div(class = "tarjeta card-celeste",
                   h3("Estadísticos descriptivos"),
                   p("Aquí se presentan los valores promedio y otras medidas importantes para resumir el comportamiento de cada algoritmo."),
                   DTOutput("tabla_desc")
               )),
        column(6,
               div(class = "tarjeta card-verde",
                   h3("Tiempo promedio por algoritmo"),
                   p("Este gráfico ayuda a comparar visualmente el rendimiento de los algoritmos y facilita la explicación de las diferencias observadas."),
                   plotOutput("graf_barra", height = 320)
               ))
      ),
      fluidRow(
        column(6,
               div(class = "tarjeta card-amarillo",
                   h3("Tabla ANOVA"),
                   p("Esta tabla resume el resultado global de la comparación estadística entre todos los algoritmos."),
                   DTOutput("tabla_anova")
               )),
        column(6,
               div(class = "tarjeta card-morado",
                   h3("Comparaciones de Tukey"),
                   p("Aquí se observa con detalle entre cuáles pares de algoritmos sí hubo diferencia y entre cuáles no."),
                   DTOutput("tabla_tukey")
               ))
      ),
      div(class = "bloque card-rojo",
          "El ANOVA mostró un valor F = 284.37 y un valor p menor a 0.001, lo que indica que sí existen diferencias significativas entre los algoritmos. Además, el tamaño del efecto fue η² = 0.81, lo que significa que el tipo de algoritmo explicó aproximadamente el 81% de la variación total en los tiempos de ejecución."
      )
    )
  ),

  tabPanel(
    "Interpretación",
    fluidPage(
      span(class = "etiqueta-seccion et-int", "Interpretación"),
      div(class = "tarjeta card-celeste",
          h3("¿Qué significan estos resultados?"),
          p("La interpretación de los resultados permite traducir los números a un lenguaje más claro. En este caso, el análisis demuestra que la elección del algoritmo sí tuvo un efecto importante en el tiempo de ejecución."),
          p("Esta sección ayuda a entender qué aportan realmente los resultados y cómo responden a la pregunta de investigación.")
      ),
      fluidRow(
        column(4,
               div(class = "mini-card card-amarillo",
                   h3("Bubble Sort"),
                   p("Presentó tiempos mucho mayores que los demás. Esto confirma que no es una buena opción cuando se trabaja con cantidades grandes de datos."),
                   p("Su comportamiento sirve como contraste frente a los algoritmos más eficientes.")
               )),
        column(4,
               div(class = "mini-card card-verde",
                   h3("Merge Sort y Quick Sort"),
                   p("Mostraron un comportamiento muy parecido. La prueba de Tukey indicó que la diferencia entre ellos no fue significativa."),
                   p("Esto sugiere que ambos pueden considerarse opciones eficientes dentro de las condiciones evaluadas.")
               )),
        column(4,
               div(class = "mini-card card-morado",
                   h3("Heap Sort"),
                   p("También tuvo un rendimiento aceptable, aunque fue más lento que Merge Sort y Quick Sort."),
                   p("Aun así, se mantuvo muy por encima del rendimiento de Bubble Sort.")
               ))
      ),
      div(class = "bloque card-celeste",
          "La función de esta sección es explicar qué aportan realmente los resultados al estudio. No se trata solo de leer tablas o números, sino de entender cómo esos resultados responden la pregunta de investigación y qué enseñan sobre el comportamiento de los algoritmos."
      )
    )
  ),

  tabPanel(
    "Conclusiones",
    fluidPage(
      span(class = "etiqueta-seccion et-conc", "Conclusiones"),
      div(class = "bloque card-oscuroverde",
          "A partir del análisis realizado, se puede concluir que sí existen diferencias significativas entre los algoritmos evaluados. Esto permitió rechazar la hipótesis nula y aceptar que el tipo de algoritmo influye de manera importante en el tiempo de ejecución. Esta conclusión responde directamente al objetivo principal del estudio."
      ),
      div(class = "bloque card-verde",
          "El resultado más claro fue que Bubble Sort presentó el peor rendimiento. Sus tiempos fueron mucho mayores que los de los otros algoritmos, lo que confirma que no es una alternativa conveniente para trabajar con conjuntos de datos grandes. Esto coincide con lo que también se espera desde la teoría."
      ),
      div(class = "bloque card-celeste",
          "También se encontró que Merge Sort y Quick Sort tuvieron un comportamiento muy similar. Aunque sus medias no fueron exactamente iguales, la diferencia no fue lo bastante grande como para considerarse significativa, por lo que ambos pueden verse como opciones eficientes en este estudio."
      ),
      div(class = "bloque card-oscuroverde",
          "En general, este trabajo demuestra que la estadística ayuda a respaldar decisiones técnicas con evidencia. Gracias a este análisis fue posible comparar algoritmos de manera más objetiva y llegar a conclusiones claras sobre su comportamiento. Así, el estudio no solo aporta resultados numéricos, sino también una forma más sólida de interpretar el rendimiento de los algoritmos."
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$go_intro, {
    updateNavbarPage(session, "nav", selected = "Introducción")
  })
  observeEvent(input$go_problema, {
    updateNavbarPage(session, "nav", selected = "Problema y Objetivo")
  })
  observeEvent(input$go_alg, {
    updateNavbarPage(session, "nav", selected = "Algoritmos")
  })
  observeEvent(input$go_diseno, {
    updateNavbarPage(session, "nav", selected = "Diseño Experimental")
  })
  observeEvent(input$go_sup, {
    updateNavbarPage(session, "nav", selected = "Supuestos")
  })
  observeEvent(input$go_res, {
    updateNavbarPage(session, "nav", selected = "Resultados")
  })
  observeEvent(input$go_inter, {
    updateNavbarPage(session, "nav", selected = "Interpretación")
  })
  observeEvent(input$go_conc, {
    updateNavbarPage(session, "nav", selected = "Conclusiones")
  })

  output$tabla_desc <- renderDT({
    datatable(
      desc_10k,
      rownames = FALSE,
      options = list(pageLength = 5, dom = 't'),
      class = "cell-border stripe"
    )
  })

  output$tabla_anova <- renderDT({
    datatable(
      anova_tabla,
      rownames = FALSE,
      options = list(pageLength = 5, dom = 't'),
      class = "cell-border stripe"
    )
  })

  output$tabla_tukey <- renderDT({
    datatable(
      tukey_tabla,
      rownames = FALSE,
      options = list(pageLength = 10, scrollX = TRUE),
      class = "cell-border stripe"
    )
  })

  output$tabla_supuestos <- renderDT({
    datatable(
      supuestos_tabla,
      rownames = FALSE,
      options = list(pageLength = 5, scrollX = TRUE, dom = 't'),
      class = "cell-border stripe"
    )
  })

  output$graf_barra <- renderPlot({
    ggplot(desc_10k, aes(x = Algoritmo, y = Media_ms, fill = Algoritmo)) +
      geom_col(show.legend = FALSE) +
      geom_text(aes(label = round(Media_ms, 1)), vjust = -0.35, size = 5) +
      labs(
        title = "Tiempo promedio de ejecución por algoritmo",
        x = "Algoritmo",
        y = "Tiempo promedio (ms)"
      ) +
      theme_minimal(base_size = 14)
  })
}

shinyApp(ui, server)
