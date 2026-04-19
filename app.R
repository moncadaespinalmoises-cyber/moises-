# ============================================================
# ESTADÍSTICA INFERENCIAL IS-241 — UNADECA
# Aplicación Global | Prof. Dodanim Castillo Aráuz
# Diseño: Moderno con portada y paleta de colores única
# ============================================================
# Paquetes: install.packages(c("shiny","ggplot2"))
# ============================================================

library(shiny)
library(ggplot2)

# ─── Paleta de colores global ────────────────────────────────
C1 <- "#0f0c29"   # morado muy oscuro (fondo portada)
C2 <- "#302b63"   # morado medio
C3 <- "#24243e"   # morado azulado
ACC1 <- "#f72585" # rosa fucsia (acento 1)
ACC2 <- "#7209b7" # violeta (acento 2)
ACC3 <- "#3a86ff" # azul eléctrico (acento 3)
ACC4 <- "#4cc9f0" # celeste (acento 4)
ACC5 <- "#06d6a0" # verde menta (acento 5)
WARN <- "#ff9e00" # naranja (advertencia / resultado)
BG   <- "#f0f2f5" # fondo general claro

# ============================================================
# UI
# ============================================================
ui <- fluidPage(
  title = "EstadísticaIS241",

  # ── CSS GLOBAL ────────────────────────────────────────────
  tags$head(
    tags$style(HTML(paste0("
      @import url('https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&family=Space+Grotesk:wght@400;500;600;700&display=swap');

      * { box-sizing: border-box; }
      body { font-family:'Nunito',sans-serif; background:", BG,"; margin:0; padding:0; }

      /* ── PORTADA ────────────────────────────────────── */
      #portada {
        background: linear-gradient(135deg,",C1,",",C2,",",C3,");
        min-height:100vh; display:flex; flex-direction:column;
        align-items:center; justify-content:center;
        padding:40px 20px; position:relative; overflow:hidden;
      }
      #portada::before {
        content:''; position:absolute; width:600px; height:600px;
        border-radius:50%;
        background: radial-gradient(circle,",ACC2,"44,transparent 70%);
        top:-100px; left:-100px; pointer-events:none;
      }
      #portada::after {
        content:''; position:absolute; width:500px; height:500px;
        border-radius:50%;
        background: radial-gradient(circle,",ACC1,"33,transparent 70%);
        bottom:-80px; right:-80px; pointer-events:none;
      }
      .portada-logo {
        font-size:80px; margin-bottom:10px;
        animation: float 3s ease-in-out infinite;
      }
      @keyframes float {
        0%,100%{transform:translateY(0)} 50%{transform:translateY(-12px)}
      }
      .portada-titulo {
        font-family:'Space Grotesk',sans-serif;
        font-size:48px; font-weight:800; color:white;
        text-align:center; line-height:1.1; margin:0;
        text-shadow:0 4px 20px rgba(0,0,0,0.5);
      }
      .portada-titulo span { color:",ACC4,"; }
      .portada-sub {
        font-size:18px; color:rgba(255,255,255,0.75);
        text-align:center; margin:12px 0 0 0; font-weight:600;
      }
      .portada-chips {
        display:flex; flex-wrap:wrap; gap:10px;
        justify-content:center; margin:30px 0;
      }
      .chip {
        background:rgba(255,255,255,0.1); color:white;
        border:1px solid rgba(255,255,255,0.2); border-radius:999px;
        padding:6px 16px; font-size:13px; font-weight:700;
        backdrop-filter:blur(8px);
      }
      .chip-color { background:rgba(76,201,240,0.2); border-color:",ACC4,"; color:",ACC4,"; }
      .portada-cards {
        display:flex; flex-wrap:wrap; gap:16px;
        justify-content:center; max-width:900px; margin:10px auto;
      }
      .portada-card {
        background:rgba(255,255,255,0.08);
        border:1px solid rgba(255,255,255,0.15);
        border-radius:16px; padding:18px 22px;
        min-width:200px; max-width:240px; flex:1;
        backdrop-filter:blur(10px);
        transition:transform .2s, background .2s;
        cursor:default;
      }
      .portada-card:hover { transform:translateY(-4px); background:rgba(255,255,255,0.14); }
      .portada-card .card-icon { font-size:32px; margin-bottom:8px; }
      .portada-card .card-title { color:white; font-weight:800; font-size:15px; margin:0 0 4px 0; }
      .portada-card .card-desc { color:rgba(255,255,255,0.6); font-size:12px; margin:0; }
      .btn-entrar {
        margin-top:36px;
        background: linear-gradient(90deg,",ACC1,",",ACC2,");
        color:white; border:none; border-radius:999px;
        padding:16px 48px; font-size:18px; font-weight:800;
        cursor:pointer; box-shadow:0 8px 30px rgba(247,37,133,0.4);
        transition:transform .2s, box-shadow .2s;
        font-family:'Nunito',sans-serif;
      }
      .btn-entrar:hover {
        transform:translateY(-2px) scale(1.03);
        box-shadow:0 12px 40px rgba(247,37,133,0.55);
      }
      .portada-footer {
        color:rgba(255,255,255,0.4); font-size:12px;
        text-align:center; margin-top:40px;
      }

      /* ── NAVBAR / HEADER APP ────────────────────────── */
      #app-main { display:none; }
      .app-topbar {
        background: linear-gradient(90deg,",C1,",",C2,");
        padding:12px 24px; display:flex; align-items:center;
        justify-content:space-between; gap:12px;
        box-shadow:0 4px 20px rgba(0,0,0,0.3);
        position:sticky; top:0; z-index:100;
      }
      .app-topbar-brand {
        font-family:'Space Grotesk',sans-serif;
        font-weight:800; font-size:20px; color:white;
        display:flex; align-items:center; gap:10px;
      }
      .app-topbar-brand span { color:",ACC4,"; }
      .btn-volver {
        background:rgba(255,255,255,0.1); color:white;
        border:1px solid rgba(255,255,255,0.2); border-radius:999px;
        padding:6px 18px; font-size:13px; font-weight:700;
        cursor:pointer; font-family:'Nunito',sans-serif;
        transition:background .2s;
      }
      .btn-volver:hover { background:rgba(255,255,255,0.2); }

      /* ── TABS ───────────────────────────────────────── */
      .nav-tabs { border:none; padding:16px 20px 0; gap:6px; display:flex; flex-wrap:wrap; }
      .nav-tabs > li > a {
        border-radius:999px !important; border:2px solid #ddd !important;
        color:#555; font-weight:700; font-size:13px;
        padding:7px 18px; background:white;
        transition:all .2s;
      }
      .nav-tabs > li > a:hover { border-color:",ACC3," !important; color:",ACC3,"; background:#f0f4ff; }
      .nav-tabs > li.active > a {
        background: linear-gradient(90deg,",ACC3,",",ACC2,") !important;
        color:white !important; border-color:transparent !important;
        box-shadow:0 4px 15px rgba(58,134,255,0.35);
      }
      .tab-content { padding:20px; }

      /* ── PANEL LATERAL (inputs) ─────────────────────── */
      .panel-inputs {
        background:white; border-radius:20px;
        padding:22px; box-shadow:0 4px 24px rgba(0,0,0,0.07);
        border-top:5px solid ",ACC3,";
      }
      .panel-inputs h4 {
        font-family:'Space Grotesk',sans-serif;
        color:",C2,"; font-weight:700; margin-top:0;
        font-size:16px;
      }
      .panel-inputs .form-control {
        border-radius:10px; border:2px solid #e8ecf0;
        font-family:'Nunito',sans-serif; font-size:14px;
        transition:border .2s;
      }
      .panel-inputs .form-control:focus { border-color:",ACC3,"; box-shadow:0 0 0 3px rgba(58,134,255,0.15); }
      .panel-inputs label { font-weight:700; color:#444; font-size:13px; }
      .panel-inputs .help-block { font-size:12px; color:#888; }
      .panel-inputs hr { border-color:#eee; margin:12px 0; }

      /* ── BOTÓN CALCULAR ──────────────────────────────── */
      .btn-calc {
        width:100%; border:none; border-radius:12px;
        padding:13px; font-size:16px; font-weight:800;
        cursor:pointer; font-family:'Nunito',sans-serif;
        background: linear-gradient(90deg,",ACC1,",",ACC2,");
        color:white; box-shadow:0 6px 20px rgba(247,37,133,0.3);
        transition:transform .15s, box-shadow .15s; margin-top:10px;
      }
      .btn-calc:hover { transform:translateY(-2px); box-shadow:0 10px 28px rgba(247,37,133,0.4); }
      .btn-calc:active { transform:translateY(0); }
      /* Shiny native buttons styled like btn-calc */
      .btn-shiny-calc {
        width:100% !important; border:none !important; border-radius:12px !important;
        padding:13px 20px !important; font-size:16px !important; font-weight:800 !important;
        font-family:'Nunito',sans-serif !important; margin-top:10px !important;
        background: linear-gradient(90deg,#f72585,#7209b7) !important;
        color:white !important; box-shadow:0 6px 20px rgba(247,37,133,0.3) !important;
        transition:transform .15s, box-shadow .15s !important;
      }
      .btn-shiny-calc:hover {
        transform:translateY(-2px) !important;
        box-shadow:0 10px 28px rgba(247,37,133,0.4) !important;
        background: linear-gradient(90deg,#f72585,#7209b7) !important;
        color:white !important;
      }
      .btn-shiny-calc:active { transform:translateY(0) !important; }
      .btn-shiny-calc:focus { outline:none !important; box-shadow:0 6px 20px rgba(247,37,133,0.3) !important; }

      /* ── PANEL RESULTADOS ───────────────────────────── */
      .panel-result {
        background:white; border-radius:20px;
        box-shadow:0 4px 24px rgba(0,0,0,0.07);
        overflow:hidden;
      }
      .result-header {
        background: linear-gradient(135deg,",C2,",",C1,");
        padding:18px 24px; display:flex; align-items:center; gap:12px;
      }
      .result-header h3 {
        margin:0; color:white;
        font-family:'Space Grotesk',sans-serif; font-size:20px; font-weight:700;
      }
      .result-header .result-icon { font-size:28px; }
      .result-body { padding:22px; }
      .result-body pre {
        background:#1a1a2e; color:#e0e0ff;
        border-radius:12px; padding:16px; font-size:13px;
        line-height:1.7; border:none;
        font-family:'Courier New',monospace;
      }

      /* ── FORMULA BOX ────────────────────────────────── */
      .formula-box {
        background: linear-gradient(135deg,rgba(58,134,255,0.08),rgba(114,9,183,0.08));
        border:1px solid rgba(58,134,255,0.2); border-radius:14px;
        padding:14px 16px; margin-top:14px;
      }
      .formula-box p { margin:0; color:#333; font-size:13px; }

      /* ── INFO CARDS ──────────────────────────────────── */
      .info-strip {
        display:flex; flex-wrap:wrap; gap:10px; margin-bottom:16px;
      }
      .info-card {
        flex:1; min-width:120px; border-radius:14px;
        padding:14px 16px; text-align:center;
      }
      .ic-blue  { background:linear-gradient(135deg,#e8f0fe,#c7d9fc); border:1px solid #a8c4fa; }
      .ic-pink  { background:linear-gradient(135deg,#fde8f4,#fac7e5); border:1px solid #f7a8d4; }
      .ic-green { background:linear-gradient(135deg,#e8fef5,#c7fadf); border:1px solid #a8f0c4; }
      .ic-orange{ background:linear-gradient(135deg,#fff3e0,#ffe0b2); border:1px solid #ffcc80; }
      .ic-purple{ background:linear-gradient(135deg,#f3e5f5,#e1bee7); border:1px solid #ce93d8; }
      .info-card .ic-val { font-size:22px; font-weight:900; color:#222; font-family:'Space Grotesk',sans-serif; }
      .info-card .ic-lbl { font-size:11px; color:#666; font-weight:700; margin-top:2px; }

      /* ── TABLA ───────────────────────────────────────── */
      .table-striped > tbody > tr:nth-child(odd) > td { background:#f7f0ff; }
      .table > thead > tr > th {
        background: linear-gradient(90deg,",C2,",",ACC2,");
        color:white; font-weight:700; border:none;
      }
      .table { border-radius:12px; overflow:hidden; font-size:13px; }

      /* ── SECCIÓN REFERENCIA ──────────────────────────── */
      .ref-box {
        background:white; border-radius:20px; padding:24px;
        box-shadow:0 4px 24px rgba(0,0,0,0.07);
        border-left:5px solid ",ACC3,";
      }
      .ref-box h3 { color:",C2,"; font-family:'Space Grotesk',sans-serif; }
      .ref-box h4 { color:",ACC2,"; font-size:15px; margin-top:18px; }

      /* ── SCROLLBAR ───────────────────────────────────── */
      ::-webkit-scrollbar { width:6px; }
      ::-webkit-scrollbar-track { background:#f1f1f1; }
      ::-webkit-scrollbar-thumb { background:",ACC2,"; border-radius:3px; }

      /* ── SELECT ──────────────────────────────────────── */
      select.form-control { border-radius:10px; }

      /* ── SIDEBAR LAYOUT OVERRIDE ─────────────────────── */
      .well { background:transparent; border:none; box-shadow:none; padding:0; }
    ")))
  ),

  # ── JAVASCRIPT (portada → app) ─────────────────────────────
  tags$script(HTML("
    function mostrarApp() {
      document.getElementById('portada').style.display='none';
      document.getElementById('app-main').style.display='block';
    }
    function volverPortada() {
      document.getElementById('app-main').style.display='none';
      document.getElementById('portada').style.display='flex';
    }
  ")),

  # ===========================================================
  # PORTADA
  # ===========================================================
  div(id = "portada",
    div(class = "portada-logo", "📊"),
    h1(class = "portada-titulo",
      "Estadística", tags$br(),
      tags$span("Inferencial"), " IS-241"
    ),
    p(class = "portada-sub", "UNADECA | Escuela de Ingeniería en Sistemas"),
    p(class = "portada-sub",
      style = "font-size:14px; opacity:0.6; margin-top:4px;",
      "Prof. Dodanim Castillo Aráuz | 2026"
    ),
    div(class = "portada-chips",
      span(class="chip chip-color", "📋 Estadística Descriptiva"),
      span(class="chip chip-color", "🎲 Distribución Binomial"),
      span(class="chip chip-color", "🔔 Distribución Normal"),
      span(class="chip chip-color", "🔬 Prueba de Hipótesis"),
      span(class="chip chip-color", "χ² Chi-cuadrado"),
      span(class="chip chip-color", "📈 Regresión y Correlación"),
      span(class="chip chip-color", "🎯 Muestreo Estadístico")
    ),
    div(class = "portada-cards",
      div(class="portada-card",
        div(class="card-icon","🔬"),
        p(class="card-title","Pruebas de Hipótesis"),
        p(class="card-desc","Z, t, proporciones, diferencia de medias y proporciones")
      ),
      div(class="portada-card",
        div(class="card-icon","📈"),
        p(class="card-title","Regresión y Correlación"),
        p(class="card-desc","Lineal, cuadrática, exponencial, logarítmica y múltiple")
      ),
      div(class="portada-card",
        div(class="card-icon","χ²"),
        p(class="card-title","Chi-cuadrado"),
        p(class="card-desc","Bondad de ajuste, tablas de contingencia y homogeneidad")
      ),
      div(class="portada-card",
        div(class="card-icon","🎯"),
        p(class="card-title","Muestreo"),
        p(class="card-desc","Aleatorio, estratificado, sistemático y tamaño de muestra")
      )
    ),
    tags$button(class="btn-entrar", onclick="mostrarApp()",
      "🚀  Ingresar a la Aplicación"
    ),
    p(class="portada-footer",
      "Aplicación Global de Resolución de Problemas | IS-241 Estadística Inferencial"
    )
  ),

  # ===========================================================
  # APP PRINCIPAL
  # ===========================================================
  div(id = "app-main",

    # Barra superior
    div(class="app-topbar",
      div(class="app-topbar-brand",
        "📊 EstadísticaIS241 —", tags$span(" UNADECA")
      ),
      tags$button(class="btn-volver", onclick="volverPortada()", "← Portada")
    ),

    # Tabs principales
    tabsetPanel(id="tabs", type="tabs",

      # ─────────────────────────────────────────────
      # TAB 1: DESCRIPTIVA
      # ─────────────────────────────────────────────
      tabPanel("📋 Descriptiva",
        br(),
        fluidRow(
          column(4,
            div(class="panel-inputs",
              h4("📥 Ingreso de datos"),
              textAreaInput("desc_datos","Datos (separados por comas o espacios):",
                value="12,15,14,10,18,20,14,16,15,13,17,11", rows=3),
              div(class="formula-box",
                tags$p("Calcula: media, mediana, moda, varianza, desv. estándar,",
                       "CV, cuartiles, IQR y asimetría de Pearson.")
              ),
              br(),
              actionButton("calc_desc", "⚡  Calcular", class="btn-shiny-calc")
            )
          ),
          column(8,
            div(class="panel-result",
              div(class="result-header",
                span(class="result-icon","📊"),
                h3("Estadística Descriptiva")
              ),
              div(class="result-body",
                uiOutput("desc_cards"),
                verbatimTextOutput("desc_resultado"),
                plotOutput("desc_grafico", height="380px")
              )
            )
          )
        )
      ),

      # ─────────────────────────────────────────────
      # TAB 2: BINOMIAL
      # ─────────────────────────────────────────────
      tabPanel("🎲 Binomial",
        br(),
        fluidRow(
          column(4,
            div(class="panel-inputs",
              h4("⚙️ Parámetros"),
              fluidRow(
                column(6, numericInput("bin_n","n — Ensayos:",value=12,min=1,max=500)),
                column(6, numericInput("bin_p","p — P(éxito):",value=0.80,min=0,max=1,step=0.01))
              ),
              numericInput("bin_x","x — Número de éxitos:",value=7,min=0),
              selectInput("bin_tipo","Tipo de probabilidad:",
                choices=c(
                  "P(X = x) — Exactamente x"="igual",
                  "P(X ≤ x) — A lo sumo x"="menor_igual",
                  "P(X ≥ x) — Al menos x"="mayor_igual",
                  "P(X < x) — Menos de x"="menor",
                  "P(X > x) — Más de x"="mayor",
                  "P(a ≤ X ≤ b) — Entre a y b"="entre"
                )),
              conditionalPanel("input.bin_tipo=='entre'",
                fluidRow(
                  column(6,numericInput("bin_a","a (inf):",value=5,min=0)),
                  column(6,numericInput("bin_b","b (sup):",value=9,min=0))
                )
              ),
              div(class="formula-box",
                withMathJax(helpText("$$P(X=x)=\\binom{n}{x}p^x q^{n-x}$$"))
              ),
              br(),
              actionButton("calc_bin", "⚡  Calcular", class="btn-shiny-calc")
            )
          ),
          column(8,
            div(class="panel-result",
              div(class="result-header",
                span(class="result-icon","🎲"),
                h3("Distribución Binomial")
              ),
              div(class="result-body",
                uiOutput("bin_cards"),
                verbatimTextOutput("bin_resultado"),
                plotOutput("bin_grafico", height="340px"),
                br(),
                h4(style="color:#302b63;font-family:'Space Grotesk';",
                   "📋 Tabla de distribución completa"),
                div(style="max-height:300px;overflow-y:auto;",
                  tableOutput("bin_tabla"))
              )
            )
          )
        )
      ),

      # ─────────────────────────────────────────────
      # TAB 3: NORMAL
      # ─────────────────────────────────────────────
      tabPanel("🔔 Normal",
        br(),
        fluidRow(
          column(4,
            div(class="panel-inputs",
              h4("⚙️ Parámetros"),
              fluidRow(
                column(6,numericInput("norm_mu","μ — Media:",value=100)),
                column(6,numericInput("norm_sigma","σ — Desv. est.:",value=15,min=0.001))
              ),
              hr(),
              selectInput("norm_tipo","¿Qué calcular?",
                choices=c(
                  "P(X ≤ x)"="menor",
                  "P(X ≥ x)"="mayor",
                  "P(a ≤ X ≤ b)"="entre",
                  "Valor x dado P (cuantil)"="cuantil",
                  "Z-score de un valor x"="zscore"
                )),
              conditionalPanel("input.norm_tipo!='entre'&&input.norm_tipo!='cuantil'",
                numericInput("norm_x","Valor de x:",value=110)
              ),
              conditionalPanel("input.norm_tipo=='entre'",
                fluidRow(
                  column(6,numericInput("norm_a","a:",value=90)),
                  column(6,numericInput("norm_b","b:",value=115))
                )
              ),
              conditionalPanel("input.norm_tipo=='cuantil'",
                numericInput("norm_p","Probabilidad P:",value=0.95,min=0.001,max=0.999,step=0.001)
              ),
              div(class="formula-box",
                withMathJax(helpText("$$Z=\\frac{x-\\mu}{\\sigma}$$"))
              ),
              br(),
              actionButton("calc_norm", "⚡  Calcular", class="btn-shiny-calc")
            )
          ),
          column(8,
            div(class="panel-result",
              div(class="result-header",
                span(class="result-icon","🔔"),
                h3("Distribución Normal")
              ),
              div(class="result-body",
                uiOutput("norm_cards"),
                verbatimTextOutput("norm_resultado"),
                plotOutput("norm_grafico",height="380px")
              )
            )
          )
        )
      ),

      # ─────────────────────────────────────────────
      # TAB 4: PRUEBA DE HIPÓTESIS
      # ─────────────────────────────────────────────
      tabPanel("🔬 Hipótesis",
        br(),
        fluidRow(
          column(4,
            div(class="panel-inputs",
              h4("⚙️ Seleccione el caso"),
              selectInput("ph_caso","Tipo de prueba:",
                choices=c(
                  "── MEDIA ──"="",
                  "Media (σ conocida) — Prueba Z"="media_z",
                  "Media (σ desconocida, t) — Prueba t"="media_t",
                  "── PROPORCIÓN ──"="",
                  "Una proporción — Prueba Z"="proporcion",
                  "── DOS MUESTRAS ──"="",
                  "Diferencia de medias"="dos_medias",
                  "Diferencia de proporciones"="dos_proporciones"
                )),
              hr(),

              # --- MEDIA Z ---
              conditionalPanel("input.ph_caso=='media_z'",
                h4("Una media — Prueba Z"),
                fluidRow(
                  column(6,numericInput("mz_mu0","μ₀ (H₀):",value=100)),
                  column(6,numericInput("mz_xbar","X̄ muestral:",value=102))
                ),
                fluidRow(
                  column(6,numericInput("mz_sigma","σ (conocida):",value=10,min=0.001)),
                  column(6,numericInput("mz_n","n:",value=400,min=1))
                ),
                selectInput("mz_cola","Tipo H₁:",
                  choices=c("Bilateral μ≠μ₀"="dos","Cola der. μ>μ₀"="derecha","Cola izq. μ<μ₀"="izquierda")),
                numericInput("mz_alfa","α:",value=0.05,step=0.01)
              ),

              # --- MEDIA t ---
              conditionalPanel("input.ph_caso=='media_t'",
                h4("Una media — Prueba t"),
                fluidRow(
                  column(6,numericInput("mt_mu0","μ₀ (H₀):",value=104)),
                  column(6,numericInput("mt_xbar","X̄ muestral:",value=102))
                ),
                fluidRow(
                  column(6,numericInput("mt_s","s muestral:",value=8,min=0.001)),
                  column(6,numericInput("mt_n","n:",value=36,min=2))
                ),
                selectInput("mt_cola","Tipo H₁:",
                  choices=c("Bilateral μ≠μ₀"="dos","Cola der. μ>μ₀"="derecha","Cola izq. μ<μ₀"="izquierda")),
                numericInput("mt_alfa","α:",value=0.05,step=0.01)
              ),

              # --- PROPORCIÓN ---
              conditionalPanel("input.ph_caso=='proporcion'",
                h4("Una proporción — Prueba Z"),
                fluidRow(
                  column(6,numericInput("pr_P","P pob. (H₀):",value=0.32,min=0,max=1,step=0.01)),
                  column(6,numericInput("pr_p","p muestral:",value=0.26,min=0,max=1,step=0.01))
                ),
                numericInput("pr_n","n:",value=400,min=1),
                selectInput("pr_cola","Tipo H₁:",
                  choices=c("Bilateral P≠P₀"="dos","Cola der. P>P₀"="derecha","Cola izq. P<P₀"="izquierda")),
                numericInput("pr_alfa","α:",value=0.05,step=0.01)
              ),

              # --- DOS MEDIAS ---
              conditionalPanel("input.ph_caso=='dos_medias'",
                h4("Diferencia de medias"),
                fluidRow(
                  column(6,numericInput("dm_x1","X̄₁:",value=68)),
                  column(6,numericInput("dm_x2","X̄₂:",value=65))
                ),
                fluidRow(
                  column(6,numericInput("dm_s1","s₁:",value=12,min=0.001)),
                  column(6,numericInput("dm_s2","s₂:",value=14,min=0.001))
                ),
                fluidRow(
                  column(6,numericInput("dm_n1","n₁:",value=40,min=1)),
                  column(6,numericInput("dm_n2","n₂:",value=50,min=1))
                ),
                selectInput("dm_cola","Tipo H₁:",
                  choices=c("Bilateral μ₁≠μ₂"="dos","Cola der. μ₁>μ₂"="derecha","Cola izq. μ₁<μ₂"="izquierda")),
                numericInput("dm_alfa","α:",value=0.05,step=0.01)
              ),

              # --- DOS PROPORCIONES ---
              conditionalPanel("input.ph_caso=='dos_proporciones'",
                h4("Diferencia de proporciones"),
                fluidRow(
                  column(6,numericInput("dp_p1","p₁:",value=0.65,step=0.01)),
                  column(6,numericInput("dp_p2","p₂:",value=0.60,step=0.01))
                ),
                fluidRow(
                  column(6,numericInput("dp_n1","n₁:",value=200,min=1)),
                  column(6,numericInput("dp_n2","n₂:",value=300,min=1))
                ),
                selectInput("dp_cola","Tipo H₁:",
                  choices=c("Bilateral P₁≠P₂"="dos","Cola der. P₁>P₂"="derecha","Cola izq. P₁<P₂"="izquierda")),
                numericInput("dp_alfa","α:",value=0.05,step=0.01)
              ),

              br(),
              actionButton("calc_ph", "⚡  Calcular prueba", class="btn-shiny-calc")
            )
          ),
          column(8,
            div(class="panel-result",
              div(class="result-header",
                span(class="result-icon","🔬"),
                h3("Prueba de Hipótesis")
              ),
              div(class="result-body",
                uiOutput("ph_decision_badge"),
                verbatimTextOutput("ph_resultado"),
                plotOutput("ph_grafico",height="360px")
              )
            )
          )
        )
      ),

      # ─────────────────────────────────────────────
      # TAB 5: CHI-CUADRADO
      # ─────────────────────────────────────────────
      tabPanel("χ² Chi-cuadrado",
        br(),
        fluidRow(
          column(4,
            div(class="panel-inputs",
              h4("⚙️ Tipo de prueba"),
              selectInput("chi_tipo","Seleccione:",
                choices=c(
                  "Bondad de ajuste"="bondad",
                  "Tabla de contingencia (independencia)"="contingencia",
                  "Prueba de homogeneidad"="homogeneidad"
                )),

              conditionalPanel("input.chi_tipo=='bondad'",
                h4("Bondad de ajuste"),
                textAreaInput("chi_obs","Frecuencias OBSERVADAS (comas):",
                  value="16,10,15,18,14,17",rows=2),
                textAreaInput("chi_esp_p","Probabilidades esperadas (comas):",
                  value="1/6,1/6,1/6,1/6,1/6,1/6",rows=2),
                helpText("Vacío = distribución uniforme."),
                numericInput("chi_alfa_b","α:",value=0.05,step=0.01)
              ),

              conditionalPanel("input.chi_tipo=='contingencia'",
                h4("Tabla de contingencia"),
                fluidRow(
                  column(6,numericInput("chi_filas","Filas:",value=2,min=2,max=6)),
                  column(6,numericInput("chi_cols","Columnas:",value=2,min=2,max=6))
                ),
                textAreaInput("chi_tabla","Frecuencias obs. (fila a fila, comas):",
                  value="36,52,26,86",rows=4),
                numericInput("chi_alfa_c","α:",value=0.05,step=0.01)
              ),

              conditionalPanel("input.chi_tipo=='homogeneidad'",
                h4("Homogeneidad"),
                fluidRow(
                  column(6,numericInput("chi_filas_h","Filas:",value=2,min=2,max=6)),
                  column(6,numericInput("chi_cols_h","Columnas:",value=3,min=2,max=6))
                ),
                textAreaInput("chi_tabla_h","Frecuencias observadas (comas):",
                  value="57,80,43,57,58,20",rows=4),
                numericInput("chi_alfa_h","α:",value=0.05,step=0.01)
              ),

              div(class="formula-box",
                withMathJax(helpText("$$\\chi^2=\\sum\\frac{(O_i-E_i)^2}{E_i}$$"))
              ),
              br(),
              actionButton("calc_chi", "⚡  Calcular χ²", class="btn-shiny-calc")
            )
          ),
          column(8,
            div(class="panel-result",
              div(class="result-header",
                span(class="result-icon","χ²"),
                h3("Chi-cuadrado")
              ),
              div(class="result-body",
                uiOutput("chi_decision_badge"),
                verbatimTextOutput("chi_resultado"),
                plotOutput("chi_grafico",height="340px"),
                br(),
                div(style="max-height:280px;overflow-y:auto;",
                  tableOutput("chi_tabla_result"))
              )
            )
          )
        )
      ),

      # ─────────────────────────────────────────────
      # TAB 6: REGRESIÓN
      # ─────────────────────────────────────────────
      tabPanel("📈 Regresión",
        br(),
        fluidRow(
          column(4,
            div(class="panel-inputs",
              h4("📥 Datos"),
              textAreaInput("reg_x","Variable X (comas):",
                value="1,2,3,4,5,6,7,8,9,10",rows=2),
              textAreaInput("reg_y","Variable Y (comas):",
                value="2.1,3.9,6.2,8.0,9.8,11.9,13.5,15.8,17.3,19.2",rows=2),
              selectInput("reg_tipo","Modelo:",
                choices=c(
                  "Lineal: Ŷ = a + bX"="lineal",
                  "Cuadrático: Ŷ = a+bX+cX²"="cuadratico",
                  "Exponencial: Ŷ = a·e^(bX)"="exponencial",
                  "Logarítmico: Ŷ = a+b·ln(X)"="logaritmico"
                )),
              conditionalPanel("input.reg_tipo=='lineal'",
                numericInput("reg_xpred","Predecir Ŷ para X =",value=5)
              ),
              div(class="formula-box",
                withMathJax(helpText(
                  "$$b=\\frac{n\\sum XY-\\sum X\\sum Y}{n\\sum X^2-(\\sum X)^2}$$",
                  "$$r=\\frac{n\\sum XY-\\sum X\\sum Y}{\\sqrt{\\cdots}}$$"
                ))
              ),
              br(),
              actionButton("calc_reg", "⚡  Calcular", class="btn-shiny-calc")
            )
          ),
          column(8,
            div(class="panel-result",
              div(class="result-header",
                span(class="result-icon","📈"),
                h3("Regresión y Correlación")
              ),
              div(class="result-body",
                uiOutput("reg_cards"),
                verbatimTextOutput("reg_resultado"),
                plotOutput("reg_grafico",height="360px"),
                br(),
                div(style="max-height:280px;overflow-y:auto;",
                  tableOutput("reg_tabla"))
              )
            )
          )
        )
      ),

      # ─────────────────────────────────────────────
      # TAB 7: MUESTREO
      # ─────────────────────────────────────────────
      tabPanel("🎯 Muestreo",
        br(),
        fluidRow(
          column(4,
            div(class="panel-inputs",
              h4("⚙️ Tipo de muestreo"),
              selectInput("muest_tipo","Seleccione:",
                choices=c(
                  "Aleatorio Simple"="simple",
                  "Estratificado Proporcional"="estratificado",
                  "Sistemático"="sistematico",
                  "Tamaño de muestra necesario"="tamano"
                )),

              conditionalPanel("input.muest_tipo=='simple'",
                fluidRow(
                  column(6,numericInput("ms_N","N (población):",value=500,min=1)),
                  column(6,numericInput("ms_n","n (muestra):",value=50,min=1))
                ),
                numericInput("ms_semilla","Semilla aleatoria:",value=42,min=1)
              ),

              conditionalPanel("input.muest_tipo=='estratificado'",
                numericInput("est_n_total","n total deseado:",value=100,min=1),
                textAreaInput("est_estratos","Nombres de estratos (comas):",
                  value="Estrato A,Estrato B,Estrato C",rows=2),
                textAreaInput("est_tamanos","Tamaño Nᵢ de cada estrato:",
                  value="200,350,150",rows=2)
              ),

              conditionalPanel("input.muest_tipo=='sistematico'",
                fluidRow(
                  column(6,numericInput("sist_N","N:",value=200,min=1)),
                  column(6,numericInput("sist_n","n:",value=20,min=1))
                ),
                numericInput("sist_inicio","Inicio k₀:",value=3,min=1)
              ),

              conditionalPanel("input.muest_tipo=='tamano'",
                h5(style="color:#302b63;font-weight:700;","Para estimar una MEDIA:"),
                fluidRow(
                  column(6,numericInput("tam_sigma","σ:",value=15,min=0.001)),
                  column(6,numericInput("tam_E","E (error):",value=3,min=0.001))
                ),
                numericInput("tam_alfa_m","α:",value=0.05,step=0.01),
                hr(),
                h5(style="color:#302b63;font-weight:700;","Para estimar una PROPORCIÓN:"),
                fluidRow(
                  column(6,numericInput("tam_p","p:",value=0.5,min=0,max=1,step=0.01)),
                  column(6,numericInput("tam_Ep","E (error):",value=0.05,step=0.01))
                ),
                numericInput("tam_alfap","α:",value=0.05,step=0.01)
              ),

              br(),
              actionButton("calc_muest", "⚡  Calcular", class="btn-shiny-calc")
            )
          ),
          column(8,
            div(class="panel-result",
              div(class="result-header",
                span(class="result-icon","🎯"),
                h3("Muestreo Estadístico")
              ),
              div(class="result-body",
                verbatimTextOutput("muest_resultado"),
                plotOutput("muest_grafico",height="360px"),
                br(),
                div(style="max-height:280px;overflow-y:auto;",
                  tableOutput("muest_tabla"))
              )
            )
          )
        )
      ),

      # ─────────────────────────────────────────────
      # TAB 8: REFERENCIA
      # ─────────────────────────────────────────────
      tabPanel("📚 Referencia",
        br(),
        fluidRow(
          column(6,
            div(class="ref-box",
              h3("📐 Tablas de valores críticos"),
              h4("Valores Z más usados"),
              tableOutput("ref_z_tabla"),
              br(),
              h4("Valores χ² (gl 1–10)"),
              div(style="overflow-x:auto;",tableOutput("ref_chi_tabla"))
            )
          ),
          column(6,
            div(class="ref-box",
              h3("📖 Guía de uso"),
              tags$ol(style="line-height:2;",
                tags$li(tags$b("Descriptiva:")," Ingrese datos separados por comas."),
                tags$li(tags$b("Binomial:")," Defina n, p, x y el tipo de cálculo."),
                tags$li(tags$b("Normal:")," Ingrese μ, σ y el valor o probabilidad."),
                tags$li(tags$b("Hipótesis:")," Seleccione el caso y llene los datos."),
                tags$li(tags$b("Chi-cuadrado:")," Elija el tipo y los datos."),
                tags$li(tags$b("Regresión:")," Ingrese pares X, Y y elija el modelo."),
                tags$li(tags$b("Muestreo:")," Elija el tipo y los parámetros.")
              ),
              br(),
              h4("⚖️ Reglas de decisión"),
              tags$ul(style="line-height:2;",
                tags$li("Si |Z_calc| > Z_α → Rechazar H₀"),
                tags$li("Si p-valor < α → Rechazar H₀"),
                tags$li("Si χ²_calc > χ²_α → Rechazar H₀")
              ),
              br(),
              h4("🔗 Interpretación de r (Pearson)"),
              tags$ul(style="line-height:1.8;",
                tags$li(tags$b("|r| ≥ 0.90")," → Correlación muy fuerte"),
                tags$li(tags$b("|r| ≥ 0.70")," → Correlación fuerte"),
                tags$li(tags$b("|r| ≥ 0.50")," → Correlación moderada"),
                tags$li(tags$b("|r| < 0.50")," → Correlación débil")
              )
            )
          )
        )
      )
    ) # fin tabsetPanel
  ) # fin app-main
) # fin fluidPage


# ============================================================
# SERVIDOR
# ============================================================
server <- function(input, output, session) {

  # ── Parse números desde texto ─────────────────────────────
  pn <- function(txt) {
    txt <- gsub("\n",",",txt)
    partes <- trimws(strsplit(txt,"[,\\s]+")[[1]])
    partes <- partes[partes!=""]
    sapply(partes, function(x) tryCatch(eval(parse(text=x)), error=function(e) NA))
  }

  # ── Badge decisión ────────────────────────────────────────
  badge <- function(decision) {
    if (grepl("RECHAZAR",decision)) {
      tags$div(style=paste0(
        "background:linear-gradient(90deg,",ACC1,",",ACC2,");",
        "color:white;border-radius:999px;padding:8px 22px;",
        "font-weight:800;font-size:16px;display:inline-block;margin-bottom:14px;",
        "box-shadow:0 4px 15px rgba(247,37,133,0.35);"
      ), "❌ RECHAZAR H₀")
    } else {
      tags$div(style=paste0(
        "background:linear-gradient(90deg,",ACC5,",",ACC3,");",
        "color:white;border-radius:999px;padding:8px 22px;",
        "font-weight:800;font-size:16px;display:inline-block;margin-bottom:14px;",
        "box-shadow:0 4px 15px rgba(6,214,160,0.35);"
      ), "✅ NO RECHAZAR H₀")
    }
  }

  # ── Info card HTML ────────────────────────────────────────
  ic <- function(val, lbl, clase="ic-blue") {
    tags$div(class=paste("info-card",clase),
      tags$div(class="ic-val", val),
      tags$div(class="ic-lbl", lbl)
    )
  }

  # ── Gráfico región de rechazo Z ──────────────────────────
  plot_zreg <- function(z_calc, z_crit, cola, titulo) {
    x <- seq(-4,4,length.out=1000)
    y <- dnorm(x)
    df <- data.frame(x=x,y=y)

    g <- ggplot(df,aes(x,y)) +
      geom_line(color=C2,size=1.3) +
      labs(title=titulo, x="Z", y="Densidad") +
      theme_minimal(base_size=13) +
      theme(
        plot.title=element_text(color=C2,face="bold",family="sans"),
        plot.background=element_rect(fill="white",color=NA),
        panel.grid.minor=element_blank(),
        panel.grid.major=element_line(color="#f0f0f0")
      )

    fill_col <- ACC1
    if (cola=="dos") {
      g <- g +
        geom_area(data=subset(df,x<=-abs(z_crit)),aes(y=y),fill=fill_col,alpha=0.35) +
        geom_area(data=subset(df,x>=abs(z_crit)),aes(y=y),fill=fill_col,alpha=0.35) +
        geom_vline(xintercept=c(-abs(z_crit),abs(z_crit)),color=fill_col,linetype="dashed",size=1)
    } else if (cola=="derecha") {
      g <- g +
        geom_area(data=subset(df,x>=z_crit),aes(y=y),fill=fill_col,alpha=0.35) +
        geom_vline(xintercept=z_crit,color=fill_col,linetype="dashed",size=1)
    } else {
      g <- g +
        geom_area(data=subset(df,x<=z_crit),aes(y=y),fill=fill_col,alpha=0.35) +
        geom_vline(xintercept=z_crit,color=fill_col,linetype="dashed",size=1)
    }

    rechazado <- (cola=="dos" && abs(z_calc)>=abs(z_crit)) ||
                 (cola=="derecha" && z_calc>=z_crit) ||
                 (cola=="izquierda" && z_calc<=z_crit)
    col_zc <- if(rechazado) ACC1 else ACC5

    g + geom_vline(xintercept=z_calc,color=col_zc,size=2) +
      annotate("text",x=z_calc,y=max(y)*0.85,
               label=paste0("Z_calc\n",round(z_calc,4)),
               color=col_zc,fontface="bold",size=4) +
      annotate("text",x=if(cola=="izquierda") -3.2 else 3.2,
               y=max(y)*0.4,label="Región\nrechazo",
               color=fill_col,fontface="bold",size=3.5)
  }


  # ===========================================================
  # 1. ESTADÍSTICA DESCRIPTIVA
  # ===========================================================
  observeEvent(input$calc_desc, {
    datos <- tryCatch(pn(input$desc_datos), error=function(e) NULL)
    datos <- datos[!is.na(datos)]
    if (is.null(datos)||length(datos)<2) return()

    n <- length(datos)
    media <- mean(datos)
    mediana <- median(datos)
    ft <- table(datos); moda <- as.numeric(names(ft)[ft==max(ft)])
    moda_txt <- if(length(moda)==n) "Sin moda" else paste(moda,collapse=", ")
    var_m <- var(datos); sd_m <- sd(datos)
    var_p <- var_m*(n-1)/n; sd_p <- sqrt(var_p)
    cv <- sd_m/media*100
    q1 <- quantile(datos,0.25); q3 <- quantile(datos,0.75); iqr <- q3-q1
    asim <- 3*(media-mediana)/sd_m

    output$desc_cards <- renderUI({
      div(class="info-strip",
        ic(round(media,3),"Media (X̄)","ic-blue"),
        ic(round(mediana,3),"Mediana","ic-green"),
        ic(round(sd_m,3),"Desv. est. (s)","ic-pink"),
        ic(round(cv,2),"CV (%)","ic-orange"),
        ic(round(asim,3),"Asimetría","ic-purple")
      )
    })

    output$desc_resultado <- renderPrint({
      cat("════════════════════════════════════════\n")
      cat("  ESTADÍSTICA DESCRIPTIVA\n")
      cat("════════════════════════════════════════\n")
      cat(sprintf("  n=%d | Mín=%.2f | Máx=%.2f | Rango=%.2f\n",
                  n,min(datos),max(datos),max(datos)-min(datos)))
      cat("────────────────────────────────────────\n")
      cat("  TENDENCIA CENTRAL\n")
      cat(sprintf("  Media (X̄):  %.4f\n",media))
      cat(sprintf("  Mediana:    %.4f\n",mediana))
      cat(sprintf("  Moda:       %s\n",moda_txt))
      cat("────────────────────────────────────────\n")
      cat("  DISPERSIÓN\n")
      cat(sprintf("  s² (muestral):  %.4f\n",var_m))
      cat(sprintf("  s  (muestral):  %.4f\n",sd_m))
      cat(sprintf("  σ² (pobl.):     %.4f\n",var_p))
      cat(sprintf("  σ  (pobl.):     %.4f\n",sd_p))
      cat(sprintf("  CV:             %.2f%%\n",cv))
      cat("────────────────────────────────────────\n")
      cat("  CUARTILES\n")
      cat(sprintf("  Q1=%.4f | Q2=%.4f | Q3=%.4f | IQR=%.4f\n",q1,mediana,q3,iqr))
      cat("────────────────────────────────────────\n")
      cat("  ASIMETRÍA (Pearson)\n")
      cat(sprintf("  Coef=%.4f → %s\n",asim,
          if(abs(asim)<0.1)"Simétrica"
          else if(asim>0)"Asimétrica positiva (+)"
          else"Asimétrica negativa (-)"))
      cat("════════════════════════════════════════\n")
    })

    output$desc_grafico <- renderPlot({
      par(mfrow=c(1,3), mar=c(4,4,3,1), bg="white")

      # Histograma
      hist(datos, col=ACC3, border="white",
           main="Histograma", xlab="Valores", ylab="Frecuencia",
           las=1, col.main=C2, font.main=2)
      abline(v=media,   col=ACC1, lwd=2.5, lty=2)
      abline(v=mediana, col=ACC5, lwd=2.5, lty=2)
      legend("topright", legend=c(paste0("Media=",round(media,2)),
             paste0("Med=",round(mediana,2))),
             col=c(ACC1,ACC5), lwd=2, lty=2, bty="n", cex=0.8)

      # Boxplot
      boxplot(datos, col=ACC4, border=C2,
              main="Boxplot", ylab="Valores", las=1,
              col.main=C2, font.main=2)
      stripchart(datos, method="jitter", vertical=TRUE,
                 pch=19, col=paste0(ACC2,"99"), add=TRUE, cex=0.9)

      # Dotplot de frecuencias
      barplot(table(datos), col=colorRampPalette(c(ACC3,ACC2,ACC1))(length(table(datos))),
              border="white", main="Frecuencias", las=2,
              col.main=C2, font.main=2,
              xlab="Valor", ylab="Frecuencia")
    })
  })


  # ===========================================================
  # 2. DISTRIBUCIÓN BINOMIAL
  # ===========================================================
  observeEvent(input$calc_bin, {
    n <- input$bin_n; p <- input$bin_p; x <- input$bin_x
    tipo <- input$bin_tipo; q <- 1-p
    mu <- n*p; sigma <- sqrt(n*p*q)

    prob <- switch(tipo,
      "igual"       = dbinom(x,n,p),
      "menor_igual" = pbinom(x,n,p),
      "mayor_igual" = 1-pbinom(x-1,n,p),
      "menor"       = pbinom(x-1,n,p),
      "mayor"       = 1-pbinom(x,n,p),
      "entre"       = pbinom(input$bin_b,n,p)-pbinom(input$bin_a-1,n,p)
    )
    enum <- switch(tipo,
      "igual"       = paste0("P(X=",x,")"),
      "menor_igual" = paste0("P(X≤",x,")"),
      "mayor_igual" = paste0("P(X≥",x,")"),
      "menor"       = paste0("P(X<",x,")"),
      "mayor"       = paste0("P(X>",x,")"),
      "entre"       = paste0("P(",input$bin_a,"≤X≤",input$bin_b,")")
    )

    output$bin_cards <- renderUI({
      div(class="info-strip",
        ic(sprintf("%.6f",prob),enum,"ic-pink"),
        ic(sprintf("%.2f%%",prob*100),"Porcentaje","ic-purple"),
        ic(round(mu,4),"μ = n·p","ic-blue"),
        ic(round(sigma,4),"σ = √(npq)","ic-green"),
        ic(sprintf("[%.1f, %.1f]",max(0,mu-2*sigma),min(n,mu+2*sigma)),"Intervalo usual","ic-orange")
      )
    })

    output$bin_resultado <- renderPrint({
      cat("════════════════════════════════════════\n")
      cat(sprintf("  BINOMIAL B(n=%d, p=%.4f, q=%.4f)\n",n,p,q))
      cat("════════════════════════════════════════\n")
      cat(sprintf("  μ=%.4f | σ²=%.4f | σ=%.4f\n",mu,n*p*q,sigma))
      cat("────────────────────────────────────────\n")
      cat(sprintf("  %s = %.8f\n",enum,prob))
      cat(sprintf("  %s ≈ %.4f  (%.2f%%)\n",enum,prob,prob*100))
      cat("════════════════════════════════════════\n")
    })

    output$bin_grafico <- renderPlot({
      xs <- 0:n; probs_all <- dbinom(xs,n,p)
      colores <- rep(ACC3,length(xs))
      if(tipo=="igual") colores[xs==x] <- ACC1
      else if(tipo=="menor_igual") colores[xs<=x] <- ACC1
      else if(tipo=="mayor_igual") colores[xs>=x] <- ACC1
      else if(tipo=="menor") colores[xs<x] <- ACC1
      else if(tipo=="mayor") colores[xs>x] <- ACC1
      else if(tipo=="entre") colores[xs>=input$bin_a&xs<=input$bin_b] <- ACC1

      df <- data.frame(x=factor(xs),prob=probs_all,col=colores)
      ggplot(df,aes(x=x,y=prob,fill=col)) +
        geom_col(color="white",width=0.7) +
        scale_fill_identity() +
        geom_text(aes(label=ifelse(prob>0.005,round(prob,4),"")),
                  vjust=-0.3,size=2.8,fontface="bold") +
        labs(title=paste0("Distribución Binomial — n=",n,", p=",p),
             subtitle=paste0(enum," = ",round(prob,6),"  (rojo = región de interés)"),
             x="x",y="P(X=x)") +
        theme_minimal(base_size=12) +
        theme(plot.title=element_text(color=C2,face="bold"),
              plot.subtitle=element_text(color=ACC2),
              plot.background=element_rect(fill="white",color=NA),
              panel.grid.minor=element_blank())
    })

    output$bin_tabla <- renderTable({
      xs <- 0:n
      data.frame(
        x=xs,
        "P(X=x)"=round(dbinom(xs,n,p),6),
        "P(X≤x)"=round(pbinom(xs,n,p),6),
        "P(X≥x)"=round(1-pbinom(xs-1,n,p),6),
        check.names=FALSE
      )
    }, striped=TRUE, hover=TRUE, bordered=TRUE)
  })


  # ===========================================================
  # 3. DISTRIBUCIÓN NORMAL
  # ===========================================================
  observeEvent(input$calc_norm, {
    mu <- input$norm_mu; sigma <- input$norm_sigma; tipo <- input$norm_tipo

    res <- switch(tipo,
      "menor"  = { x<-input$norm_x; z<-(x-mu)/sigma
                   list(prob=pnorm(z),z=z,x=x,txt=paste0("P(X≤",x,")"),xl=NA,xu=x) },
      "mayor"  = { x<-input$norm_x; z<-(x-mu)/sigma
                   list(prob=1-pnorm(z),z=z,x=x,txt=paste0("P(X≥",x,")"),xl=x,xu=NA) },
      "entre"  = { za<-(input$norm_a-mu)/sigma; zb<-(input$norm_b-mu)/sigma
                   list(prob=pnorm(zb)-pnorm(za),za=za,zb=zb,
                        txt=paste0("P(",input$norm_a,"≤X≤",input$norm_b,")"),
                        xl=input$norm_a,xu=input$norm_b,x=NA,z=NA) },
      "cuantil"= { z<-qnorm(input$norm_p); xv<-mu+z*sigma
                   list(prob=input$norm_p,z=z,x=xv,txt=paste0("x para P=",input$norm_p),xl=NA,xu=xv) },
      "zscore" = { x<-input$norm_x; z<-(x-mu)/sigma
                   list(prob=pnorm(z),z=z,x=x,txt=paste0("Z de x=",x),xl=NA,xu=x) }
    )

    output$norm_cards <- renderUI({
      div(class="info-strip",
        ic(sprintf("%.6f",res$prob),"Probabilidad","ic-pink"),
        ic(sprintf("%.2f%%",res$prob*100),"Porcentaje","ic-purple"),
        if(!is.na(res$z)) ic(round(res$z,4),"Valor Z","ic-blue"),
        if(!is.na(res$x)) ic(round(res$x,4),"Valor x","ic-green")
      )
    })

    output$norm_resultado <- renderPrint({
      cat("════════════════════════════════════════\n")
      cat(sprintf("  NORMAL N(μ=%.2f, σ=%.2f)\n",mu,sigma))
      cat("════════════════════════════════════════\n")
      cat(sprintf("  Cálculo: %s\n",res$txt))
      if(!is.na(res$z)) {
        cat(sprintf("  Z = (x-μ)/σ = (%.4f-%.4f)/%.4f = %.4f\n",
                    res$x,mu,sigma,res$z))
      }
      cat("────────────────────────────────────────\n")
      if(tipo=="cuantil") {
        cat(sprintf("  Para P=%.4f → x = %.4f\n",res$prob,res$x))
      } else {
        cat(sprintf("  Probabilidad = %.8f\n",res$prob))
        cat(sprintf("              ≈ %.4f  (%.2f%%)\n",res$prob,res$prob*100))
      }
      cat("════════════════════════════════════════\n")
    })

    output$norm_grafico <- renderPlot({
      li <- mu-4*sigma; ls <- mu+4*sigma
      xs <- seq(li,ls,length.out=1000)
      ys <- dnorm(xs,mu,sigma)
      df <- data.frame(x=xs,y=ys)

      g <- ggplot(df,aes(x,y)) +
        geom_line(color=C2,size=1.3) +
        labs(title=paste0("Distribución Normal  N(μ=",mu,", σ=",sigma,")"),
             x="x",y="f(x)") +
        theme_minimal(base_size=13) +
        theme(plot.title=element_text(color=C2,face="bold"),
              plot.background=element_rect(fill="white",color=NA),
              panel.grid.minor=element_blank())

      if(tipo=="menor") {
        g <- g + geom_area(data=subset(df,x<=res$xu),aes(y=y),fill=ACC1,alpha=0.4)
      } else if(tipo=="mayor") {
        g <- g + geom_area(data=subset(df,x>=res$xl),aes(y=y),fill=ACC1,alpha=0.4)
      } else if(tipo=="entre") {
        g <- g + geom_area(data=subset(df,x>=res$xl&x<=res$xu),aes(y=y),fill=ACC3,alpha=0.4)
      } else {
        g <- g + geom_area(data=subset(df,x<=res$xu),aes(y=y),fill=ACC5,alpha=0.4) +
          geom_vline(xintercept=res$x,color=ACC5,size=1.3,linetype="dashed")
      }

      g + annotate("text",x=mu+3.2*sigma,y=max(ys)*0.65,
                   label=paste0("P = ",round(res$prob,4),"\n(",round(res$prob*100,2),"%)"),
                   color=ACC1,fontface="bold",size=5)
    })
  })


  # ===========================================================
  # 4. PRUEBA DE HIPÓTESIS
  # ===========================================================
  observeEvent(input$calc_ph, {
    caso <- input$ph_caso
    if(caso=="") return()

    calc <- if(caso=="media_z") {
      mu0<-input$mz_mu0; xb<-input$mz_xbar; sig<-input$mz_sigma; n<-input$mz_n
      alfa<-input$mz_alfa; cola<-input$mz_cola
      sx <- sig/sqrt(n); zc <- (xb-mu0)/sx
      zcrit <- switch(cola,"dos"=qnorm(1-alfa/2),"derecha"=qnorm(1-alfa),"izquierda"=qnorm(alfa))
      pv <- switch(cola,"dos"=2*pnorm(-abs(zc)),"derecha"=1-pnorm(zc),"izquierda"=pnorm(zc))
      h1 <- switch(cola,"dos"=paste0("μ ≠ ",mu0),"derecha"=paste0("μ > ",mu0),"izquierda"=paste0("μ < ",mu0))
      dec <- switch(cola,
        "dos"=if(abs(zc)>zcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀",
        "derecha"=if(zc>zcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀",
        "izquierda"=if(zc<zcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀"
      )
      txt <- paste0(
        "════════════════════════════════════════\n",
        "  PRUEBA Z — UNA MEDIA (σ conocida)\n",
        "════════════════════════════════════════\n",
        "  H₀: μ = ",mu0," | H₁: ",h1,"\n",
        "  α = ",alfa," | cola = ",cola,"\n",
        "────────────────────────────────────────\n",
        sprintf("  X̄=%.4f | σ=%.4f | n=%d\n",xb,sig,n),
        sprintf("  σ_x̄ = σ/√n = %.4f/√%d = %.6f\n",sig,n,sx),
        sprintf("  Z = (X̄-μ₀)/σ_x̄ = (%.4f-%.4f)/%.6f\n",xb,mu0,sx),
        sprintf("  Z_calculado = %.4f\n",zc),
        sprintf("  Z_crítico   = ±%.4f\n",abs(zcrit)),
        sprintf("  p-valor     = %.6f\n",pv),
        "────────────────────────────────────────\n",
        "  DECISIÓN: ",dec,"\n",
        if(pv<alfa)"  p-valor < α → se rechaza H₀\n" else "  p-valor ≥ α → no se rechaza H₀\n",
        "════════════════════════════════════════\n"
      )
      list(txt=txt,dec=dec,zc=zc,zcrit=abs(zcrit),cola=cola,titulo="Prueba Z — Una media")

    } else if(caso=="media_t") {
      mu0<-input$mt_mu0; xb<-input$mt_xbar; s<-input$mt_s; n<-input$mt_n
      alfa<-input$mt_alfa; cola<-input$mt_cola; gl<-n-1
      se<-s/sqrt(n); tc<-(xb-mu0)/se
      tcrit<-switch(cola,"dos"=qt(1-alfa/2,gl),"derecha"=qt(1-alfa,gl),"izquierda"=qt(alfa,gl))
      pv<-switch(cola,"dos"=2*pt(-abs(tc),gl),"derecha"=1-pt(tc,gl),"izquierda"=pt(tc,gl))
      dec<-switch(cola,
        "dos"=if(abs(tc)>tcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀",
        "derecha"=if(tc>tcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀",
        "izquierda"=if(tc<tcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀"
      )
      txt <- paste0(
        "════════════════════════════════════════\n",
        "  PRUEBA t — UNA MEDIA (σ desconocida)\n",
        "════════════════════════════════════════\n",
        sprintf("  H₀: μ=%s | α=%.3f | gl=%d\n",mu0,alfa,gl),
        sprintf("  X̄=%.4f | s=%.4f | n=%d\n",xb,s,n),
        sprintf("  SE = s/√n = %.4f\n",se),
        sprintf("  t_calculado = %.4f\n",tc),
        sprintf("  t_crítico   = ±%.4f  (gl=%d)\n",abs(tcrit),gl),
        sprintf("  p-valor     = %.6f\n",pv),
        "────────────────────────────────────────\n",
        "  DECISIÓN: ",dec,"\n",
        "════════════════════════════════════════\n"
      )
      list(txt=txt,dec=dec,zc=tc,zcrit=abs(tcrit),cola=cola,titulo="Prueba t")

    } else if(caso=="proporcion") {
      P<-input$pr_P; Q<-1-P; pm<-input$pr_p; n<-input$pr_n
      alfa<-input$pr_alfa; cola<-input$pr_cola
      sp<-sqrt(P*Q/n); zc<-(pm-P)/sp
      zcrit<-switch(cola,"dos"=qnorm(1-alfa/2),"derecha"=qnorm(1-alfa),"izquierda"=qnorm(alfa))
      pv<-switch(cola,"dos"=2*pnorm(-abs(zc)),"derecha"=1-pnorm(zc),"izquierda"=pnorm(zc))
      dec<-switch(cola,
        "dos"=if(abs(zc)>zcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀",
        "derecha"=if(zc>zcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀",
        "izquierda"=if(zc<zcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀"
      )
      txt <- paste0(
        "════════════════════════════════════════\n",
        "  PRUEBA Z — UNA PROPORCIÓN\n",
        "════════════════════════════════════════\n",
        sprintf("  H₀: P=%.4f | Q=%.4f\n",P,Q),
        sprintf("  p (muestral)=%.4f | n=%d | α=%.3f\n",pm,n,alfa),
        sprintf("  σ_p = √(P·Q/n) = %.6f\n",sp),
        sprintf("  Z = (p-P)/σ_p = (%.4f-%.4f)/%.6f = %.4f\n",pm,P,sp,zc),
        sprintf("  Z_crítico = ±%.4f | p-valor=%.6f\n",abs(zcrit),pv),
        "────────────────────────────────────────\n",
        "  DECISIÓN: ",dec,"\n",
        "════════════════════════════════════════\n"
      )
      list(txt=txt,dec=dec,zc=zc,zcrit=abs(zcrit),cola=cola,titulo="Prueba Z — Proporción")

    } else if(caso=="dos_medias") {
      x1<-input$dm_x1;x2<-input$dm_x2;s1<-input$dm_s1;s2<-input$dm_s2
      n1<-input$dm_n1;n2<-input$dm_n2;alfa<-input$dm_alfa;cola<-input$dm_cola
      sd<-sqrt(s1^2/n1+s2^2/n2); zc<-(x1-x2)/sd
      zcrit<-switch(cola,"dos"=qnorm(1-alfa/2),"derecha"=qnorm(1-alfa),"izquierda"=qnorm(alfa))
      pv<-switch(cola,"dos"=2*pnorm(-abs(zc)),"derecha"=1-pnorm(zc),"izquierda"=pnorm(zc))
      dec<-switch(cola,
        "dos"=if(abs(zc)>zcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀",
        "derecha"=if(zc>zcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀",
        "izquierda"=if(zc<zcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀"
      )
      txt <- paste0(
        "════════════════════════════════════════\n",
        "  PRUEBA Z — DIFERENCIA DE MEDIAS\n",
        "════════════════════════════════════════\n",
        sprintf("  Muestra1: X̄₁=%.2f, s₁=%.2f, n₁=%d\n",x1,s1,n1),
        sprintf("  Muestra2: X̄₂=%.2f, s₂=%.2f, n₂=%d\n",x2,s2,n2),
        sprintf("  X̄₁-X̄₂=%.4f | σ_Δ=%.4f\n",x1-x2,sd),
        sprintf("  Z_calc=%.4f | Z_crit=±%.4f | p=%.6f\n",zc,abs(zcrit),pv),
        "────────────────────────────────────────\n",
        "  DECISIÓN: ",dec,"\n",
        "════════════════════════════════════════\n"
      )
      list(txt=txt,dec=dec,zc=zc,zcrit=abs(zcrit),cola=cola,titulo="Diferencia de Medias")

    } else {
      p1<-input$dp_p1;p2<-input$dp_p2;n1<-input$dp_n1;n2<-input$dp_n2
      alfa<-input$dp_alfa;cola<-input$dp_cola
      pp<-(p1*n1+p2*n2)/(n1+n2); qp<-1-pp
      sdp<-sqrt(pp*qp*(1/n1+1/n2)); zc<-(p1-p2)/sdp
      zcrit<-switch(cola,"dos"=qnorm(1-alfa/2),"derecha"=qnorm(1-alfa),"izquierda"=qnorm(alfa))
      pv<-switch(cola,"dos"=2*pnorm(-abs(zc)),"derecha"=1-pnorm(zc),"izquierda"=pnorm(zc))
      dec<-switch(cola,
        "dos"=if(abs(zc)>zcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀",
        "derecha"=if(zc>zcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀",
        "izquierda"=if(zc<zcrit)"RECHAZAR H₀" else "NO RECHAZAR H₀"
      )
      txt <- paste0(
        "════════════════════════════════════════\n",
        "  PRUEBA Z — DIFERENCIA DE PROPORCIONES\n",
        "════════════════════════════════════════\n",
        sprintf("  p₁=%.4f,n₁=%d | p₂=%.4f,n₂=%d\n",p1,n1,p2,n2),
        sprintf("  p̄=%.4f | σ_Δp=%.6f\n",pp,sdp),
        sprintf("  Z_calc=%.4f | Z_crit=±%.4f | p=%.6f\n",zc,abs(zcrit),pv),
        "────────────────────────────────────────\n",
        "  DECISIÓN: ",dec,"\n",
        "════════════════════════════════════════\n"
      )
      list(txt=txt,dec=dec,zc=zc,zcrit=abs(zcrit),cola=cola,titulo="Diferencia de Proporciones")
    }

    output$ph_decision_badge <- renderUI(badge(calc$dec))
    output$ph_resultado <- renderPrint(cat(calc$txt))
    output$ph_grafico <- renderPlot(
      plot_zreg(calc$zc,calc$zcrit,calc$cola,calc$titulo)
    )
  })


  # ===========================================================
  # 5. CHI-CUADRADO
  # ===========================================================
  observeEvent(input$calc_chi, {
    tipo <- input$chi_tipo

    if(tipo=="bondad") {
      obs <- tryCatch(pn(input$chi_obs),error=function(e)NULL)
      obs <- obs[!is.na(obs)]
      if(is.null(obs)) return()
      k <- length(obs); n_tot <- sum(obs); alfa <- input$chi_alfa_b
      txt_p <- trimws(input$chi_esp_p)
      pr <- if(nchar(txt_p)==0) rep(1/k,k) else {
        p <- tryCatch(pn(txt_p),error=function(e)rep(1/k,k))
        p/sum(p)
      }
      esp <- n_tot*pr
      chi2 <- sum((obs-esp)^2/esp)
      gl <- k-1; chi_crit <- qchisq(1-alfa,gl); pv <- 1-pchisq(chi2,gl)
      dec <- if(chi2>chi_crit) "RECHAZAR H₀" else "NO RECHAZAR H₀"

      output$chi_decision_badge <- renderUI(badge(dec))
      output$chi_resultado <- renderPrint({
        cat("════════════════════════════════════════\n")
        cat("  CHI-CUADRADO — BONDAD DE AJUSTE\n")
        cat("════════════════════════════════════════\n")
        cat(sprintf("  n=%d | k=%d | gl=%d | α=%.3f\n",n_tot,k,gl,alfa))
        cat("  Cat | Obs(O) | Esp(E) | (O-E)²/E\n")
        for(i in 1:k)
          cat(sprintf("  %3d | %6.1f | %6.2f | %9.4f\n",
                      i,obs[i],esp[i],(obs[i]-esp[i])^2/esp[i]))
        cat(sprintf("\n  χ²_calc  = %.4f\n",chi2))
        cat(sprintf("  χ²_crit  = %.4f  (gl=%d, α=%.3f)\n",chi_crit,gl,alfa))
        cat(sprintf("  p-valor  = %.6f\n",pv))
        cat("────────────────────────────────────────\n")
        cat("  DECISIÓN:",dec,"\n")
        cat("════════════════════════════════════════\n")
      })
      output$chi_tabla_result <- renderTable({
        data.frame(
          Cat=paste0("Cat ",1:k), Obs=obs, Esp=round(esp,2),
          "(O-E)²/E"=round((obs-esp)^2/esp,4),check.names=FALSE
        )
      },striped=TRUE,bordered=TRUE)

      output$chi_grafico <- renderPlot({
        xr <- seq(0,max(chi2*1.5,chi_crit*1.5,15),length.out=500)
        yr <- dchisq(xr,gl)
        df <- data.frame(x=xr,y=yr)
        ggplot(df,aes(x,y)) +
          geom_line(color=C2,size=1.3) +
          geom_area(data=subset(df,x>=chi_crit),aes(y=y),fill=ACC1,alpha=0.4) +
          geom_vline(xintercept=chi2,
                     color=if(chi2>chi_crit)ACC1 else ACC5,size=2) +
          geom_vline(xintercept=chi_crit,color=WARN,linetype="dashed",size=1.2) +
          annotate("text",x=chi2,y=max(yr)*0.7,
                   label=paste0("χ²_calc\n",round(chi2,3)),
                   color=C2,fontface="bold",size=4) +
          labs(title=paste0("Distribución χ²  (gl=",gl,")"),
               subtitle=paste0("χ²_calc=",round(chi2,4)," | χ²_crit=",round(chi_crit,4),
                               " | ",dec),
               x="χ²",y="Densidad") +
          theme_minimal(base_size=12) +
          theme(plot.title=element_text(color=C2,face="bold"),
                plot.background=element_rect(fill="white",color=NA))
      })

    } else {
      f <- if(tipo=="contingencia") input$chi_filas else input$chi_filas_h
      c_ <- if(tipo=="contingencia") input$chi_cols  else input$chi_cols_h
      tx <- if(tipo=="contingencia") input$chi_tabla  else input$chi_tabla_h
      alfa <- if(tipo=="contingencia") input$chi_alfa_c else input$chi_alfa_h

      vals <- tryCatch(pn(tx),error=function(e)NULL)
      vals <- vals[!is.na(vals)]
      if(is.null(vals)||length(vals)<f*c_) {
        output$chi_resultado <- renderPrint(
          cat("❌ Ingrese exactamente",f*c_,"valores (tiene",length(vals),")"))
        return()
      }
      mo <- matrix(vals[1:(f*c_)],nrow=f,byrow=TRUE)
      n_tot <- sum(mo)
      me <- outer(rowSums(mo),colSums(mo))/n_tot
      chi2 <- sum((mo-me)^2/me)
      gl <- (f-1)*(c_-1)
      chi_crit <- qchisq(1-alfa,gl); pv <- 1-pchisq(chi2,gl)
      dec <- if(chi2>chi_crit) "RECHAZAR H₀" else "NO RECHAZAR H₀"

      output$chi_decision_badge <- renderUI(badge(dec))
      output$chi_resultado <- renderPrint({
        cat("════════════════════════════════════════\n")
        cat(if(tipo=="contingencia")"  CHI-CUADRADO — INDEPENDENCIA\n"
            else "  CHI-CUADRADO — HOMOGENEIDAD\n")
        cat("════════════════════════════════════════\n")
        cat(sprintf("  Tabla %dx%d | n=%d | gl=%d | α=%.3f\n",f,c_,n_tot,gl,alfa))
        cat("  Obs:\n"); print(mo)
        cat("  Esp:\n"); print(round(me,2))
        cat(sprintf("\n  χ²_calc = %.4f\n",chi2))
        cat(sprintf("  χ²_crit = %.4f  (gl=%d)\n",chi_crit,gl))
        cat(sprintf("  p-valor = %.6f\n",pv))
        cat("────────────────────────────────────────\n")
        cat("  DECISIÓN:",dec,"\n")
        if(tipo=="contingencia")
          cat(if(dec=="RECHAZAR H₀")"  → Variables NO independientes\n"
              else"  → Variables independientes\n")
        cat("════════════════════════════════════════\n")
      })
      output$chi_tabla_result <- renderTable({
        cbind(Fila=paste0("F",1:f),as.data.frame(mo))
      },striped=TRUE,bordered=TRUE)

      output$chi_grafico <- renderPlot({
        xr <- seq(0,max(chi2*1.5,chi_crit*1.5,20),length.out=500)
        yr <- dchisq(xr,gl)
        df <- data.frame(x=xr,y=yr)
        ggplot(df,aes(x,y)) +
          geom_line(color=C2,size=1.3) +
          geom_area(data=subset(df,x>=chi_crit),aes(y=y),fill=ACC1,alpha=0.4) +
          geom_vline(xintercept=chi2,
                     color=if(chi2>chi_crit)ACC1 else ACC5,size=2) +
          geom_vline(xintercept=chi_crit,color=WARN,linetype="dashed",size=1.2) +
          labs(title=paste0("χ²  (gl=",gl,")  — ",dec),
               x="χ²",y="Densidad") +
          theme_minimal(base_size=12) +
          theme(plot.title=element_text(color=C2,face="bold"),
                plot.background=element_rect(fill="white",color=NA))
      })
    }
  })


  # ===========================================================
  # 6. REGRESIÓN Y CORRELACIÓN
  # ===========================================================
  observeEvent(input$calc_reg, {
    xv <- tryCatch(pn(input$reg_x),error=function(e)NULL)
    yv <- tryCatch(pn(input$reg_y),error=function(e)NULL)
    xv <- xv[!is.na(xv)]; yv <- yv[!is.na(yv)]
    if(is.null(xv)||is.null(yv)||length(xv)!=length(yv)||length(xv)<3) return()

    n <- length(xv)
    sx<-sum(xv);sy<-sum(yv);sx2<-sum(xv^2);sy2<-sum(yv^2);sxy<-sum(xv*yv)
    xb<-mean(xv);yb<-mean(yv)

    rn <- n*sxy-sx*sy
    rd <- sqrt((n*sx2-sx^2)*(n*sy2-sy^2))
    r  <- rn/rd; r2 <- r^2
    fr <- if(abs(r)>=0.9)"Muy fuerte" else if(abs(r)>=0.7)"Fuerte"
          else if(abs(r)>=0.5)"Moderada" else if(abs(r)>=0.3)"Débil" else "Muy débil"

    tipo_r <- input$reg_tipo
    mod <- switch(tipo_r,
      "lineal"={
        b<-rn/(n*sx2-sx^2); a<-yb-b*xb
        list(a=a,b=b,fn=function(x)a+b*x,
             eq=paste0("Ŷ=",round(a,4),"+",round(b,4),"·X"))
      },
      "cuadratico"={
        ft<-lm(yv~poly(xv,2,raw=TRUE)); co<-coef(ft)
        list(a=co[1],b=co[2],c=co[3],fn=function(x)co[1]+co[2]*x+co[3]*x^2,
             eq=paste0("Ŷ=",round(co[1],4),"+",round(co[2],4),"·X+",round(co[3],4),"·X²"))
      },
      "exponencial"={
        yl<-log(abs(yv)+0.001); ft<-lm(yl~xv); a<-exp(coef(ft)[1]); b<-coef(ft)[2]
        list(a=a,b=b,fn=function(x)a*exp(b*x),
             eq=paste0("Ŷ=",round(a,4),"·e^(",round(b,4),"·X)"))
      },
      "logaritmico"={
        xl<-log(abs(xv)+0.001); ft<-lm(yv~xl); a<-coef(ft)[1]; b<-coef(ft)[2]
        list(a=a,b=b,fn=function(x)a+b*log(abs(x)+0.001),
             eq=paste0("Ŷ=",round(a,4),"+",round(b,4),"·ln(X)"))
      }
    )

    yp <- sapply(xv,mod$fn)
    res <- yv-yp
    sse <- sum(res^2)
    r2m <- 1-sse/sum((yv-yb)^2)

    output$reg_cards <- renderUI({
      div(class="info-strip",
        ic(round(r,4),"Correlación (r)","ic-pink"),
        ic(sprintf("%.2f%%",r2*100),"r² (lineal)","ic-purple"),
        ic(sprintf("%.4f",r2m),"R² modelo","ic-blue"),
        ic(fr,"Fuerza","ic-green"),
        if(tipo_r=="lineal") ic(round(mod$a+mod$b*input$reg_xpred,4),
           paste0("Ŷ para X=",input$reg_xpred),"ic-orange")
      )
    })

    output$reg_resultado <- renderPrint({
      cat("════════════════════════════════════════\n")
      cat("  REGRESIÓN Y CORRELACIÓN\n")
      cat("════════════════════════════════════════\n")
      cat(sprintf("  n=%d | X̄=%.4f | Ȳ=%.4f\n",n,xb,yb))
      cat(sprintf("  ΣX=%.2f | ΣY=%.2f | ΣX²=%.2f | ΣY²=%.2f | ΣXY=%.2f\n",
                  sx,sy,sx2,sy2,sxy))
      cat("────────────────────────────────────────\n")
      cat(sprintf("  r = %.6f (%s %s)\n",r,fr,if(r>0)"(+)" else "(-)"))
      cat(sprintf("  r² = %.6f  (%.2f%% explicado)\n",r2,r2*100))
      cat("────────────────────────────────────────\n")
      cat(sprintf("  Modelo: %s\n",toupper(tipo_r)))
      cat(sprintf("  %s\n",mod$eq))
      cat(sprintf("  R² del modelo = %.4f | SSE = %.4f\n",r2m,sse))
      if(tipo_r=="lineal") {
        xp<-input$reg_xpred
        cat(sprintf("\n  PREDICCIÓN: X=%.4f → Ŷ=%.4f\n",xp,mod$fn(xp)))
      }
      cat("════════════════════════════════════════\n")
    })

    output$reg_grafico <- renderPlot({
      xr <- seq(min(xv)*0.9,max(xv)*1.1,length.out=300)
      yr <- sapply(xr,mod$fn)
      ggplot() +
        geom_point(data=data.frame(x=xv,y=yv),aes(x,y),
                   color=C2,size=3.5,alpha=0.85) +
        geom_line(data=data.frame(x=xr,y=yr),aes(x,y),
                  color=ACC1,size=1.5) +
        geom_segment(data=data.frame(x=xv,y=yv,yend=yp),
                     aes(x=x,y=y,xend=x,yend=yend),
                     color=paste0(ACC2,"55"),size=0.8) +
        labs(title=paste0("Regresión ",toupper(tipo_r)),
             subtitle=mod$eq,x="X",y="Y") +
        theme_minimal(base_size=13) +
        theme(plot.title=element_text(color=C2,face="bold"),
              plot.subtitle=element_text(color=ACC1,face="italic"),
              plot.background=element_rect(fill="white",color=NA)) +
        annotate("label",x=min(xv),y=max(yv),hjust=0,
                 label=paste0("r = ",round(r,4),"\nR² = ",round(r2m,4)),
                 fill=paste0(ACC5,"22"),color=ACC2,fontface="bold",size=4.5,
                 label.padding=unit(0.4,"lines"),label.r=unit(0.3,"lines"))
    })

    output$reg_tabla <- renderTable({
      data.frame(i=1:n,X=xv,Y=yv,
                 "Ŷ"=round(yp,4),
                 "Residuo"=round(res,4),
                 "(Y-Ŷ)²"=round(res^2,4),
                 check.names=FALSE)
    },striped=TRUE,hover=TRUE,bordered=TRUE)
  })


  # ===========================================================
  # 7. MUESTREO
  # ===========================================================
  observeEvent(input$calc_muest, {
    tipo <- input$muest_tipo

    if(tipo=="simple") {
      N<-input$ms_N; n<-input$ms_n
      set.seed(input$ms_semilla)
      m <- sort(sample(1:N,min(n,N)))
      output$muest_resultado <- renderPrint({
        cat("════════════════════════════════════════\n")
        cat("  MUESTREO ALEATORIO SIMPLE\n")
        cat("════════════════════════════════════════\n")
        cat(sprintf("  N=%d | n=%d | f=n/N=%.4f\n",N,n,n/N))
        cat("  Elementos seleccionados:\n")
        cat(paste(m,collapse=", "),"\n")
        cat("════════════════════════════════════════\n")
      })
      output$muest_grafico <- renderPlot({
        df <- data.frame(id=1:N,
          tipo=ifelse(1:N %in% m,"Seleccionado","No seleccionado"))
        ggplot(df,aes(x=(id-1)%%25+1,y=(id-1)%/%25+1,color=tipo,size=tipo)) +
          geom_point(alpha=0.8) +
          scale_color_manual(values=c("Seleccionado"=ACC1,"No seleccionado"="#cccccc")) +
          scale_size_manual(values=c("Seleccionado"=4,"No seleccionado"=2)) +
          labs(title=paste0("Muestreo Aleatorio Simple (N=",N,", n=",n,")"),
               x=NULL,y=NULL,color="",size="") +
          theme_minimal(base_size=12) +
          theme(plot.title=element_text(color=C2,face="bold"),
                axis.text=element_blank(),
                plot.background=element_rect(fill="white",color=NA))
      })
      output$muest_tabla <- renderTable(NULL)

    } else if(tipo=="estratificado") {
      n_tot<-input$est_n_total
      ests<-trimws(strsplit(input$est_estratos,",")[[1]])
      tam<-tryCatch(pn(input$est_tamanos),error=function(e)NULL)
      tam<-tam[!is.na(tam)]
      if(is.null(tam)||length(tam)!=length(ests)) return()
      N_tot<-sum(tam); ni<-round(n_tot*tam/N_tot)
      output$muest_resultado <- renderPrint({
        cat("════════════════════════════════════════\n")
        cat("  MUESTREO ESTRATIFICADO PROPORCIONAL\n")
        cat("════════════════════════════════════════\n")
        cat(sprintf("  N_total=%d | n_total=%d\n",N_tot,n_tot))
        cat("  Fórmula: nᵢ = n × Nᵢ/N\n")
        cat("  Estrato       |  Nᵢ  | Nᵢ/N | nᵢ\n")
        for(i in seq_along(ests))
          cat(sprintf("  %-14s|%5d |%.4f|%4d\n",ests[i],as.integer(tam[i]),tam[i]/N_tot,ni[i]))
        cat(sprintf("  TOTAL         |%5d |      |%4d\n",N_tot,sum(ni)))
        cat("════════════════════════════════════════\n")
      })
      output$muest_grafico <- renderPlot({
        cols <- colorRampPalette(c(ACC3,ACC2,ACC1,ACC4,ACC5))(length(ests))
        df <- data.frame(
          Estrato=rep(ests,2),
          Valor=c(tam,ni),
          Tipo=rep(c("Población (Nᵢ)","Muestra (nᵢ)"),each=length(ests))
        )
        ggplot(df,aes(x=Estrato,y=Valor,fill=Tipo)) +
          geom_col(position="dodge",width=0.6,color="white") +
          geom_text(aes(label=Valor),position=position_dodge(0.6),
                    vjust=-0.4,fontface="bold",size=4) +
          scale_fill_manual(values=c("Población (Nᵢ)"=ACC3,"Muestra (nᵢ)"=ACC1)) +
          labs(title="Muestreo Estratificado Proporcional",
               x="Estrato",y="Frecuencia",fill="") +
          theme_minimal(base_size=12) +
          theme(plot.title=element_text(color=C2,face="bold"),
                plot.background=element_rect(fill="white",color=NA))
      })
      output$muest_tabla <- renderTable({
        data.frame(Estrato=ests,Nᵢ=as.integer(tam),
                   "Nᵢ/N"=round(tam/N_tot,4),"nᵢ"=ni,check.names=FALSE)
      },striped=TRUE,bordered=TRUE)

    } else if(tipo=="sistematico") {
      N<-input$sist_N;n<-input$sist_n;k0<-input$sist_inicio
      k<-floor(N/n)
      els<-seq(k0,by=k,length.out=n); els<-els[els<=N]
      output$muest_resultado <- renderPrint({
        cat("════════════════════════════════════════\n")
        cat("  MUESTREO SISTEMÁTICO\n")
        cat("════════════════════════════════════════\n")
        cat(sprintf("  N=%d | n=%d | k=N/n=%d | k₀=%d\n",N,n,k,k0))
        cat("  Patrón: k₀, k₀+k, k₀+2k, ...\n")
        cat("  Elementos:\n")
        cat(paste(els,collapse=", "),"\n")
        cat("════════════════════════════════════════\n")
      })
      output$muest_grafico <- renderPlot({
        df<-data.frame(id=1:N,tipo=ifelse(1:N %in% els,"Seleccionado","No seleccionado"))
        ggplot(df,aes(x=(id-1)%%25+1,y=(id-1)%/%25+1,color=tipo,size=tipo)) +
          geom_point(alpha=0.8) +
          scale_color_manual(values=c("Seleccionado"=ACC4,"No seleccionado"="#cccccc")) +
          scale_size_manual(values=c("Seleccionado"=4.5,"No seleccionado"=2)) +
          labs(title=paste0("Muestreo Sistemático (k=",k,", k₀=",k0,")"),
               x=NULL,y=NULL,color="",size="") +
          theme_minimal(base_size=12) +
          theme(plot.title=element_text(color=C2,face="bold"),
                axis.text=element_blank(),
                plot.background=element_rect(fill="white",color=NA))
      })
      output$muest_tabla <- renderTable(NULL)

    } else {
      alfa_m<-input$tam_alfa_m; zm<-qnorm(1-alfa_m/2)
      sig<-input$tam_sigma; Em<-input$tam_E
      nm<-ceiling((zm*sig/Em)^2)

      alfa_p<-input$tam_alfap; zp<-qnorm(1-alfa_p/2)
      p<-input$tam_p; q<-1-p; Ep<-input$tam_Ep
      np<-ceiling(zp^2*p*q/Ep^2)

      output$muest_resultado <- renderPrint({
        cat("════════════════════════════════════════\n")
        cat("  TAMAÑO DE MUESTRA\n")
        cat("════════════════════════════════════════\n")
        cat("  PARA UNA MEDIA:\n")
        cat(sprintf("  σ=%.4f | E=%.4f | α=%.3f\n",sig,Em,alfa_m))
        cat(sprintf("  Z_α/2=%.4f\n",zm))
        cat(sprintf("  n=(Z·σ/E)²=(%.4f·%.4f/%.4f)²\n",zm,sig,Em))
        cat(sprintf("  n=%.2f → n=%d\n",(zm*sig/Em)^2,nm))
        cat("────────────────────────────────────────\n")
        cat("  PARA UNA PROPORCIÓN:\n")
        cat(sprintf("  p=%.4f | q=%.4f | E=%.4f | α=%.3f\n",p,q,Ep,alfa_p))
        cat(sprintf("  Z_α/2=%.4f\n",zp))
        cat(sprintf("  n=Z²·p·q/E²=%.4f²·%.4f·%.4f/%.4f²\n",zp,p,q,Ep))
        cat(sprintf("  n=%.2f → n=%d\n",zp^2*p*q/Ep^2,np))
        cat("════════════════════════════════════════\n")
      })
      output$muest_grafico <- renderPlot({
        Er<-seq(Em*0.3,Em*4,length.out=150)
        nr<-ceiling((zm*sig/Er)^2)
        df<-data.frame(E=Er,n=nr)
        ggplot(df,aes(E,n)) +
          geom_line(color=ACC2,size=1.5) +
          geom_vline(xintercept=Em,color=ACC1,linetype="dashed",size=1.2) +
          geom_hline(yintercept=nm,color=ACC1,linetype="dashed",size=1.2) +
          geom_point(data=data.frame(E=Em,n=nm),aes(E,n),
                     color=ACC1,size=5) +
          annotate("label",x=Em*1.3,y=nm*1.1,
                   label=paste0("E=",Em,"\nn=",nm),
                   color=ACC1,fontface="bold",fill=paste0(ACC1,"15"),
                   label.r=unit(0.3,"lines")) +
          labs(title="Error tolerable vs Tamaño de muestra",
               x="Error máximo (E)",y="n") +
          theme_minimal(base_size=13) +
          theme(plot.title=element_text(color=C2,face="bold"),
                plot.background=element_rect(fill="white",color=NA))
      })
      output$muest_tabla <- renderTable(NULL)
    }
  })


  # ===========================================================
  # 8. TABLAS DE REFERENCIA
  # ===========================================================
  output$ref_z_tabla <- renderTable({
    a <- c(0.10,0.05,0.025,0.01,0.005)
    data.frame(
      "α (bilateral)"=c(0.20,0.10,0.05,0.02,0.01),
      "α/2"=a,
      "Z cola derecha"=round(qnorm(1-a),4),
      "±Z bilateral"=round(qnorm(1-a/2),4),
      check.names=FALSE
    )
  },striped=TRUE,bordered=TRUE)

  output$ref_chi_tabla <- renderTable({
    g<-1:10
    data.frame(gl=g,
      "χ²_0.10"=round(qchisq(0.90,g),3),
      "χ²_0.05"=round(qchisq(0.95,g),3),
      "χ²_0.025"=round(qchisq(0.975,g),3),
      "χ²_0.01"=round(qchisq(0.99,g),3),
      check.names=FALSE)
  },striped=TRUE,bordered=TRUE)

} # fin server

shinyApp(ui, server)
