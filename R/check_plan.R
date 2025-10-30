#' Check randomisation plan
#'
#' Before committing to a randomisation plan (in terms of the number of strata,
#' block sizes etc) it can be useful to estimate the imbalance that might be
#' expected. This function simulates trials of a given sample size and returns
#' the imbalance that might be expected.
#'
#'
#' @rdname check_plan
#' @param n_rando number of participants to randomise
#' @param n_strata number of strata
#' @param arms arms that will be randomised
#' @param blocksizes number of each randomisation group per block (e.g. 1 = one of each arm per block,
#' 2 = per of each arm per block)
#' @param n_sim number of simulations
#'
#' @returns list of class checkplan with slots the same slots as input to the
#' function plus mean (mean imbalance), counts (counts of the imbalances) and
#' worst_case (randomisation results with the worst observed imbalance)
#' @export
#'
#' @seealso https://www.sealedenvelope.com/randomisation/simulation/
#'
#' @importFrom dplyr join_by
#'
#' @examples
#'
#' check_plan(50, 3, n_sim = 50)
#'
check_plan <- function(n_rando,
                       n_strata,
                       arms = c("A", "B"),
                       blocksizes = c(1, 2),
                       n_sim = 1000){

  strata <- letters[1:n_strata]

  strata_txt <- nth <- seq_in_strata <- arm <- N <- `%` <- NULL

  sims <- lapply(cli_progress_along(1:n_sim, clear = TRUE), function(x){
    rl <- randolist(n = n_rando, arms = arms, strata = list(strata), blocksizes = blocksizes)
    sim_parts <- data.frame(strata = sample(strata, n_rando, replace = TRUE)) |>
      mutate(.by = strata,
             nth = 1:n()) |>
      left_join(rl, join_by(strata == strata_txt, nth == seq_in_strata))

    out <- list(imbalance = sim_parts |> imbalance(arm),
                counts = sim_parts |> count(arm))
    return(out)
  })
  # cli_progress_done()

  worst_count <- NA
  imbalances <- sapply(sims, function(x) x$imbalance) |> as.numeric()
  if(!all(imbalances == 0)){
    worst <- which(imbalances == max(imbalances))[1]
    worst_count <- sims[[worst]]$counts

    # worst <- ggplot(worst_count) +
    #   geom_bar(aes(x = arm, y = n),
    #            stat = "identity")
  }



  # imb_plot <- ggplot(data.frame(x = imbalances)) +
  #   geom_bar(aes(x = x)) +
  #   labs(x = "Imbalance between groups")

  out <- list(n_rando = n_rando,
              n_strata = n_strata,
              blocksizes = blocksizes,
              n_sim = n_sim,
              arms = arms,
              mean = mean(imbalances),
              counts = count(data.frame(imbalance = imbalances), imbalance) |>
                mutate(N = sum(n),
                       `%` = n / N * 100,
                       `cum%` = cumsum(`%`)) |>
                select(-N),
              worst_case = worst_count
              )

  class(out) <- c("checkplan", class(out))

  return(out)

}


#' @describeIn check_plan Print method for check_plan output
#'
#' @param x check_plan object
#' @param ... options passed to print.data.frame
#' @export
print.checkplan <- function(x, ...){
  cat("\n")

  cat("Number of simulated trials:", x$n_sim, "\n",
      "Number of participants per trial:", x$n_rando, "\n",
      "Number of strata:", x$n_strata, "\n",
      "Blocksizes:", paste(length(x$arms) * x$blocksizes, collapse = ", "), "\n",
      "Mean imbalance:", x$mean, "\n",
      "Distribution of imbalance:\n")
  x$counts |> print(row.names = FALSE, ...)

  if(max(x$counts$imbalance) > 0){
    cat("\nWorst case imbalance from simulations:\n")
    print(x$worst_case)
  }
}

# check_plan(312, 9, arms = 1:8, n_sim = 500)
# check_plan(312, 2, arms = 1:8, n_sim = 200) |> str()
#
# microbenchmark::microbenchmark(
# check_plan(312, 1, arms = 1:8, n_sim = 50),
# check_plan(312, 2, arms = 1:8, n_sim = 50)




