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

#' A function to create a interactive box plot
#'
#' @param outdata an `outdata` object created from `prepare_ae_forestly`
#' @param color color for box plot
#' @param hover_summary_var a character vector of statistics to be displayed on hover label of box
#' @param hover_outlier_label a character vector of hover label for outlier
#' @param x_label x-axis label
#' @param y_label y-axis label
#' @param heading_select_list Select list menu label
#' @param heading_summary_table Summary table label
#'
#' @export
#' @importFrom ggplot2 ggplot aes geom_point position_jitterdodge scale_color_manual ylab xlab theme_bw
#' @importFrom dplyr mutate select filter
#' @importFrom plotly config layout add_trace ggplotly
#' @importFrom stats reshape
#' @return Interactive box plot
#' @examples
#' \dontrun{
#' library(metalite)
#' library(dplyr)
#' library(ggplot2)
#' meta <- meta_boxly()
#' prepare_boxly(meta,
#'               population = "apat",
#'               observation = "wk12",
#'               analysis = "lb_boxly",
#'               parameter = "sodium;bili;urate") |>
#' boxly()
#' }
boxly <- function(outdata,
                  color = NULL,
                  hover_summary_var = c("n", "min", "q1", "median", "mean", "q3", "max"),
                  #hover_outlier_var = c("USUBJID", "AVAL"),
                  hover_outlier_label = c("Participant Id", "Parameter value"),
                  x_label = "Visit",
                  y_label = "Change",
                  heading_select_list = "Lab parameter",
                  heading_summary_table = "Number of Participants") {

  # Test if two treatment
  # tbl <- tbl|>
  #   filter(TRTA %in% unique(outdata$plotds$TRTA)[1:2])

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

  # ============ TODO begin ==================#
  # adjust this part to align with hover_summary_var
  tbl$label <- paste("N :", tbl$n,
                     "<br>Min :", tbl$min,
                     "<br>Q1 :", tbl$q1,
                     "<br>Median :", tbl$median,
                     "<br>Mean :", tbl$mean,
                     "<br>Q3 :", tbl$q3,
                     "<br>Max :", tbl$max)
  # ============ TODO end ====================#

  # ============ TODO begin ==================#
  # paste multiple hover_outlier_labels
  tbl$text <- ifelse(!is.na(tbl$outlier),
                     paste(hover_outlier_label[1], tbl[["USUBJID"]],
                           "\n", hover_outlier_label[2], tbl[["outlier"]]),
                     NA)
  # ============ TODO end ====================#

  # This looks overlap with the aboe tbl$text.
  # hover label for outlier besides default variable
  # for (i in 1:length(hover_var_outlier)){
  #   tbl$text <- ifelse(!is.na(tbl$outlier),
  #                      paste(tbl$text, "\n", attr(tbl[[hover_var_outlier[i]]], "label"),
  #                            ": ", tbl[[hover_var_outlier[i]]]),
  #                      tbl$text)
  # }

  # implement color
  if (is.null(color)) {
    color_pal <- c("#00857C", "#6ECEB2", "#BFED33", "#FFF063", "#0C2340", "#5450E4")
    color <- c("#66203A", rep(color_pal, length.out = n_group - 1))
  }else{
    color <- rep(color, length.out = n_group)
  }

  # input data set for bar
  bar <- tbl |>
    select(group, param, min, max, label, x) |>
    mutate(range = max - min) |>
    dplyr::distinct()
  bar <- crosstalk::SharedData$new(bar, key = ~param, group = "groupdata")

  # create 2 shareddata, 1 all data + 1 outlier data only
  box_all <- crosstalk::SharedData$new(tbl, key = ~param, group = "groupdata")
  box_outlier <- crosstalk::SharedData$new(tbl |> subset(is.na(tbl$outlier)), key = ~param, group = "groupdata")

  # get the summary of subjects counts
  cnt <- tbl[!duplicated(tbl[, c("param", "x", "group", "n")]),c("param", "x", "group", "n")] |>
    reshape(timevar = "x", idvar = c("param", "group"), v.names = "n", direction = "wide")
  # cnt <- cnt[,2:ncol(cnt)]
  names(cnt) <- c("param", "Treatment Group", as.character(unique(tbl$AVISITN)))
  row.names(cnt) <- NULL
  # names(cnt) <- gsub("n.", "", names(cnt)) #??
  cnt <- crosstalk::SharedData$new(cnt, key = ~param, group = "groupdata")


  # get the select list of parameters
  select_list <- crosstalk::filter_select(id = "filter_param",
                                          label = heading_select_list,
                                          sharedData = box_all,
                                          group = ~ param,
                                          multiple = FALSE)
  # get the slider bar of counts
  # slider_bar <- crosstalk::filter_slider(id = "cut_off",
  #                                        label = heading_slider_bar,
  #                                        sharedData = box_all,
  #                                        column = ~n,
  #                                        width = "60%",
  #                                        step = 1,
  #                                        min = 0,
  #                                        max = 100)

  # get the interactive box plot
  p <- ggplot(box_all,
              aes(x = x, y = outlier, color = group, group = group,
                  text = text)) +
    geom_point(position = position_jitterdodge(jitter.width = 0), show.legend = FALSE) +
    scale_color_manual(values = color) +
    ylab(y_label) +
    xlab(x_label) +
    theme_bw()

  # combine into interactive plots & tables
  ans <- htmltools::div(
    select_list,
    #slider_bar,
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
        hovertemplate = paste('%{text}<br>', "<extra></extra>"),
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
      config(displayModeBar = F) |>
      htmlwidgets::onRender("function(el,x){el.on('plotly_legendclick', function(){ return false; })}"),

    heading_summary_table,
    DT::datatable(cnt, options = list(columnDefs = list(list(visible = FALSE, targets = c(0)))),
                                      rownames = FALSE))

  offline = TRUE

  # Get first parameter name
  default_param <- as.character(unique(tbl$param)[1])

  brew::brew(system.file("js/filter_default.js", package = "boxly"),
             output = file.path(tempdir(),  "filter_default.js"))

  paste(readLines(file.path(tempdir(),  "filter_default.js")), collapse = "\n")

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
    ans))

}