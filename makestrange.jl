using Luxor, Colors
using Printf
using JSON
using ArgParse

include("strange.jl")


function parse_commandline()
    settings = ArgParseSettings()

    @add_arg_table settings begin
        "--basename"
            help = "strange image and json basename"
            default = "strange"
	"--a"
	    help = "a control point range"
	    arg_type = Float64
	    default = 5.0
	"--b"
	    help = "b control point range"
	    arg_type = Float64
	    default = 10.0
	"--c"
	    help = "c control point range"
	    arg_type = Float64
	    default = 5.0
	"--d"
	    help = "d control point range"
	    arg_type = Float64
	    default = 10.0
	"--e"
	    help = "e control point range"
	    arg_type = Float64
	    default = 5.0
	"--n"
	    help = "number of images to generate"
	    arg_type = Int64
	    default = 1
	"--res"
	    help = "image w x w res"
	    arg_type = Int64
	    default = 1_000
	"--rc"
	    help = "rgb r  color weight"
	    arg_type = Float64
	    default = 2.13
	"--gc"
	    help = "rgb g color weight"
	    arg_type = Float64
	    default = .13
	"--bc"
	    help = "rgb b color weight"
	    arg_type = Float64
	    default = 2.83
	"--dot_max"
	    help = "max dotsize"
	    arg_type = Float64
	    default = .65
	"--dot_min"
	    help = "min dotsize"
	    arg_type = Float64
	    default = .35
	"--flip"
	    help = "flip sin and cos in the calculations"
	    arg_type = Bool
	    default = false
	"--clamp"
	    help = "clamp red and equalize blue green"
	    arg_type = Bool
	    default = false
    end

    return parse_args(settings)
end

function main()

	parsed_args = parse_commandline()

	# parameters controls
	a_range = parsed_args["a"]
	b_range = parsed_args["b"]
	c_range = parsed_args["c"]
	d_range = parsed_args["d"]
	e_range = parsed_args["e"]

	# image size:res x res 
	res = parsed_args["res"]

	# number of images to generate
	n = parsed_args["n"]

	basename = parsed_args["basename"]

	# rgb color profile
	color_profile = Dict([
			     :r=>parsed_args["rc"],
			     :g=>parsed_args["gc"],
			    :b=>parsed_args["bc"]
			    ])

	# toggle trig functions
	flip = parsed_args["flip"]

	# clamp
	flip = parsed_args["clamp"]

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
		if dotsize > parsed_args["dot_max"]
			dotsize = parsed_args["dot_max"]
		elseif dotsize < parsed_args["dot_min"]
			dotsize = parsed_args["dot_min"]
		end

		fn = @sprintf("%s_%-2.2d.png", basename, i)
		fn_ctrl = @sprintf("%s_%-2.2d.json", basename, i)

		cf = open(fn_ctrl, "w")
		sset = StrangeSet(Dict([:a=>a, :b=>b, :c=>c, :d=>d, :e=>ev]), dotsize, res, color_profile, fn, flip, clamp)
		JSON.print(cf, JSON.parse(JSON.json(sset)), 4)
		close(cf)

		params = @sprintf("Params: a=%-2.16f, b=%-2.16f, c=%-2.16f, d=%-2.16f, e=%-2.16f, res=%-2.2d, dotsize = %-2.16f, flip = %d, clamp = %d\n",
		   a, b, c, d, ev, res, dotsize, flip, clamp)

		println("$params")

		strange(fn, flip, clamp, dotsize, res, Dict([:a=>a,:b=>b, :c=>c, :d=>d, :e=>ev]), color_profile)
		println("finished generating $fn")
	end
end

main()

