module complexity::CyclomaticComplexity

import List;

import lang::java::jdt::m3::AST; 

import Util;
import MetricTypes;

//Public functions
public CC cyclomaticComplexityForStatement(Statement statement) 
{
 	CC cc = 1;

 	visit(statement) 
 	{
 		case \do(Statement impl, _): cc += 1;
 	  	case \foreach(_, _, Statement impl): cc += 1;
 	  	case \for(_, _, _, Statement impl): cc += 1;
  		case \for(_, _, Statement impl): cc += 1;	
 	  	case \if(_, Statement elseImpl): cc += 1;
  		case \if(_, Statement thenImpl, Statement elseImpl): cc += 1;
  		case \case(_): cc += 1;
  		case \defaultCase(): cc += 1;
  		case \catch(_, Statement impl): cc += 1;
  		case \while(_, Statement impl): cc += 1;
  		case \infix(_,"||",_): cc += 1;
  		case \infix(_,"&&",_): cc += 1;
  		case \conditional(_,_,_): cc += 1;
 	}

 	return cc;
}

public list[bool] allTests() = [	testSimpleMethod(),
									testDo(),
									testForEach(),
									testForLoop(),
									testForLoop2(),
									testIfElseStatement(),
									testNestedIfStatement(),
									testSwitchStatement(),
									testSwitchStatementWithoutDefault(),
									testTryCatch(),
									testWhile(),
									testIfStatementWithTwoInfixOperators(),
									testConditional()									
								];


//Tests
test bool testSimpleMethod()
{
	str methodString = "public int test(){return 1;}";
	str classString = "class A{" + methodString + "}";
	
	Declaration declaration = createAstFromString(|file:///|, classString, true);
	
	Statement statement = head(statementsFromDeclaration(declaration));
	
	CC cc = cyclomaticComplexityForStatement(statement);
	
	return cc == 1;
}

test bool testDo()
{
	str array = "int[] test = new int[] {1,4,5,7}";
	str doString = "do {System.out.println(\"hello\");} while (x \> 0);";
	str methodString = "public void test(){" + doString + "}";
	str classString = "class A{" + methodString + "}";
	
	Declaration declaration = createAstFromString(|file:///|, classString, true);
	
	Statement statement = head(statementsFromDeclaration(declaration));
	
	CC cc = cyclomaticComplexityForStatement(statement);
	
	return cc == 2;
}

test bool testForEach()
{
	str array = "int[] test = new int[] {1,4,5,7}";
	str forLoop = array + " for(int intValue : test){  System.out.println(intValue}; }";
	str methodString = "public void test(){" + forLoop + "}";
	str classString = "class A{" + methodString + "}";
	
	Declaration declaration = createAstFromString(|file:///|, classString, true);
	
	Statement statement = head(statementsFromDeclaration(declaration));
	
	CC cc = cyclomaticComplexityForStatement(statement);
	
	return cc == 2;
}

test bool testForLoop()
{
	str forLoop = "for(int i = 0; i \< 10; i++){ System.out.println(i}; }";
	str methodString = "public void test(){" + forLoop + "}";
	str classString = "class A{" + methodString + "}";
	
	Declaration declaration = createAstFromString(|file:///|, classString, true);
	
	Statement statement = head(statementsFromDeclaration(declaration));
	
	CC cc = cyclomaticComplexityForStatement(statement);
	
	return cc == 2;
}

test bool testForLoop2()
{
	str forLoop = "for(int i = 0; i++){  System.out.println(i}; break; }";
	str methodString = "public void test(){" + forLoop + "}";
	str classString = "class A{" + methodString + "}";
	
	Declaration declaration = createAstFromString(|file:///|, classString, true);
	
	Statement statement = head(statementsFromDeclaration(declaration));
	
	CC cc = cyclomaticComplexityForStatement(statement);
	
	return cc == 2;
}

test bool testIfElseStatement()
{
	str ifStatement = "if(x == 1){ return = 0; }else{ return = 1;}";
	str methodString =  "public int test(){ int x = 1;" + ifStatement + "return 1; }";
	str classString = "class A{ " + methodString + " }";
	
	Declaration declaration = createAstFromString(|file:///|, classString, true);
	
	Statement statement = head(statementsFromDeclaration(declaration));
	
	CC cc = cyclomaticComplexityForStatement(statement);
	
	return cc == 2;
}

test bool testNestedIfStatement()
{
	str ifStatement = "if(x == 1){ return = 0; }else{ return = 1;}";
	str nestedIfStatement = "if (x == 0){" + ifStatement + "}else{ return = 1;}";
	str methodString =  "public int test(){ int x = 1;" + nestedIfStatement + "return 1; }";
	str classString = "class A{ " + methodString + " }";
	
	Declaration declaration = createAstFromString(|file:///|, classString, true);
	
	Statement statement = head(statementsFromDeclaration(declaration));
	
	CC cc = cyclomaticComplexityForStatement(statement);
	
	return cc == 3;
}

test bool testSwitchStatement()
{
	str switchString = "switch(value){ case 1:{ return;}\ncase 2:{ return;}\ncase 3:{ return;}\ncase 4:{ return;}\ndefault:{ return;} }";
	str methodString = "public void test(){" + switchString + "}";
	str classString = "class A{" + methodString + "}";
	
	Declaration declaration = createAstFromString(|file:///|, classString, true);
	
	Statement statement = head(statementsFromDeclaration(declaration));
	
	CC cc = cyclomaticComplexityForStatement(statement);
	
	return cc == 6;
}

test bool testSwitchStatementWithoutDefault()
{
	str switchString = "switch(value){ case 1:{ return;}\ncase 2:{ return;}\ncase 3:{ return;}\ncase 4:{ return;} }";
	str methodString = "public void test(){" + switchString + "}";
	str classString = "class A{" + methodString + "}";
	
	Declaration declaration = createAstFromString(|file:///|, classString, true);
	
	Statement statement = head(statementsFromDeclaration(declaration));
	
	CC cc = cyclomaticComplexityForStatement(statement);
	
	return cc == 5;
}

test bool testTryCatch()
{
	str tryCatchString = "try {} catch (ExceptionType name) {} catch (ExceptionType name) {}";
	str methodString = "public void test(){" + tryCatchString + "}";
	str classString = "class A{" + methodString + "}";
	
	Declaration declaration = createAstFromString(|file:///|, classString, true);
	
	Statement statement = head(statementsFromDeclaration(declaration));
	
	CC cc = cyclomaticComplexityForStatement(statement);
	
	return cc == 3;
}

test bool testWhile()
{
	str array = "int[] test = new int[] {1,4,5,7}";
	str whileString = "while (x \> 0){System.out.println(\"hello\");}";
	str methodString = "public void test(){" + whileString + "}";
	str classString = "class A{" + methodString + "}";
	
	Declaration declaration = createAstFromString(|file:///|, classString, true);
	
	Statement statement = head(statementsFromDeclaration(declaration));
	
	CC cc = cyclomaticComplexityForStatement(statement);
	
	return cc == 2;
}

test bool testIfStatementWithTwoInfixOperators()
{
	str ifStatement = "if(x == 1 && y == 2){ return = 0; }else{ return = 1;}";
	str methodString =  "public int test(){ bool m = (x == 1 || y == 3);" + ifStatement + "return 1; }";
	str classString = "class A{ " + methodString + " }";
	
	Declaration declaration = createAstFromString(|file:///|, classString, true);
	
	Statement statement = head(statementsFromDeclaration(declaration));
	
	CC cc = cyclomaticComplexityForStatement(statement);
	
	return cc == 4;
}

test bool testWithConditional()
{
	str methodString = "public boolean test(){ return x = (x==1) ? true : false;}";
	str classString = "class A{" + methodString + "}";
	
	Declaration declaration = createAstFromString(|file:///|, classString, true);
	
	Statement statement = head(statementsFromDeclaration(declaration));
	
	CC cc = cyclomaticComplexityForStatement(statement);
	
	return cc == 2;
}