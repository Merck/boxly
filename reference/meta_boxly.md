# Create an example metadata object

Create an example metadata object

## Usage

``` r
meta_boxly(
  dataset_adsl,
  dataset_param,
  population_term,
  population_subset = SAFFL == "Y",
  observation_term,
  observation_subset = SAFFL == "Y",
  parameters = unique(dataset_param$PARAMCD)
)
```

## Arguments

- dataset_adsl:

  ADSL source dataset.

- dataset_param:

  Observation level source dataset for boxplot.

- population_term:

  A character value of population term name.

- population_subset:

  An unquoted condition for selecting the populations from ADSL dataset.

- observation_term:

  A character value of observation term name.

- observation_subset:

  An unquoted condition for selecting the observations from
  `dataset_param` dataset.

- parameters:

  A chracter vector of parameters defined in `dataset_param$PARAMCD`

## Value

A metalite object.

## Examples

``` r
meta_boxly(
  boxly_adsl,
  boxly_adlb,
  population_term = "apat",
  observation_term = "wk12"
)
#> ADaM metadata: 
#>    .$data_population     Population data with 254 subjects 
#>    .$data_observation    Observation data with 24746 records 
#>    .$plan    Analysis plan with 1 plans 
#> 
#> 
#>   Analysis population type:
#>     name        id  group var       subset label
#> 1 'apat' 'USUBJID' 'TRTA'     SAFFL == 'Y'    ''
#> 
#> 
#>   Analysis observation type:
#>     name        id  group     var       subset label
#> 1 'wk12' 'USUBJID' 'TRTA' 'PARAM' SAFFL == 'Y'    ''
#> 
#> 
#>   Analysis parameter type:
#>        name                              label              subset
#> 1  'SODIUM'                  'Sodium (mmol/L)' PARAMCD == 'SODIUM'
#> 2       'K'               'Potassium (mmol/L)'      PARAMCD == 'K'
#> 3      'CL'                'Chloride (mmol/L)'     PARAMCD == 'CL'
#> 4    'BILI'               'Bilirubin (umol/L)'   PARAMCD == 'BILI'
#> 5     'ALP'       'Alkaline Phosphatase (U/L)'    PARAMCD == 'ALP'
#> 6     'GGT' 'Gamma Glutamyl Transferase (U/L)'    PARAMCD == 'GGT'
#> 7     'ALT'   'Alanine Aminotransferase (U/L)'    PARAMCD == 'ALT'
#> 8     'AST' 'Aspartate Aminotransferase (U/L)'    PARAMCD == 'AST'
#> 9     'BUN'     'Blood Urea Nitrogen (mmol/L)'    PARAMCD == 'BUN'
#> 10  'CREAT'              'Creatinine (umol/L)'  PARAMCD == 'CREAT'
#> 11  'URATE'                   'Urate (umol/L)'  PARAMCD == 'URATE'
#> 12   'PHOS'               'Phosphate (mmol/L)'   PARAMCD == 'PHOS'
#> 
#> 
#>   Analysis function:
#>      name                  label
#> 1 'boxly' 'Interactive Box Plot'
#> 
```
