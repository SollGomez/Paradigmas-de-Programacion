import example.*

object gryffindor {
	var property esPeligrosa = false
}

object slytherin {
	var property esPeligrosa = true
}

object ravenclaw {
	var property estudiantes = []
	
	method esPeligrosa() = estudiantes.size() - self.cantEstudiantesPuros() > self.cantEstudiantesPuros()
	method cantEstudiantesPuros() = estudiantes.count({ e => e.aceitePuro() })
}

object hufflepuff {
	var property estudiantes = []
	
	method esPeligrosa() = estudiantes.size() - self.cantEstudiantesPuros() > self.cantEstudiantesPuros()
	method cantEstudiantesPuros() = estudiantes.count({ e => e.aceitePuro() })
}
