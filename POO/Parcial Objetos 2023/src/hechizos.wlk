import example.*

// inmobilus: Le disminuye la carga electrica en 50 unidades y no hay requisitos adicionales para lanzarlo
object inmobilus{
	method cumpleRequisitos(bot) = true
	
	method usarEn(bot) {
		bot.modificarCargaElectrica(-50)
	}	
}

//sectum sempra: En caso que tenga aceite puro, lo deja sucio. Es necesario ser experimentado para lanzarlo.
object sectumSempra {
	method cumpleRequisitos(bot) = bot.esExperimentado()
	
	method usarEn(bot){
		if ( bot.aceitePuro() ){ bot.volverSucio() }
	}
}

//avadakedabra: anula totalmente la carga electrica, solo lo puede lanzar quien tiene aceite sucio o pertenece a una casa peligrosa. 
object avadakedabra {
	method cumpleRequisitos(bot) = !bot.aceitePuro() || howarts.casasPeligrosas().contains(bot.casa())
	
	method usarEn(bot){
		 bot.desactivar()
	}
}


//Hay muchos otros hechizos comunes, que disminuyen la carga electrica en una cantidad determinada, y tiene como requisito adicionales tener mayor carga electrica que la que disminuira al hechizado.
class Comun {
	var cargaElectrica
	
	method cumpleRequisitos(bot) = bot.cargaElectrica() > cargaElectrica
	
	method usarEn(bot){
		bot.modificarCargaElectrica(-cargaElectrica)
	}
}


//Inventar un nuevo hechizo.
