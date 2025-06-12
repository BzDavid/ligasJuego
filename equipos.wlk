import classEquipo.*

object liga1 inherits Liga(participantes = listaPrimera) {
    override method jugarLiga() {
        super()
        console.println("¡El campeón de la liga es: " + self.participantes().first().nombre() + "!")
        console.println(self.participantes().get(self.participantes().size() - 2).nombre() + " va a jugar la promoción para permanecer en la liga!")
        console.println("El equipo que desciende es: " + self.participantes().last().nombre())
    }

    method queEquiposDescienden() = [self.participantes().get(self.participantes().size() - 2).nombre(), self.participantes().last().nombre()]

    method jugarPromocion() {
        2.times({i =>
            resultados.jugarPartido(
                self.participantes().get(self.participantes().size() - 2),
                liga2.participantes().get(1))
            })

    }
}

object liga2 inherits Liga(participantes = listaSegunda) {
    override method jugarLiga() {
        super()
        console.println("Campeón y ascenso de la liga: " + self.participantes().first().nombre() + "!")
        console.println("¡" + self.participantes().get(1).nombre() + " deberá jugar la promoción para ascender!")
    }
    
    method queEquiposAscienden() = participantes.take(2).map({equipo => equipo.nombre()})
}

const calverna = new Equipo(
    nombre = "Calverna"
) //Antes "Barco"

const monteluz = new Equipo(
    nombre = "Monteluz"
) //Antes "Avión"

const streinbruck = new Equipo(
    nombre = "Streinbr"
) //Antes "Tren"

const rodanor = new Equipo(
    nombre = "Rodanor"
) //Antes "Coche"

const novigrad = new Equipo(
    nombre = "Novigrad"
) // Antes "Bicicleta"

const lormont = new Equipo(
    nombre = "Lormont"
) // Antes "Moto"

const boravik = new Equipo(
    nombre = "Boravik"
) // Antes "Silenciadores"

const veltsen = new Equipo(
    nombre = "Veltsen"
) // Antes "Fumetas"

const listaPrimera = [
    calverna,
    monteluz,
    streinbruck,
    rodanor,
    novigrad,
    lormont,
    boravik,
    tirana
]

const listaSegunda = [
    victoria,
    valdonza,
    cernovia,
    pardenos,
    ferrosur,
    dravus,
    rogar,
    veltsen
]

const victoria = new Equipo(
    nombre = "Victoria"
)

const valdonza = new Equipo(
    nombre = "Valdonza"
)

const cernovia = new Equipo(
    nombre = "Cernovia"
)

const pardenos = new Equipo(
    nombre = "Pardenos"
)

const tirana = new Equipo(
    nombre = "Tirana"
)

const ferrosur = new Equipo(
    nombre = "Ferrosur"
)

const dravus = new Equipo(
    nombre = "Dravus"
)

const rogar = new Equipo(
    nombre = "Rogar"
)