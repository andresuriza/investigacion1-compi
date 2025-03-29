package com.miorganizacion.simple.interprete2.ast;

import java.util.Map;

public class SquareRoot implements ASTNode {
	private ASTNode val;
	private int result;
	
	public SquareRoot(ASTNode val) {
		super();
		this.val = val;
	}

	@Override
	public Object execute(Map<String, Object> symbolTable) {
		this.result = (int)val.execute(symbolTable);
		System.out.println((int) Math.sqrt(this.result));
		return null;
	}

}
