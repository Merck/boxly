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

#' Prepare data for interactive box plot
#'
#' @param meta A metadata object created by metalite.
#' @param population A character value of population term name.
#'   The term name is used as key to link information.
#' @param observation A character value of observation term name.
#'   The term name is used as key to link information.
#' @param analysis A character value of analysis term name.
#'   The term name is used as key to link information.
#'
#' @return Metadata list with plotting dataset.
#'
#' @export
#'
#' @examples
#' library(metalite)
#'
#' meta <- meta_boxly(
#'   boxly_adsl,
#'   boxly_adlb,
#'   population_term = "apat",
#'   observation_term = "wk12"
#' )
#' prepare_boxly(meta)
#'
#' @return Metadata list with plotting dataset
#' @export
prepare_boxly <- function(meta,
                          population = NULL,
                          observation = NULL,
                          analysis = NULL) {
  if (is.null(population)) {
    if (length(meta$population) == 1) {
      population <- meta$population[[1]]$name
    } else {
      stop("Population term should be one selected from metadata.")
    }
  }

  if (is.null(observation)) {
    if (length(meta$observation) == 1) {
      observation <- meta$observation[[1]]$name
    } else {
      stop("Observation term should be one selected from metadata.")
    }
  }

  if (is.null(analysis)) {
    if (nrow(meta$plan) == 1) {
      analysis <- meta$plan[1, "analysis"]
    } else {
      stop("Analysis term should be one selected from metadata.")
    }
  }

  parameter <- meta$plan$parameter[meta$plan$analysis == analysis]

  # Obtain variables
  obs_var <- metalite::collect_adam_mapping(meta, observation)$var
  pop_var <- metalite::collect_adam_mapping(meta, population)$var
  y <- metalite::collect_adam_mapping(meta, analysis)$y
  x <- metalite::collect_adam_mapping(meta, analysis)$x
  # hover_outlier <- collect_adam_mapping(meta, analysis)$hover_outlier

  # Obtain Data
  pop <- metalite::collect_population_record(meta, population, var = pop_var)
  obs <- do.call(
    rbind,
    lapply(
      unlist(strsplit(parameter, ";")),
      function(s) {
        metalite::collect_observation_record(meta, population, observation,
          parameter = s,
          var = unique(c(obs_var, y, x))
        )
      }
    )
  )

  # Obtain variable name
  pop_id <- metalite::collect_adam_mapping(meta, population)$id
  obs_id <- metalite::collect_adam_mapping(meta, observation)$id

  pop_group <- metalite::collect_adam_mapping(meta, population)$group
  obs_group <- metalite::collect_adam_mapping(meta, observation)$group

  # Input checking
  if (!"factor" %in% class(obs[[obs_group]])) {
    message("In observation level data, the group variable '", obs_group, "' is automatically transformed into a factor.")
    obs[[obs_group]] <- factor(obs[[obs_group]], levels = sort(unique(obs[[obs_group]])))
  }

  if (!"factor" %in% class(obs[[obs_var]])) {
    message("In observation level data, the facet variable '", obs_var, "' is automatically transformed into a factor.")
    obs[[obs_var]] <- factor(obs[[obs_var]], levels = sort(unique(obs[[obs_var]])))
  }

  if (!"factor" %in% class(obs[[x]])) {
    message("In observation level data, the group variable '", x, "' is automatically transformed into a factor.")
    obs[[x]] <- factor(obs[[x]], levels = sort(unique(obs[[x]])))
  }

  if (!"numeric" %in% class(obs[[y]])) {
    message("In observation level data, the group variable '", y, "' is automatically transformed into a numerical number.")
    obs[[y]] <- as.numeric(obs[[y]])
  }

  # a table calculates the number of subjects per parameter per visit per arm
  n_tbl <- table(obs[, c(x, obs_group, obs_var)]) |>
    as.data.frame()

  n_tbl$n <- n_tbl$Freq

  tbl <- merge(obs, n_tbl, all.x = TRUE)

  # Calculate summary statistics and add these variables into tbl
  plotds <- mapply(
    function(s, u) {
      t <- as.vector(summary(s[[y]]))

      if (nrow(s) > 5) {
        iqr.range <- t[5] - t[2]
        upper_outliers <- t[5] + iqr.range * 1.5
        lower_outliers <- t[2] - iqr.range * 1.5
        s$outlier <- ifelse((s[[y]] > upper_outliers | s[[y]] < lower_outliers), s[[y]], NA)
      } else if (nrow(s) > 0) {
        s$outlier <- NA
      } else {
        warning(paste0(
          "There is no record for the combination of `var` and `group` in `meta$observation`, and `x` in `meta$analysis`: ",
          u
        ))
      }
      # mutate ans for output
      if (nrow(s) > 0) {
        ans <- s
        ans$min <- t[1]
        ans$q1 <- t[2]
        ans$median <- t[3]
        ans$mean <- t[4]
        ans$q3 <- t[5]
        ans$max <- t[6]

        ans
      }
    },
    split(tbl, list(tbl[[obs_var]], tbl[[obs_group]], tbl[[x]])),
    names(split(tbl, list(tbl[[obs_var]], tbl[[obs_group]], tbl[[x]]), sep = ", ")),
    SIMPLIFY = FALSE
  )

  plotds <- do.call(rbind, plotds)
  rownames(plotds) <- NULL

  # Return value
  metalite::outdata(meta, population, observation, parameter,
    x_var = x, y_var = y, group_var = obs_group,
    param_var = obs_var,
    n = n_tbl, order = NULL, group = NULL, reference_group = NULL,
    plotds = plotds
  )
}
