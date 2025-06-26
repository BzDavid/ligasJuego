import classEquipo.*
import equipos.*
import classCopa.*
object liga1 inherits Liga(participantes = listaPrimera) {
    override method jugarLiga() {
        super()
        console.println("¡El campeón de la liga es: " + self.participantes().first().nombre() + "!")
        console.println(self.participantes().get(self.participantes().size() - 2).nombre() + " va a jugar la promoción para permanecer en la liga!")
        console.println("El equipo que desciende es: " + self.participantes().last().nombre())
        console.println("")
        self.imprimirEstadisticasTotalesDeEquipos()
    } 

    method queEquiposDescienden() = [self.participantes().get(self.participantes().size() - 2).nombre(), self.participantes().last().nombre()]

    method jugarPromocion() {
        resultados.jugarPartido(
            self.participantes().get(self.participantes().size() - 2),
            liga2.participantes().get(1)
        )
           
        resultados.jugarPartido(
            liga2.participantes().get(1),
            self.participantes().get(self.participantes().size() - 2)
        )
    }
}

object liga2 inherits Liga(participantes = listaSegunda) {
    override method jugarLiga() {
        super()
        console.println("Campeón y ascenso de la liga: " + self.participantes().first().nombre() + "!")
        console.println("¡" + self.participantes().get(1).nombre() + " deberá jugar la promoción para ascender!")
        console.println("")
        self.imprimirEstadisticasTotalesDeEquipos()
    }
    
    method queEquiposAscienden() = participantes.take(2).map({equipo => equipo.nombre()})
}

object copa1 inherits Copa(participantes = listaPrimera/* + listaSegunda*/) {

}