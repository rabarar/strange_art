# strange_art
Luxor-inspired strange art in Julia

![splash image](sample.jpg)

## Generate cool random strange art using Julia and [Lexor](https://github.com/JuliaGraphics/Luxor.jl)


This is a derivative work from the Luxor strange example. To run, first edit the makestrange.jl file and fiddle with the parameters. Then
run the program from the command line. The output is n files sequentially numbered along with a json control file that stores the parameters for the
generated image. Have fun!

```
$ julia ./makestrange.jl -h
usage: makestrange.jl [--basename BASENAME] [--a A] [--b B] [--c C]
                      [--d D] [--e E] [--n N] [--res RES] [--rc RC]
                      [--gc GC] [--bc BC] [--dot_max DOT_MAX]
                      [--dot_min DOT_MIN] [--flip FLIP] [-h]

optional arguments:
  --basename BASENAME  strange image and json basename (default:
                       "regenerate.png")
  --a A                a control point range (type: Float64, default:
                       5.0)
  --b B                b control point range (type: Float64, default:
                       10.0)
  --c C                c control point range (type: Float64, default:
                       5.0)
  --d D                d control point range (type: Float64, default:
                       10.0)
  --e E                e control point range (type: Float64, default:
                       5.0)
  --n N                number of images to generate (type: Int64,
                       default: 1)
  --res RES            image w x w res (type: Int64, default: 1000)
  --rc RC              rgb r  color weight (type: Float64, default:
                       2.13)
  --gc GC              rgb g color weight (type: Float64, default:
                       0.13)
  --bc BC              rgb b color weight (type: Float64, default:
                       2.83)
  --dot_max DOT_MAX    max dotsize (type: Float64, default: 0.65)
  --dot_min DOT_MIN    min dotsize (type: Float64, default: 0.35)
  --flip FLIP          flip sin and cos in the calculations (type:
                       Bool, default: false)
  -h, --help           show this help message and exit


````

You can edit the json file and regenerate an image using the `generate.jl` program. If `--n` is greater than one, you can generate new json control files that randomize colors with the given ranges and random variance.

```
$ julia ./generate.jl -h
usage: generate.jl [--infile INFILE] [--outfile OUTFILE] [--n N]
                   [--red RED] [--blue BLUE] [--green GREEN]
                   [--redvar REDVAR] [--bluevar BLUEVAR]
                   [--greenvar GREENVAR] [-h]

optional arguments:
  --infile INFILE      parameter input filename (default:
                       "params.json")
  --outfile OUTFILE    strange image output filename (default:
                       "regenerate.png")
  --n N                generate n variations of random colors on input
                       file (type: Int64, default: 1)
  --red RED            red midpoint (type: Float64, default: 1.0)
  --blue BLUE          blue midpoint (type: Float64, default: 1.0)
  --green GREEN        green midpoint (type: Float64, default: 1.0)
  --redvar REDVAR      red midpoint (type: Float64, default: 0.5)
  --bluevar BLUEVAR    blue midpoint (type: Float64, default: 0.5)
  --greenvar GREENVAR  green midpoint (type: Float64, default: 0.5)
  -h, --help           show this help message and exit


```


 -- rob


