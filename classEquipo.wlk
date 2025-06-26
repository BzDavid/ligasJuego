import equipos.*
class Liga {
    const property participantes 

    const property primerSegmentoDeEquipos = []

    const property segundoSegmentoDeEquipos = []

    method initialize() {
        self.actualizarEquiposParticipantes()
    }

    method primerSegmentoPorNombre() = primerSegmentoDeEquipos.map({equipo => equipo.nombre()})

    method segundoSegmentoPorNombre() = segundoSegmentoDeEquipos.map({equipo => equipo.nombre()})

    method participantesPorNombre() = participantes.map({equipo => equipo.nombre()})

    method participantesPorPuntos() = participantes.map({equipo => equipo.puntos()})

    method anadirListaDeEquipos(unaListaDeEquipos) {
        participantes.addAll(unaListaDeEquipos)
        self.actualizarEquiposParticipantes()
    }

    method eliminarYAnadirLista(unaListaDeEquipos) {
        participantes.clear()
        self.anadirListaDeEquipos(unaListaDeEquipos)
    }

    method eliminarParticipante(unEquipo) {
        participantes.remove(unEquipo)
    }

    method ordenarPorPuntos() {
        participantes.sortBy({equipoUno, equipoDos => if (equipoUno.puntos() == equipoDos.puntos()) equipoUno.diferenciaDeGoles() > equipoDos.diferenciaDeGoles() else equipoUno.puntos() > equipoDos.puntos()})
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

    method imprimirEstadisticasTotalesDeEquipos() {
        var posicion = 0
        participantes.forEach({equipo =>
            posicion += 1
            console.println([posicion] + equipo.fullStats())
        })
        posicion = 0
    }

    method jugarUnaVuelta() {
        (participantes.size() - 1).times({i =>
            console.println("Inicio de la fecha " + i + " ==========================")
            self.jugarFecha((0 .. (participantes.size() / 2 - 1)).asList())
            console.println("")
            self.imprimirEstadoDeLiga()
        })
    }

    method jugarLiga() {
        self.jugarUnaVuelta()
        console.println("")
        console.println("Fin de la primera vuelta ==========================")
        console.println("")
        self.jugarUnaVuelta()
    }

    method reiniciarLiga() {
        participantes.forEach({equipo => equipo.reiniciarEstadisticas()})
    }

    method jugarFecha(listaDeNumeroDeEnfrentamientos) {
        listaDeNumeroDeEnfrentamientos.forEach({i => resultados.jugarPartido(primerSegmentoDeEquipos.get(i), segundoSegmentoDeEquipos.get(i))})
        self.ordenarSegmentosParaSiguienteFecha()
    }

    method ordenarSegmentosParaSiguienteFecha() {
        segundoSegmentoDeEquipos.add(primerSegmentoDeEquipos.last())
        primerSegmentoDeEquipos.addAll([segundoSegmentoDeEquipos.get(1)] + primerSegmentoDeEquipos.take(primerSegmentoDeEquipos.size() - 1))
        primerSegmentoDeEquipos.removeAll(primerSegmentoDeEquipos.take(participantes.size() / 2))
        segundoSegmentoDeEquipos.remove(segundoSegmentoDeEquipos.get(1))
    }

    method actualizarEquiposParticipantes() {
        primerSegmentoDeEquipos.clear()
        primerSegmentoDeEquipos.addAll(participantes.subList(0, (participantes.size() - (participantes.size() / 2 ) - 1)))
        segundoSegmentoDeEquipos.clear()
        segundoSegmentoDeEquipos.addAll(participantes.subList((participantes.size() - (participantes.size() / 2 )), participantes.size() - 1))
    }
}

class Equipo {
    const property nombre
    
    var puntos = 0

    var golesAFavor = 0

    var golesEnContra = 0

    var golesEnPartido = 0

    //var partidosJugados = 0 

    method puntos() = puntos

    method golesAFavor() = golesAFavor

    method golesEnContra() = golesEnContra

    method golesEnPartido() = golesEnPartido

    method diferenciaDeGoles() = golesAFavor - golesEnContra

    //method partidosJugados() = partidosJugados

    method statGoles() = [golesAFavor, golesEnContra, self.diferenciaDeGoles()]

    method stats() = [nombre, puntos, self.diferenciaDeGoles()]

    method fullStats() = [nombre, puntos, golesAFavor, golesEnContra, self.diferenciaDeGoles()]

    method jugarPartidoContra_(unRival) {
        golesEnPartido = resultados.generar()
        //partidosJugados += 1
        golesAFavor += golesEnPartido
        unRival.sumarGolesEnContra(golesEnPartido)
    }

    method jugarPartidoEspecial() {
        golesEnPartido = resultados.generar()
    }

    method jugarProrroga() {
        golesEnPartido = 0.max(resultados.generar() - 3)
    }

    method sumarGolesEnContra(goles) {
        golesEnContra += goles
    }

    method reiniciarEstadisticas() {
        puntos = 0
        golesAFavor = 0
        golesEnContra = 0
        golesEnPartido = 0
        //partidosJugados = 0
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

    method ganadorEntre(equipoLocal, equipoVisitante) {
        equipoLocal.jugarPartidoEspecial()
        equipoVisitante.jugarPartidoEspecial()
        mensaje.mostrarResultado(equipoLocal, equipoVisitante)
        if (equipoLocal.golesEnPartido() > equipoVisitante.golesEnPartido()) {
            return equipoLocal
        } 
        else if (equipoLocal.golesEnPartido() == equipoVisitante.golesEnPartido()) {
            return self.jugarProrroga(equipoLocal, equipoVisitante)
        } 
        else {
            return equipoVisitante
        }
    }

    method jugarProrroga(equipoLocal, equipoVisitante) {
        equipoLocal.jugarProrroga()
        equipoVisitante.jugarProrroga()
        console.println("Es empate, procediendo a la prórroga: ")
        mensaje.mostrarResultado(equipoLocal, equipoVisitante)
        if (equipoLocal.golesEnPartido() > equipoVisitante.golesEnPartido()) {
            return equipoLocal
        } 
        else if (equipoLocal.golesEnPartido() == equipoVisitante.golesEnPartido()) {
            return resultadosPenales.jugarTandaDePenales(equipoLocal, equipoVisitante)
        } 
        else {
            return equipoVisitante
        }
    }
}

object resultadosPenales {
    const property golesLocal = []

    const property golesVisitante = []

    method golesTotalesLocal() = golesLocal.sum()

    method golesTotalesVisitante() = golesVisitante.sum()

    method jugarTandaDePenales(equipoLocal, equipoVisitante) {
        self.reiniciarTandaDePenales()
        5.times({i =>
            self.jugarUnaRondaDeTandaDePenales()
        })
        self.jugarUnaRondaMasDePenalesSiEsNecesario(equipoLocal, equipoVisitante)
        console.println("Tanda de penales: ")
        self.mostrarResultadosDePenales(equipoLocal, equipoVisitante)
        return self.quienGanoTandaDePenales(equipoLocal, equipoVisitante)
    }

    method reiniciarTandaDePenales() {
        golesLocal.clear()
        golesVisitante.clear()
    }

    method jugarUnaRondaMasDePenalesSiEsNecesario(equipoLocal, equipoVisitante) {
        if (self.golesTotalesLocal() == self.golesTotalesVisitante()) {
            self.jugarUnaRondaDeTandaDePenales()
            self.jugarUnaRondaMasDePenalesSiEsNecesario(equipoLocal, equipoVisitante)
        }
    }

    method jugarUnaRondaDeTandaDePenales() {
        golesLocal.add(self.esGolDePenal_(resultados.rango()))
        golesVisitante.add(self.esGolDePenal_(resultados.rango()))
    }

    method mostrarResultadosDePenales(equipoLocal, equipoVisitante) {
        mensaje.mostrarListaDePenales_DeEquipo_(golesLocal, equipoLocal)
        mensaje.mostrarListaDePenales_DeEquipo_(golesVisitante, equipoVisitante)
    }

    method quienGanoTandaDePenales(equipoLocal, equipoVisitante) {
        if (self.golesTotalesLocal() > self.golesTotalesVisitante()) {
            return equipoLocal
        }
        else {
            return equipoVisitante
        }
    }

    method esGolDePenal_(numero) {
        if (numero > 2) {
            return 1
        } else {
            return 0
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
        console.println(primerEquipo.nombre() + " " + [primerEquipo.golesEnPartido()] + " - " + [segundoEquipo.golesEnPartido()] + " " + segundoEquipo.nombre())
    }

    method mostrarListaDePenales_DeEquipo_(unaListaDePenales, unEquipo) {
        console.println(
            unEquipo.nombre() +
            ": " +
            unaListaDePenales.map({numero => if(numero == 1) "🟢" else "🔴"})
        )
    }
}