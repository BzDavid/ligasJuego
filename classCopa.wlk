import classEquipo.*
class Copa {
    const property participantes 

    const property listaDeGrupos = []

    const property faseFinalGrupo1 = []

    const property faseFinalGrupo2 = []

    method initialize() {
        self.anadirParticipantesAGrupos()
    }

    method anadirListaDeParticipantes_(unaLista) {
        participantes.addAll(unaLista)
        self.anadirParticipantesAGrupos()
    }

    method anadirParticipantesAGrupos() {
        var numeroIndice = 0
        (participantes.size() / 4).times({i =>
            listaDeGrupos.add(new Liga(
                participantes = [
                    participantes.get(numeroIndice), 
                    participantes.get(numeroIndice + 1),
                    participantes.get(numeroIndice + 2),
                    participantes.get(numeroIndice + 3)
                ]
            ))
            numeroIndice += 4
        })
    }

    method jugarCopa() {
        self.jugarFaseDeGrupos()
        self.jugarFaseEliminatoria()
        self.jugarFinal()
    }

    method jugarFecha() {
        var numeroDeGrupo = 1
        listaDeGrupos.forEach({grupo => 
            console.println("Grupo número " + numeroDeGrupo + ":")
            console.println("")
            numeroDeGrupo += 1
            grupo.jugarFecha()
            grupo.ordenarPorPuntos()
            grupo.imprimirEstadoDeLiga()
            console.println("")
        })
        numeroDeGrupo = 1
    }

    method jugarFaseDeGrupos() {
        var numeroDeJornada = 1
        3.times({i => 
            console.println("Jornada número " + numeroDeJornada + ": ==========================")
            self.jugarFecha()
            numeroDeJornada += 1
        })
        numeroDeJornada = 1
        self.avanzarDeFase()
    }

    method avanzarDeFase() {
        listaDeGrupos.forEach({grupo => faseFinalGrupo1.add(grupo.participantes().get(0))})
        listaDeGrupos.forEach({grupo => faseFinalGrupo2.add(grupo.participantes().get(1))})
        console.println("Primeros que avanzan a la fase final:")
        console.println(faseFinalGrupo1.map({equipo => equipo.nombre()}))
        console.println("")
        console.println("Segundos que avanzan a la fase final:")
        console.println(faseFinalGrupo2.map({equipo => equipo.nombre()}))
        console.println("")
    }

    method jugarFaseEliminatoria() {
        if (faseFinalGrupo1.size() >= 2) {
            self.jugarUNAFaseEliminatoria()
            self.jugarFaseEliminatoria()
        }
    }

    method jugarUNAFaseEliminatoria() {
        self.jugarPrimerLado()
        self.jugarSegundoLado()
        self.avanzarEliminatoria()
    }

    method jugarPrimerLado() {
        const listaDeEnfrentamientos = (0 .. (faseFinalGrupo1.size() / 2) - 1).asList()
        listaDeEnfrentamientos.forEach({i => 
            console.println("Partido número " + (i + 1))
            faseFinalGrupo1.add(resultados.ganadorEntre(faseFinalGrupo1.get(i), faseFinalGrupo2.get(i)))
            console.println("==========================")
            console.println("")
        })
    }

    method jugarSegundoLado() {
        const listaDeEnfrentamientos = (faseFinalGrupo2.size() / 2 .. faseFinalGrupo2.size() - 1).asList()
        listaDeEnfrentamientos.forEach({i => 
            console.println("Partido número " + (i + 1))
            faseFinalGrupo2.add(resultados.ganadorEntre(faseFinalGrupo1.get(i), faseFinalGrupo2.get(i)))
            console.println("==========================")
            console.println("")
        })
    }

    method avanzarEliminatoria() {
        faseFinalGrupo1.removeAll(faseFinalGrupo1.take((faseFinalGrupo1.size() / 2 + 1).truncate(0)))
        faseFinalGrupo2.removeAll(faseFinalGrupo2.take((faseFinalGrupo2.size() / 2 + 1).truncate(0)))
    }

    method jugarFinal() {
        console.println("¡" + resultados.ganadorEntre(faseFinalGrupo1.get(0), faseFinalGrupo2.get(0)).nombre() + " es el campeón de la copa!")
    }

    method reiniciarCopa() {
        listaDeGrupos.forEach({liga => liga.reiniciarLiga()})
    }

    //TODO: Luego veo cómo implementar la ida y vuelta
}