
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
#'
sum <- function(x,y) {x+y}
