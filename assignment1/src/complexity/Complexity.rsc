module complexity::Complexity

import List;
import util::Math;

import MetricTypes;
import Conversion;
import volume::Volume;
import complexity::ComplexityConversion;

//Public Functions

public Rank projectComplexity(loc project)
{
	list[Unit] units = projectUnits(project);

	map[ComplexityRiskEvaluation, real] complexityPie = complexityPie(units);
	
	return size(units) > 0 ? convertPieToRank(complexityPie) : neutral();
}

//Private Functions

private ComplexityRiskEvaluation complexityRiskFornit(Unit unit)
{
	CC cc = cyclomaticComplexityForUnit(unit);
	
	return convertCCToComplexityRiskEvalutation(cc);
}

//TODO: implement
private CC cyclomaticComplexityForUnit(Unit unit)
{
	return 0;
}

//TODO: Create tests;
private LOC numberOfLines(CodeFragment codeFragment) = size(split("\n", codeFragment));


//TODO: Create test;
private LOC numberOfLines(Unit unit) = numberOfLines(unit.codeFrogment);


//TODO: refactor it to be simple and testable
public map[ComplexityRiskEvaluation, real] complexityPie(list[Unit] units)
{
	list[tuple [Unit, ComplexityRiskEvaluation]] complexityPerUnit = [];
	
	complexityPerUnit = for (unit <- units)
		append <unit, complexityRiskForUnit(unit)>;
	
	list[Unit] simpleUnits = [];
	list[Unit] moreComplexUnits = [];
	list[Unit] complexUnits = [];
	list[Unit] untestableUnits = [];
	
	for (<u, c> <- complexityPerUnit)
	{
		switch (c)
		{
			case simple() : (u:simpleUnits);
			case moreComplex() : (u:moreComplexUnits);
			case complex() : (u:complexUnits);
			case untestable() : (u:untestableUnits);
			default : fail; 
		}
	}
	
	LOC totalLinesOfCode = size(units) > 0 ? linesOfCodeOfUnitList(units) : 1;
	
	LOC simpleLines = size(units) > 0 ? linesOfCodeOfUnitList(simpleUnits) : 1;
	LOC moreComplexLines = size(units) > 0 ? linesOfCodeOfUnitList(moreComplexUnits) : 0;
	LOC complexLines = size(units) > 0 ? linesOfCodeOfUnitList(complexUnits) : 0;
	LOC untestableLines = size(units) > 0 ? linesOfCodeOfUnitList(untestableUnits) : 0;
	
	map[ComplexityRiskEvaluation, real] result = (
													simple() : toReal(simpleLines) / toReal(totalLinesOfCode),
													moreComplex() : toReal(moreComplexLines) / toReal(totalLinesOfCode),
													complex() : toReal(complexLines) / toReal(totalLinesOfCode),
													untestable() : toReal(untestableLines) / toReal(totalLinesOfCode)
													);
	
	return result;
}

private LOC linesOfCodeOfUnitList([]) = 0;
private LOC linesOfCodeOfUnitList(list[Unit] units) = sum([numberOfLines(u) | u <- units]);