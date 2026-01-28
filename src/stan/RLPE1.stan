data {
  int<lower=0> n;
  int<lower=0> k;
  array[n, k] int<lower=0, upper=1> Y;
}
parameters {
  vector[n] theta;
  vector[k] b;
  vector<lower=0>[k] a;
  vector<lower=0>[k] lambda;
}
transformed parameters{

  matrix[n,k] m;
  matrix<lower=0, upper=1>[n, k] prob;

 for (j in 1:k) {
    m[, j] = a[j] * (theta - b[j]);
  }

 for (j in 1:k) {
     prob[,j] = 1 - pow(1 + exp(m[,j]),-lambda[j]);
  }

}
model {
  theta ~ normal(0,1);
  b ~ normal(0,1);
  a ~ lognormal(0,1);
  lambda ~ gamma(0.25,0.25);

  for (j in 1:k) {
    Y[, j] ~ bernoulli(prob[, j]);
  }
}



