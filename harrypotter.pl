% DICT %
mago(harry).
mago(draco).
mago(hermione).

casa(slytherin).
casa(hufflepuff).
casa(ravenclaw).
casa(gryffindor).

casaApropiada(gryffindor, corajudo).
casaApropiada(slytherin, [orgullo, inteligente]).
casaApropiada(ravenclaw, [inteligente, responsable]).
casaApropiada(hufflepuff, amistoso).

sangre(harry, mestiza).
sangre(draco, pura).
sangre(hermione, impura).

caracterizticas(harry, [corajudo, amistoso, orgulloso, inteligente]).
caracterizticas(draco, [inteligente, orgulloso]).
caracterizticas(hermione, [inteligente, orgullosa, responsable]).

odiariaIr(harry, slytherin).
odiariaIr(draco, hufflepuff).

%---------------------
%       Parte 1
%---------------------

permiteEntrarMago(Casa):-
    casa(Casa),
    Casa \= slytherin.

caracterApropiadoParaCasa(Mago, Casa):-
    casaApropiada(Casa, CaracterizticasCasa),
    caracterizticas(Mago, CaracterizticasMago),
    forall(member(Caracteriztica, CaracterizticasCasa), member(Caracteriztica, CaracterizticasMago)).
    
puedeQuedarSeleccionado(Mago, Casa):-
    caracterApropiadoParaCasa(Mago, Casa),
    permiteEntrarMago(Casa),
    not(odiariaIr(Mago,Casa)).
puedeQuedarSeleccionado(hermione, gryffindor).

cadenaDeAmistades(Magos):-
    % Todos son amistosos TODO: (Se puede abstraer este predicado en otro)
    forall(
        (member(Mago, Magos), caracterizticas(Mago, CaracterizticasMago)), % Antecedente
        (member(Caracteriztica, CaracterizticasMago), Caracteriztica == amistoso) % Consecuente
    ),
    % Pueden entrar a misma casa TODO: (Se puede abstraer este predicado en otro)
    forall(
        (member(Mago, Magos), member(Mago2, Magos), Mago \= Mago2), % Antecedente
        (puedeQuedarSeleccionado(Mago, Casa), puedeQuedarSeleccionado(Mago2, Casa)) % Consecuente
    ).


%---------------------
%       Parte 2
%---------------------

% Acciones

accionMago(harry, andarFueraDeCama).
accionMago(hermione, irA(bosque)).
accionMago(hermione, irA(bibloteca)).
accionMago(harry, irA(bosque)).
accionMago(harry, irA(tercerPiso)).
accionMago(draco, irA(mazmorra)).
accionMago(ron, buenaAccion(50, ganarAjedrez)).
accionMago(hermione, buenaAccion(50, salvarAmigos)).
accionMago(harry, buenaAccion(60, vencerVoldemort)).

puntajeMalaAccion(andarFueraDeCama, -50).
puntajeMalaAccion(irA(bosque), -50).
puntajeMalaAccion(irA(bibloteca), -10).
puntajeMalaAccion(irA(tercerPiso), -75).

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% Malas acciones
hizoUnaMalaAccion(Mago):-
    accionMago(Mago, Accion),
    puntajeMalaAccion(Accion, Puntaje),
    Puntaje < 0.
esBuenAlumno(Mago):-
    not(hizoUnaMalaAccion(Mago)).

accionRecurrente(Accion):- % Recibe como parametro un functor
    % Primera Opcion

    % findall(Mago, accionMago(Mago, Accion), Magos),
    % length(Magos, Cantidad),
    % Cantidad >= 2.

    % Segunda Opcion
    accionMago(Mago2, Accion), 
    accionMago(Mago, Accion), 
    Mago2 \= Mago.

puntosPorMago(Mago):-
    forall(accionMago(Mago, Accion), puntajeMalaAccion(Accion, Puntaje))

puntajeTotalDeCasa(Casa, Sum):-
    esDe(Mago, Casa),
    findall(Puntaje, (forall(accionMago(Mago, Accion), puntajeMalaAccion(Accion, Puntaje)), PuntajeTotal)),
    sum_list(PuntajeTotal, Sum).
    
    
    