meta_boxly_test <- function(
  dataset_adsl,
  dataset_param,
  population_term,
  observation_term,
  parameters = unique(dataset_param$PARAMCD)
) {
  analysis_plan <- metalite::plan(
    analysis = "boxly",
    population = population_term,
    observation = observation_term,
    parameter = paste(parameters, collapse = ";")
  )

  meta <- metalite::meta_adam(
    population = dataset_adsl,
    observation = dataset_param
  ) |>
    metalite::define_plan(plan = analysis_plan) |>
    metalite::define_population(
      name = population_term,
      group = "TRTA",
      subset = SAFFL == "Y",
      label = ""
    ) |>
    metalite::define_observation(
      name = observation_term,
      group = "TRTA",
      var = "PARAM",
      subset = AVISITN <= 12 & !is.na(CHG),
      label = ""
    ) |>
    metalite::define_analysis(
      name = "boxly",
      label = "Interactive Box Plot",
      x = "AVISITN",
      y = "CHG"
    )

  parameter_data <- unique(dataset_param[, c("PARAM", "PARAMCD")])
  parameter_data <- parameter_data[parameter_data[["PARAMCD"]] %in% parameters, ]

  for (index in seq(parameters)) {
    term <- paste0("PARAMCD == '", parameter_data[["PARAMCD"]][index], "'")
    meta <- meta |>
      metalite::define_parameter(
        name = parameter_data[["PARAMCD"]][index],
        label = parameter_data[["PARAM"]][index],
        subset = str2lang(term)
      )
  }

  metalite::meta_build(meta)
}