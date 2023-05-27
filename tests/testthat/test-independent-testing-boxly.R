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

test_that("validation of boxly plot Case 1", {
  library(metalite)
  library(ggplot2)
  library(plotly)
  library(dplyr)

  meta <- meta_boxly()
  meta$observation$wk12$subset <- quote(ANL01FL == "Y" & as.numeric(AVISITN) <= 12 & !is.na(CHG))
  meta$data_observation$AVISITN <- factor(meta$data_observation$AVISITN, levels = sort(unique(meta$data_observation$AVISITN)))
  meta$data_observation$PARAM <- factor(meta$data_observation$PARAM, levels = sort(unique(meta$data_observation$PARAM)))

  x <- prepare_boxly(meta,
    population = "apat",
    observation = "wk12",
    analysis = "lb_boxly",
    parameter = "sodium;bili;urate"
  )

  y <- boxly(x,
    color = c("black", "grey", "red"),
    hover_summary_var = c("n", "min", "q1", "median", "mean", "q3", "max"),
    hover_outlier_label = c("Subject Id", "Change from Baseline"),
    x_label = "Time",
    y_label = "Value",
    heading_select_list = "Laboratory Parameter",
    heading_summary_table = "Number of Subjects"
  )

  ylab <- y[[2]][["children"]][[2]][["x"]][["layout"]][["xaxis"]][["title"]][["text"]]
  expect_equal(ylab, "Time")

  xlab <- y[[2]][["children"]][[2]][["x"]][["layout"]][["yaxis"]][["title"]][["text"]]
  expect_equal(xlab, "Value")

  rowheader <- y[[2]][["children"]][[3]]
  expect_equal(rowheader, "Number of Subjects")

  header <- y[[2]][["children"]][[1]][["children"]][[1]][["children"]][[1]]
  expect_equal(header, "Laboratory Parameter")

  intlabel <- y[[2]][["children"]][[2]][["x"]][["data"]][[1]][["text"]][283]
  subj <- substr(intlabel, 1, 10)
  baselabel <- substr(intlabel, 25, 46)
  expect_equal(subj, "Subject Id")
  expect_equal(baselabel, "Change from Baseline: ")
})


test_that("validation of boxly plot Case 2", {
  library(metalite)
  library(ggplot2)
  library(plotly)
  library(dplyr)

  meta <- meta_boxly()
  meta$observation$wk12$subset <- quote(ANL01FL == "Y" & as.numeric(AVISITN) <= 12 & !is.na(CHG))
  meta$data_observation$AVISITN <- factor(meta$data_observation$AVISITN, levels = sort(unique(meta$data_observation$AVISITN)))
  meta$data_observation$PARAM <- factor(meta$data_observation$PARAM, levels = sort(unique(meta$data_observation$PARAM)))

  x <- prepare_boxly(meta,
    population = "apat",
    observation = "wk12",
    analysis = "lb_boxly",
    parameter = "sodium;bili;urate"
  )

  y <- boxly(x,
    color = c("green", "yellow", "red"),
    hover_summary_var = c("n", "min", "q1", "mean", "q3"),
    hover_outlier_label = c("Patient Id", "Percent Change from Baseline"),
    x_label = "Time Point",
    y_label = "Analysis Value",
    heading_select_list = "Lab Parameter",
    heading_summary_table = "Number of Patients"
  )

  ylab <- y[[2]][["children"]][[2]][["x"]][["layout"]][["xaxis"]][["title"]][["text"]]
  expect_equal(ylab, "Time Point")

  xlab <- y[[2]][["children"]][[2]][["x"]][["layout"]][["yaxis"]][["title"]][["text"]]
  expect_equal(xlab, "Analysis Value")

  rowheader <- y[[2]][["children"]][[3]]
  expect_equal(rowheader, "Number of Patients")

  header <- y[[2]][["children"]][[1]][["children"]][[1]][["children"]][[1]]
  expect_equal(header, "Lab Parameter")

  intlabel <- y[[2]][["children"]][[2]][["x"]][["data"]][[1]][["text"]][283]
  subj <- substr(intlabel, 1, 10)
  baselabel <- substr(intlabel, 25, 54)
  expect_equal(subj, "Patient Id")
  expect_equal(baselabel, "Percent Change from Baseline: ")
})
