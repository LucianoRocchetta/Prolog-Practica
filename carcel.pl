% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).

% prisionero(Nombre, Crimen)
prisionero(piper, narcotrafico([metanfetaminas])).
prisionero(alex, narcotrafico([heroina])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(2500)).
prisionero(dayanara, narcotrafico([heroina, opio])).
prisionero(dayanara, narcotrafico([metanfetaminas])).
prisionero(fernando, narcotrafico([ventaDeAutos, drogaEnOnce, yerbaMateIlegal, anteojosRobados, celulares, pasasteEnRojo30Semaforos])).

% controla(Controlador, Controlado)

controla(piper, alex).
controla(bennett, dayanara).
controla(Controlador, Controlado):- prisionero(Controlado,_), guardia(Controlador), not(controla(Controlado, Controlador)).

conflictoDeInteres(Controlador1, Controlador2):-
    Controlador1 \= Controlador2,
    controla(Controlador1, Otro),
    controla(Controlador2, Otro),
    not(controla(Controlador1, Controlador2)),
    not(controla(Controlador2, Controlador1)).
    
peligroso(Prisionero):- prisionero(Prisionero, homicidio(_)).
peligroso(Prisionero):- 
    prisionero(Prisionero, narcotrafico(Lista)), 
    member(metanfetaminas, Lista).
peligroso(Prisionero):-
    prisionero(Prisionero, narcotrafico(Lista)),
    length(Lista, Cantidad),
    Cantidad > 5.

ladronDeGuanteBlanco(Prisionero):-
    prisionero(Prisionero, robo(MontoRobado)),
    MontoRobado > 100000.

condenaPor(robo(Valor), Condena):- Condena is Valor / 10000.
condenaPor(homicidio(_), 7).
condenaPor(homicidio(Victima), 2):-
    guardia(Victima). 
condenaPor(narcotrafico(Lista), Condena):-
    length(Lista, Cantidad),
    Condena is (Cantidad * 2).

condena(Prisionero, CondenaTotal):-
    prisionero(Prisionero, Delito),
    findall(Condena, condenaPor(Delito, Condena), Condenas),
    sum_list(Condenas, CondenaTotal).


capoDiTutiLiCapi(Capo):-
    %forall(prisionero(Prisionero, _), not(controla(Prisionero, Capo))).
    prisionero(Capo, _),
    not(controla(_, Capo)).