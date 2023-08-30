cantante(megurineLuka).
cantante(hatsuneMiku).
cantante(gumi).
cantante(seeU).
cantante(kaito).
cantante(luchinio).

% sabeCantar(Cantante, cancion(Cancion, Duración))
sabeCantar(megurineLuka, cancion(nightFever, 4)).
sabeCantar(megurineLuka, cancion(foreverYoung, 5)).
sabeCantar(hatsuneMiku, cancion(tellYourWorld, 4)).
sabeCantar(gumi, cancion(foreverYoung, 4)).
sabeCantar(gumi, cancion(tellYourWorld, 5)).
sabeCantar(gumi, cancion(thundertruck, 7)).
sabeCantar(seeU, cancion(novemberRain, 6)).
sabeCantar(seeU, cancion(nightFever, 5)).
sabeCantar(luchinio, cancion(magalenia, 10)).
sabeCantar(luchinio, cancion(fearOfTheDark, 2)).
sabeCantar(luchinio, cancion(realGone, 1)).
sabeCantar(luchinio, cancion(mienteme, 9)).

% Vocaloid = Cantante
cantidadCanciones(Cantante, Cantidad):-
    findall(Cancion, sabeCantar(Cantante, cancion(Cancion, _)), Canciones),
    length(Canciones, Cantidad).

duracionTotal(Cantante, DuracionTotal):-
    findall(Duracion, sabeCantar(Cantante, cancion(_, Duracion)), Duraciones),
    sum_list(Duraciones, DuracionTotal).

cantanteNovedoso(Cantante):-
    cantante(Cantante),
    findall(Duracion, sabeCantar(Cantante, cancion(_, Duracion)), Duraciones),
    sum_list(Duraciones, DuracionTotal),
    length(Duraciones, Cantidad),
    DuracionTotal < 15, 
    Cantidad > 2.

cantanteAcelerado(Cantante):-
    sabeCantar(Cantante, _),
    not((sabeCantar(Cantante, cancion(_, Duracion)), Duracion > 4)).
    
% concierto(Nombre, Pais, CantidadDeFama, Tipo).
concierto(mikuExpo, estadosUnidos, 2000, gigante).
concierto(magicalMirai, japon, 3000, gigante).
concierto(vocalektVisions, estadosUnidos, 1000, mediano).
concierto(mikuFest, argentina, 100, pequenio).

puedeParticipar(Cantante, mikuExpo):-
    sabeCantar(Cantante, _),
    cantidadCanciones(Cantante, CantidadCanciones),
    duracionTotal(Cantante, DuracionTotal),
    CantidadCanciones > 2, DuracionTotal >= 6.

puedeParticipar(Cantante, magicalMirai):-
    sabeCantar(Cantante, _),
    cantidadCanciones(Cantante, CantidadCanciones),
    duracionTotal(Cantante, DuracionTotal),
    CantidadCanciones > 3, DuracionTotal >= 10.

puedeParticipar(Cantante, vocalektVisions):-
    sabeCantar(Cantante, _),
    duracionTotal(Cantante, DuracionTotal),
    DuracionTotal =< 9.

puedeParticipar(Cantante, mikuFest):-
    sabeCantar(Cantante, cancion(_, Duracion)),
    Duracion > 4.

puedeParticipar(hatsuneMiku, _).

famaTotalDeCantante(Cantante, FamaTotal):-
    sabeCantar(Cantante, _),
    findall(Fama, (puedeParticipar(Cantante, Concierto), concierto(Concierto, _, Fama, _)), FamaPorConcierto),
    list_to_set(FamaPorConcierto, FamaPorConciertoSinRepetir),
    cantidadCanciones(Cantante, CantidadCanciones),
    sum_list(FamaPorConciertoSinRepetir, FamaTotalDeConciertos),
    FamaTotal is (FamaTotalDeConciertos * CantidadCanciones).

cantanteMasFamoso(Cantante):-
    famaTotalDeCantante(Cantante, FamaTotalCantante),
    forall((famaTotalDeCantante(Cantante2, FamaTotalCantante2), Cantante \= Cantante2), FamaTotalCantante >= FamaTotalCantante2).
    