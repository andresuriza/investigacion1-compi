package com.miorganizacion.simple.interprete2.ast;

import java.util.Map;
import java.util.List;

public class StandardDev implements ASTNode {
	private List<ASTNode> numbers;
	
	public StandardDev(List<ASTNode> numbers) {
		super();
		this.numbers = numbers;
	}

	@Override
	public Object execute(Map<String, Object> symbolTable) {
		double sum = 0.0;
		
	    for (ASTNode i : numbers) {
	        sum += (int)i.execute(symbolTable);
	    }

	    int length = numbers.size();

	    double mean = sum / length;

	    double standardDeviation = 0.0;
	    
	    for (ASTNode num : numbers) {
	        standardDeviation += Math.pow((int)num.execute(symbolTable) - mean, 2);
	    }

	    System.out.println(Math.sqrt(standardDeviation / length));
	    
	    return null;
	}
}
