# strange_art
Luxor-inspired strange art in Julia

## Generate cool random strange art using Julia and [Lexor](https://github.com/JuliaGraphics/Luxor.jl)

This is a derivative work from the Luxor strange example. To run, first edit the makestrange.jl file and fiddle with the parameters. Then
run the program from the command line. The output is n files sequentially numbered along with a json control file that stores the parameters for the
generated image. Have fun!

```
$ julia makestrange.jl
````

You can edit the json file and regenerate an image using the `generate.jl` program:

```
$ julia ./generate.jl --help
usage: generate.jl [--infile INFILE] [--outfile OUTFILE] [-h]

optional arguments:
  --infile INFILE    parameter input filename (default: "params.json")
  --outfile OUTFILE  strange image output filename (default:
                     "regenerate.png")
  -h, --help         show this help message and exit

```


 -- rob


