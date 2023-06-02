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

#' Create an example metadata object
#'
#' @param dataset_adsl ADSL source dataset.
#' @param dataset_param Observation level source dataset for boxplot.
#' @param population_term A character value of population term name.
#' @param population_subset An unquoted condition for selecting the
#'   populations from ADSL dataset.
#' @param observation_term A character value of observation term name.
#' @param observation_subset An unquoted condition for selecting the
#'   observations from `dataset_param` dataset.
#' @param parameters A chracter vector of parameters defined in `dataset_param$PARAMCD`
#'
#' @return A metalite object.
#'
#' @export
#'
#' @examples
#'
#' meta_boxly(
#'   boxly_adsl,
#'   boxly_adlb,
#'   population_term = "apat",
#'   observation_term = "wk12"
#' )
meta_boxly <- function(
    dataset_adsl,
    dataset_param,
    population_term,
    population_subset = SAFFL == "Y",
    observation_term,
    observation_subset = SAFFL == "Y",
    parameters = unique(dataset_param$PARAMCD)) {
  # Input Checking
  require_param <- c("PARAM", "PARAMCD", "AVISITN", "CHG")

  if (!all(require_param %in% names(dataset_param))) {
    dataset_param_diff <- paste(setdiff(names(dataset_param), require_param), collapse = ";")
    stop("Missing Standard Variable in dataset_param: ", dataset_param_diff)
  }

  if (!all(parameters %in% dataset_param$PARAMCD)) {
    param_diff <- paste(setdiff(parameters, unique(dataset_param$PARAMCD)), collapse = ";")
    stop("Mismatch parameters in dataset_param$PARAMCD: ", param_diff)
  }

  # Analysis Plan
  parameter_term <- paste(parameters, collapse = ";")

  plan <- metalite::plan(
    analysis = "boxly",
    population = population_term,
    observation = observation_term,
    parameter = parameter_term
  )

  # Define metalite object
  meta <- metalite::meta_adam(
    population = dataset_adsl,
    observation = dataset_param
  ) |>
    metalite::define_plan(plan = plan) |>
    metalite::define_population(
      name = population_term,
      group = "TRTA",
      subset = !!rlang::enquo(population_subset),
      label = ""
    ) |>
    metalite::define_observation(
      name = observation_term,
      group = "TRTA",
      var = "PARAM",
      subset = !!rlang::enquo(observation_subset),
      label = ""
    ) |>
    metalite::define_analysis(
      name = "boxly",
      label = "Interactive Box Plot",
      x = "AVISITN",
      y = "CHG"
    )

  # Add parameter definition
  u_param <- unique(dataset_param[, c("PARAM", "PARAMCD")])
  u_param <- u_param[u_param[["PARAMCD"]] %in% parameters, ]

  for (i in seq(parameters)) {
    term <- paste0("PARAMCD == '", u_param[["PARAMCD"]][i], "'")
    meta <- meta |>
      metalite::define_parameter(
        name = u_param[["PARAMCD"]][i],
        label = u_param[["PARAM"]][i],
        subset = str2lang(term)
      )
  }

  metalite::meta_build(meta)
}
