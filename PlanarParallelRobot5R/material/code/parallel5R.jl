# code d'origine : https://github.com/ddelago/5-Bar-Parallel-Robot-Kinematics-Simulation/

using Plots
using Printf

# Define constants
l0 = 4.05    # Length between origin and the two motors
l1 = 8.05    # Length from motor to passive joints
l2 = 12.05   # Length from passive joints to end effector

# Function to calculate shoulder angles
function calc_angles(x, y)
    # Angle from left shoulder to end effector
    β₁ = atan(y, (l0 + x))  

    # Angle from right shoulder to end effector
    β₂ = atan(y, (l0 - x))

    # Alpha angle pre-calculations
    α₁_calc = (l1^2 + ((l0 + x)^2 + y^2) - l2^2) / (2 * l1 * sqrt((l0 + x)^2 + y^2)) 
    α₂_calc = (l1^2 + ((l0 - x)^2 + y^2) - l2^2) / (2 * l1 * sqrt((l0 - x)^2 + y^2))

    # If calculations > 1, will fail acos function
    if α₁_calc > 1 || α₂_calc > 1
        println("Coordonnees non-atteignables")
        return nothing
    end

    # Angles of left shoulder - β₁ and right shoulder - β₂
    α₁ = acos(α₁_calc)
    α₂ = acos(α₂_calc)

    # Calculate shoulder angles
    shoulder1 = β₁ + α₁
    shoulder2 = π - β₂ - α₂

    return shoulder1, shoulder2
end

# Fonction qui trace les bras du robot
function plot_arms(shoulder1, shoulder2, efx, efy)
    # Passive joints (x, y) location
    p1 = (-l0 + l1 * cos(shoulder1), l1 * sin(shoulder1))
    p2 = (l0 + l1 * cos(shoulder2), l1 * sin(shoulder2))

    # Bras gauche
    plot!([-l0, p1[1], efx], [0, p1[2], efy], label = "", color = :blue, marker = :circle)
    #plot!([-l0, p1[1], efx], [0, p1[2], efy], seriestype = :path, label = "", color = :blue, marker = :circle)
    #annotate!([-l0 + 0.3, 0 + 0.3], text(string(@sprintf("%.2f degrees", rad2deg(shoulder1))), :left))

    # Bras droit
    plot!([l0, p2[1], efx], [0, p2[2], efy], label = "", color = :blue, marker = :circle)
    #plot!([l0, p2[1], efx], [0, p2[2], efy], seriestype = :path, label = "", color = :blue, marker = :circle)
    #annotate!([l0 + 0.3, 0 + 0.3], text(string(@sprintf("%.2f degrees", rad2deg(shoulder2))), :left))

    # Extremite du robot
    scatter!([efx], [efy], color = :red, label = "")
    #annotate!([efx + 0.3, efy + 0.3], text(string(@sprintf("(%.2f, %.2f)", efx, efy)), :left))
end

# Fonction qui trace le robot dans une configuration specifique
function plot_robot(efx, efy)
    # Initialise le plot
    plot(xlims = (-15, 15), ylims = (-5, 20), aspect_ratio = :equal, title = "Robot parallèle 5R")
    scatter!([-l0, l0], [0, 0], color = :blue, label = "")

    s1, s2 = calc_angles(efx, efy)
    if s1 !== nothing && s2 !== nothing
        plot_arms(s1, s2, efx, efy)
    end
    display(current())
    sleep(0.05)
end

# Boucle d'animation du robot
function main()
    for i in -5:5
        plot_robot(i, 10)
    end
    for j in 10:15
        plot_robot(5, j)
    end
    for k in 5:-1:-5
        plot_robot(k, 15)
    end
    for l in 15:-1:10
        plot_robot(-5, l)
    end
end

# point d'entree principal
main()