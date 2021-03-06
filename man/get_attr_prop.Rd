% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/net.utils.R
\name{get_attr_prop}
\alias{get_attr_prop}
\title{Proportional Table of Vertex Attributes}
\usage{
get_attr_prop(nw, fterms, only.formula = TRUE)
}
\arguments{
\item{nw}{The \code{networkDynamic} object contained in the \code{netsim}
simulation.}

\item{fterms}{Vector of attributes used in formation formula, usually as
output of \code{\link{get_formula_terms}}.}

\item{only.formula}{Limit the tables to those terms only in \code{fterms},
       otherwise output proportions for all attributes on the network object.}
}
\description{
Calculates the proportional distribution of each vertex attribute
             contained on the network, with a possible limitation to those
             attributes contained in the formation formula only.
}
\seealso{
\code{\link{get_formula_terms}}, \code{\link{copy_toall_attr}},
         \code{\link{update_nwattr}}.
}
\keyword{internal}
\keyword{netUtils}

