using Turing
using Distributions
using Base.Test

@model test_ex_rt() = begin
  x ~ Normal(10, 1)
  y ~ Normal(x / 2, 1)
  z = y + 1
  x = x - 1
  x, y, z
end

mf = test_ex_rt()

for alg = [HMC(2000, 0.2, 3), PG(20, 2000), SMC(10000), IS(10000), Gibbs(2000, PG(20, 1, :x), HMC(1, 0.2, 3, :y))]
  println("[explicit_ret.jl] testing $alg")
  chn = sample(mf, alg)
  @test_approx_eq_eps mean(chn[:x]) 9.0 0.2
  @test_approx_eq_eps mean(chn[:y]) 5.0 0.2
  @test_approx_eq_eps mean(chn[:z]) 6.0 0.2
end
