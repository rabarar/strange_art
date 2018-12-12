using Luxor, Colors
using Printf
using JSON
using ArgParse

include("strange.jl")

function parse_commandline()
    settings = ArgParseSettings()

    @add_arg_table settings begin
        "--infile"
            help = "parameter input filename"
            arg_type = String
            default = "params.json"
        "--outfile"
            help = "strange image output filename"
            default = "regenerate.png"
	"--n"
	    help = "generate n variations of random colors on input file"
	    default = 1
	    arg_type = Int
	"--red"
	    help = "red midpoint"
	    default = 1.0
	    arg_type = Float64
	"--blue"
	    help = "blue midpoint"
	    default = 1.0
	    arg_type = Float64
	"--green"
	    help = "green midpoint"
	    default = 1.0
	    arg_type = Float64
	"--redvar"
	    help = "red midpoint"
	    default = .50
	    arg_type = Float64
	"--bluevar"
	    help = "blue midpoint"
	    default = .50
	    arg_type = Float64
	"--greenvar"
	    help = "green midpoint"
	    default = .50
	    arg_type = Float64
    end

    return parse_args(settings)
end


# generate n png images

function main()
	parsed_args = parse_commandline()

	infile = parsed_args["infile"]
	outfile = parsed_args["outfile"]

	n = parsed_args["n"]

	red_range = parsed_args["red"]
	green_range = parsed_args["green"]
	blue_range = parsed_args["blue"]

	red_var = parsed_args["redvar"]
	green_var = parsed_args["greenvar"]
	blue_var = parsed_args["bluevar"]

	println("input ctrl file: $infile")

	sp = JSON.parsefile(infile)

	ctrl_params = Dict([
			    :a => sp["ctrl_params"]["a"],
			    :b => sp["ctrl_params"]["b"],
			    :c => sp["ctrl_params"]["c"],
			    :d => sp["ctrl_params"]["d"],
			    :e => sp["ctrl_params"]["e"]])

	dot_size = get(sp, "dot_size", .50)
	res = get(sp, "res", 1000)

	color_profile = Dict([
			      :r => sp["color_profile"]["r"],
			      :g => sp["color_profile"]["g"],
			      :b => sp["color_profile"]["b"]])
	flip = get(sp, "flip", false)
	clamp = get(sp, "clamp", false)

	params = @sprintf("Params: a=%-2.16f, b=%-2.16f, c=%-2.16f, d=%-2.16f, e=%-2.16f, res=%-2.2d, dotsize = %-2.16f flip = %d, clamp = %d\n",
			  ctrl_params[:a],
			  ctrl_params[:b],
			  ctrl_params[:c],
			  ctrl_params[:d],
			  ctrl_params[:e],
			  res,
			  dot_size,
			  flip,
			  clamp)
	println("$params")

	if n > 1

		# override clamp to generate variance
		if clamp == true
			println("*** Overriding clamp -> clamp is false to generate color variation across all three channels ***")
		end

		clamp = false
		for i in 1:n

			imagefile = @sprintf("%s_%-2.2d.png", outfile, i)
			jsonfile = @sprintf("%s_%-2.2d.json", outfile, i)

			println("outputfile: $imagefile")
			color_profile = Dict([
					      :r => red_range + rand()*rs()*red_range*red_var,
					      :g => green_range + rand()*rs()*green_range*green_var,
					      :b => blue_range + rand()*rs()*blue_range*blue_var
					     ])

			cf = open(jsonfile, "w")
                	sset = StrangeSet(ctrl_params, dot_size, res, color_profile, imagefile, flip, clamp)
                	JSON.print(cf, JSON.parse(JSON.json(sset)), 4)
                	close(cf)

			strange(imagefile, flip, clamp, dot_size, res, ctrl_params, color_profile)
		end
	else
		println("outputfile: $outfile")
		strange(outfile, flip, clamp, dot_size, res, ctrl_params, color_profile)
	end
	println("finished generating $outfile")
end

main()
