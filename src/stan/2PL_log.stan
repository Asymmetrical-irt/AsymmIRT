data {
  int<lower=1> n;
  int<lower=1> k;
  array[n, k] int<lower=0, upper=1> Y;
}
parameters {
  vector[n] theta;
  vector[k] b;
  vector<lower=0>[k] a;
}
transformed parameters {
  matrix[n,k] m;
  matrix<lower=0, upper=1>[n, k] prob;


  for (j in 1:k) {
    m[, j] = a[j] * (theta - b[j]);
  }

  prob = inv_logit(m);

}
model{
      theta ~ normal(0, 1);
      b     ~ normal(0, sqrt(2));
      a     ~ lognormal(0, 1);

  for (i in 1:n) {
    for (j in 1:k) {
      Y[i, j] ~ bernoulli(prob[i,j]);
    }
  }
}

generated quantities {
  matrix[n, k] log_lik;
  real dev;
  dev = 0;

  for (j in 1:k) {
    for (i in 1:n) {
      log_lik[i, j] = bernoulli_lpmf(Y[i, j] | prob[i, j]);
      dev = dev + (-2)*log_lik[i,j];
    }
  }
}
