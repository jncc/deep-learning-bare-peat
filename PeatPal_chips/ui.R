ui <- shiny::fluidPage(
  title = 'PeatPal_chips',
  
  ## HTML tags for JNCC style
  shiny::includeCSS('./style.css'),
  rintrojs::introjsUI(),
  # styling for the header bar
  tags$head(tags$style(
    HTML(
      ".shiny-notification {height: 60px;
                                          width: 400px;position:fixed;
                                          top: calc(50% - 150px);;
                                          left: calc(57.5% - 200px);;}
                                          .shiny-notification-close {display: none;}
                                          .fa-cloud {color:#3F9C35}
                                          .fa-cloud-upload-alt {color:#3F9C35}
                                          .fa-book-open {color:#3F9C35}
                                          .fa-cloudversify {color:#3F9C35}
                                          .box.box-solid.box-primary>.box-header {color:#C9CAC8;background:#C9CAC8;}
                                          .box.box-solid.box-primary{border-bottom-color:#C9CAC8;border-left-color:#C9CAC8;border-right-color:#C9CAC8;border-top-color:#C9CAC8;background:#C9CAC8; box-shadow: none}
                                          .box.box-solid.box-success>.box-header {background:#3F9C35}
                                          }
                                          .nav-tabs-custom>.nav-tabs {background-color: #3F9C35;}
                                          .nav-tabs-custom>.nav-tabs>li>a {color: #3F9C35;}
                                          .nav-tabs-custom>.nav-tabs>li.active>a {color: #3F9C35;}
                                          }"
    )
  )),
  ## Tell shiny we want to use JS
  shinyjs::useShinyjs(),
  shinybusy::use_busy_spinner(
    spin = 'fading-circle',
    position = "top-right",
    color = '#C9CAC8'
  ),
  shinydashboard::dashboardPage(
    # HEADER
    header = shinydashboard::dashboardHeader(title = 'PeatPal', shiny::tags$li(
      actionLink(
        "initTutorial",
        label = NULL,
        icon = shiny::icon("info-circle", class = "infoicon")
      ),
      class = "dropdown"
    )),
    # SIDE MENU
    sidebar = shinydashboard::dashboardSidebar(
      shiny::selectInput(
        'imageid',
        label = "Select Image:",
        choices = gsub(
          all,
          pattern = ".tif",
          replacement = ""
        )
      ),
      shinydashboard::box(
        height = 400,
        solidHeader = T,
        background = NULL,
        status = "primary"
      ),
      #adding the JNCC logo in the bottom corner, position in style.css
      shiny::a(
        shiny::img(src = 'JNCCLogo_3DCol_transp.png', class = 'background-img', style =
                     'padding-left:20px;padding-right:20px;padding-top:5%; float:left; height=8%;width:100%; align:center'),
        href = "https://jncc.gov.uk/"
      )
    ),
    # PAGE CONTENT
    body = shinydashboard::dashboardBody(
      shinydashboard::tabBox(
        id = "tabset1",
        width = "90%",
        shiny::tabPanel(
          "Labelling Chips",
          shiny::fluidRow(
            style = "padding-top:20px",
            shiny::column(
              width = 9,
              
              leaflet::leafletOutput('tileplot',width="100%",height=700) %>%  shinycssloaders::withSpinner(color="#3F9C35", type=6)
            ),
            shiny::column(width=3,
              shiny::actionButton('Bare',label='Bare Peat', style="color: #FFFFFF; background-color: #3F9C35; border-color: #FFFFFF"),
              p(),
              shiny::actionButton('NoBare',label='Not Bare', style="color: #FFFFFF; background-color: #3F9C35; border-color: #FFFFFF"),
              p(),
              shiny::actionButton('Skip',label='Skip chip'),
              p(),
              shiny::textOutput("Unlabelled"),
              
              
              
          )
          )
        )#close tabpanel
        
        
      )# close tabBox
    )# close dashboard body
  ) # close dashboard page
)# close ui
