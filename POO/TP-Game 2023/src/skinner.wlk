import wollok.game.*
import movimientos.*
import remy.*
import nivel1.*

class Skinner{
	
	var property position 
	var property movimiento = comienzo

	method image() = "skinner_" + self.movimiento().toString() + ".png"
	  	
	method chocar() { self.remyPierdeVida() }
	
	method remyPierdeVida(){
		remy.perderVida()
		remy.inmunidad(true)
		game.schedule(700, { remy.inmunidad(false) })
		if(remy.cantVidas() == 0){
			game.schedule(400, { fin.ejecutar("derrota")})
		}
  	}
  	
	method moverHaciaRemy() {
		var mejorDireccion = self.mejorDireccion(self.direccionesPosibles())
		mejorDireccion.mover(self)
	}
	
	method mejorDireccion(direcciones) = direcciones.min{ d => d.siguientePosicion(self.position()).distance(remy.position())}
	
	method direccionesPosibles() = [ izquierda, derecha, arriba, abajo ].filter{ d => d.puedeMoverse(self) }
}	
