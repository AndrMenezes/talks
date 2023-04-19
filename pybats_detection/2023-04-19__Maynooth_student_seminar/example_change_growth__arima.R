library(cowplot)
library(ggplot2)
theme_set(
  theme_cowplot(font_size = 20, font_family = "Palatino") +
    background_grid() +
    theme(text = element_text(size = 20, family = "Palatino"),
          legend.position = "top")
)

blue <- rgb(32, 114, 184, maxColorValue = 255)
red <- rgb(237,0,0, maxColorValue = 255)

# Simulating
set.seed(6669)
y <- c(rnorm(40, mean = 100, sd = 0.5),
       # rnorm(40, mean = 90, sd = 0.5),
       0.5 * 1:30 + rnorm(30, mean = 100, sd = 0.3))
plot(y)
data_sim <- data.frame(t = seq_along(y), y = y)

# Fitting
t_ini <- 5
t_end <- length(y)
fcast <- numeric(t_end)
fcast_ci_lower <- numeric(t_end)
fcast_ci_upper <- numeric(t_end)
for (t in t_ini:(t_end - 1)) {
  y_cur <- y[1:t]
  fit_arima <- arima(x = y_cur, order = c(0, 2, 2))
  tmp <- predict(fit_arima, n.ahead = 1)
  fcast[t + 1] <- tmp$pred[1L]
  fcast_ci_lower[t + 1] <- tmp$pred[1L] - 1.96 * sqrt(tmp$se[1L])
  fcast_ci_upper[t + 1] <- tmp$pred[1L] + 1.96 * sqrt(tmp$se[1L])
}
data_sim$fcast_arima <- fcast
data_sim$ci_lower <- fcast_ci_lower
data_sim$ci_upper <- fcast_ci_upper
ggplot(data = dplyr::filter(data_sim, t > 5), aes(x = t, y = y)) +
  geom_point() +
  geom_point(aes(y = fcast_arima), col = blue, size = 2) +
  geom_line(aes(y = fcast_arima), col = blue, size = 1) +
  geom_ribbon(aes(ymin = ci_lower, ymax = ci_upper),
              alpha = 0.2) +
  geom_vline(xintercept = c(40, 80), linetype = "dotted") +
  scale_y_continuous(breaks = scales::pretty_breaks(8)) +
  scale_x_continuous(breaks = scales::pretty_breaks(10))


library(RBATS)
mod <- dlm(polynomial_order = 2,
           discount_factors = list(polynomial = 0.95))
fitted_mod <- fit(object = mod, y = y, a0 = c(100, 0), R0 = diag(100, 2))
plot(fitted_mod)
fitted_mod$data_predictive$y <- y
ggplot(data = dplyr::filter(fitted_mod$data_predictive, t > 5),
       aes(x = t, y = y)) +
  geom_point() +
  geom_point(aes(y = mean), col = blue, size = 2) +
  geom_line(aes(y = mean), col = blue, size = 1) +
  geom_ribbon(aes(ymin = ci_lower, ymax = ci_upper),
              alpha = 0.2) +
  geom_vline(xintercept = c(40, 80), linetype = "dotted") +
  scale_y_continuous(breaks = scales::pretty_breaks(8)) +
  scale_x_continuous(breaks = scales::pretty_breaks(10))
