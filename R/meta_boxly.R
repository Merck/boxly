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

#' Create a dummy data for box plot
#' @export
#' @return Metadata for creating interactive box plot
#'
meta_boxly <- function() {
  adsl <- r2rtf::r2rtf_adsl |>
    dplyr::rename(TRTA = TRT01A) |>
    dplyr::mutate(TRTA = factor(TRTA,
                         levels = c("Placebo", "Xanomeline High Dose", "Xanomeline Low Dose")))

  adlb <- boxly_adlb

  names(adlb) <- toupper(names(adlb))
  adlb$TRTA <- factor(adlb$TRTA,
                      levels = c("Placebo", "Xanomeline High Dose", "Xanomeline Low Dose"))

  plan <- metalite::plan(
    analysis = "lb_boxly", population = "apat",
    observation = c("wk12", "wk24"), parameter = "sodium;bili;urate"
  )

  metalite::meta_adam(
    population = adsl,
    observation = adlb
  ) |>
    metalite::define_plan(plan = plan) |>
    metalite::define_population(
      name = "apat",
      group = "TRTA",
      subset = quote(SAFFL == "Y")
    ) |>
    metalite::define_observation(
      name = "wk12",
      group = "TRTA",
      var = "PARAM",
      subset = ANL01FL == "Y" & AVISITN <= 12 & !is.na(CHG),
      label = "Weeks 0 to 12"
    ) |>
    metalite::define_observation(
      name = "wk24",
      group = "TRTA",
      var = "PARAM",
      subset = ANL01FL == "Y" & AVISITN > 12 & AVISITN <=24 & !is.na(CHG),
      label = "Weeks 12 to 24"
    ) |>
    metalite::define_analysis(
      name = "lb_boxly",
      label = "Interactive: box plot for laboratory results",
      title = "Interactive Boxplot of Laboratory Results",
      x = "AVISITN",
      y = "CHG"
    ) |>
    metalite::define_parameter(
      name = "sodium",
      label = "Sodium (mmol/L)",
      subset = PARAMCD == "SODIUM"
    ) |>
    metalite::define_parameter(
      name = "bili",
      label = "Bilirubin (umol/L)",
      subset = PARAMCD == "BILI"
    ) |>
    metalite::define_parameter(
      name = "urate",
      label = "Urate (umol/L)",
      subset = PARAMCD == "URATE"
    ) |>
    metalite::meta_build()
}
