package com.miorganizacion.simple.interprete2.ast;

import java.util.Map;

/* Interfaz para nodos de arboles de expresion*/
public interface ASTNode {
	public Object execute(Map<String, Object> symbolTable);
}
