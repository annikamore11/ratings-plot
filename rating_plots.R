library(plotly)
library(dplyr)
library(readxl)

ratings <- read_excel("ratings.xlsx") %>% rename(high_score = "What a High Score Suggests")

# Ensure 0% ratings show slightly
df <- ratings %>% mutate(AdjustedRating = ifelse(Rating == 0, 3, Rating))

# Split into two traces for legend
df_progressive <- df %>% filter(Leaning == "Progressive") %>%
  mutate(Hover = paste0(
    "<b>", Organization, "</b><br>",
    Summary, "<br><b>High Score Suggests:</b> ", high_score,
    "<br><b>Organization Political Leaning:</b> ", Leaning
  ))

df_conservative <- df %>% filter(Leaning == "Conservative") %>%
  mutate(Hover = paste0(
    "<b>", Organization, "</b><br>",
    Summary, "<br><b>High Score Suggests:</b> ", high_score,
    "<br><b>Organization Political Leaning:</b> ", Leaning
  ))

# Plot
fig <- plot_ly() %>%
  add_trace(
    data = df_progressive,
    x = ~AdjustedRating,
    y = ~Issue,
    type = 'bar',
    orientation = 'h',
    text = ~paste0(Rating, "%"),
    textposition = 'auto',
    hoverinfo = 'text',
    hovertext = ~Hover,
    marker = list(color = '#2F4F4F'), 
    name = "Progressive-leaning org rating"
  ) %>%
  add_trace(
    data = df_conservative,
    x = ~AdjustedRating,
    y = ~Issue,
    type = 'bar',
    orientation = 'h',
    text = ~paste0(Rating, "%"),
    textposition = 'auto',
    hoverinfo = 'text',
    hovertext = ~Hover,
    marker = list(color = '#8B0000'),
    name = "Conservative-leaning org rating"
  ) %>%
  layout(
    title = list(
      text = "Ted Cruz Policy Ratings by Issue",
      font = list(family = "Georgia", size = 22, color = "#000000"),
      x = .5,
      xanchor = "center"
    ),
    margin = list(t = 120, b = 120, l = 80, r = 40),
    xaxis = list(
      title = "Rating (0-100)",
      range = c(0, 100),
      titlefont = list(family = "Times New Roman", size = 16, color = "#000000"),
      tickfont = list(family = "Times New Roman", size = 14, color = "#000000"),
      gridcolor = "#d9d9d9",
      zerolinecolor = "#999999"
    ),
    yaxis = list(
      autorange = "reversed",
      tickfont = list(family = "Times New Roman", size = 14, color = "#000000")
    ),
    barmode = 'group',
    legend = list(
      title = list(text = "<b>Organization Leaning</b>", font = list(family = "Georgia", size = 14)),
      font = list(family = "Times New Roman", size = 12)
    ),
    margin = list(b = 120),
    plot_bgcolor = "#fdf6e3",  
    paper_bgcolor = "#fdf6e3",
    annotations = list(
      list(
        x = 0.5, 
        y = -0.2,
        text = "Hover over a bar to see the organization, its summary, and what the score suggests about the stance.",
        xref = "paper", 
        yref = "paper",
        showarrow = FALSE,
        xanchor = "center",
        yanchor = "top",
        font = list(family = "Times New Roman", size = 12, color = "#000000")
      )
    )
  )

fig
htmlwidgets::saveWidget(fig, "ted_cruz_ratings.html", selfcontained = TRUE)


