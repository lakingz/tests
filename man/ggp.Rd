% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/test2.R
\name{ggp}
\alias{ggp}
\title{Illustration of crayon colors}
\usage{
ggp(method2order = c("hsv", "cluster"), cex = 0.6, mar = rep(0.1, 4))
}
\arguments{
\item{method2order}{method to order colors (\code{"hsv"} or \code{"cluster"})}

\item{cex}{character expansion for the text}

\item{mar}{margin paramaters; vector of length 4 (see \code{\link[graphics]{par}})}
}
\value{
None
}
\description{
Creates a plot of the crayon colors in \code{\link{brocolors}}
}
\examples{
plot_crayons()

}
\references{
\url{http://en.wikipedia.org/wiki/List_of_Crayola_crayon_colors}
}
\seealso{
\code{\link{brocolors}}
}
\author{
Karl W Broman, \email{kbroman@biostat.wisc.edu}
}
\keyword{hplot}
