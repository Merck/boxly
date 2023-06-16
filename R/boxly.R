# Copyright (c) 2023 Merck & Co., Inc., Rahway, NJ, USA and its affiliates.
# All rights reserved.
#
# This file is part of the boxly program.
#
# boxly is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' Create an interactive box plot
#'
#' @param outdata An `outdata` object created from `prepare_ae_forestly()`.
#' @param color Color for box plot.
#' @param hover_summary_var A character vector of statistics to be displayed
#'   on hover label of box.
#' @param hover_outlier_label A character vector of hover label for outlier.
#' @param x_label x-axis label.
#' @param y_label y-axis label.
#' @param heading_select_list Select list menu label.
#' @param heading_summary_table Summary table label.
#'
#' @return Interactive box plot.
#'
#' @importFrom ggplot2 ggplot aes geom_point position_jitterdodge
#'   scale_color_manual ylab xlab theme_bw .data
#' @importFrom plotly config layout add_trace ggplotly
#' @importFrom stats reshape
#'
#' @export
#'
#' @examples
#' # Only run this example in interactive R sessions
#' if (interactive()) {
#'   library(metalite)
#'
#'   meta_boxly(
#'     boxly_adsl,
#'     boxly_adlb,
#'     population_term = "apat",
#'     observation_term = "wk12"
#'   ) |>
#'     prepare_boxly() |>
#'     boxly()
#' }
boxly <- function(outdata,
                  color = NULL,
                  hover_summary_var = c("n", "min", "q1", "median", "mean", "q3", "max"),
                  hover_outlier_label = c("Participant Id", "Parameter value"),
                  x_label = "Visit",
                  y_label = "Change",
                  heading_select_list = "Lab parameter",
                  heading_summary_table = "Number of Participants") {
  x_var <- outdata$x_var
  y_var <- outdata$y_var
  group_var <- outdata$group_var
  param_var <- outdata$param_var
  hover_var_outlier <- outdata$hover_var_outlier
  n_group <- length(unique(outdata$plotds[[group_var]]))

  tbl <- outdata$plotds |> as.data.frame()
  tbl$x <- as.numeric(tbl[[x_var]])
  tbl$y <- tbl[[y_var]]
  tbl$group <- tbl[[group_var]]
  tbl$param <- tbl[[param_var]]

  # prepare hover label in hover_summary_var

  stat_var_label <- data.frame(
    stat_var = c("n", "min", "q1", "median", "mean", "q3", "max"),
    label = c("N: ", "Min: ", "Q1: ", "Median: ", "Mean: ", "Q3: ", "Max: "),
    value = c("tbl$n", "tbl$min", "tbl$q1", "tbl$median", "tbl$mean", "tbl$q3", "tbl$max"),
    stringsAsFactors = FALSE
  )

  tbl$label <- NULL
  for (var in hover_summary_var) {
    if (var %in% hover_summary_var) {
      tbl$label <- paste0(
        tbl$label,
        stat_var_label$label[stat_var_label$stat_var == var],
        eval(parse(text = stat_var_label$value[stat_var_label$stat_var == var])),
        "\n"
      )
    }
  }

  # paste multiple hover_outlier_labels
  tbl$text <- ifelse(!is.na(tbl$outlier),
    paste0(
      hover_outlier_label[1], ": ", tbl[["USUBJID"]],
      "\n", hover_outlier_label[2], ": ", tbl[["outlier"]]
    ),
    NA
  )

  # implement color
  if (is.null(color)) {
    color_pal <- c("#00857C", "#6ECEB2", "#BFED33", "#FFF063", "#0C2340", "#5450E4")
    color <- c("#66203A", rep(color_pal, length.out = n_group - 1))
  } else {
    color <- rep(color, length.out = n_group)
  }

  # input data set for bar
  bar <- tbl[, c("group", "param", "min", "max", "label", "x")]
  bar$range <- bar$max - bar$min
  bar <- unique.data.frame(bar)

  shareddata_id <- uuid::UUIDgenerate()
  bar <- crosstalk::SharedData$new(bar, key = ~param, group = shareddata_id)

  # create 2 shareddata, 1 all data + 1 outlier data only
  box_all <- crosstalk::SharedData$new(tbl, key = ~param, group = shareddata_id)
  box_outlier <- crosstalk::SharedData$new(tbl |> subset(is.na(tbl$outlier)), key = ~param, group = shareddata_id)

  # get the summary of subjects counts
  cnt <- tbl[!duplicated(tbl[, c("param", "x", "group", "n")]), c("param", "x", "group", "n")] |>
    reshape(timevar = "x", idvar = c("param", "group"), v.names = "n", direction = "wide")

  names(cnt) <- c("param", "Treatment Group", as.character(unique(tbl$AVISITN)))
  row.names(cnt) <- NULL

  cnt <- crosstalk::SharedData$new(cnt, key = ~param, group = shareddata_id)


  # Get first parameter name
  default_param <- as.character(unique(tbl$param)[1])

  random_id <- paste0("filter_param_", uuid::UUIDgenerate(), "|", default_param)
  # get the select list of parameters
  select_list <- crosstalk::filter_select(
    id = random_id,
    label = heading_select_list,
    sharedData = box_all,
    group = ~param,
    multiple = FALSE
  )

  # get the interactive box plot
  p <- ggplot(
    box_all,
    aes(
      x = .data$x,
      y = .data$outlier,
      color = .data$group,
      group = .data$group,
      text = .data$text
    )
  ) +
    geom_point(position = position_jitterdodge(jitter.width = 0), show.legend = FALSE) +
    scale_color_manual(values = color) +
    ylab(y_label) +
    xlab(x_label) +
    theme_bw()

  # combine into interactive plots & tables
  ans <- htmltools::div(
    select_list,
    # slider_bar,
    ggplotly(p, tooltip = "text", dynamicTicks = TRUE) |>
      add_trace(
        data = box_outlier, x = ~x, y = ~y, type = "box", boxpoints = FALSE, color = ~group,
        opacity = 1, colors = color,
        hoverinfo = "none",
        legendgroup = "group", showlegend = FALSE
      ) |>
      add_trace(
        data = bar, x = ~x, y = ~range, base = ~min, type = "bar", color = ~group,
        opacity = 0, text = ~label, colors = color,
        hovertemplate = paste("%{text}<br>", "<extra></extra>"),
        legendgroup = "group", showlegend = FALSE
      ) |>
      layout(
        xaxis = list(
          ticktext = as.character(unique(tbl[[x_var]])),
          tickvals = as.numeric(unique(tbl[[x_var]])),
          tickmode = "array"
        )
      ) |>
      layout(
        barmode = "group",
        boxmode = "group"
      ) |>
      config(displayModeBar = FALSE) |>
      htmlwidgets::onRender("function(el,x){el.on('plotly_legendclick', function(){ return false; })}"),
    heading_summary_table,
    DT::datatable(cnt,
      options = list(columnDefs = list(list(visible = FALSE, targets = c(0)))),
      rownames = FALSE
    )
  )

  offline <- TRUE

  brew::brew(system.file("js/filter_default.js", package = "boxly"),
    output = file.path(tempdir(), "filter_default.js")
  )

  paste(readLines(file.path(tempdir(), "filter_default.js")), collapse = "\n")

  htmltools::browsable(htmltools::tagList(
    htmltools::htmlDependency(
      # name and version: doesn't really matter, can be anything
      "default-parameter", "0.1.0",
      # src: path to directory containing the script (e.g., the current directory '.')
      src = tempdir(),
      # script: filename of script to include
      script = "filter_default.js",
      # Exclude all other files in src directory
      all_files = FALSE
    ),
    ans
  ))
}
