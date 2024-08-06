object red {
	var equipo=[ratatta,machop,dragonite]
	method equipo()=equipo
	method agregarPokemon(pokemon){
		equipo.add(pokemon)
	}
	method poderioTotal(){	
		return equipo.sum({n=>n.poder()})
        }
		
	method abandonarMenosPoderoso(){
		const menorPoder = self.pokeMenosPoderoso()
		equipo.remove(menorPoder)
		
	}
	method pokeMenosPoderoso(){
    	return equipo.min({n=>n.poder()})
	}

	method reclutar(){
	 equipo.add(ciudad.ciudadanos().filter( {m=>m.poder()> self.poderioTotal()/equipo.size()}))
	}
	method entrenamiento(){
		equipo.forEach({m=>m.entrenar()})
	}
	
}

//hacemos otro entrenador para que compita con red en la liga
object ash{ 
	var equipo=[ratatta,machop,pikachu,blue]
		method agregarPokemon(pokemon){
		equipo.add(pokemon)
	}
	method poderioTotal(){	
		return equipo.sum({n=>n.poder()})
        }
}

//otro entrenador
object messi{ 
	var equipo=[pikachu,roselia]
		method agregarPokemon(pokemon){
		equipo.add(pokemon)
	}
	method poderioTotal(){	
		return equipo.sum({n=>n.poder()})
        }
}

object ciudad{
	var ciudadanos= [ratatta,machop,dragonite]
	method ciudadanos()=ciudadanos
}

//punto 1 d)
object liga{		
	var competidores=[ash,red,messi]
	method competir(){
		return competidores.max({n=>n.poderioTotal()})
	}
}
object ratatta{
	var poder =1500
	method poder()=poder
	method entrenar(){}
}

// POKEMONES
object machop{
	var poder = 2000
	method poder()=poder
	method entrenar(){
		poder= poder*1.1	
		}
}

object pikachu{
	var resueltos=["RoboBanco","muerteMachop"]
	method resueltos()=resueltos
	
	method poder(){
	return 20*resueltos.sum({m=>m.length()})
	}
	
	method entrenar(){
		var nuevoMisterio
		nuevoMisterio = resueltos.find({m=> not(m.contains("parte2")) and (not(resueltos.contains(m + "parte2")))})
		resueltos.add(nuevoMisterio + "parte2")
		}
}

object dragonite{
	var poder
	method poder(){
		poder=2*machop.poder()
		return poder
		}
	method entrenar(){
		blue.entrenar()
	}
}

object blue{
	var poder=100
	var amigos = [dragonite,ratatta,machop]
	method amigos() = amigos
	method poder(){
		poder=poder*amigos.filter({m=>m.poder()>3000}).size()
		return poder
	} 
	method entrenar(){
		amigos.add(ciudad.ciudadanos().anyOne())
	}
}

object roselia{
	var poder=400
	method poder()=poder
	method entrenar(){
		poder= machop.poder()/2
	}
}
