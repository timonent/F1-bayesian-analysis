// The input data N tells how many age pools we have
// The I tells how many samples we have for each of the ages pools.
// The max_i tells the largest value of I vector.
// The vecotr 'ages'  is of length 'N*I containing age differneces for different ages of drives
// Vector y is the scaled time difference.
// 
//
data {
  int<lower=0> N;
  int<lower=0> I[N];
  int<lower=0> max_i;
  int indices[max_i,N];
  int total_length;
  real time[total_length];
}


parameters {
  real mu[N];
  real<lower=0> sigma[N];

}

model {
  mu ~ normal(0,1);        //prior
  sigma ~ normal(0,1);     //prior
  for(j in 1:N){
    for(i in 1:I[j]){
      time[indices[i,j]] ~ normal(mu[j], sigma[j]);
    }
  }
}

generated quantities{
  real time_pred[N];
  real log_lik[total_length];
  for(j in 1:N){
    time_pred[j] = normal_rng(mu[j], sigma[j]);
    for (i in 1:I[j]){
      log_lik[indices[i,j]] = normal_lpdf(time[indices[i,j]] | mu[j], sigma[j]);
    }
  }

}
