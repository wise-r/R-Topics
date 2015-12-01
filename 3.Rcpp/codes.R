library(microbenchmark)
library(Rcpp)

# example one
sumR <- function(x) {
  total <- 0
  for (i in seq_along(x)) {
    total <- total + x[i]
  }
  total
}

cppFunction('double sumCpp(NumericVector x) {
  int n = x.size();
  double total = 0;
  for(int i = 0; i < n; ++i) {
    total += x[i];
  }
  return total;
}')

x <- runif(1e3)

microbenchmark(
  sum(x),
  sumCpp(x),
  sumR(x)
)

# example two
gibbs_r <- function(N, thin) {
  mat <- matrix(nrow = N, ncol = 2)
  x <- y <- 0
  
  for (i in 1:N) {
    for (j in 1:thin) {
      x <- rgamma(1, 3, y * y + 4)
      y <- rnorm(1, 1 / (x + 1), 1 / sqrt(2 * (x + 1)))
    }
    mat[i, ] <- c(x, y)
  }
  mat
}

sourceCpp("3.Rcpp/gibbs_sampler.cpp")

microbenchmark(
  gibbs_r(100, 10),
  gibbs_cpp(100, 10)
)

# example three
sourceCpp("3.Rcpp/backtest.cpp")
set.seed(123)
p <- cumsum(rnorm(1e3, mean = 1, sd = 50))
plot(p, type = 'l')

balance <- backtest(p, params = list(K = 15, BKRatio = 1.5))
plot(balance, type = 'l')

# example four
positions <- data.frame(ID = 1:1e3,
                        LONG = rnorm(1e3, sd = 0.01) + 118.1, 
                        LAT = rnorm(1e3, sd = 0.01) + 24.46)

sourceCpp("3.Rcpp/calc_dist.cpp")
neighbors <- lapply(positions$ID, get_neighbors, 24.46, positions)
