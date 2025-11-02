# --------------------------------------------------------------------------- #
function setDepArr(mapchar::Matrix{Char}, D::Tuple{Int64,Int64}, A::Tuple{Int64,Int64} )

    height,width = size(mapchar)
    while true
        D = (rand(1:height),rand(1:width))
        mapchar[D[1],D[2]]=='.' && break
    end
    mapchar[D[1],D[2]] = 'D'

    while true
        A = (rand(1:height),rand(1:width))
        mapchar[A[1],A[2]]=='.' && D!=A && break
    end
    mapchar[A[1],A[2]] = 'A'

    return D,A
end


# --------------------------------------------------------------------------- #
function intitializeDistances(mapchar::Matrix{Char})

    height,width = size(mapchar)
    mapDist::Matrix{Int64} = zeros(Int,height,width)

    return mapDist
end


# --------------------------------------------------------------------------- #
function distanceL1(
            N::Tuple{Int64,Int64}, 
            A::Tuple{Int64,Int64}
        )

    #@show N
    #@show A
    return abs(N[1]-A[1]) + abs(N[2]-A[2])
end


# --------------------------------------------------------------------------- #
function distanceL2(
            N::Tuple{Int64,Int64}, 
            A::Tuple{Int64,Int64}
        )

    #@show N
    #@show A
    return convert(Int, round(sqrt((N[1]-A[1])^2 + (N[2]-A[2])^2)))
end


# --------------------------------------------------------------------------- #
function nbStates(mapDist::Matrix{Int64})

    nbStates::Int64 = 0
    height,width = size(mapDist)  
    for i in 1:height
      for j in 1:width
        if mapDist[i,j] > 0
            nbStates+=1
        end
      end
    end
    return nbStates
end


# --------------------------------------------------------------------------- #
function propagate3!(mapchar::Matrix{Char}, 
                     P::Tuple{Int64,Int64}, 
                     N::Tuple{Int64,Int64}, 
                     mapDist::Matrix{Int64},
                     pending::BinaryMinHeap{Tuple{Int64, Tuple{Int64, Int64}}},
                     mapOrig::Matrix{Tuple{Int64,Int64}},
                     A::Tuple{Int64,Int64})

    height,width = size(mapchar)  
    coutMvmt::Int64 = 0

    if  ( (N[1] ≥ 1) && (N[1] ≤ height) &&  (N[2] ≥ 1) && (N[2] ≤ width) && (mapchar[N[1],N[2]] ∉ "X") )
        coutMvmt = 1
        heuristic = distanceL1(N,A)
        if (mapDist[N[1],N[2]] == 0) ||
           (mapDist[P[1],P[2]] + coutMvmt < mapDist[N[1],N[2]])
           mapDist[N[1],N[2]] = mapDist[P[1],P[2]] + coutMvmt
           mapOrig[N[1],N[2]] = P
           push!(pending,( mapDist[N[1],N[2]] + heuristic, N))
        end
    end

    return nothing   
end


# --------------------------------------------------------------------------- #
function AstarAlgorithm(   
            mapchar::Matrix{Char}, 
            D::Tuple{Int64,Int64}, 
            A::Tuple{Int64,Int64}, 
            mapDist::Matrix{Int64}
        )

    arrived::Bool = false
    pending = BinaryMinHeap{Tuple{Int64, Tuple{Int64, Int64}}}()
    push!(pending,(0,D))

    height,width = size(mapchar) 
    mapOrig::Matrix{Tuple{Int64,Int64}} = fill( (-1,-1), (height,width))

    while !isempty(pending) && !arrived 
        v,P = pop!(pending)
        arrived = P==A
        if !arrived
            # propagate to the North
            propagate3!(mapchar, P, (P[1]-1,P[2]), mapDist, pending, mapOrig, A)
            # propagate to the South
            propagate3!(mapchar, P, (P[1]+1,P[2]), mapDist, pending, mapOrig, A)
            # propagate to the West
            propagate3!(mapchar, P, (P[1],P[2]-1), mapDist, pending, mapOrig, A)
            # propagate to the East
            propagate3!(mapchar, P, (P[1],P[2]+1), mapDist, pending, mapOrig, A)
            #@show pending
        end
    end

    if arrived
        #@show mapOrig
        mapDist[D[1],D[2]] = -1

        #push!(cheminA,mapDist[P[1],P[2]])
        #@show A
        P = mapOrig[A[1],A[2]]; #push!(cheminA,mapDist[P[1],P[2]])
        mapchar[P[1],P[2]] = 'P'
        while P!=D
            #@show P
            P = mapOrig[P[1],P[2]]; #push!(cheminA,mapDist[P[1],P[2]])
            mapchar[P[1],P[2]] = 'P'
        end
        mapchar[P[1],P[2]] = 'D'
        #@show P
        return mapDist[A[1],A[2]]
    else
        return -1 # error: Arrival note reacheable
    end
end
