library(readxl)
library(lubridate)
library(tseries)
library(TSstudio)
library(tsibble)
library(forecast)
library(tidyverse)
library(magrittr)
library(zoo)

df1 <- read_excel("datos_parcial2.xlsx", 
                             sheet = "serie1")

t <- df1$valor %>% ts(., start = c(2021,1), frequency = 365)

diff(t)

auto.arima(t, trace=T)
Box.test(S1.m1$residuals,lag=10,type = "Ljung-Box", fitdf = 3)

win.graph()
par(mfrow=c(2,2))
acf(t)
pacf(t)
acf(diff(t))
pacf(diff(t))

df2 <- read_excel("datos_parcial2.xlsx", 
                  sheet = "serie2")

df3 <- read_excel("datos_parcial2.xlsx", 
                  sheet = "serie3")


df3 <- df3[order(df3$fecha, decreasing = F),]

df3 %>%  summary()

t2 <- ts(df2$value,start = c(2020,1), frequency = 365)

t3 <- ts(df3$registro,start = c(2019,1), frequency = 365)

dt3 <- t3 %>% diff()

m2 <- auto.arima(t2)

dm3 <- auto.arima(dt3, max.p = 3)

require(lmtest)
dwtest(dm3)

require(car)



par(mfrow=c(1,2))
acf(dt3)
pacf(dt3)

plot(dm3)
plot(m2)

checkresiduals(dm3)

summary(dm3)

res <- residuals(naive(dm3$residuals))

Box.test(dm3$residuals, lag = 10, fitdf = T)

gridExtra::grid.arrange(ggAcf(res),ggAcf(dm3$residuals),ncol=2)


polyroot(c(1,-0.9761,0.2952,-0.4563,0.6435,-0.2057)) %>% abs()

jarque.bera.test(m2$residuals)


auto.arima(dt3)

