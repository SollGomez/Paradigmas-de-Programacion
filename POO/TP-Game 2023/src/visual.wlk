import wollok.game.*
import nivel1.*
import remy.*

// Fondos
class Fondo {
	var property image
	var property position = game.origin()
	
	method image() = image
}

//Comida
class Ingrediente{
	var property position
	var property image
	
	method position(nuevaPos) { position = nuevaPos }
	
	method chocar(){
		remy.agarrar(self)
	}
}


// Escenario
object mesa {
	const property image ="mesa.png"
	var property position = game.at(7, 0)	
}

object plato {
	var property position = game.at(7, 1)
	method image() = "Plato" + nivel1.ingredientesEnPlato().toString() + ".png" 
}


// Tablero
class Escalera {
	const property image = "pixelEscalera.png"
	const property position	
	
	method chocar(){}
}

class Plataforma { 				
	var property position
	method image() = "plataforma.jpeg"
	
	method chocar(){}
}


object rampaIzq {
	const property image = "rampaArriba70.png"
	const property position = game.at(6, 0)
	
	method position() = position
}

object rampaDer {
	const property image = "rampaArriba70.png"
	const property position = game.at(10,0)
	
	method position() = position
}


// PowerUps / Items
object hielo {
	const property image = "hielo2.png"
  	var property position
  	
  	method ponerHielo() {
  		game.onTick(15000, "hielo", {self.posicionarHielo()})
  	}
  	method posicionarHielo(){
  		position = new Position (x=0.randomUpTo(16), y=[4,7].anyOne() )
  		if(self.posicionLibre(position)){
  			if(!game.hasVisual(self))
  					game.addVisualIn(self, position)
  		}else
  			self.posicionarHielo()
  	}
  	method posicionLibre(pos) = game.getObjectsIn(pos).isEmpty()
  	
  	method chocar(){ nivel1.congelar() }
}


object sonido{
	const property position = game.at(0,9)
	var property image = "unmute.png"
}

object inventario{
	var property position = game.at(3,9)
	var property image = "remyConQueso70.png"

	method estaVacio() = game.getObjectsIn(position.right(1)).isEmpty()
	method vaciar() { game.removeVisual(game.getObjectsIn(position.right(1)).head()) }
	method agregar(ingrediente) { ingrediente.position(position.right(1)) }
}

// Interfaz
object platosCompletados{
	method position() = game.at(8,9)
	
	method image() = nivel1.cantPlatos().toString() + "de2.png"
}