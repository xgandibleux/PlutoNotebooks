# --------------------------------------------------------------------------- #
function showMapGraphic(mapchar::Matrix{Char}, algorithm::String, fname::String)

  height,width = size(mapchar)

  # color codes of pixels appearing in the map
  noir  = [0,     0,   0]
  brun  = [128,   0,   0]
  blanc = [255, 255, 255]
  jaune = [255, 255, 0]
  vert  = [  0, 255,   0]
  rouge = [255,   0,   0]
  bleu  = [0,     0, 255]
  olive = [128, 128,   0]
 
 
  carte = fill(blanc,height,width)

  for i in 1:height
    for j in 1:width
      if      (mapchar[i,j]=='X')
        carte[i,j] = noir # wall (no passage)
      elseif  (mapchar[i,j]=='D')
        carte[i,j] = vert # Departure 
      elseif  (mapchar[i,j]=='A')
        carte[i,j] = rouge # Arrival 
      elseif  (mapchar[i,j]=='P')
        carte[i,j] = jaune  # path                                               
      end
    end
  end

  # Commands for drawing the figure ----------------------------------------- #
  figure(algorithm, figsize=(6,6))
  xticks([]);  yticks([])
  imshow(carte)
  #  imshow(A,extent=[0,20, 0,20])

  title(fname) # * " | " * "\$z_{Opt}=  $nbStates\$")

  if height > 40 || width > 40
    # no value diplayed on the graphic map
  else
    for i in 1:height
      for j in 1:width
          if mapDist[i,j] > 0
              text(j-1,i-1,mapDist[i,j],va="center", ha="center", color="gray", size="x-small")
          elseif mapDist[i,j] == -1
              text(j-1,i-1,"0",va="center", ha="center", color="gray", size="x-small") 
          else
              text(j-1,i-1,".",va="center", ha="center", color="gray", size="x-small")           
          end 
      end
    end
  end

  return nothing

end
