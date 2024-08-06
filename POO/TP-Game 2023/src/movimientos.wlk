import wollok.game.*

class Movimiento{
	
const limiteIzquierdo = -1
const limiteDerecho = 17
	
  	method mover(personaje) {
	const posPersonaje = personaje.position()
		if( self.puedeMoverse(personaje) ){ 
  			personaje.position(self.siguientePosicion(posPersonaje))
    		personaje.movimiento(self)
    	} 
    }
    
    method puedeMoverse(personaje)
    method siguientePosicion(posicion) = game.at(0,0)
  	
  	method hayEscalera(pos) = game.getObjectsIn(pos).any({ n => n.image() == "pixelEscalera.png" })
  	method hayPlataformas(pos) = game.getObjectsIn(pos.down(1)).any({n => n.image() == "plataforma.jpeg" || n.image() == "rampaArriba70.png"})
  	
}

object arriba inherits Movimiento{
	override method siguientePosicion(posicion) = posicion.up(1)
	
	override method puedeMoverse(personaje) = self.hayEscalera(personaje.position())
}

object abajo inherits Movimiento{
	override method siguientePosicion(posicion) = posicion.down(1) 
	
	override method puedeMoverse(personaje) = self.hayEscalera(personaje.position().down(1))	
}

object izquierda inherits Movimiento{	
	override method siguientePosicion(posicion) = posicion.left(1)
	
	override method puedeMoverse(personaje) = self.hayPlataformas(personaje.position().left(1))
	
	
	override method mover(personaje) { 
		const posicionOpuesta = new Position(x=limiteDerecho-1, y=personaje.position().y() )
		//const posPersonaje = personaje.position()
  		
  		if( self.estaEnLimite(limiteIzquierdo, personaje) ){
				personaje.position( posicionOpuesta )
			}else { super(personaje) }
			
			
	}
	method estaEnLimite(limite, personaje) = self.siguientePosicion(personaje.position()).x() == limite
	
}


object derecha inherits Movimiento{
	override method siguientePosicion(posicion) = posicion.right(1)	
	override method puedeMoverse(personaje) = self.hayPlataformas(personaje.position().right(1))
	
	override method mover(personaje) {
		const posOpuesta = new Position(x=limiteIzquierdo+1, y=personaje.position().y() )
		
		if( self.siguientePosicion(personaje.position()).x() == limiteDerecho ){
  				personaje.position(posOpuesta)
  			}else{ super(personaje) } 
		}
} 


object comienzo{
	method siguientePosicion(posicion) = posicion 
	method puedeMoverse(personaje) = false
	method mover(personaje){}
}