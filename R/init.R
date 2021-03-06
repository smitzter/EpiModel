
#' @title Initial Conditions for Deterministic Compartmental Models
#'
#' @description Sets the initial conditions for deterministic compartmental
#'              models simulated with \code{dcm}.
#'
#' @param s.num Number of initial susceptible. For two-group models, this is
#'        the number of initial group 1 susceptible.
#' @param i.num Number of initial infected. For two-group models, this is the
#'        number of initial group 1 infected.
#' @param r.num Number of initial recovered. For two-group models, this is the
#'        number of initial group 1 recovered. This parameter is only used for
#'        the \code{SIR} model type.
#' @param s.num.g2 Number of initial susceptible in group 2. This parameter is
#'        only used for two-group models.
#' @param i.num.g2 Number of initial infected in group 2. This parameter is only
#'        used for two-group models.
#' @param r.num.g2 Number of initial recovered in group 2. This parameter is
#'        only used for two-group \code{SIR} models.
#' @param ... Additional initial conditions passed to model.
#'
#' @details
#' The initial conditions for a model solved with \code{\link{dcm}} should be
#' input into the \code{init.dcm} function. This function handles initial
#' conditions for both built-in model types and original models. For an overview
#' of initial conditions for built-in DCM class models, consult the
#' \href{http://statnet.github.io/tut/BasicDCMs.html}{Basic DCMs} tutorial.
#'
#' Original models may use the parameter names listed as arguments here, a new
#' set of names, or a combination of both. With new models, initial conditions
#' must be input in the same order that the solved derivatives from the model
#' are output. More details on this requirement are outlined in the
#' \href{http://statnet.github.io/tut/NewDCMs.html}{Solving New DCMs} tutorial.
#'
#' @seealso Use \code{\link{param.dcm}} to specify model parameters and
#'          \code{\link{control.dcm}} to specify the control settings. Run the
#'          parameterized model with \code{\link{dcm}}.
#'
#' @keywords parameterization
#'
#' @export
#'
init.dcm <- function(s.num,
                     i.num,
                     r.num,
                     s.num.g2,
                     i.num.g2,
                     r.num.g2,
                     ...) {

  # Get arguments
  p <- list()
  formal.args <- formals(sys.function())
  formal.args[["..."]] <- NULL
  for (arg in names(formal.args)) {
    if (as.logical(mget(arg) != "")) {
      p[arg] <- list(get(arg))
    }
  }
  dot.args <- list(...)
  names.dot.args <- names(dot.args)
  if (length(dot.args) > 0) {
    for (i in 1:length(dot.args)) {
      p[[names.dot.args[i]]] <- dot.args[[i]]
    }
  }

  # Reorder arguments
  mc <- names(as.list(sys.call()[-1]))
  out.p <- list()
  for (i in seq_along(mc)) {
    out.p[[mc[i]]] <- p[[mc[i]]]
  }

  ## Output
  class(out.p) <- "init.dcm"
  return(out.p)
}


#' @title Initial Conditions for Stochastic Individual Contact Models
#'
#' @description Sets the initial conditions for stochastic individual contact
#'              models simulated with \code{icm}.
#'
#' @param s.num Number of initial susceptible. For two-group models, this is
#'        the number of initial group 1 susceptible.
#' @param i.num Number of initial infected. For two-group models, this is the
#'        number of initial group 1 infected.
#' @param r.num Number of initial recovered. For two-group models, this is the
#'        number of initial group 1 recovered. This parameter is only used for
#'        the \code{SIR} model type.
#' @param s.num.g2 Number of initial susceptible in group 2. This parameter is
#'        only used for two-group models.
#' @param i.num.g2 Number of initial infected in group 2. This parameter is only
#'        used for two-group models.
#' @param r.num.g2 Number of initial recovered in group 2. This parameter is
#'        only used for two-group \code{SIR} models.
#' @param status.rand If \code{TRUE}, sets infection based on random binomial
#'        draws from the distribution implied by the number susceptible, infected,
#'        and recovered in each group.
#' @param ... Additional initial conditions passed to model.
#'
#' @details
#' The initial conditions for a model solved with \code{\link{icm}} should be
#' input into the \code{init.icm} function. This function handles initial
#' conditions for both built-in models and original models using new modules. For
#' an overview of initial conditions for built-in ICM class models, consult the
#' \href{http://statnet.github.io/tut/BasicICMs.html}{Basic ICMs} tutorial.
#'
#' @seealso Use \code{\link{param.icm}} to specify model parameters and
#'          \code{\link{control.icm}} to specify the control settings. Run the
#'          parameterized model with \code{\link{icm}}.
#'
#' @keywords parameterization
#'
#' @export
#'
init.icm <- function(s.num,
                     i.num,
                     r.num,
                     s.num.g2,
                     i.num.g2,
                     r.num.g2,
                     status.rand = TRUE,
                     ...) {

  # Get arguments
  p <- list()
  formal.args <- formals(sys.function())
  formal.args[["..."]] <- NULL
  for (arg in names(formal.args)) {
    if (as.logical(mget(arg) != "")) {
      p[arg] <- list(get(arg))
    }
  }
  dot.args <- list(...)
  names.dot.args <- names(dot.args)
  if (length(dot.args) > 0) {
    for (i in 1:length(dot.args)) {
      p[[names.dot.args[i]]] <- dot.args[[i]]
    }
  }


  ## Output
  class(p) <- "init.icm"
  return(p)
}


#' @title Initial Conditions for Stochastic Network Models
#'
#' @description Sets the initial conditions for stochastic network models
#'              simulated with \code{netsim}.
#'
#' @param i.num Number of initial infected. For bipartite models, this is the
#'        number of initial mode 1 infected.
#' @param r.num Number of initial recovered. For bipartite models, this is the
#'        number of initial mode 1 recovered. This parameter is only used for
#'        the \code{SIR} model type.
#' @param i.num.m2 Number of initial infected in mode 2. This parameter is only
#'        used for bipartite models.
#' @param r.num.m2 Number of initial recovered in mode 2. This parameter is
#'        only used for bipartite \code{SIR} models.
#' @param status.vector A vector of length equal to the size of the input network,
#'        containing the status of each node. Setting status
#'        here overrides any inputs passed in the \code{.num} arguments and also
#'        overrides \code{status.rand=TRUE}.
#' @param status.rand If \code{TRUE} and not using \code{status.vector}, sets
#'        infection based on random binomial draws from the distribution implied
#'        by the number infected and recovered in each mode.
#' @param ... Additional initial conditions passed to model.
#'
#' @details
#' The initial conditions for a model solved with \code{\link{netsim}} should be
#' input into the \code{init.net} function. This function handles initial
#' conditions for both built-in models and new modules. For an overview of
#' specifying initial conditions across a variety of built-in network models,
#' consult the \href{http://statnet.github.io/tut/BasicNet.html}{Basic Network
#' Models} tutorial.
#'
#' @seealso Use \code{\link{param.net}} to specify model parameters and
#'          \code{\link{control.net}} to specify the control settings. Run the
#'          parameterized model with \code{\link{netsim}}.
#'
#' @keywords parameterization
#'
#' @export
#'
init.net <- function(i.num,
                     r.num,
                     i.num.m2,
                     r.num.m2,
                     status.vector,
                     status.rand = TRUE,
                     ...) {

  # Get arguments
  p <- list()
  formal.args <- formals(sys.function())
  formal.args[["..."]] <- NULL
  for (arg in names(formal.args)) {
    if (as.logical(mget(arg) != "")) {
      p[arg] <- list(get(arg))
    }
  }
  dot.args <- list(...)
  names.dot.args <- names(dot.args)
  if (length(dot.args) > 0) {
    for (i in 1:length(dot.args)) {
      p[[names.dot.args[i]]] <- dot.args[[i]]
    }
  }


  ## Defaults and checks
  if (!is.null(p$i.num) & !is.null(p$status.vector)) {
    stop("Use i.num OR status.vector to set initial infected")
  }
  if (!is.null(p$status.vector)) {
    p$status.rand <- FALSE
  }

  ## Output
  class(p) <- "init.net"
  return(p)
}
