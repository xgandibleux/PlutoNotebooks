# --------------------------------------------------------------------------- #
function loadMap(fname::String)

    f = open(fname)

    # Read the first lines
    line = readline(f)      # line 1: keyword "type" and the corresponding value for the map

    line = readline(f)      # line 2: keyword "height" and the corresponding value for the map
    keyword, value = split(line)
    height = parse(Int,value)

    line = readline(f)      # line 3: keyword "width" and the corresponding value for the map
    keyword, value = split(line)
    width = parse(Int,value)

    line = readline(f)      # line 4: keyword "map" followed by the description of the map
    println("Map of size: \n height: ",height,"\n width : ",width )

    mapchar = Matrix{Char}(undef,height,width)

    #= The map data is stored as a grid of characters.
       The following characters are possible in a given map:
         . - passable terrain                                   => usable position
         x - wall                                               => unusable position
    =#

    # Read the 'heigth' lines describing the map
    for i=1:height
      mapchar[i,:] = collect(readline(f))
    end

    close(f)
    return mapchar

end
