library(readxl)
library(lubridate)
library(tseries)
library(TSstudio)
library(tsibble)
library(forecast)
library(tidyverse)
library(magrittr)
library(zoo)

datos_parcial2 <- read_excel("datos_parcial2.xlsx", 
                             sheet = "serie1")

t <- datos_parcial2$valor %>% ts(., start = c(2021,1), frequency = 365)

diff(t)

auto.arima(t, trace=T)
Box.test(S1.m1$residuals,lag=10,type = "Ljung-Box", fitdf = 3)

win.graph()
par(mfrow=c(2,2))
acf(t)
pacf(t)
acf(diff(t))
pacf(diff(t))

2040-2021
