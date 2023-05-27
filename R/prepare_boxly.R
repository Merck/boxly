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

#' Prepare data for interactive box plot
#'
#' @inheritParams metalite.ae::prepare_ae_specific
#' @param analysis Name of analysis plan
#'
#' @examples
#' library(metalite)
#' library(dplyr)
#' meta <- meta_boxly()
#' prepare_boxly(meta,
#'   population = "apat",
#'   observation = "wk12",
#'   analysis = "lb_boxly",
#'   parameter = "sodium;bili;urate"
#' )
#' @return Metadata list with plotting dataset
#' @export
prepare_boxly <- function(meta,
                          population,
                          observation,
                          analysis,
                          parameter) {
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
    warning("In observation level data, the group variable '", obs_group, "' is automatically transformed into a factor!")
    obs[[obs_group]] <- factor(obs[[obs_group]], levels = sort(unique(obs[[obs_group]])))
  }

  if (!"factor" %in% class(obs[[obs_var]])) {
    warning("In observation level data, the facet variable '", obs_var, "' is automatically transformed into a factor!")
    obs[[obs_var]] <- factor(obs[[obs_var]], levels = sort(unique(obs[[obs_var]])))
  }

  if (!"factor" %in% class(obs[[x]])) {
    warning("In observation level data, the group variable '", x, "' is automatically transformed into a factor!")
    obs[[x]] <- factor(obs[[x]], levels = sort(unique(obs[[x]])))
  }

  if (!"numeric" %in% class(obs[[y]])) {
    warning("In observation level data, the group variable '", y, "' is automatically transformed into a numerical number!")
    obs[[y]] <- as.numeric(obs[[y]])
  }

  # a table calculates the number of subjects per parameter per visit per arm
  n_tbl <- table(obs[, c(x, obs_group, obs_var)]) |>
    as.data.frame()

  n_tbl$n <- n_tbl$Freq

  tbl <- merge(obs, n_tbl, all.x = TRUE)

  # Calculate summary statistics and add these variables into tbl
  plotds <- lapply(
    split(tbl, list(tbl[[obs_var]], tbl[[obs_group]], tbl[[x]])),
    function(s) {
      t <- as.vector(summary(s[[y]]))

      if (nrow(s) > 5) {
        iqr.range <- t[5] - t[2]
        upper_outliers <- t[5] + iqr.range * 1.5
        lower_outliers <- t[2] - iqr.range * 1.5
        s$outlier <- ifelse((s[[y]] > upper_outliers | s[[y]] < lower_outliers), s[[y]], NA)
      } else {
        s$outlier <- NA
      }
      # mutate ans for output
      ans <- s
      ans$min <- t[1]
      ans$q1 <- t[2]
      ans$median <- t[3]
      ans$mean <- t[4]
      ans$q3 <- t[5]
      ans$max <- t[6]

      ans
    }
  )
  plotds <- do.call(rbind, plotds)
  rownames(plotds) <- NULL

  # Return value
  outdata(meta, population, observation, parameter,
    x_var = x, y_var = y, group_var = obs_group,
    param_var = obs_var,
    n = n_tbl, order = NULL, group = NULL, reference_group = NULL,
    plotds = plotds
  )
}
