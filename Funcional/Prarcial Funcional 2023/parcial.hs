data Personaje = UnPersonaje {
    nombre :: String,
    dinero :: Int,
    felicidad :: Int
} deriving (Show, Eq)

--resta 20 a la felicidad, salvo que sea lisa, en cuyo caso aumenta la felicidad en igual cantidad.
irAEscuela :: Personaje -> Personaje
irAEscuela personaje
    | personaje == lisa = aumentarFelicidad 20 personaje
    | otherwise = aumentarFelicidad (-20) personaje

aumentarFelicidad :: Int -> Personaje -> Personaje
aumentarFelicidad num personaje = personaje { felicidad = verificar (felicidad personaje + num) }

verificar :: Int -> Int
verificar num
    | num >= 0 = num
    | otherwise = 0

-- se le suma 10 de felicidad por cada dona comida y se le resta $10.
comerDonas :: Int -> Actividad
comerDonas num = aumentarFelicidad (10*num) . sumarDinero (-10)

sumarDinero :: Int -> Actividad
sumarDinero num personaje = personaje { dinero = dinero personaje + num }

-- gana una cantidad de dinero según cantidad de caracteres
irAlTrabajo :: String -> Actividad
irAlTrabajo trabajo = sumarDinero (length trabajo)

-- ira a trabajar a "escuela elemental" y restar 20 de felicidad (como todo el que va a dicha escuela) 
trabajarDirector :: Actividad
trabajarDirector = irAlTrabajo "escuela elemental" . irAEscuela

--Inventado: implica comer 1 dona en el trabajo de la persona
comerEnTrabajo :: String -> Actividad
comerEnTrabajo lugar = irAlTrabajo lugar . comerDonas 1

type Actividad = (Personaje -> Personaje)
hacerVarias :: Actividad -> Actividad -> Personaje -> Personaje
hacerVarias actv1 actv2 = actv1 . actv2


homero, skinner, lisa, srBurns, bart :: Personaje
homero = UnPersonaje "Homero" 100 75
skinner = UnPersonaje "skinner" 5 30
lisa = UnPersonaje "lisa" 25 50
srBurns =  UnPersonaje "Sr. Burns" 300 0
bart = UnPersonaje "Bartolomeo" 6 100

{- 
EJEMPLOS: 
homero come una docena de donas:  
*Main> comerDonas 12 homero
UnPersonaje {nombre = "Homero", dinero = 90, felicidad = 195}

skinner va a trabajar como director: 
*Main> trabajarDirector skinner
UnPersonaje {nombre = "skinner", dinero = 22, felicidad = 10}

lisa va a la escuela y luego realiza la actividad inventada:
*Main> hacerVarias irAEscuela (comerEnTrabajo "asilo de ancianos") lisa
UnPersonaje {nombre = "lisa", dinero = 52, felicidad = 80}
 -}


 -- LOGROS
type Logro = Personaje -> Bool
-- Ser millonario: lo alcanza  si tiene más dinero que el Sr. Burns 
millonario :: Logro
millonario personaje = (>) (dinero personaje) (dinero srBurns)

-- Alegrarse: dado un nivel de felicidad deseado, lo alcanza si su propia felicidad lo supera.
alegrarse :: Int -> Logro
alegrarse num (UnPersonaje _ _ f ) = (<) num f

-- Ir a ver el programa de Krosti: lo  alcanza si tiene al menos $10
verKrosti :: Logro
verKrosti (UnPersonaje _ d _ ) = (>=) d 10

-- Inventada: lo alcanza si su felicidad es mayor a 100
serFeliz :: Logro
serFeliz (UnPersonaje _ _ f) = f > 100

variasActividades :: [Actividad]
variasActividades = [irAlTrabajo "mafia", comerDonas 2, irAEscuela]

-- PUNTO 2.A
esDecisiva :: Personaje -> Logro -> Actividad -> Bool
esDecisiva persona logro actv
    | logro persona = False
    | otherwise =  logro (actv persona)

-- PUNTO 2.B
primeraDecisiva :: Personaje -> Logro -> [Actividad] -> Personaje
primeraDecisiva personaje _ [] = personaje
primeraDecisiva personaje logro lista
    | null (listaDecisivas  personaje logro lista) = personaje
    | otherwise = head (listaDecisivas personaje logro lista) personaje

listaDecisivas :: Personaje -> Logro -> [Actividad] -> [Actividad]
listaDecisivas persona logro = filter (esDecisiva persona logro)

-- PUNTO 2.C
actividadesInfinitas :: [Actividad]
actividadesInfinitas = cycle variasActividades

{- 
*Main> primeraDecisiva lisa (alegrarse 60) actividadesInfinitas
UnPersonaje {nombre = "lisa", dinero = 15, felicidad = 70}

Como solo necesita aplicar la primer avtividad de la listaDecisivas (solo las decisivas de la lista infinita),
al encontrar la primera que cumple la aplica. Por lazy evaluation no necesita saber todas las que son decisivas,
con la primera alcanza


*Main> primeraDecisiva lisa millonario actividadesInfinitas
Interrupted.
En este ejemplo lazy evaluation no influye porque en la lista infinita no encuentra ninguna actividad que cumpla,
por eso nunca aplica la primera y no da respuesta.
 -}
