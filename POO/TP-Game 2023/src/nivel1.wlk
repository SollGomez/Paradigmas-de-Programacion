import wollok.game.*
import skinner.*
import remy.*
import visual.*
import movimientos.*

object nivel1{
	const property cancionJuego = game.sound("cancionJuego.mp3")
	const skinner = new Skinner(position = game.at(16,4))
	var ingredientesEnPlato = 0
	var cantPlatos = 0
	
	
		method ingredientesEnPlato() = ingredientesEnPlato
  		method cantPlatos() = cantPlatos
	
	
		method ponerPlatYEscalera(){
		  	self.ponerPlataforma(17,0,6)
	        self.ponerPlataforma(17,0,3)
	        self.ponerPlataforma(6,0,0)
	        self.ponerPlataforma(6,11,0)
	        
	        self.ponerEscalera(6,4)
	        self.ponerEscalera(10,4)
	        self.ponerEscalera(2,1)
	        self.ponerEscalera(14,1)
        }
      
		method ponerPlataforma(cantCeldad, cordX, cordY){
      	      cantCeldad.times({n => self.dibujar(new Plataforma(position = new Position(x=n+cordX-1, y=cordY)))}) 
      	}      	
      
		method ponerEscalera(cordX, cordY){
      	          	3.times({ n =>  self.dibujar(new Escalera(position = new Position(x=cordX, y=n+cordY-1))) })
      	}
     
		method empezar(){
          game.addVisual(new Fondo(image = "fondo9.png")) 
          
          cancionJuego.play()
          keyboard.m().onPressDo({ 
          	if(cancionJuego.paused()){
          		sonido.image("unmute.png")
          		cancionJuego.resume()
          		}else{
          			cancionJuego.pause()
          			sonido.image("Mute.png")
          		}
          })

          //Ponemos Plataformas y Escaleras
          self.ponerPlatYEscalera()
        
          //Agrego las 2 rampas
          game.addVisual(rampaIzq)
          game.addVisual(rampaDer)
          
          //Agrego cebollas
          game.addVisual(new Ingrediente(position = game.at(15,4), image= "cebolla40.png")) 
          game.addVisual(new Ingrediente(position = game.at(1,7),image= "cebolla40.png")) 

          //Agrego berenjenas
          game.addVisual(new Ingrediente(position=game.at(1,4),image= "berenjena40.png")) 
          
         //Agrego tomates
          game.addVisual(new Ingrediente(position=game.at(8,7),image= "tomate40.png"))
          game.addVisual(new Ingrediente(position=game.at(12,1), image= "tomate40.png"))
          
         //Agrego zanahorias
          game.addVisual(new Ingrediente(position=game.at(15,7),image = "tomate40.png"))
          
          hielo.ponerHielo()
          
          //Ponemos Personajes
          game.addVisual(remy)
          game.addVisual(skinner)
          
 		  self.activarSkinners()
  		   
          //Ponemos Interfaz
          game.addVisual(vidas)
          game.addVisual(mesa)
          game.addVisual(plato)
          game.addVisual(platosCompletados)
          game.addVisual(sonido)
          game.addVisual(inventario)
          
          game.whenCollideDo(remy, { elemento => elemento.chocar()})
           
          keyboard.up().onPressDo({ arriba.mover(remy) })
          keyboard.down().onPressDo({ abajo.mover(remy) })
          keyboard.left().onPressDo({ izquierda.mover(remy) })
          keyboard.right().onPressDo({ derecha.mover(remy) })
          
          keyboard.space().onPressDo({ remy.dejarEnMesa() })
          
          // PARA PROBAR
          keyboard.p().onPressDo({ fin.ejecutar("derrota") })
          keyboard.g().onPressDo({ fin.ejecutar("victoria") })
          
          
  	}
  
  method activarSkinners(){
  		game.onTick(300,"movimiento",{ skinner.moverHaciaRemy() })
  }
  
  method congelar(){
  		game.removeVisual(hielo)
		game.removeTickEvent("movimiento")
		game.schedule(1500 , { self.activarSkinners() })
	}
  
  method dibujar(objeto){game.addVisual(objeto)}
  
  method sacarCancion() { cancionJuego.stop() }
  
  
  method sumarIngrediente() {
  	ingredientesEnPlato += 1
  	if(ingredientesEnPlato == 3){
  			cantPlatos += 1
  			if(cantPlatos == 2){ game.schedule(600, {fin.ejecutar("victoria")}) }
  			game.schedule(600, {ingredientesEnPlato = 0})
  		}
  	}
}

object fin{
	method fondo(winOrlose) = new Fondo(image = winOrlose + ".png")
	method cancion(winOrlose) = game.sound(winOrlose + ".mp3")
	
	method ejecutar(winOrlose){
		game.clear()
		nivel1.sacarCancion()
		self.cancion(winOrlose).play()
		game.addVisual(self.fondo(winOrlose))
		game.schedule(10000, { game.stop()})
	}
}