import equipos.*
object liga {
    const participantes = []

    method participantesPorNombre() = participantes.map({equipo => equipo.nombre()})

    method participantesPorPuntos() = participantes.map({equipo => equipo.puntos()})

    method participantesPorClase() = participantes

    method anadirListaDeEquipos(equipos) {
        participantes.addAll(equipos)
        partidos.actualizarEquiposParticipantes(participantes)
    }

    method ordenarPorPuntos() {
        participantes.sortBy({equipoUno, equipoDos => equipoUno.puntos() > equipoDos.puntos()})
    }

    method contraQuienPuedeJugar_EnLaLista_(unEquipo, listaDeEquipos) = listaDeEquipos.filter({equipo => equipo.puedeJugarContra_(unEquipo)})


    method lista_SinElPrimeroNiElUltimo(unaLista) = unaLista.remove(unaLista.first()).remove(unaLista.last())

    method estadisticasDeEquipos() {
        const estadisticasADevolver = []
        estadisticasADevolver.clear()
        (0 .. participantes.size() - 1).asList().forEach({i =>
            estadisticasADevolver.add(self.participantesPorNombre().get(i))
            estadisticasADevolver.add(self.participantesPorPuntos().get(i))
        })
        return estadisticasADevolver
    }

    method jugarLiga() {
        (participantes.size() - 1).times({i =>
            console.println("Inicio de la fecha " + i + " ==========================")
            partidos.jugarFecha()
            console.println("Estado de la liga: ")
            console.println(self.estadisticasDeEquipos())
        })
        //console.println("Posición de los participantes: " + self.participantesPorNombre())
        //console.println("Puntos de los participantes: " + self.participantesPorPuntos())
    }
}

object partidos {
    const property participantes = []

    const property primerSegmentoDeEquipos = []

    const property segundoSegmentoDeEquipos = []

    method participantes() = liga.participantesPorClase()

    method primerSegmentoPorNombre() = primerSegmentoDeEquipos.map({equipo => equipo.nombre()})

    method segundoSegmentoPorNombre() = segundoSegmentoDeEquipos.map({equipo => equipo.nombre()})

    method actualizarEquiposParticipantes(listaDeParticipantes) {
        participantes.clear()
        participantes.addAll(listaDeParticipantes)
        primerSegmentoDeEquipos.clear()
        primerSegmentoDeEquipos.addAll(participantes.subList(0, (participantes.size() - (participantes.size() / 2 ) - 1)))
        segundoSegmentoDeEquipos.clear()
        segundoSegmentoDeEquipos.addAll(participantes.subList((participantes.size() - (participantes.size() / 2 )), participantes.size() - 1))
    }

    method jugarFecha() {
        const listaDeEnfrentamientos = (0 .. (participantes.size() / 2 - 1)).asList()
        listaDeEnfrentamientos.forEach({i => resultados.jugarPartido(primerSegmentoDeEquipos.get(i), segundoSegmentoDeEquipos.get(i))})
        self.ordenarSegmentosParaSiguienteFecha()
        liga.ordenarPorPuntos()
    }

    method ordenarSegmentosParaSiguienteFecha() {
        segundoSegmentoDeEquipos.add(primerSegmentoDeEquipos.last())
        primerSegmentoDeEquipos.addAll([segundoSegmentoDeEquipos.get(1)] + primerSegmentoDeEquipos.take(primerSegmentoDeEquipos.size() - 1))
        primerSegmentoDeEquipos.removeAll(primerSegmentoDeEquipos.take(participantes.size() / 2))
        segundoSegmentoDeEquipos.remove(segundoSegmentoDeEquipos.get(1))
    }
}

class Equipo {
    const property nombre

    const property numeroID

    const property equiposConLosQueSeJugo = [self]

    method nombreDeEquiposConLosQueSeJugo() = equiposConLosQueSeJugo.map({equipo => equipo.nombre()})
    
    var property puntos = 0

    var property golesEnPartido = 0

    var property partidosJugados = 0 

    method jugarPartidoContra_(unRival) {
        golesEnPartido = resultados.generar()
        partidosJugados += 1
        equiposConLosQueSeJugo.add(unRival)
    }

    method gana() {
        puntos += 3
    }

    method empata() {
        puntos += 1
    }

    method puedeJugarContra_(unRival) = not equiposConLosQueSeJugo.contains(unRival)
}

object resultados {
    method rango() = [1, 2, 3, 4, 5, 6].anyOne()

    method generar() {
        const resultado = self.rango() - self.rango()
        if (resultado < 0) {
            return 0
        }
        else {
            return resultado
        }
    }

    method jugarPartido(equipoLocal, equipoVisitante) {
        equipoLocal.jugarPartidoContra_(equipoVisitante)
        equipoVisitante.jugarPartidoContra_(equipoLocal)
        if (equipoLocal.golesEnPartido() > equipoVisitante.golesEnPartido()) {
            equipoLocal.gana()
            //mensaje.ganaLocal()
        } 
        else if (equipoLocal.golesEnPartido() == equipoVisitante.golesEnPartido()) {
            equipoLocal.empata()
            equipoVisitante.empata()
            //mensaje.empatan()
        } 
        else {
            equipoVisitante.gana()
            //mensaje.ganaVisitante()
        }
        mensaje.mostrarResultado(equipoLocal, equipoVisitante)
    }
}

object mensaje {
    method ganaLocal() {
        console.println("El equipo local ha ganado el partido.")
    }

    method empatan() {
        console.println("El partido ha terminado en empate.")
    }

    method ganaVisitante() {
        console.println("El equipo visitante ha ganado el partido.")
    }

    method mostrarResultado(primerEquipo, segundoEquipo) {
        const string = primerEquipo.nombre() + " " + [primerEquipo.golesEnPartido()] + " - " + [segundoEquipo.golesEnPartido()] + " " + segundoEquipo.nombre()
        console.println(string)
    }
}