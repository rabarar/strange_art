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
    end

    return parse_args(settings)
end


struct StrangeSet
	ctrl_params::Dict{Symbol,Float64}
	dot_size::Float64
	res::Int64
	color_profile::Dict{Symbol,Float64}
	filename::String
end

# generate n png images

function main()
	parsed_args = parse_commandline()

	infile = parsed_args["infile"]
	outfile = parsed_args["outfile"]
	println("ctrl file: $infile")
	println("outputfile: $outfile")

	sp = JSON.parsefile(infile)

	ctrl_params = Dict([
			    :a => sp["ctrl_params"]["a"],
			    :b => sp["ctrl_params"]["b"],
			    :c => sp["ctrl_params"]["c"],
			    :d => sp["ctrl_params"]["d"],
			    :e => sp["ctrl_params"]["e"]])

	dot_size = sp["dot_size"]
	res = sp["res"]
	color_profile = Dict([
			      :r => sp["color_profile"]["r"],
			      :g => sp["color_profile"]["g"],
			      :b => sp["color_profile"]["b"]])
	flip = sp["flip"]

	params = @sprintf("Params: a=%-2.16f, b=%-2.16f, c=%-2.16f, d=%-2.16f, e=%-2.16f, res=%-2.2d, dotsize = %-2.16f flip=%d\n",
			  ctrl_params[:a],
			  ctrl_params[:b],
			  ctrl_params[:c],
			  ctrl_params[:d],
			  ctrl_params[:e],
			  res,
			  dot_size,
			  flip)
	println("$params")

	strange(outfile, flip, dot_size, res, ctrl_params, color_profile)
	println("finished generating $outfile")
end

main()
