# Identificación, diagnóstico y pronóstico de modelos ARIMA en Python

**EN** — Box-Jenkins workflow applied to three daily time series in Python: ACF/PACF identification, Augmented Dickey-Fuller tests, model selection by AIC/BIC, stationarity and invertibility checks, residual diagnostics (Ljung-Box, Jarque-Bera, Shapiro-Wilk) and 5-step-ahead forecasts. The selected models were ARIMA(3,1,0), ARIMA(3,1,0) and ARIMA(0,1,4).

**ES** — Aplicación de la metodología Box-Jenkins a tres series de tiempo diarias en Python: identificación con ACF/PACF, prueba de Dickey-Fuller aumentada, selección de modelos por AIC/BIC, verificación de estacionariedad e invertibilidad, diagnóstico de residuales (Ljung-Box, Jarque-Bera, Shapiro-Wilk) y pronóstico de 5 valores futuros. Los modelos elegidos fueron ARIMA(3,1,0), ARIMA(3,1,0) y ARIMA(0,1,4).

## Objetivo

Para cada una de tres series de tiempo, identificar los órdenes (p, d, q) de un modelo ARIMA, seleccionar el mejor modelo con criterios de información, validar sus supuestos y producir pronósticos de corto plazo.

### Enunciado

Considere las tres series de tiempo de las hojas del archivo `datos_parcial2.xlsx`. Para cada una, en Python:

1. Realice los gráficos ACF y PACF para identificar los órdenes p, d y q del modelo ARIMA(p, d, q).
2. Aplique la prueba de Dickey-Fuller para decidir si es necesario diferenciar (valor de d).
3. Si d ≥ 1, repita los gráficos ACF y PACF sobre la serie diferenciada para identificar p y q.
4. Ajuste varios modelos y use un criterio de selección (AIC, BIC) para elegir el "mejor".
5. Verifique si el modelo elegido es estacionario e invertible (raíces de los polinomios con `abs` y `np.roots`).
6. Verifique la autocorrelación de los residuales con el ACF y la prueba de Ljung-Box (h = 10).
7. Verifique la normalidad de los residuales.
8. Si todo lo anterior se cumple, pronostique los 5 valores futuros.

En cada punto se piden conclusiones argumentadas.

## Datos

`datos_parcial2.xlsx` (incluido en el repositorio), suministrado por el curso, sin unidades ni descripción de la variable:

| Hoja | Variables | Observaciones | Periodo (diario) |
|---|---|---|---|
| `serie1` | `fecha`, `valor` | 231 | 2021-01-01 a 2021-08-19 |
| `serie2` | `fecha`, `value` | 521 | 2020-01-01 a 2021-06-04 |
| `serie3` | `fecha`, `registro` | 837 | 2019-01-01 a 2021-04-16 (viene desordenada; se ordena por fecha) |

## Métodos

- Exploración: estadísticos descriptivos, histogramas y gráficos de la serie.
- Identificación: ACF y PACF de la serie original y de la diferenciada.
- Estacionariedad: prueba de Dickey-Fuller aumentada (`adfuller`) antes y después de diferenciar.
- Estimación: `statsmodels.tsa.arima.model.ARIMA` para varios candidatos por serie; selección por AIC y BIC, priorizando parámetros significativos cuando ambos criterios no coinciden.
- Validación: raíces de los polinomios AR y MA fuera del círculo unitario; ACF de residuales y prueba de Ljung-Box (10 rezagos); normalidad con Q-Q plot, Jarque-Bera y Shapiro-Wilk.
- Pronóstico: 5 pasos adelante con intervalos de confianza del 95 %.
- `parcial2.R` contiene una verificación exploratoria en R con `forecast::auto.arima`.

## Resultados principales

| Serie | ADF (nivel), p-valor | Modelo elegido | AIC | BIC | Diagnóstico de residuales |
|---|---|---|---|---|---|
| 1 | 0,848 | ARIMA(3,1,0) | 657,72 | 671,48 | Ljung-Box sin autocorrelación; Jarque-Bera p = 0,468 |
| 2 | 0,941 | ARIMA(3,1,0) | 1469,45 | 1486,47 | Ljung-Box p > 0,86 en los 10 rezagos |
| 3 | 0,521 | ARIMA(0,1,4) | 2364,71 | 2388,36 | Ljung-Box p > 0,60 en los 10 rezagos; Shapiro-Wilk p = 0,087 |

- Las tres series requirieron una diferencia (d = 1). En la serie 1, la serie diferenciada rechaza la raíz unitaria (p ≈ 1,3 × 10⁻⁹).
- Los polinomios AR de las series 1 y 2 tienen todas sus raíces con módulo mayor que 1, de modo que los modelos son estacionarios.
- Serie 2: con intercepto, el AIC baja a 1467,19, pero el BIC favorece el modelo sin intercepto, que fue el elegido.
- Serie 3: el menor AIC fue ARIMA(3,1,8) y el menor BIC ARIMA(3,1,4), ambos con parámetros no significativos. ARIMA(5,1,1) tenía parámetros significativos, pero sus residuales mostraron autocorrelación según Ljung-Box. El modelo final fue ARIMA(0,1,4).
- Los pronósticos a 5 pasos muestran intervalos que se amplían con el horizonte.

## Estructura del repositorio

```
.
├── Parcial2_series_tiempo.ipynb   # Notebook principal con la solución completa
├── Parcial2_series_tiempo.html    # Notebook exportado a HTML
├── Parcial2_series_tiempo.pdf     # Notebook exportado a PDF
├── datos_parcial2.xlsx            # Datos: hojas serie1, serie2 y serie3
├── parcial2.R                     # Verificación exploratoria en R (auto.arima, Ljung-Box, Jarque-Bera)
├── Dickey_Fuller.png, ljung_Box.png, S3_m13_summary.png, S3_m16_summary.png  # Figuras usadas en el notebook
├── Clase_10_python.ipynb, PRESENTACION 13.ipynb, PRESENTACION 14.ipynb       # Notebooks de clase de referencia
├── Presentacion_11.pdf, Presentacion_12.pdf                                  # Diapositivas del curso
└── parcial2_TimeSeries.zip        # Copia comprimida de la entrega (html, ipynb y pdf)
```

## Cómo reproducir

- Python 3.10 (versión registrada en el notebook), con Jupyter.
- Paquetes: `pandas`, `numpy`, `matplotlib`, `seaborn`, `statsmodels`, `scipy`, `pmdarima`, `openpyxl` (para leer el Excel) e `ipython`.
- El notebook usa el estilo `seaborn-white` de matplotlib, que se retiró en matplotlib 3.8. Use una versión anterior o cámbielo por `seaborn-v0_8-white`.

```bash
pip install pandas numpy matplotlib seaborn statsmodels scipy pmdarima openpyxl jupyter
jupyter notebook Parcial2_series_tiempo.ipynb
```

El notebook lee `datos_parcial2.xlsx` desde la raíz del repositorio. Para `parcial2.R` se necesitan `readxl`, `lubridate`, `tseries`, `TSstudio`, `tsibble`, `forecast`, `tidyverse`, `magrittr`, `zoo`, `lmtest` y `car`.

## Contexto y autoría

Segundo examen parcial del curso Series de Tiempo Univariadas, Escuela de Estadística, Facultad de Ciencias, Universidad Nacional de Colombia, sede Medellín (2022). Profesor: Mauricio Alejandro Mazo Lopera (autor del material de clase incluido).

Autores: Kaline Andrea Rios Castro y Daniel Felipe Villa Rengifo.
