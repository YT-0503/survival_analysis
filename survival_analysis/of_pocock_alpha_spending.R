# Function to calculate the alpha-spending function for Pocock type
pocock_alpha_spending <- function(t, alpha){
    alpha * log(1 + (exp(1) - 1) * t)
} 

# Function to calculate the alpha-spending function for O'Brien-Fleming type
of_alpha_spending <- function(t, alpha){
    2 * (1 - pnorm(qnorm(alpha / 2, lower = FALSE) / sqrt(t)))
}

# Number of analyses
n_analyses <- 10001

# Overall alpha level
overall_alpha <- 0.02500

# Information times for each analysis
information_times <- seq(0, 1, by = 0.0001)

# Calculate alpha values for each analysis (O'Brien-Fleming)
of_alpha_values <- rep(0, n_analyses)
for (i in 1:n_analyses) {
    of_alpha_values[i] <- of_alpha_spending(information_times[i], overall_alpha)
}

# Calculate alpha values for each analysis (Pocock)
pocock_alpha_values <- rep(0, n_analyses)
for (i in 1:n_analyses) {
    pocock_alpha_values[i] <- pocock_alpha_spending(information_times[i], overall_alpha)
}

# Calculate alpha differences
of_alpha_differences <- c(of_alpha_values[1], diff(of_alpha_values))
pocock_alpha_differences <- c(pocock_alpha_values[1], diff(pocock_alpha_values))

# Display alpha values and differences for each analysis
for (i in 1:n_analyses){
    cat(sprintf("Analysis %d: Information Time = %.2f\n", i, information_times[i]))
    cat(sprintf(" O'Brien-Fleming Alpha = %.10f\n", of_alpha_values[i]))
    cat(sprintf(" Pocock Alpha = %.10f\n", pocock_alpha_values[i]))
    cat(sprintf(" O'Brien-Fleming Alpha Difference = %.10f\n", of_alpha_differences[i]))
    cat(sprintf(" Pocock Alpha Differences = %.10f\n", pocock_alpha_differences[i]))
}

library(ggplot2)

# Create a data frame for the results
of_results <- data.frame(
    Analysis = 1:n_analyses,
    Information_Time = information_times,
    Alpha = of_alpha_values,
    Difference = of_alpha_differences,
    Type = "O'Brien-Fleming"
)

pocock_results <- data.frame(
    Analysis = 1:n_analyses,
    Information_Time = information_times,
    Alpha = pocock_alpha_values,
    Difference = pocock_alpha_differences,
    Type = "Pocock"
)

# Combine the results data frames
results <- rbind(of_results, pocock_results)

# Plot the results using ggplot2
ggplot(results, aes(x = Information_Time, y = Alpha, color = Type, linetype = Type)) +
    #geom_point() +
    geom_line(linetype = "solid", lwd = 1.2) +
    #geom_text(aes(label = sprintf("%.5f", Alpha)), hjust = -0.2, vjust = 0.5) +
    labs(title = "Alpha Allocation in Each Analysis",
         x = "Information Time",
         y = "Cumulative Alpha") +
    theme_minimal() +
    theme(
        # axis
        plot.title = element_text(size = rel(1.5), face="bold"),
        axis.title = element_text(size=rel(1.5)),
        axis.text = element_text(size=rel(1.5))
    ) +
    scale_y_continuous(labels = scales::number_format(accuracy = 0.00001))
