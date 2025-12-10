# Create an interactive box plot

Create an interactive box plot

## Usage

``` r
boxly(
  outdata,
  color = NULL,
  hover_summary_var = c("n", "min", "q1", "median", "mean", "q3", "max"),
  hover_outlier_label = c("Participant ID", "Parameter value"),
  x_label = "Visit",
  y_label = "Change",
  heading_select_list = "Lab parameter",
  heading_summary_table = "Number of Participants"
)
```

## Arguments

- outdata:

  An `outdata` object created from `prepare_ae_forestly()`.

- color:

  Color for box plot.

- hover_summary_var:

  A character vector of statistics to be displayed on hover label of
  box.

- hover_outlier_label:

  A character vector of hover label for outlier. A label from an input
  data is used if `NA` for a variable is specified.

- x_label:

  x-axis label.

- y_label:

  y-axis label.

- heading_select_list:

  Select list menu label.

- heading_summary_table:

  Summary table label.

## Value

Interactive box plot.

## Examples

``` r
# Only run this example in interactive R sessions
if (interactive()) {
  library(metalite)

  meta_boxly(
    boxly_adsl,
    boxly_adlb,
    population_term = "apat",
    observation_term = "wk12"
  ) |>
    prepare_boxly() |>
    boxly()
}
```
