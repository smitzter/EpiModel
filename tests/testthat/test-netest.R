context("netest")


# Test formation models ---------------------------------------------------

test_that("netest works for edges only model", {
  nw <- network.initialize(n = 50, directed = FALSE)
  est <- netest(
    nw,
    formation = ~ edges,
    dissolution = ~offset(edges),
    target.stats = 25,
    coef.diss = dissolution_coefs(~offset(edges), 10, 0),
    verbose = FALSE)
  expect_is(est, "netest")
})


test_that("netest works for edges + nodematch model", {
  nw <- network.initialize(n = 50, directed = FALSE)
  nw <- set.vertex.attribute(nw, "race", rbinom(50, 1, 0.5))
  est <- netest(
    nw,
    formation = ~ edges + nodematch("race"),
    dissolution = ~offset(edges),
    target.stats = c(25, 10),
    coef.diss = dissolution_coefs(~offset(edges), 10, 0),
    verbose = FALSE)
  expect_is(est, "netest")
})


test_that("netest works with offset.coef terms", {
  nw <- network.initialize(100, directed = FALSE)
  nw <- set.vertex.attribute(nw, "role", rep(c("I", "V", "R"), c(10, 80, 10)))
  est <- netest(nw,
                formation = ~ edges +
                              offset(nodematch('role', diff = TRUE, keep = 1:2)),
                coef.form = c(-Inf, -Inf),
                target.stats = c(40),
                dissolution = ~offset(edges),
                coef.diss = dissolution_coefs(~offset(edges), 52 * 2, 0.0009),
                verbose = FALSE)
  expect_is(est, "netest")
})



# Test dissolution models -------------------------------------------------

test_that("netest works for heterogeneous dissolutions", {
  nw <- network.initialize(100, directed = FALSE)
  nw <- set.vertex.attribute(nw, "race", rbinom(50, 1, 0.5))
  est <- netest(
    nw,
    formation = ~edges + nodematch("race"),
    dissolution = ~ edges + nodematch("race"),
    target.stats = c(50, 20),
    coef.diss = dissolution_coefs(~offset(edges) + offset(nodematch("race")), c(10, 20)),
    verbose = FALSE
  )
  expect_is(est, "netest")
})

test_that("netest diss_check flags bad models", {
  nw <- network.initialize(100, directed = FALSE)
  nw <- set.vertex.attribute(nw, "race", rbinom(50, 1, 0.5))

  formation <- ~edges + nodematch("race")
  dissolution <- ~offset(edges) + offset(nodefactor("race"))
  cd <- dissolution_coefs(dissolution, c(10, 20))
  expect_error(netest(nw, formation, dissolution, target.stats = c(50, 20),
               cd, verbose = FALSE),
               "Dissolution model is not a subset of formation model.")

  formation <- ~edges + nodematch("race", diff = TRUE)
  dissolution <- ~offset(edges) + offset(nodematch("race"))
  cd <- dissolution_coefs(dissolution, c(10, 20))
  expect_error(netest(nw, formation, dissolution, target.stats = c(50, 20),
                      cd, verbose = FALSE),
               "Term options for one or more terms in dissolution model")
})



# Other -------------------------------------------------------------------

test_that("nonconv.error error flag", {
  skip_on_cran()
  nw <- network.initialize(100, directed = FALSE)
  expect_error(netest(nw, formation = ~ edges + concurrent,
                      dissolution = ~offset(edges), target.stats = c(100, 1),
                      coef.diss = dissolution_coefs(~offset(edges), 50),
                      set.control.ergm = control.ergm(MCMLE.maxit = 5),
                      nonconv.error = TRUE), "Model did not converge.")
})

