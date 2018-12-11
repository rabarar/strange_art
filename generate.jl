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

# generate n png images

sp = JSON.parsefile("strange_01.json")

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

filename = "regen" * sp["filename"]

params = @sprintf("Params: a=%-2.16f, b=%-2.16f, c=%-2.16f, d=%-2.16f, e=%-2.16f, res=%-2.2d, dotsize = %-2.16f\n",
		  ctrl_params[:a],
		  ctrl_params[:b],
		  ctrl_params[:c],
		  ctrl_params[:d],
		  ctrl_params[:e],
		  res,
		  dot_size)
println("$params")

strange(filename, dot_size, res, ctrl_params, color_profile)
println("finished generating $filename")
