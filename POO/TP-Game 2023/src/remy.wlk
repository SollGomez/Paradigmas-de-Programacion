import wollok.game.*
import nivel1.*
import movimientos.*
import visual.*


object remy{
	var property position = game.at(0,1)
	var property movimiento = comienzo
	var property cantVidas = 3
	var property inmunidad = false 
  
	method perderVida(){ 
		if(!inmunidad)
			cantVidas = cantVidas - 1
	}  

	method image() = "remy_" + self.movimiento().toString() + ".png"
  	
	method agarrar(ingrediente){
		if(inventario.estaVacio()){
			inventario.agregar(ingrediente)
		}
	}
	
	method dejarEnMesa(){
			if(self.position() == rampaIzq.position().up(1) || self.position() == rampaDer.position().up(1)){
				if(!(inventario.estaVacio())){
					nivel1.sumarIngrediente()
					inventario.vaciar()
			}
		}	
	}
}


object vidas{
  	var property position = game.at(15, 9)
  	
  	method image() = "vidas" + remy.cantVidas().toString() + "_30.png"
}