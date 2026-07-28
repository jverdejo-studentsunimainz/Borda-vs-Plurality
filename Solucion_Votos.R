# 1. Instalar el paquete de votaciones (se descarga de internet)
install.packages("vote")

# 2. Activar el paquete para poder usarlo
library(vote)

# 3. Cargar tus datos (ahora sí los encontrará a la primera)
load("rankings.RData")


# 1. Ver los nombres de las "cajas" que hay dentro de tu lista
names(ranking.list)

# 2. Ver la estructura interna (te dice qué tipo de datos tiene)
str(ranking.list)

# 3. Echar un vistazo rápido a los primeros datos en la consola
head(ranking.list)



# PASO 1: Sacar los datos de España a una tabla limpia
datos_espana <- ranking.list$Spain_2008

# Cotillea la tabla para asegurarte de que ves los partidos y las notas
View(datos_espana)

# PASO 2: Convertir las notas (1-10) en un ranking (1º, 2º, 3º...)
# El signo menos (-) hace que la nota más alta (un 10) se convierta en el puesto número 1
rankings_borda <- t(apply(-datos_espana, 1, rank, ties.method = "random"))

# PASO 3: Aplicar el Método de Borda usando la función correcta ("score")
resultado_borda <- score(rankings_borda)

# PASO 4: Ver los resultados en la consola
summary(resultado_borda)

load("cses3.RData")

# PASO 1: Extraer a qué partido puso cada persona en el puesto número 1
puesto_uno <- apply(rankings_borda, 1, function(x) which(x == 1)[1])
partidos_ganadores <- colnames(rankings_borda)[puesto_uno]

# PASO 2: Contar cuántos votos absolutos se lleva cada partido
tabla_votos <- table(partidos_ganadores)

# PASO 3: Convertir esos votos en porcentajes (multiplicado por 100)
porcentajes_pluralidad <- prop.table(tabla_votos) * 100

# PASO 4: Ver el resultado final ordenado de mayor a menor
sort(porcentajes_pluralidad, decreasing = TRUE)

head(datos_espana, n = 3)

# 1. Creamos los rankings CORRECTOS (sin el signo menos)
rankings_borda_buenos <- t(apply(datos_espana, 1, rank, ties.method = "random"))

# 2. Extraemos quién es el verdadero puesto número 1 para cada ciudadano
puesto_uno_real <- apply(rankings_borda_buenos, 1, function(x) which(x == 1)[1])
partidos_ganadores_reales <- colnames(rankings_borda_buenos)[puesto_uno_real]

# 3. Contamos los votos y los convertimos en porcentajes
tabla_votos_reales <- table(partidos_ganadores_reales)
porcentajes_reales <- prop.table(tabla_votos_reales) * 100

# 4. Vemos el resultado definitivo ordenado
sort(porcentajes_reales, decreasing = TRUE)
