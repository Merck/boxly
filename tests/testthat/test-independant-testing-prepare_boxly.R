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

library(metalite)
library(ggplot2)
library(dplyr)

meta <- meta_boxly()
meta$observation$wk12$subset <- quote(ANL01FL == "Y" & as.numeric(AVISITN) <= 12 & !is.na(CHG))
meta$data_observation$AVISITN <- factor(meta$data_observation$AVISITN, levels = sort(unique(meta$data_observation$AVISITN)))
meta$data_observation$PARAM <- factor(meta$data_observation$PARAM, levels = sort(unique(meta$data_observation$PARAM)))


test_that("Its class is 'outdata'", {
  output <- prepare_boxly(meta,
    population = "apat",
    observation = "wk12",
    analysis = "lb_boxly",
    parameter = "sodium;bili;urate"
  )
  expect_equal(class(output), "outdata")
  expect_equal(output$population, "apat")
  expect_equal(output$observation, "wk12")
  expect_equal(output$x_var, "AVISITN")
  expect_equal(output$y_var, "CHG")
  expect_equal(output$group_var, "TRTA")
  expect_equal(output$param_var, "PARAM")
  expect_equal(output$parameter, "sodium;bili;urate")
  expect_equal(output$order, NULL)
  expect_equal(output$group, NULL)
  expect_equal(names(output), c("meta", "population", "observation", "parameter", "n", "order", "group", "reference_group", "x_var", "y_var", "group_var", "param_var", "plotds"))
  expect_equal(names(output$meta), c("data_population", "data_observation", "plan", "observation", "population", "parameter", "analysis"))
  expect_equal(nrow(output$meta$data_population), nrow(meta$data_population))
  expect_equal(nrow(output$meta$data_observation), nrow(meta$data_observation))
  expect_equal(ncol(output$meta$data_population), ncol(meta$data_population))
  expect_equal(ncol(output$meta$data_observation), ncol(meta$data_observation))
  expect_equal(output$meta$plan, meta$plan)
  expect_equal(output$meta, meta)
})
