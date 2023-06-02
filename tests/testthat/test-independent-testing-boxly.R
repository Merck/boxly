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


meta <- meta_boxly(
  boxly_adsl,
  boxly_adlb,
  population_term = "apat",
  observation_term = "wk12",
  observation_subset = AVISITN <= 12 & !is.na(CHG)
)

x <- prepare_boxly(meta)

test_that("validation of boxly plot Case 1", {
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

  intlabel <- y[[2]][["children"]][[2]][["x"]][["data"]][[1]][["text"]][13]
  subj <- substr(intlabel, 1, 10)
  baselabel <- substr(intlabel, 25, 46)
  expect_equal(subj, "Subject Id")
  expect_equal(baselabel, "Change from Baseline: ")
})


test_that("validation of boxly plot Case 2", {
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

  intlabel <- y[[2]][["children"]][[2]][["x"]][["data"]][[1]][["text"]][13]
  subj <- substr(intlabel, 1, 10)
  baselabel <- substr(intlabel, 25, 54)
  expect_equal(subj, "Patient Id")
  expect_equal(baselabel, "Percent Change from Baseline: ")
})
