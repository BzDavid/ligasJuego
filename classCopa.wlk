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
        listaDeGrupos.clear()
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

    method jugarCopaEliminacionDirecta() {
        self.establecerGruposFaseFinalParaEliminacionDirecta()
        self.jugarFaseEliminatoria() 
        self.jugarFinal()
    }

    method establecerGruposFaseFinalParaEliminacionDirecta() {
        faseFinalGrupo1.clear()
        faseFinalGrupo1.addAll(participantes.subList(0, (participantes.size() - (participantes.size() / 2 ) - 1)))
        faseFinalGrupo2.clear()
        faseFinalGrupo2.addAll(participantes.subList((participantes.size() - (participantes.size() / 2 )), participantes.size() - 1))
    }

    method jugarFecha() {
        var numeroDeGrupo = 1
        listaDeGrupos.forEach({grupo => 
            console.println("Grupo número " + numeroDeGrupo + ":")
            console.println("")
            numeroDeGrupo += 1
            grupo.jugarFecha((0 .. (grupo.participantes().size() / 2 - 1)).asList())
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
        faseFinalGrupo1.randomize()
        faseFinalGrupo2.randomize()
        console.println("Primeros que avanzan a la fase final:")
        console.println(faseFinalGrupo1.map({equipo => equipo.nombre()}))
        console.println("")
        console.println("Segundos que avanzan a la fase final:")
        console.println(faseFinalGrupo2.map({equipo => equipo.nombre()}))
        console.println("")
    }

    method jugarFaseEliminatoria() {
        if (faseFinalGrupo1.size() >= 2) {
            self.jugarUNAFaseEliminatoria(faseFinalGrupo1.size())
            self.jugarFaseEliminatoria()
        }
    }

    method jugarUNAFaseEliminatoria(numeroDeEquiposAEliminar) {
        self.jugarConEnfrentamientos_DelGrupoFinal_((0 .. (faseFinalGrupo1.size() / 2) - 1).asList(), faseFinalGrupo1)
        self.jugarConEnfrentamientos_DelGrupoFinal_((faseFinalGrupo2.size() / 2 .. faseFinalGrupo2.size() - 1).asList(), faseFinalGrupo2)
        self.avanzarEliminatoria(numeroDeEquiposAEliminar)
    }

    method jugarConEnfrentamientos_DelGrupoFinal_(listaDelNumeroDeEnfrentamientos, listaDeLaFaseFinal) {
        listaDelNumeroDeEnfrentamientos.forEach({i => 
            console.println("Partido número " + (i + 1))
            listaDeLaFaseFinal.add(resultados.ganadorEntre(faseFinalGrupo1.get(i), faseFinalGrupo2.get(i)))
            console.println("==========================")
            console.println("")
        })
        
    }

    method avanzarEliminatoria(numeroTotalDeListaPrevia) {
        faseFinalGrupo1.removeAll(faseFinalGrupo1.take(numeroTotalDeListaPrevia))
        faseFinalGrupo2.removeAll(faseFinalGrupo2.take(numeroTotalDeListaPrevia))
    }

    method jugarFinal() {
        console.println("¡La gran final de la copa ha comenzado!")
        console.println("¡" + resultados.ganadorEntre(faseFinalGrupo1.get(0), faseFinalGrupo2.get(0)).nombre() + " es el campeón de la copa!")
        self.reiniciarCopa()
    }

    method reiniciarCopa() {
        listaDeGrupos.forEach({liga => liga.reiniciarLiga()})
        faseFinalGrupo1.clear()
        faseFinalGrupo2.clear()
    }

    //TODO: Luego veo cómo implementar la ida y vuelta
}