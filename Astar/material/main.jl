# ============================================================================ #
# Introduction
println("Pathfind"); println("")

# ============================================================================ #
# Package used
println("Setting the required packages..."); println("")
using Printf, Random
using DataStructures
using PyPlot

# ============================================================================ #
# Parts of the app to include
include("parser.jl")
include("plotRun.jl")
include("algorithms.jl")

# ============================================================================ #
# Entry point

# Loading an instance -------------------------------------------------------- #
path = "../dat/"
fnames = "plateau20x20.map"

println("\nInstance: \n ",fnames)
mapCharInitial = loadMap(path*fnames)
mapchar = copy(mapCharInitial)

# Set a departure and an arrival -------------------------------------------- #
#D,A = setDepArr(mapchar,D,A)
D = (6,10); A = (9,16)

println("Scenario:")
println(" D: ",D)
println(" A: ",A,"\n")

#cheminD =[]; cheminA =[]

println("\n====================================================================")

# Astar algorithm ----------------------------------------------------------- # 
println("Astar Algorithm")
mapchar = copy(mapCharInitial)

mapchar[D[1],D[2]] = 'D'
mapchar[A[1],A[2]] = 'A'

mapDist = intitializeDistances(mapchar)
distance3 = AstarAlgorithm(mapchar, D, A, mapDist)
if distance3 == -1
    println("Failure: arrival point not reachable")
else
    showMapGraphic(mapchar, "Astar", fnames)

    println("\nDistance D → A            : $distance3")
    println("Number of states evaluated: ",nbStates(mapDist))
end

#=
cheminD = reverse(cheminD)
cheminA = reverse(cheminA)
for i in 1:length(cheminD)
    print(i, " ", cheminD[i], " ", cheminA[i], " ")
    if cheminD[i] == cheminA[i]
        println(" ")
    else
        println(" <<< faux ")
    end
end
=#

# --------------------------------------------------------------------------- #
println("\nthat's all folk")
