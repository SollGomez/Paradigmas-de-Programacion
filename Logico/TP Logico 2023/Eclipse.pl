
% nombreCiudad, provincia, datos(hora(h,m), altura, duracion(m,s))
ciudad(arrecifes, buenosAires, datos(hora(17, 44), 2.5, duracion(0, 40))).
ciudad(bellaVista, sanJuan, datos(hora(17, 41), 11.5, duracion(2, 27))).
ciudad(carmenDeAreco, buenosAires, datos(hora(17, 44), 2.1, duracion(1, 30))).
ciudad(chacabuco, buenosAires, datos(hora(17, 43), 2.6, duracion(2, 7))).
ciudad(chepes, laRioja, datos(hora(17, 42), 8.9, duracion(2, 3))).
ciudad(ezeiza, buenosAires, datos(hora(17, 44), 0.9, duracion(1, 1))).
ciudad(jachal, sanJuan, datos(hora(17, 41), 11.1, duracion(1, 39))).
ciudad(pergamino, buenosAires, datos(hora(17, 44), 2.9, duracion(0, 56))).
ciudad(quines, sanLuis, datos(hora(17, 42), 7.8, duracion(2, 13))).
ciudad(rodeo, sanJuan, datos(hora(17, 41), 11.5, duracion(2, 16))).
ciudad(rioCuarto, cordoba, datos(hora(17, 42), 6.3, duracion(1, 54))).
ciudad(venadoTuerto, santaFe, datos(hora(17, 43), 4.1, duracion(2, 11))).
ciudad(merlo, sanLuis, datos(hora(17, 42), 7.1, duracion(2, 19))).


tieneServicio(telescopio, bellaVista).
tieneServicio(telescopio, chepes).
tieneServicio(telescopio, ezeiza).
tieneServicio(reposera, arrecifes).
tieneServicio(reposera, chepes).
tieneServicio(reposera, venadoTuerto).
tieneServicio(reposera, chacabuco).
tieneServicio(observatorio, quines).
tieneServicio(lentes, quines).
tieneServicio(lentes, rodeo).
tieneServicio(lentes, rioCuarto).
tieneServicio(lentes, merlo).


%% PUNTO 1
%% Tienen Buena Vista: Los lugares donde la altura del sol es más de 10º o empieza después de las 17:42.
tieneBuenaVista(Ciudad):-
    ciudad(Ciudad,_,datos(_,Altura,_)),
    Altura>10.
tieneBuenaVista(Ciudad):-
    ciudad(Ciudad,_,datos(Hora,_,_)),
    limiteHorario(Limite),
    esMayor(Hora,Limite).

limiteHorario(hora(17,42)).

esMayor(Duracion1,Duracion2):-
    convertirASegundos2(Duracion1, Resultado1),
    convertirASegundos2(Duracion2, Resultado2),
    Resultado1>Resultado2.

convertirASegundos2(hora(Min, Seg), Resultado):-
      Resultado is Min*60 + Seg.

%% PUNTO 2
%% Los lugares que no tienen ningún servicio.
noTieneServicio(Ciudad):-
    ciudad(Ciudad,_,_),
    not(tieneServicio(_,Ciudad)).


%% PUNTO 3
%% Provincias que tienen una sola ciudad para verlo
vistaEnSoloUnaCiudad(Provincia):-
    ciudad(_,Provincia,_),  
    not(vistaEnMuchasCiudades(Provincia)).

vistaEnMuchasCiudades(Provincia):-
    ciudad(Ciudad, Provincia,_),
    ciudad(OtraCiudad, Provincia,_),
    Ciudad\=OtraCiudad.


%% PUNTO 4
%% El lugar donde dura más.
dondeDureMas(Ciudad):-
    ciudad(Ciudad,_,datos(_,_,Duracion1)),
    forall(ciudad(OtraCiudad,_,datos(_,_,Duracion2)), esMayor(Duracion1,Duracion2)).


convertirASegundos(duracion(Min, Seg), Resultado):-
    Resultado is Min*60 + Seg.


%% PUNTO 5
%% La duración promedio del eclipse:en todo el pais,en cada provincia,en las ciudades con telescopio
duracionEnTodoElPais(Promedio):-
    findall(Resultado, (ciudad(Ciudad,_,datos(_,_,Duracion)), convertirASegundos(Duracion, Resultado)) , Lista), % Hace la lista con las duraciones en segundos
    promedioLista(Lista,Promedio).

duracionEnCadaProvincia(Provincia,Promedio):- 
    ciudad(_,Provincia,_),
    findall(Resultado, (ciudad(_, Provincia, datos(_,_,Duracion)), convertirASegundos(Duracion, Resultado)), Lista),
    promedioLista(Lista,Promedio).

duracionCiudadesConTelescopio(Promedio):- 
    findall(Resultado, (tieneServicio(telescopio,Ciudad), ciudad(Ciudad,_,datos(_,_,Duracion)), convertirASegundos(Duracion, Resultado)) , Lista),
    promedioLista(Lista,Promedio).

promedioLista(Lista, PromedioMin):- % Da promedio en Int
    sumlist(Lista, Suma),
    length(Lista, CantElementos),
    PromedioSeg is Suma div CantElementos,      
    convertirAMinutos(PromedioMin, PromedioSeg).

convertirAMinutos(resultado(Min, Seg), NumEnSegundos):-
    Min is NumEnSegundos div 60,
    Seg is NumEnSegundos mod 60.

/*
PUNTO 6
Analizar la inversibilidad de los predicados del item 2 y 5. Justificar.

2) noTieneServicio es inversible porque Ciudad te devuelve todas las ciudades que lo cumplen, ya que,
 al ligar la variable Ciudad, a pesar de que el not/1 no es inversible, puede comprobar si tiene o no un servicio.  
    
5) duracionEnTodoElPais y duracionCiudadesConTelescopio (item a y c) son inversibles ya que al preguntar por los promedios no es 
necesario ligar ni la ciudad ni la provincia y te puede devolver el promedio de todas las ciudades que lo cumplan. 

En cuanto a duracionEnCadaProvincia tamien es inversible ya que se puede consultar por cualquiera de los dos parametros.
Al igual que las anteriores te devuelve el promedio y al estar ligada la provincia (ciudad(_,Provincia,_)) puede
devolver el promedio de cada una de estas.
*/
