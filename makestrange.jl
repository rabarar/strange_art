using Luxor, Colors
using Printf

include("strange.jl")

# parameters controls
a_range = 5.0
b_range = 10.0
c_range = 5.0
d_range = 10.0
e_range = 5.0

# image size:res x res 
res = 5_000

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
	fn_ctrl = @sprintf("%s_%-2.2d.ctrl", basename, i)

	cf = open(fn_ctrl, "w")
	write(cf, @sprintf("Filename: %s\n", fn))

	params = @sprintf("Params: a=%-2.4f, b=%-2.4f, c=%-2.4f, d=%-2.4f, e=%-2.4f, res=%-2.2d, dotsize = %-2.4f\n",
			   a, b, c, d, ev, res, dotsize)
	write(cf, params)

	write(cf, @sprintf("Color Profile: [%f, %f, %f]\n", color_profile[:r], color_profile[:g], color_profile[:b]))
	close(cf)
	println("$params")

	strange(fn, dotsize, res, Dict([:a=>a,:b=>b, :c=>c, :d=>c, :e=>ev]), color_profile)
	println("finished generating $fn")
end
