#' @title Autocorrelation Function for Causaly ARMA(p,q) Process
#'
#' @description The function acf_arma() computes estimates of the autocorrelation/autocoveriance up to given lag.
#' @description It returns a data frame including lags, autocovariances and autocorellations.
#'
#' @param phi A vector, containing coefficient of AR part as array. it require to have 1 as leading coefficient.
#' @param theta A vector, containing coefficient of MA part as array. it require to have 1 as leading coefficient.
#' @param lag The desired maximun lag , The default value is 20.
#' @param dig The desired rounding digit of return value, the default value is 5
#'
#' @return lag       (lag)
#' @return gamma     (autocovariance)
#' @return rho       (autocorrelation)
#'
#' @note If an integer (within 8 decimal places) is not entered for the value of dig,
#'   then the floor of dig will be used instead.
#' @note If an positive integer (within 8 decimal places) is not entered for the value of lag,
#'   then the floor of absolute value of lag will be used instead.
#' @note This function STRONGLY REQUIRE arma process to be causal.
#'
#' @author Ankai Liu, \email{ankailiu@trentu.ca}
#' @references Brockwell, P. J., & Davis, R. A. (2013). Time series: theory and methods. New York, NY: Springer.
#' @seealso None
#' @keywords Autocovariance, Autocorrelation, ACF, ARMA
#'
#' @examples
#' # Define time series data in a vector, x
#' phi <- c(1, -1, 1 / 4)
#' theta <- c(1, 1)
#'
#' # Use acf_arma function
#' acf_arma(phi, theta)
#' acf_arma(phi, theta, 20, 8)
#'
#' # Another example
#' phi <- c(1, rnorm(100))
#' theta <- c(1,rnorm(50))
#'
#' acf_arma(phi, theta)
#' acf_arma(phi, theta, 10, 8)
#'
#' @export
#' @importFrom grDevices rgb2hsv
#' @importFrom graphics par plot rect text
#'


#
# since method #1 is not acceptable for computation. we thus use method #2
# the two inputs would be both strings with the coefficient.
# the output would be just a string with lag=c(0:20)
#

acf_arma <- function( phi, theta, lag = 20, dig = 5 ) {

  stopifnot(is.numeric( phi ), is.numeric( theta ),
            is.vector( phi ), is.vector( theta ),
            length( phi ) > 0, length( theta ) > 0,
            is.numeric(lag),
            is.numeric(dig), dig >= 1)

  if (round(lag) != abs(lag)) {
    lag <- ceiling(abs(lag))
  }
  if (round(dig) != dig) {
    dig <- ceiling(dig)
  }
  if (phi[1] != 1) {
    stop( "Leading coefficient of PHI must be 1.")
  }
  if (theta[1] != 1) {
    stop( "Leading coefficient of THETA must be 1.")
  }

  #
  # make sure it is casual
  #
  #k <- abs(polyroot(phi)) <= 1
  #if (sum(k) != 0) {
  #  warning( "Non casual ARMA, implementation might not be valid")
  #}
  #

  #
  # we first find psi=theta/phi
  #
  p <- length( phi )
  q <- length( theta )

  phi_1 <- c( phi, rep(0, max(q , lag) * 2) )
  theta_1 <- c( theta, rep(0,max(q , lag) * 2) )
  psi <- rep(0, max(q , lag))
  psi[1] <- theta_1[1]
  for (i in 2:max(q , lag)) {
    psi[i] <- theta_1[i] - sum(psi[1:(i - 1)] * phi_1[i:2])
    # here becaues the phi here is the actual coefficient
    # (include the negative sign in front of it.)
    # so we use "-" istead "+)
  }
  #print(psi)
  #print(length(psi))

  #
  # method 2 find lag 1:p
  #

  #
  # Left hand side
  #
  phi_2 <- c(rep(0,p),phi,rep(0,2 * p))
  l <- matrix(c(phi_2[(p + 1):(2 * p)],rep(0,(p)^2 - p)),nrow=p,ncol=p,byrow=FALSE)
  for (i in 1:p) {
    for (j in 2:p) {
      l[i,j] <- phi_2[p + i - (j - 1)]+phi_2[p + i + (j - 1)]
      #print(phi_2[p - 1 + i - (j - 1)])
      #print(phi_2[p - 1 + i + (j - 1)])
    }
  }
  #print(l)

  #
  # right hand side
  #
  r <- rep(0,p)
  for (i in 1:p) {
    #
    # we only need right hand side up to p. and we make the rest 0
    #
    if ( i <= q ) {
      r[i] <- sum(psi[1:(q - i + 1)] * theta[i:q])
      #print(psi[1:(q - i + 1)])
    }
    else {
      r[i] <- 0
    }
  }
  #print(r)
  gam <- solve(l,r)

  #
  # method 3, we use existence gamma to find the rest
  #
  if ( (p - 1 ) < lag ) {
    for (i in (p + 1):(lag + 1)) {
      g <- - sum(phi[-1] * gam[(i - 1):(i - p + 1)])
      gam <- c(gam, g)
    }
  }
  #print(gam)
  #
  # output
  #
  rho <- gam / gam[1]
  data <- round(data.frame(lags = 0:lag, gamma=gam[1:(lag + 1)], rho=rho[1:(lag + 1)]), digit = dig)
  output <- list("data" = data)
  return(output)
}

#
# test acf
#
# phi <- c(1, -1, 1 / 4)
# theta <- c(1, 1)

# phi <- c(1, rnorm(10))
# theta <- c(1,rnorm(50))

# closed form formular from book in p93
# testgamma <- rep(0, 21)
# for (i in 1:21) {
#   testgamma[i] <- (32 / 3 + 8 * (i - 1)) * 2^(- i + 1)
# }
# testrho <- testgamma / testgamma[1]
# test1 <- data.frame(lag=0:20, gamma=testgamma,rho=testrho)
# test1

# test2 <- acf_arma(phi, theta, 20, 10)
# test1-test2$data
