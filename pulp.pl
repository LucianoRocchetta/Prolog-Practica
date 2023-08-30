personaje(pumkin, ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent, mafioso(maton)).
personaje(jules, mafioso(maton)).
personaje(marsellus, mafioso(capo)).
personaje(winston, mafioso(resuelveProblemas)).
personaje(mia, actriz([foxForceFive])).
personaje(butch, boxeador).

pareja(marsellus, mia).
pareja(pumkin, honeyBunny).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(vincent, jules, cuidar(mia)).
encargo(marsellus, vincent,  cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).


esPeligroso(Personaje):-
    personaje(Personaje, mafioso(maton)).
esPeligroso(Personaje):-
    personaje(Personaje, ladron(Lista)),
    member(licorerias, Lista).
esPeligroso(Personaje):-
    trabajaPara(Personaje, Empleado),
    esPeligroso(Empleado).

duoTemible(Personaje1, Personaje2):-
    esPeligroso(Personaje1),
    esPeligroso(Personaje2),
    Personaje1 \= Personaje2,
    pareja(Personaje1, Personaje2),
    amigo(Personaje1, Personaje2).

estaEnProblemas(Personaje):-
    trabajaPara(Jefe, Personaje),
    esPeligroso(Jefe),
    pareja(Jefe, Pareja),
    encargo(Jefe, Personaje, cuidar(Pareja)).
estaEnProblemas(Personaje):-
    encargo(_, Personaje, buscar(butch, _)).
estaEnProblemas(butch).

tieneCerca(Personaje1, Personaje2):-
    amigo(Personaje1, Personaje2).
tieneCerca(Personaje1, Personaje2):-
    trabajaPara(Personaje1, Personaje2).
   
sanCayetano(Personaje):-
    encargo(Personaje, _, _),
    forall(tieneCerca(Personaje, Personaje2), encargo(Personaje, Personaje2, _)).

cantidadEncargos(Personaje, Cantidad):-
    findall(Encargo, encargo(_, Personaje, Encargo), Encargos),
    length(Encargos, Cantidad).

masAtareado(Personaje):-
    cantidadEncargos(Personaje, Cantidad1),
    forall((encargo(_, Personaje2, _), cantidadEncargos(Personaje2, Cantidad2), Personaje2 \= Personaje), Cantidad2 < Cantidad1).


esRespetable(actriz(CantidadPeliculas), Respeto):-
    length(CantidadPeliculas, Cantidad),
    Respeto is Cantidad / 10.
esRespetable(mafioso(resuelveProblemas), 10).
esRespetable(mafioso(maton), 1).
esRespetable(mafioso(capo), 20).


personajesRespetables(Personajes):-
    findall(Personaje, (personaje(Personaje, Tipo), esRespetable(Tipo, Respeto), Respeto > 9), Personajes).

seRelaciona(Personaje, cuidar(Personaje)).
seRelaciona(Personaje, ayudar(Personaje)).
seRelaciona(Personaje, buscar(Personaje, _)).

hartoDe(Personaje1, Personaje2):-
    personaje(Personaje1, _),
    personaje(Personaje2, _),
    forall((encargo(_, Personaje1, Tarea), Personaje1 \= Personaje2), seRelaciona(Personaje2, Tarea)).
hartoDe(Personaje1, Personaje2):-
    forall((encargo(_, Personaje1, Tarea), Personaje1 \= Personaje2, amigo(Personaje2, Amigo)), seRelaciona(Amigo, Tarea)).


caracteristicas(vincent, [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules, [tieneCabeza, muchoPelo]).
caracteristicas(marvin, [negro]).
caracteristicas(pumkin, [negro, metalero]).
caracteristicas(honeyBunny, [negro]).

sonDuo(Personaje, Personaje2):- amigo(Personaje, Personaje2).
sonDuo(Personaje, Personaje2):- pareja(Personaje, Personaje2).

duoDiferenciable(Personaje, Personaje2):-
    sonDuo(Personaje, Personaje2),
    caracteristicas(Personaje, Caracteristicas1),
    caracteristicas(Personaje2, Caracteristicas2),
    not(forall(member(Caracteristica, Caracteristicas1), member(Caracteristica, Caracteristicas2))).
