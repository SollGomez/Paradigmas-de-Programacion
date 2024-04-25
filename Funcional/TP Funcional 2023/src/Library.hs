data Archivo = UnArchivo{
    nombre :: String,
    contenido :: String
}deriving(Show,Eq)

data Carpeta = UnaCarpeta{
    nombreCarpeta :: String,
    contenidoCarpeta :: [Archivo]
} deriving(Show,Eq)

data Commit = UnCommit{
    descripcion :: String,
    conjuntoCambios :: [Carpeta->Carpeta],
    commitAnterior:: Commit,
    esInicial :: Bool
 }


--ARCHIVO PRUEBA
ar1= UnArchivo "leeme.md" "HOLA MUNDO"
ar2=UnArchivo "hola prueba" "no se que tiene"
--CARPETA PRUEBA
carp1= UnaCarpeta "pdep" [ar1]


--CAMBIOS PRUEBA
cambio1 = crearArchivo "leeme.md"
cambio2 = crearArchivo "parcial.hs"
cambio8 = crearArchivo "holamundo"
cambio3 = agregarTexto "leeme.md" "Este es un TP"
cambio4 = eliminarArchivo "leeme.md"
cambio5 = vaciarCarpeta
cambio6 = sacarTexto "leeme.md"  1 3


--COMMIT PRUEBA
commit1 = UnCommit "incial" [cambio1, cambio3] commit1 True
commit2 =UnCommit "hola" [cambio2] commit1 False
commit3 =UnCommit "chau" [cambio6,cambio3] commit2 False 
-- commit4 =UnCommit "como" [cambio1,cambio3,cambio6]
-- commit5 =UnCommit "lima" [cambio2,cambio1,cambio8] --cuatro archivos
-- commit6 =UnCommit "sala" [cambio3,cambio5,cambio1]

br1= armarLista commit3

-- PUNTO 1.1
buscadorArchivos::String->Carpeta->Bool
buscadorArchivos nombrearchivo carpeta= any (esIgual nombrearchivo) (contenidoCarpeta carpeta)

-- PUNTO 1.2
realizarUnCambio :: Carpeta -> (Carpeta->Carpeta) -> Carpeta --Realiza un determinado cambio en una carpeta
realizarUnCambio carpeta f= f carpeta


-- PUNTO 2
--Efectua todos los cambios de un commit que se puedan realizar (los que no, deja la carpeta igual)
commitear :: Carpeta -> Commit -> Carpeta
commitear carpeta commit = foldl realizarUnCambio carpeta (conjuntoCambios commit)


-- PUNTO 3
-- Determinar si un commit es inutil para una carpeta, lo cual se deduce de que la carpeta quede igual que antes luego de "cometerlo".

esInutil :: Carpeta -> Commit -> Bool
esInutil carpeta commit = carpeta == commitear carpeta commit

-- PUNTO 4
-- Determinar si un commit que resulta inutil para una carpeta, dejaría de serlo si se realizaran sus cambios en la misma carpeta en orden inverso.
dejarSerInutil :: Commit -> Carpeta -> Bool
dejarSerInutil commit carpeta
    | not (esInutil carpeta commit) = error "no es inutil"
    | otherwise = commitear carpeta (commit{conjuntoCambios=reverse(conjuntoCambios commit)}) /= carpeta


--FUNCIONES PRINCIPALES
crearArchivo :: String-> Carpeta -> Carpeta
crearArchivo nombre carpeta
    | buscadorArchivos nombre carpeta = carpeta  -- error "ya existe la carpeta con ese nombre"
    | otherwise = carpeta {contenidoCarpeta = contenidoCarpeta carpeta ++ [UnArchivo nombre ""]}


eliminarArchivo ::  String->Carpeta-> Carpeta
eliminarArchivo nombre carpeta
    | not(buscadorArchivos nombre carpeta) = carpeta --error "no existe el archivo"
    | otherwise = carpeta {contenidoCarpeta = filter (esDistinto nombre) (contenidoCarpeta carpeta)}


vaciarCarpeta :: Carpeta-> Carpeta
vaciarCarpeta carpeta = carpeta {contenidoCarpeta = []}


agregarTexto ::  String -> String -> Carpeta -> Carpeta
agregarTexto  archbuscado texto carpeta
            | not(buscadorArchivos archbuscado carpeta) = error "no existe el archivo"
            | otherwise= carpeta {contenidoCarpeta =  map (funcionArchivoParaAgregar texto archbuscado) (contenidoCarpeta carpeta) }

funcionArchivoParaAgregar :: String->String-> Archivo -> Archivo
funcionArchivoParaAgregar  text nombrearc archivo
                 | esIgual nombrearc archivo = archivo {contenido = text ++ " " ++ contenido archivo}
                 |otherwise= archivo

sacarTexto :: String->Int->Int->Carpeta -> Carpeta
sacarTexto nombarchivo pos1 pos2 carpeta
     | not(buscadorArchivos nombarchivo carpeta) = error "no existe el archivo"
     | otherwise = carpeta {contenidoCarpeta = map (funcionArchivoParaSacar pos1 pos2 nombarchivo) (contenidoCarpeta carpeta) }

funcionArchivoParaSacar::Int->Int->String->Archivo->Archivo
funcionArchivoParaSacar pos1 pos2 nombarch archivo
    | esIgual nombarch  archivo = archivo {contenido = take pos1 (contenido archivo) ++ drop pos2 (contenido archivo)}
    | otherwise = archivo


--FUNCIONES AUX
esIgual :: String -> Archivo -> Bool
esIgual nombrearchi archivo = nombrearchi == nombre archivo

esDistinto::String->Archivo->Bool
esDistinto nombrearchi archivo = nombrearchi /= nombre archivo



---SEGUNDA PARTE
type Branch=[Commit]

armarBranch :: Commit -> Branch    -- Hace la Branch pero INVERSA
armarBranch (UnCommit _ _ _ True)= []
armarBranch commit = commit : armarBranch (commitAnterior commit)


-- PUNTO 5 (PARTE 2)
checkout :: Branch -> Carpeta -> Carpeta   -- Aplica los commits de la branch en la carpeta
checkout branch carpeta = foldl commitear carpeta (reverse branch)

-- PUNTO 2 (PARTE 2)
checkoutInverso :: Carpeta -> Commit -> Branch -> Carpeta   -- Hace el checkout en la INVERSA de una lista hasta el commit pedido
checkoutInverso carpeta commit lista = checkout (sublista (reverse lista) commit) carpeta

sublista :: Branch -> Commit -> [Commit]    -- Devuelve una lista de commits hasta el commit pedido
sublista [] _ = []  -- si es vacia devuelve una vacía
sublista (x:xs) comienzoLista
  | descripcion x == descripcion comienzoLista = [x]
  | otherwise = x : sublista xs comienzoLista                   

-- PUNTO 6 (PARTE 2)
log1 :: Archivo->Carpeta->Branch->[String]
log1 arch carp branch = map nombreCommits (logArchivo arch carp branch) 
     where
         nombreCommits (UnCommit desc _ _ _) = desc
         logArchivo arch carp branch = filter (afectaArchivo arch carp) branch
         afectaArchivo arch carpeta commit = not (compararArchivos (contenidoCarpeta (commitear carpeta commit)) arch)

compararArchivos :: [Archivo] -> Archivo -> Bool
compararArchivos (x:xs) arch
 | nombre arch == nombre x = arch == x
 | otherwise = compararArchivos xs arch

--PARTE 3
contenidoInfi::Archivo->String->Archivo
contenidoInfi archivo palabra= archivo{contenido= contenido archivo ++ cycle palabra}

carpetaInfi::Carpeta->Archivo->Carpeta
carpetaInfi carpeta archivo= carpeta{contenidoCarpeta= repeat archivo}
