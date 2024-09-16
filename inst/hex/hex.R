# draw a hex sticker for `elm`
library(tibble)
library(dplyr)
library(sf)
library(ggplot2)

# create hexagons
# adapt code from hexSticker to use sf objects
create_hexagon <- function(scale = 1){
  hexd <- data.frame(x = 1+c(rep(-sqrt(3)/2, 2), 0, rep(sqrt(3)/2, 2), 0),
                     y = 1+c(0.5, -0.5, -1, -0.5, 0.5, 1))
  rbind(hexd, hexd[1, ]) |>
    tibble() |>
    mutate(x = (x - 1) * scale,
           y = (y - 1) * scale) |>
    st_as_sf(coords = c("x", "y")) |>
    summarise(geometry = st_combine(geometry)) |>
    st_cast("POLYGON")
}

external_hexagon <- create_hexagon(scale = 1.00)
internal_hexagon <- create_hexagon(scale = 0.935)
border <- st_sym_difference(external_hexagon, internal_hexagon)

# draw sunburst offset outside hex area
# first set parameters
k <- 3
n <- 40
n_polygons <- n * 0.5
x_offset <- 1.2
y_offset <- 1.0
# trigonometry
alpha <- (-88-(180/n)) * (pi/180) 
theta <- (2*(pi/n) * seq(0, (n-1))) - alpha
values <- tibble(
  x = k * cos(theta),
  y = k * sin(theta),
  group = rep(seq_len(n_polygons), each = 2)) |>
  mutate(x = x + x_offset,
         y = y + y_offset)
# convert to polygons
background_polygons <- map(
  split(values, values$group),
  \(x){
    tibble(x = x_offset, y = y_offset) |>
      bind_rows(x) |>
      st_as_sf(coords = c("x", "y")) |>
      summarise(geometry = st_combine(geometry)) |>
      st_cast("POLYGON") 
  }) |>
  bind_rows() |>
  st_intersection(internal_hexagon)

# make snowy ground box
ground_max <- (-0.4)
snowy_box <- tibble(x = c(-1, 1, 1, -1, -1),
                    y = c(-1, -1, ground_max, ground_max, -1)) |> 
  st_as_sf(coords = c("x", "y")) |>
  summarise(geometry = st_combine(geometry)) |>
  st_cast("POLYGON") |>
  st_intersection(internal_hexagon)

# draw
edge_color <- "#003A70"
simple_palette <- c(# "#003A70",
                    # "#396691",
                    # "#7697b8",
                    # "#81afc7",
                    "#abcdde",
                    "#d6f1ff",
                    "#edfeff"
                    ) |>
  rev()

p <- ggplot() +
  geom_sf(data = internal_hexagon,
          fill = "#d6f1ff",
          color = NA,
          linewidth = 0) +
  geom_sf(data = background_polygons,
          fill = "#abcdde",
          color = NA) +
  geom_sf(data = snowy_box,
          fill = "#ffffff",
          color = NA,
          linewidth = 0) +
  geom_sf(data = border, 
          fill = edge_color, 
          color = NA) +
  annotate(geom = "text",
           x = 0.35,
           y = -0.63,
           label = "ala.org.au",
           family = "lato",
           size = 2,
           angle = 30,
           hjust = 0,
           color = edge_color) +
  annotate(geom = "text",
           x = 0.05,
           y = -0.74,
           label = "elm",
           family = "lato",
           size = 8,
           angle = -30,
           hjust = 1,
           color = edge_color) +
  scale_colour_gradientn(colors = simple_palette) +
  theme_void() +
  theme(legend.position = "none")

ggsave("man/figures/logo_r.pdf",
       p,
       width = 43.9,
       height = 50.8,
       units = "mm",
       bg = "transparent",
       device = cairo_pdf,
       dpi = 600)
