module type2::Util

import Prelude;

import lang::java::jdt::m3::AST;

import model::CodeLineModel;

public bool isDeclaration(node n)
{	
	if (Declaration d := n)
	{	
		return true;
	}
	
	return  false;
}

public bool isStatement(node n)
{
	if (Statement s := n)
	{
		return true;
	}
	
	return false;
}

public bool isExpression(node n)
{
	if(Expression e := n)
	{
		return true;	
	}
	
	return false;
}

public bool hasAnnotatedSource(node n)
{
	map[str, value] annotations = getAnnotations(n);
						
	if ("src" in annotations)
	{
		return true;
	}
	
	return false;
}

public loc getSourceFromNode(node n)
{	
	if (hasAnnotatedSource(n))
	{
		if (Declaration d := n)
		{
			return d@src;
		}
	
		if (Statement s := n)
		{
			return s@src;
		}
	
		if (Expression e := n)
		{
			return e@src;
		}
	}
	
	println("thisNode:<n>:<isExpression(n)>");
}

public bool isCloneSubtreeCandidate(node n)
{
	if (isDeclaration(n) || isStatement(n) || isExpression(n))
	{					
		if (hasAnnotatedSource(n))
		{			
			return true;
		}
	}
	
	return false;
}

//Could be replaced to the CodeLineModel
public list[CodeLine] codeLinesForFragement(loc codeFragment, CodeLineModel codeLineModel)
{
	int begin = codeFragment.begin[0];
	int end = codeFragment.end[0];
	
	map[int, CodeLine] linesOfFile = codeLineModel[codeFragment.top];
	
	returnList = [];
	
	int numberOfLines = size(linesOfFile);
	
	for (i <- [begin..end+1])
	{
		CodeLine l = linesOfFile[i];
	
		if (l.hasOnlyCode)
		{
			returnList += model::CodeLineModel::codeLine(l.fileName, l.lineNumber, 0, l.codeFragment, true);
		}
	}
	
	return returnList;
}

private bool consistsOfMoreThanNLines(int numberOfLines, loc codeFragment, CodeLineModel codeLineModel)
{
	return size(codeLinesForFragement(codeFragment, codeLineModel)) >= numberOfLines;
}

public bool allTheCodeFragmentsHasEnoughLines(int numberOfLines, set[loc] codeFragments, CodeLineModel codeLineModel)
{
	return all(c <- codeFragments, consistsOfMoreThanNLines(numberOfLines, c, codeLineModel));
}