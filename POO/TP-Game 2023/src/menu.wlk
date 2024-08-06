import wollok.game.*
import nivel1.*
import visual.*

object menu {
	const fondoMenu = new Fondo(image = "fondoMenu.jpeg")
	const property cancion = game.sound("inicio.mp3")
	const property botones = [play, howToPlay, controles]
	var property seleccion = 0
	
	method ejecutar() {
		
		if(!cancion.played())
  			cancion.play()
		game.addVisual(fondoMenu)
		game.addVisualIn(play, game.at(5,5))
		game.addVisualIn(howToPlay, game.at(5,3))
		game.addVisualIn(controles, game.at(5,1))
		
		keyboard.down().onPressDo { self.cambiarSeleccion(1) }
		keyboard.up().onPressDo { self.cambiarSeleccion(-1) }
		keyboard.space().onPressDo { 
  			game.clear() 
			self.queBoton().iniciar()
		}
	}
	
	method cambiarSeleccion(cuanto){	
		self.queBoton().estado("noSeleccionado")
		self.sumarPos(cuanto)
		if(seleccion < 0)
			self.seleccion(0)
		if(seleccion > 2)
			self.seleccion(2)
		self.queBoton().estado("seleccionado")
	}
	
	method queBoton() = botones.get(seleccion)
	method sumarPos(cuanto) { seleccion += cuanto }
}

class Boton {
	method iniciar(){
		game.clear() 
		self.ejecutar()
	}
	
	method ejecutar(){
  		keyboard.del().onPressDo({
  			game.clear() 
  			menu.ejecutar()
  		})
  		
  		keyboard.enter().onPressDo({
  			menu.cancion().stop()
  			nivel1.empezar()
  		})
  	}
}

object play inherits Boton {
	var property estado = "seleccionado"
	
	method image() = "play_" + estado.toString() + ".png"
	
	override method iniciar(){
		menu.cancion().stop()
		game.clear()
		nivel1.empezar()
	}
}

object howToPlay inherits Boton {
	var property estado = "noSeleccionado"
	const fondoHowToPlay = new Fondo(image = "howToPlay.jpeg")
	
	method image() = "howToPlay_" + estado.toString() + ".png"
	
	override method ejecutar() {
		game.addVisual(fondoHowToPlay)
		super()
	}
}

object controles inherits Boton {
	var property estado = "noSeleccionado"
	const fondoControles = new Fondo(image = "controles.jpeg")
	
	method image() = "controles_" + estado.toString() + ".png"
	
	override method ejecutar() {
		game.addVisual(fondoControles)
		super()
	}
}