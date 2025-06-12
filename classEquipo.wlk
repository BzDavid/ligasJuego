import equipos.*
class Liga {
    const property participantes 

    method participantesPorNombre() = participantes.map({equipo => equipo.nombre()})

    method participantesPorPuntos() = participantes.map({equipo => equipo.puntos()})

    method participantesPorClase() = participantes

    method anadirListaDeEquipos(equipos) {
        participantes.addAll(equipos)
        partidos.actualizarEquiposParticipantes(participantes)
    }

    method enviarActualizacion() {
        partidos.actualizarEquiposParticipantes(participantes)
        //Ya que los partidos se simulan en el objeto partidos, le mando mi lista de participantes para que el objeto trabaje con su propia copia de la lista. Esto es "actualizar" los equipos.
    }

    method eliminarParticipante(unEquipo) {
        participantes.remove(unEquipo)
    }

    method ordenarPorPuntos() {
        participantes.sortBy({equipoUno, equipoDos => equipoUno.puntos() > equipoDos.puntos()})
    }

    method imprimirEstadoDeLiga() {
        self.ordenarPorPuntos()
        console.println("Estado de la liga: ")
        console.println("")
        self.imprimirEstadisticasDeEquipos()
    }

    method imprimirEstadisticasDeEquipos() {
        var posicion = 0
        participantes.forEach({equipo =>
            posicion += 1
            console.println([posicion] + equipo.stats())
        })
        posicion = 0
    }

    method jugarLigaPV() {
        self.enviarActualizacion()
        self.jugarLigaSV()
        //Es muy anti-intuitivo, pero es así porque en la primera vuelta actualizo los equipos, y en la segunda no.
    }

    method jugarLigaSV() {
        (participantes.size() - 1).times({i =>
            console.println("Inicio de la fecha " + i + " ==========================")
            partidos.jugarFecha()
            console.println("")
            self.imprimirEstadoDeLiga()
        })
        //Acá se juega una parte de la liga. La única diferencia que tiene es que no se actualizan los equipos, ya que de eso se encarga primera vuelta. 
    }

    method jugarLiga() {
        self.jugarLigaPV()
        console.println("")
        console.println("Fin de la primera vuelta ==========================")
        console.println("")
        self.jugarLigaSV()
    }

    method reiniciarLiga() {
        participantes.forEach({equipo => equipo.reiniciarEstadisticas()})
    }
}


object partidos {
    const property participantes = []

    const property primerSegmentoDeEquipos = []

    const property segundoSegmentoDeEquipos = []

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
    
    var puntos = 0

    var golesAFavor = 0

    var golesEnContra = 0

    var golesEnPartido = 0

    var partidosJugados = 0 

    method puntos() = puntos

    method golesAFavor() = golesAFavor

    method golesEnContra() = golesEnContra

    method golesEnPartido() = golesEnPartido

    method diferenciaDeGoles() = golesAFavor - golesEnContra

    method partidosJugados() = partidosJugados

    method statGoles() = [golesAFavor, golesEnContra, self.diferenciaDeGoles()]

    method stats() = [nombre, puntos, self.diferenciaDeGoles()]

    method jugarPartidoContra_(unRival) {
        golesEnPartido = resultados.generar()
        partidosJugados += 1
        golesAFavor += golesEnPartido
        unRival.sumarGolesEnContra(golesEnPartido)
    }

    method sumarGolesEnContra(goles) {
        golesEnContra += goles
    }

    method reiniciarEstadisticas() {
        puntos = 0
        golesAFavor = 0
        golesEnContra = 0
        golesEnPartido = 0
        partidosJugados = 0
    }

    method gana() {
        puntos += 3
    }

    method empata() {
        puntos += 1
    }
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

    method tirarUnPenal() {
        const resultado = self.rango()
        if (resultado < 3) {
            return 0 
        } 
        else {
            return 1 
        }
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