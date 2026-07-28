# Borda-vs-Plurality
How would have been if in the elections of 2008 in Spain, instead the Plurality System would have been used the Borda System. Data Analysis.

# Re-simulating the 2008 Spanish General Elections: Borda Count vs. Plurality

##  Project Overview
This empirical Social Choice project evaluates the results of the 2008 Spanish General Elections by contrasting traditional **Plurality Voting** with the **Borda Count method**. Using representative survey sample data from the Comparative Study of Electoral Systems (CSES), individual citizen evaluations (scored on a 1–10 scale across political parties) are transformed into ordinal ranking profiles. 

The goal is to determine how the electoral outcome and parliamentary distribution would have changed under a consensus-based aggregation mechanism.

---

##  Repository Structure

* `Script_SocialChoice.R`: Main R script executing data cleaning, score-to-rank transformation, Borda scoring, and plurality share extraction.
* `rankings.RData`: R Data file containing `ranking.list` with survey preference profiles (including `Spain_2008`).
* `cses3.RData`: CSES module data containing complementary electoral and respondent variables.
* `README.md`: Complete project documentation and workflow explanation.

---

##  Dependencies & Setup

The analysis relies on the specialized `vote` package in R for social choice aggregations.

To replicate the project:
1. Ensure `rankings.RData` and `cses3.RData` are placed in your working directory.
2. Run the following setup in R / Positron:

```R
install.packages("vote")
library(vote)

load("rankings.RData")
load("cses3.RData")


Steps of the Script:

Step 1: Data Extraction and Inspection
The 2008 Spanish electoral sample is isolated from the main ranking list:
datos_espana <- ranking.list$Spain_2008
This dataset contains individual voter scores (1 to 10) for each major Spanish political party.

Step 2: Score-to-Ranking Transformation
Because raw scores represent evaluation intensity, they are converted into ordinal rankings (where rank 1 represents the voter's most preferred party). The ties.method = "random" argument handles equal score assignments across parties:
rankings_borda <- t(apply(-datos_espana, 1, rank, ties.method = "random"))


Empirical results and conclusions:

Result 1: Determining the Borda Winner
Using the score() function from the vote package, Borda points are assigned across all individual preference rankings:
resultado_borda <- score(rankings_borda)
summary(resultado_borda)
The console outputs the aggregate Borda score and ordinal ranking of parties. Unlike Plurality, this identifies the overall consensus winner by taking into account voters' second and lower-tier preferences, revealing which party generates the least collective rejection across the Spanish electorate.

Result 2: Electoral Vote & Seat Share Distribution
To compare the consensus outcome with standard first-preference dynamics, the script isolates each citizen's top choice (1st rank) and computes total party vote percentages:
rankings_borda_buenos <- t(apply(datos_espana, 1, rank, ties.method = "random"))
puesto_uno_real <- apply(rankings_borda_buenos, 1, function(x) which(x == 1)[1])
partidos_ganadores_reales <- colnames(rankings_borda_buenos)[puesto_uno_real]

tabla_votos_reales <- table(partidos_ganadores_reales)
porcentajes_reales <- prop.table(tabla_votos_reales) * 100
sort(porcentajes_reales, decreasing = TRUE)
This step yields the percentage distribution of primary choices across the sample. It simulates the proportional vote share each political party would command in Congress, highlighting the structural gap between first-preference dominance (Plurality) and overall broad-based consensus (Borda Count).
