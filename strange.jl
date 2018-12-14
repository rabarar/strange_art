#
# A Derivative mod of the Luxor.jl example strange(). See https://github.com/JuliaGraphics/Luxor.jl
# Rob Baruch, 2018
#

using Luxor, Colors, ProgressMeter

struct StrangeSet
	ctrl_params::Dict{Symbol,Float64}
	dot_size::Float64
	res::Int64
	color_profile::Dict{Symbol,Float64}
	filename::String
	flip::Bool
	cmode::String
end

struct CMode{s} end

function cmode_symbol(::CMode{s}) where s
	     (s ∈ [:rgb, :clamp, :grey, :gray] ? s : throw(error("wrong mode, $s")))

	     if s == :rgb
		     "rgb"
	     elseif s == :clamp
		     "clamp"
	     elseif s == :grey || s == :gray
		     "grey"
	     end
end

function cmode_string(mode) 
	if ! in(mode, ["rgb", "clamp", "grey", "gray"])
		throw(error("invalid mode string: $mode"))
	else
		if mode == "rgb"
			:rgb
		elseif mode == "clamp"
			:clamp
		elseif mode == "grey" || mode == "gray"
			:grey
		end
	end
end

function rs()
	(-1.0)^convert(Int64,floor((rand()*1000.0))) % 2
end

function strange(fn, flip, cmode, dotsize, w=800.0,
		 ctrl=Dict([:a=>2.24 + rs()*rand()*0.5, :b=>0.43, :c => -0.65, :d=>-2.43 + rs()*rand()*0.25, :e=> 1.0]),
		 colors=Dict([:r=>.7, :g=>0.5, :b=>.8]),
		 mode=:fill)
           xmin = -2.0; xmax = 2.0; ymin= -2.0; ymax = 2.0
	   Drawing(w, w, fn)
           origin()
           background("white")
           xinc = w/(xmax - xmin)
           yinc = w/(ymax - ymin)
           # control parameters
           x = y = z = 0.0
           wover2 = w/2
	   p = Progress(w*w, 1)
	   count = 0 

	   if flip
		f1 = cos
	   	f2 = sin
	   else
	   	f1 = sin
	   	f2 = cos
	   end

	   # crank...
           for j in 1:w
               for i in 1:w

		   count += 1
		   update!(p, count)

		   xx = f1(ctrl[:a] * y) - z  *  f2(ctrl[:b] * x)
		   yy = z * f1(ctrl[:c] * x) - f2(ctrl[:d] * y)
                   zz = ctrl[:e] * f1(x)
                   x = xx; y = yy; z = zz
                   if xx < xmax && xx > xmin && yy < ymax && yy > ymin
                       xpos = rescale(xx, xmin, xmax, -wover2, wover2) # scale to range
                       ypos = rescale(yy, ymin, ymax, -wover2, wover2) # scale to range

		       if cmode_string(cmode) == :rgb
			       rcolor = rescale(xx, -1, 1, 0.0, colors[:r])
			       gcolor = rescale(yy, -1, 1, 0.0, colors[:g])
			       bcolor = rescale(zz, -1, 1, 0.0, colors[:b])
			       setcolor(convert(Colors.HSV, Colors.RGB(rcolor, gcolor, bcolor)))
		       elseif cmode_string(cmode) == :clamp
			       rcolor = rescale(xx, -1, 1, 0.0, colors[:r])
			       gcolor = rescale(yy, -1, 1, 0.0, colors[:g])
			       setcolor(convert(Colors.HSV, Colors.RGB(rcolor, gcolor, gcolor)))
		       elseif cmode_string(cmode) == :grey 
			       rcolor = rescale(yy, -1, 1, 0.0, colors[:r])
			       setcolor(convert(Colors.HSV, Colors.RGB(rcolor, rcolor, rcolor)))
		       end
                       circle(Point(xpos, ypos), dotsize, mode)
                   end
               end
           end
	   println("cleaning up...")
           finish()
       end

