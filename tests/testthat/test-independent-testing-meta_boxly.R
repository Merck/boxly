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

x <- meta_boxly(
  boxly_adsl,
  boxly_adlb,
  population_term = "apat",
  observation_term = "wk12",
  observation_subset = AVISITN <= 12 & !is.na(CHG)
)

test_that("meta_boxly() structure", {
  expect_equal(class(x), "meta_adam")
  expect_equal(class(x$data_population), "data.frame")
  expect_equal(class(x$data_observation), c("tbl_df", "tbl", "data.frame"))
  expect_equal(class(x$population), "list")
  expect_equal(class(x$observation), "list")
  expect_equal(class(x$parameter), "list")
  expect_equal(class(x$analysis), "list")
})
