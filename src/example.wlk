class Revolver {
	var balas
	method recargar(unasBalas) {
		balas += unasBalas
	}
	method disparar() {
		balas -= 1
	}
	method matar(unaVictima) {
		self.disparar()
		unaVictima.morirse()
	}
	method tieneUnaBala() {
		return balas == 1
	}
	method esSutil() {
		return self.tieneUnaBala()
	}
}

object escopeta {
	method matar(unaVictima) {
		if (unaVictima.estaHerida()) {
			unaVictima.morirse()
		} else {
			unaVictima.herirse()
		}
		
	}
	method esSutil() {
		return false
	}
}

object cuerdaDePiano {
	var calidad
	method matar(unaVictima) {
		if (calidad == "buena") {
			unaVictima.morirse()
		}
	}
	method esSutil() {
		return true
	}
}

class Familia {
	var nombre
	var mafiosos = []
	method mafiososVivos() {
		return mafiosos.filter({unMafioso => unMafioso.estaVivo()})
	}
	method mafiosoMasPeligroso() {
		return self.mafiososVivos().max({unMafioso => unMafioso.cantidadDeArmas()})
	}
	method distribuirArmas() {
		const revolverConSeisBalas = new Revolver(balas = 6)
		self.mafiososVivos().forEach({unMafioso => unMafioso.agregarArma(revolverConSeisBalas)})
	}
	method atacarPorSorpresa(otraFamilia) {
		const mafiosoMasPeligroso = otraFamilia.mafiosoMasPeligroso()
		mafiosos.forEach({unMafioso=>unMafioso.atacar(unMafioso, mafiosoMasPeligroso)})
	}
	method donEstaMuerto() {
		const don = mafiosos.find({unMafioso => unMafioso.esDon()})
		return don.duermeConLosPeces()
	}
	method soldados() {
		return mafiosos.filter({unMafioso=>unMafioso.esSoldado()})
	}
	method soldadosConMasArmas() {
		return self.soldados().filter({unSoldado=>unSoldado.tieneMasDeCincoArmas()})
	}
	method reorganizar() {
		if (self.donEstaMuerto()) {
			self.soldadosConMasArmas().forEach({unSoldado=>unSoldado.rango(subjefe)})
			const mafiosoMasLeal = self.mafiososVivos().max({unMafioso=>unMafioso.lealtad()})
			 mafiosoMasLeal.rango(don)
			 mafiosos.forEach({unMafioso=>unMafioso.aumentarLealtad(10)})
		} else {
			self.error("El don no esta muerto")
		}
	}
}

class Mafioso {
	var property subordinados = []
	var familia
	var property lealtad
	var property armas = []
	var property rango
	var property estado = "vivo"
	method duermeConLosPeces() {
		return (estado == "muerto")
	}
	method esDon() {
		return (rango == don)
	}
	method cantidadDeArmas() {
		return armas.size()
	}
	method estaVivo() {
		return (estado == "vivo")
	}
	method agregarArma(unArma) {
		armas.add(unArma)
	}
	method sabeDespacharElegantemente() {
		return rango.esElegante(self)
	}
	method tieneArmaSutil() {
		return armas.any({unArma=>unArma.esSutil()})
	}
	method atacar(otroMafioso) {
		rango.atacar(self,otroMafioso)
	}
	method tieneMasDeCincoArmas() {
		rango.tieneMasDeCincoArmas(self)
	}
	method aumentarLealtad(unPorcentaje) {
		const nuevaLealtad = (100+unPorcentaje)*lealtad/100
		self.lealtad(nuevaLealtad)
	}
	method estaHerida() {
		return (estado == "herido")
	}
	method herirse() {
		estado = "herido"
	}
	method morirse() {
		estado = "muerto"
	}
	
}

object don {
	
	method ordenarAtaque(unSubordinado) {
		// subordinado ataca
		unSubordinado.atacarDosVeces()
	}
	method esElegante(unMafioso) {
		return true
	}
}

object subjefe {
	method atacar(unMafioso,otroMafioso) {
		const armaCualquiera = unMafioso.armas().anyOne()
		armaCualquiera.matar(otroMafioso)
	}
	method atacarDosVeces(unMafioso,otroMafioso) {
		self.atacar(unMafioso,otroMafioso)
		self.atacar(unMafioso,otroMafioso)
	}
	method esElegante(unMafioso) {
		return unMafioso.subordinados().any({unSubordinado => unSubordinado.tieneArmaSutil()})
	}
}

object soldado {
	method atacar(unMafioso,otroMafioso) {
		const armaAMano = unMafioso.armas().take(1)
		armaAMano.matar(otroMafioso)
	}
	method atacarDosVeces(unMafioso,otroMafioso) {
		self.atacar(unMafioso,otroMafioso)
		self.atacar(unMafioso,otroMafioso)
	}
	method esElegante(unMafioso) {
		return unMafioso.tieneArmaSutil()
	}
	method tieneMasDeCincoArmas(unSoldado) {
		return unSoldado.cantidadDeArmas() > 5
	}
}






