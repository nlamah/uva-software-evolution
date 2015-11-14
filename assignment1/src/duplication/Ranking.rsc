module duplication::Ranking

import Prelude;

import ListRelation;
import util::Math;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import model::MetricTypes;
import model::CodeLineModel;

import volume::Volume;

alias CodeFragment = str;
alias CodeBlock = list[CodeLine];

//Public Functions

//MEMO:When the volume module is adjusted to the usage of CodeLineModel, then M3 can be removed from this module.
public Rank projectDuplication(CodeLineModel model)
{
	real numberOfDuplicatedLines = toReal(size(duplicationsInProject(model)));
	real numberOfTotalLines = toReal(projectVolume(model));
	real percentage = 100 * numberOfDuplicatedLines / numberOfTotalLines;
	println("dLOC:<numberOfDuplicatedLines>, LOC:<numberOfTotalLines>, percentage:<percentage>");
	
	if (percentage > 20) return minusMinus();
	if (percentage > 10) return minus();
	if (percentage > 5) return neutral();
	if (percentage > 3) return plus();
	
	return plusPlus();
}

public LOC numberOfDuplicatedLines(CodeLineModel model)
{
	return size(duplicationsInProject(model));
}

//Private Functions

private set[CodeLine] duplicationsInProject(CodeLineModel model)
{	
	map[list[CodeFragment], set[CodeBlock]] mapping = indexAllPossibleCodeFragmentsOfNLines(model, 6);
	
	map[list[CodeFragment], set[CodeBlock]] duplicationsMap = (cf : mapping[cf] | list[CodeFragment] cf <- mapping,  size(mapping[cf]) > 1);
	
	set[CodeLine] duplicatedLines = {};
	
	for (dm <- duplicationsMap)
	{
		set[CodeBlock] setOfCodeBlocks = duplicationsMap[dm];
		
		for (codeBlock <- setOfCodeBlocks)
		{
			for (codeLine <- codeBlock)
			{
				duplicatedLines += codeLine;
			}
		}
	}
	
	return duplicatedLines;
}

private map[list[CodeFragment], set[CodeBlock]] indexAllPossibleCodeFragmentsOfNLines(CodeLineModel model, int nrOfLines)
{	
	lrel[list[CodeFragment], CodeBlock] blocks = ([] | it + allDuplicateCandidatesOfNLinesFromFile(model[f], nrOfLines) | f <- model);

	return ListRelation::index(blocks);
}


private lrel[list[CodeFragment], CodeBlock] allDuplicateCandidatesOfNLinesFromFile(list[CodeLine] lines, int nrOfLinesInBlock)
{	
	if (size(lines) < nrOfLinesInBlock) return [];
	
	lrel[list[CodeFragment], list[CodeLine]] blocks = [];
	
	for (i <- [0..size(lines)-nrOfLinesInBlock + 1])
	{
		list[CodeLine] linesInBlock = [l | l <- lines[i..i+nrOfLinesInBlock]];
		
		list[CodeFragment] codeFragments = [l.codeFragment | l <- linesInBlock];
		
		blocks += [<codeFragments, linesInBlock>];
	}
	
	return blocks;
}


//Tests

public list[bool] allTests() = [
								testSourceIsDuplicated()
								]; 

test bool testSourceIsDuplicated()
{
	loc testProject = |project://testSource|;
	M3 m3Model = createM3FromEclipseProject(testProject);
		
	CodeLineModel model = createCodeLineModel(m3Model);
	
	set[CodeLine] duplicateLines = duplicationsInProject(model);
	
	return size(duplicateLines) == 154 && projectVolume(model) == 158;
}