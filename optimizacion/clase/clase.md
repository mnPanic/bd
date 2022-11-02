# Clase

nested loop join  (todos contra todos, n^2)
merge como están ordenadas las dos tablas las recorre (o(n))

indice non clustered: como el del libro, desordenado
indice clustered: ordenado igual que la tabla

seek: ir a buscar uno particular
scan: recorrer todas

4 integridad referencial

5

index seek: busca en el índice
key lookup: busca la row en base al índice
loop porque lo puede hacer más de una vez

por qué en uno hace eso y en el otro va en el clustered?

es un plomo ir cada vez al índice si aparece muchas veces, es más rápido ir directo al índice y barrer toda la tabla

