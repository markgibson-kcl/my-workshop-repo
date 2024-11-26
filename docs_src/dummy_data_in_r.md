### Generate a dummy dataset using a custom R script


## Why use custom dummy data?
* Complete control over distribution of variables and dependencies between variables
* Complete control over dataset size
* No ad-hoc adjustments here and there - do it all in one place, once
* ehrQL will check that the custom dataset is "correct" (to an extent)


## Challenges
* Maintaining consistency between custom dummy data specification and ehrQL specification as the dataset definition evolves
* Need some understanding of data simulation

## Why use dd4d instead of base R?
* An API that supports common simulation patterns, such as:
    * Specifying dependent missingness
    * Flagging latent variables which are needed for simulation but do not appear in the final dataset
* Supports common simulation functions that are awkward in base R (eg `rcat` and `rbernoulli`)
* Supports inspection and visualisation of the specified DAG
* Tests that catch errors early, e.g. testing that the specification isn't cyclic and if so which path is cyclic.
* Variables do not have to be specified in topological order (unlike in a `mutate` step).
* You get all this whilst retaining:
    * Support for arbitrary distributions and dependencies
    * IDE syntax highlighting / error-checking (unlike if dependencies were defined with strings). 
