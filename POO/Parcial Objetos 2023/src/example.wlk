import hechizos.*
import Casas.*

object howarts {
	const property casas = [gryffindor, slytherin, ravenclaw, hufflepuff]
	var property materias = []

	method casasPeligrosas() = casas.filter({ c => c.esPeligrosa() })
	
	// 2. Crear una materia, determinando qué profesor la dicta y el hechizo que se enseñará.
	method crearMateria(nombre, prof,hechizo){
		const materia = new Materia(
			profesor = prof,
			hechizoEnseniado = hechizo
		)
		self.materias().add(materia)
		prof.materiasDictadas().add(materia)
	}
	
	// 3. Hacer que un grupo de estudiantes asista a una materia y aprenda el correspondiente hechizo
	method asistirA(materia, grupo){
		grupo.forEach({ e => e.asistrirA(materia) })
	}
	
}


class Bot {
	var property cargaElectrica = 0
	var property aceitePuro = false
	
	method modificarCargaElectrica(variacion) {
		cargaElectrica += variacion
	}
	method desactivar() { self.cargaElectrica(0) }
	method volverSucio() { self.aceitePuro(false) }
	method estaActivo() = cargaElectrica != 0
}

object sombreroBotSeleccionador inherits Bot{
	// 1.Llega un grupo de estudiante a Hogwart y el sombrero bot los distribuye en las casas correspondientes.
	
	//inmunidad
	override method volverSucio() {}
}

class Hechicero inherits Bot {
	var property casa
	var property hechizosAprendidos = []
	
	// 4. Hacer que un estudiante lance un hechizo a otro individuo, en caso que pueda hacerlo.
	method lanzarHechizoA(individuo,hechizo){
		if (!self.puedeLanzar(hechizo)){
			throw new Exception(message = "No cumple los Requisitos")
		}else
			hechizo.usarEn(individuo)
	}
	method puedeLanzar(hechizo) = 
		self.cumpleRequisitosDe(hechizo) && 
		self.estaActivo() && self.hechizosAprendidos().contains(hechizo)
	
	method cumpleRequisitosDe(hechizo) = hechizo.cumpleRequisitos(self)
}

class Estudiante inherits Hechicero {
	
	method esExperimentado() = hechizosAprendidos.size() > 3  &&  cargaElectrica > 50
	
	method asistirA(clase){
		hechizosAprendidos.add(clase.hechizoEnseniado())
	}
	
}

class Profesor inherits Hechicero {
	var property materiasDictadas = []
	
	method esExperimentado() = materiasDictadas.size() > 2
	
	//inmunidad
	override method modificarCargaElectrica(variacion) {}
	override method desactivar() { cargaElectrica = cargaElectrica/2 } 
}

class Materia {
	var profesor
	var property hechizoEnseniado
}