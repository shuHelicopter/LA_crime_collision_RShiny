######################################################
#################### by Shu Liu ######################
############ shutel at hotmail dot com ###############
################### 08/05/2016 #######################
###### Shiny project @ NYC Data Science Academy ######
######################################################

shinyUI({
  navbarPage('Los Angeles Crimes&Collisions 2011~2014 (version1.0)',
             theme = 'bootstrap.css',
             
             ##########################
             ########## WHERE #########
             tabPanel('Crimes WHERE',
                      fluidRow(
                        column(width = 2,
                               style = "background-color:#F8F8F8",
                               h3('Where Crimes Are.'),
                               checkboxGroupInput('CMyear', 
                                                  label = h5('Select Years'),
                                                  choices = c('2011' = 2011,
                                                              '2012' = 2012,
                                                              '2013' = 2013,
                                                              '2014' = 2014),
                                                              #'2015' = 2015), 
                                                  #selected = c(2011, 2012, 2013, 2014, 2015)
                                                  selected = c(2011, 2012, 2013, 2014)
                               ),
                               
                               selectInput('CMarea', 
                                           label = h5('Select the Area: '), 
                                           choices = c('All areas' =  1, 
                                                       "Central", "Olympic", "N Hollywood", "Van Nuys", "West Valley",
                                                       "Hollywood", "Rampart", "Southwest",  "Wilshire", "Hollenbeck", 
                                                       "Harbor", "West LA", "Northeast", "77th Street", "Newton",     
                                                       "Pacific", "Foothill", "Devonshire",  "Southeast", "Mission",    
                                                       "Topanga" ),
                                           selected = 1
                               ),
                               hr(),
                               p(strong('Note1: '), 'Only a part of data are displayed on the map due to browsing efficiency.')
                        ),
                        
                        column(width = 10,
                               tabsetPanel(
                                 tabPanel("Crimes Map", # leaflet map
                                          leafletOutput("mymap",
                                                        width = 'auto',
                                                        height = '700')
                                 ),
                                 tabPanel("Crimes Area", # bar chart and line charts for areas
                                          fluidRow(
                                            column(width = 6, 
                                                   htmlOutput('crm_area') # width, height parameters are useless here
                                            ),
                                            column(width = 6,
                                                   htmlOutput('crm_tot_chg')
                                            ),
                                            p(strong('Note2: '), 'LAPD oversees 21 areas which you can check details on "Reference" Page.')
                                          )
                                 )
                               )
                        ) 
                      )
             ),
             
             ##########################
             ########## WHEN ##########
             tabPanel('Crimes WHEN',
                      fluidRow(
                        column(width = 2,
                               style = "background-color:#F8F8F8",
                               h3('When Crimes Appear.')),
                        column(width = 10,
                               tabsetPanel(
                                 tabPanel('Crimes Days',
                                          #htmlOutput('calendar'),
                                          htmlOutput('crm_days_status')
                                 ), 
                                 
                                 tabPanel('Crimes Time',
                                          fluidRow(
                                            column(width = 3,
                                                   h4('Reference:'), 
                                                   tags$li(strong('Time(X-axis):')),
                                                   p('{0 ~ 23} <-> {00:00 ~ 23:00}'),
                                                   tags$li(strong('Day(Y-axis):')),
                                                   p('{0 ~ 6}  <-> {Sun ~ Sat}'),
                                                   hr(),
                                                   p(strong('Tips:')),
                                                   p('You are welcomed to spin the 3D graph to explore a lot of interesting insights.')),
                                            
                                            column(width = 9,
                                                   plotlyOutput('crm_time_3d',
                                                                width = 'auto',
                                                                height = '550')
                                            )
                                          )
                                 )
                               )
                        )
                      )
             ),
             
             ##########################
             ########## WHAT #########
             tabPanel('Crimes WHAT',
                      tabsetPanel(
                        tabPanel('Crimes Type',
                                 fluidRow(
                                   column(width = 2, 
                                          h3('What Crimes Happen.'),
                                          style = "background-color:#F8F8F8",
                                          radioButtons('sen', 
                                                       label = h5('Select the Season:'), 
                                                       c('Hot', 'Warm'), 
                                                       selected = 'Hot'),
                                          radioButtons('tmprd', 
                                                       label = h5('Select the Time:'), 
                                                       c('Early Morning', 'Morning', 'Noon', 'Afternoon', 'Evening', 'Night', 'Midnight'), 
                                                       selected = 'Early Morning')),
                                   column(width = 10,
                                          fluidRow(
                                            column(width = 6,
                                                   p(strong(HTML('<center> Crimes and Collisions Types in Season and Time </center>'))),
                                                   plotOutput('crm_type',
                                                              width = 'auto',
                                                              height = '500')),
                                            column(width = 6,
                                                   htmlOutput('crm_sen_tm'))
                                          ),
                                          p(('Note1: '), 'Hot season: May - Oct.; Warm season: Nov. - Apr. (Check details on "Reference" page)'),
                                          p(('Note2: '), '•	Early morning: 4am - 8am
                                            •	morning: 8am - 11am
                                            •	Noon: 11am - 1pm
                                            •	afternoon: 1pm - 5pm
                                            •	evening: 5pm - 8 pm
                                            •	Night: 8pm - 11am 
                                            •	Midnight  11pm - 4am')
                                   )
                                 )
                        )
                      )
             ),
             
             
             ##########################
             ########## DATA #########
             tabPanel('Data',
                      dataTableOutput('crm_table')
             ),
             
             ##########################
             ########## REFERENCE #####
             tabPanel('Reference',
                      h4(strong('Data Source')),
                      p('Datasets in this project are provided by ', 
                        a('Los Angeles Open Data', 
                          href = 'https://data.lacity.org/browse?category=A+Safe+City&limitTo=datasets&utf8=✓'), '.'),
                      p('This Shiny application focuses on 21 areas oversaw by LAPD. 
                        You can find more information about the LAPD ', 
                        a('here', href = 'http://www.lapdonline.org/inside_the_lapd/content_basic_view/1063', '.')),
                      hr(),
                      fluidRow(
                        column(width = 5,
                               p(HTML('<center> 21 Areas Oversaw by LAPD </center>')),
                               img(src = 'LAPD_Area.jpg', position = 'left', height = 'auto', width = 400),
                               p('** You can check all details about 21 Offices of Operations of LAPD ', 
                                 a('here', href = 'https://en.wikipedia.org/wiki/Los_Angeles_Police_Department', '.'))
                               ),
                        column(width = 7,
                               img(src = 'LA_Temp.png', position = 'right', height = 'auto', width = 660),
                               p('** The temperature in Los Angeles is very stable all the year round, so one year is divided 
                                 into two seasons, hot and warm, instead of general four seasons in our analysis. This
                                 division is based on historical climate data shown above. In the above chart, 
                                 three indexes ("Average Hight", "Daily Mean", and "Average Low") are compared with 
                                 the corresponding monthly average value. Hot season is from May to October with value 
                                 of three indexes below average, and warm season consists of other months with value 
                                 of three indexes above average')
                        )
                      )
             ),
             
             ##########################
             ########## ABOUT #########
             tabPanel('About',
                      h4(strong('About the Site:')),
                      p('This Shiny Visualization project is designed for people who care about their safety in Los Angeles. 
                        Three features of crime&collision were investigated: geographical distribution, crime and collision time, and 
                        crime and collision types. This website includes detailed information about crime and collision types, 
                        addresses, locations, time, and date from 2011 to 2014. Users are welcomed to explore here and know more 
                        about crime and collision in Los Angeles. '),
                      br(),
                      hr(),
                      h4(strong('About the Author:')),
                      fluidRow(
                        column(width = 2,
                               img(src = 'profile.jpg', position = 'left', height = 'auto', width = 100)),
                        column(width = 10,
                               p('Shu is currently a master’s student studying financial engineering at University of Southern 
                                 California, and he has a multidisciplinary background in math, economics, and financial 
                                 engineering. Being able to look at problems from both marketing and technical perspectives, he 
                                 is passionate about combining innovative ideas with advanced quantitative approaches using 
                                 statistical analyses and machine learning. In college, Shu interned as a strategy analyst in 
                                 the world’s largest building material company, Lafarge. In addition, Shu once established a 
                                 simulative e-pack company with 6 team members and won the silver medal(top 1%) in the 
                                 national competition among over 20,000 teams. In his spare time, Shu enjoys running and is 
                                 currently training for his first Marathon.')
                        )
                      ),
                      br(),
                      h5('Contact Author:'),
                      p('Email: shutel@hotmail.com '),
                      p('See code on ', a('Github', href = 'https://github.com/shuHelicopter')),
                      p('See more about Shu on ', a('Linkedin', href = 'https://www.linkedin.com/in/shu-liu'))
             )
  )
}
)