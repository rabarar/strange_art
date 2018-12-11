using Luxor, Colors
using Printf
using JSON

include("strange.jl")


struct StrangeSet
	ctrl_params::Dict{Symbol,Float64}
	dot_size::Float64
	res::Int64
	color_profile::Dict{Symbol,Float64}
	filename::String
end

# parameters controls
a_range = 5.0
b_range = 10.0
c_range = 5.0
d_range = 10.0
e_range = 5.0

# image size:res x res 
res = 1_000

# number of images to generate
n = 1
basename = "strange"

# rgb color profile
color_profile = Dict([:r=>2.13,:g=>.13,:b=>2.83])

# generate n png images
for i in 1:n
	a = b = c = d = ev = 0
	while (a==0 || b == 0 || c == 0 || d == 0 || ev == 0)
		a = rs()*rand()*a_range
		b = rs()*rand()*b_range
		c = rs()*rand()*c_range
		d = rs()*rand()*d_range
		ev = rs()*rand()*e_range
	end

	dotsize = rand()
	if dotsize > .65
		dotsize = .75
	elseif dotsize < .35
			dotsize = .35
	end

	fn = @sprintf("%s_%-2.2d.png", basename, i)
	fn_ctrl = @sprintf("%s_%-2.2d.json", basename, i)

	cf = open(fn_ctrl, "w")
	sset = StrangeSet(Dict([:a=>a, :b=>b, :c=>c, :d=>d, :e=>ev]), dotsize, res, color_profile, fn)
	JSON.print(cf, JSON.parse(JSON.json(sset)), 4)
	close(cf)

	params = @sprintf("Params: a=%-2.16f, b=%-2.16f, c=%-2.16f, d=%-2.16f, e=%-2.16f, res=%-2.2d, dotsize = %-2.16f\n",
	   a, b, c, d, ev, res, dotsize)
	println("$params")

	strange(fn, dotsize, res, Dict([:a=>a,:b=>b, :c=>c, :d=>d, :e=>ev]), color_profile)
	println("finished generating $fn")
end
