
% nuevoEpisodio(Heroe, Villano, Extra, Dispositivo). 
nuevoEpisodio(Heroe, Villano, Extra, Dispositivo):-
    apareceEn(Heroe,_,_),
    apareceEn(Villano,_,_),
    apareceEn(Extra,_,_),
    Heroe \= Villano,
    esHeroe(Heroe),
    esVillano(Villano),
    esReconocible(Dispositivo),
    esExtra(Extra, Heroe, Villano).

% Para mantener el espíritu clásico, el héroe tiene que ser un jedi (un maestro que estuvo alguna vez en el lado luminoso)
% que nunca se haya pasado al lado oscuro. 
esHeroe(Heroe):-
    apareceEn(Heroe,_,_),
    forall((apareceEn(Heroe,Capitulo,luminoso), maestro(Heroe)), apareceEn(Heroe,Capitulo,luminoso)).


% El villano debe haber estado en más de un episodio y tiene que mantener algún rasgo de ambigüedad,
% por lo que se debe garantizar que haya aparecido del lado luminoso en algún episodio y del lado oscuro
% en el mismo episodio o en un episodio posterior.
esVillano(Villano):-
    apareceEn(Villano, Episodio,_),
    apareceEn(Villano, OtroEpisodio,_),
    Episodio \= OtroEpisodio,
    cambioDeLado(Villano).

cambioDeLado(Personaje):-
    apareceEn(Personaje, Episodio, luminoso),
    apareceEn(Personaje, OtroEpisodio, oscuro),
    seVincula(Episodio, OtroEpisodio).

seVincula(Episodio, OtroEpisodio):- precedeA(Episodio, OtroEpisodio).
seVincula(Episodio, OtroEpisodio):-
    precedeA(Episodio, EpisodioIntermedio),
    seVincula(EpisodioIntermedio, OtroEpisodio).


% El extra tiene que ser un personaje de aspecto exótico para mantener la estética de la saga.
% Tiene que tener un vínculo estrecho con los protagonistas, que consiste en que haya estado junto
% al heroe o al villano en todos los episodios en los que apareció. Se considera exótico a los robots
% que no tengan forma de esfera y a los seres de gran tamaño (mayor a 15) o de especie desconocida.
esExtra(Extra, Heroe, Villano):-
    esExotico(Extra),
    apareceEn(Heroe, _,_),
    apareceEn(Villano, _,_),
    forall(apareceEn(Extra, Capitulo,_), estaCon(Heroe, Villano, Extra, Capitulo)).

estaCon(_, Villano, Extra, Capitulo):-
    apareceEn(Extra, Capitulo,_),
    apareceEn(Villano, Capitulo,_).

estaCon(Heroe, _, Extra, Capitulo):-
    apareceEn(Extra, Capitulo,_),
    apareceEn(Heroe, Capitulo,_),
    Extra \= Heroe.

esExotico(Extra):-
    caracterizacion(Extra, ser(_,Tamanio)),
    Tamanio > 15.
esExotico(Extra):-
    caracterizacion(Extra, ser(desconocido,_)).
esExotico(Extra):-
    caracterizacion(Extra, robot(Caracteristica)),
    Caracteristica \= esfera.
%Agrego para que hagrid y hatty puedan ser Extras
esExotico(Extra):-
    caracterizacion(Extra, gigante(Altura)),
    between(250, 400, Altura).
esExotico(Extra):-
    caracterizacion(Extra, Caracteristica),
    Caracteristica \= humano.


% El dispositivo tiene que ser reconocible por el público, por lo que tiene que ser un
% elemento que haya estado presente en muchos episodios (3 o más)
esReconocible(Dispositivo):-
    elementosPresentes(_, Lista),
    member(Dispositivo, Lista),
    findall(Capitulo, (elementosPresentes(Capitulo, ListaDispositivos), member(Dispositivo, ListaDispositivos)), Capitulos),
    length(Capitulos, CantCapitulos),
    CantCapitulos >= 3.

%apareceEn( Personaje, Episodio, Lado de la luz).
apareceEn( luke, elImperioContrataca, luminoso).
apareceEn( luke, unaNuevaEsperanza, luminoso).
apareceEn( vader, unaNuevaEsperanza, oscuro).
apareceEn( vader, laVenganzaDeLosSith, luminoso).
apareceEn( vader, laAmenazaFantasma, luminoso).
apareceEn( c3po, laAmenazaFantasma, luminoso).
apareceEn( c3po, unaNuevaEsperanza, luminoso).
apareceEn( c3po, elImperioContrataca, luminoso).
apareceEn( chewbacca, elImperioContrataca, luminoso).
apareceEn( yoda, elAtaqueDeLosClones, luminoso).
apareceEn( yoda, laAmenazaFantasma, luminoso).


%Maestro(Personaje)
maestro(luke).
maestro(leia).
maestro(vader).
maestro(yoda).
maestro(rey).
maestro(duku).


%caracterizacion(Personaje,Aspecto).
%aspectos:
% ser(Especie,Tamaño)
% humano
% robot(Forma)

caracterizacion(chewbacca,ser(wookiee,10)).
caracterizacion(luke,humano).
caracterizacion(vader,humano).
caracterizacion(yoda,ser(desconocido,5)).
caracterizacion(jabba,ser(hutt,20)).
caracterizacion(c3po,robot(humanoide)).
caracterizacion(bb8,robot(esfera)).
caracterizacion(r2d2,robot(secarropas)).
% PUNTO 3
% Agregar algunos personajes nuevos, con una forma diferente de describir su aspecto
% y que tengan chances de ser incluido como extras.
%aspectos agregados
% gigante(altura)
% mago
caracterizacion(hagrid, gigante(330)).
caracterizacion(harry, mago).



%elementosPresentes(Episodio, Dispositivos).
elementosPresentes(laAmenazaFantasma, [sableLaser]).
elementosPresentes(elAtaqueDeLosClones, [sableLaser, clon]).
elementosPresentes(laVenganzaDeLosSith, [sableLaser, mascara, estrellaMuerte]).
elementosPresentes(unaNuevaEsperanza, [estrellaMuerte, sableLaser, halconMilenario]).
elementosPresentes(elImperioContrataca, [mapaEstelar, estrellaMuerte]).


% El orden de los episodios se representa de la siguiente manera:
%precede(EpisodioAnterior,EpisodioSiguiente)
precedeA(laAmenazaFantasma,elAtaqueDeLosClones).
precedeA(elAtaqueDeLosClones,laVenganzaDeLosSith).
precedeA(laVenganzaDeLosSith,unaNuevaEsperanza).
precedeA(unaNuevaEsperanza,elImperioContrataca).



% PUNTO 1
% Verificar si una determinada conformación del episodio es válida. 
% 5 ?- nuevoEpisodio(luke, vader, c3po, estrellaMuerte).
% true 

% 6 ?- nuevoEpisodio(yoda, vader, c3po, estrellaMuerte).
% false.
% porque en elImperioContrataca esta c3po pero no estan ni yoda ni vader.

% 41 ?- nuevoEpisodio(luke, vader, c3po, sableLaser).
% true 
% 42 ?- nuevoEpisodio(luke, vader, c3po, estrellaMuerte).
% true

% PUNTO 2
% Encontrar todas las conformaciones posibles que se puedan armar.
% Mostrar ejemplos de consultas y respuestas

% 27 ?- nuevoEpisodio(Heroe, Villano, Extra, Dispositivo).
% Heroe = luke,
% Villano = vader,
% Extra = c3po,
% Dispositivo = sableLaser .
% Heroe = luke,
% Villano = vader,
% Extra = c3po,
% Dispositivo = estrellaMuerte.


