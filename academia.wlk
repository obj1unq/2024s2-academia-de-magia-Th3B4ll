object academia {
	const property muebles = #{}

	method puedeGuardar(objeto) = (!self.estaGuardada(objeto)) && self.hayAlgunMuebleParaGuardar(objeto)

	method hayAlgunMuebleParaGuardar(objeto) {
		return muebles.any({mueble => mueble.puedeGuardar(objeto)})}

	method agregarMueble(mueble) {muebles.add(mueble)}

	method estaGuardada(objeto) {
		return muebles.any({mueble => mueble.tiene(objeto)})}

	method dondeEstaGuardada(objeto){
		return muebles.find({mueble => mueble.tiene(objeto)})}

	method mueblesDisponibles(objeto) {
		return muebles.filter({mueble => mueble.puedeGuardar(objeto)})}

	method guardar(objeto) {
		self.validarGuardar(objeto)
		self.guardarEnMuebleDisponible(objeto)
		
	}
	method validarGuardar(objeto) {
		if (not self.puedeGuardar(objeto)) self.error("No se puede guardar" + objeto)
	}
	
	method guardarEnMuebleDisponible(cosa) {
		self.mueblesDisponibles(cosa).anyOne().agregar(cosa)
	}

	method objetosMenosUtiles() {
		return muebles.filter({m => m.objetoMenosUtil()})
	} 

}
class Mueble {
	// Coleccion de cosas en el mueble
	const objetosDentro = #{}

	method tiene(objeto) {
		return objetosDentro.contains(objeto)}

	method puedeGuardar(objeto)

	method agregar(objeto) {
		objetosDentro.add(objeto)}

	method precio()
	
	method utilidad() {
		return self.utilidadTotal() / self.precio() }

	method utilidadTotal() {return objetosDentro.sum({o => o.utilidad()}) }
	 // sumatoria(utilidad de las cosas) / precio

	method objetoMenosUtil() {
		return objetosDentro.min({obj => obj.utilidad()}) } 

}

class Armario inherits Mueble{
	var property cantidadMaxima
	
	override method puedeGuardar(objeto) { 
		return objetosDentro.size() < cantidadMaxima}
	
	override method precio() {
		return 5 * cantidadMaxima}
}

class GabineteMagico inherits Mueble {
	const precio
	
	override method puedeGuardar(objeto) {return objeto.esMagico()}
	
	override method precio() {return precio}
}

class Baul inherits Mueble {
	const volumenMaximo

	method volumenUsado() {
		return objetosDentro.sum({ obj => obj.volumen()})} 

	override method puedeGuardar(objeto) {
		return self.volumenUsado() + objeto.volumen() <= volumenMaximo }

	override method precio() { return volumenMaximo + 2 }

	override method utilidad() = super() + self.extras()
	
	method extras() = if (self.sonTodasReliquias()) 2 else 0

	method sonTodasReliquias() = objetosDentro.all({ c => c.esReliquia() })
}

class BaulMagico inherits Baul {

	override method precio() {return super() * 2 }
	
	override method utilidad() {
		return super() + self.cantidadDeElementosMagicos()
	}

	method cantidadDeElementosMagicos() {
		return objetosDentro.count({o=> o.esMagico()})
	}


}


class Cosa {
	const volumen
	const marca
	const magico = false
	const reliquia = false

	method esMagico() 	{return magico}
	method esReliquia() {return reliquia}
	method volumen()	{return volumen}
	
	method utilidad() {
		return  self.volumen() + self.valorSiEsMagica() + self.valorSiEsReliquia() + marca.valor(self)}

	method valorSiEsMagica() {
		return if(self.esMagico()) 3 else 0}

	method valorSiEsReliquia() {
		return if(self.esReliquia()) 5 else 0}
}



object acme {

	method valor(objeto) {return objeto.volumen() / 2}
}
object fenix {

	method valor(objeto) {return if(objeto.esReliquia()) 3 else 0}
}
object cuchuflito {

	method valor(objeto) {return 0}
}
