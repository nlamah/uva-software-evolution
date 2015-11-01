module volume::VolumeConversion

import MetricTypes;

//Conversion from Lines of Code to an enumerated Rank
public Rank convertLOCToRankForJava(LOC l) = plusPlus() when l <= 66000;
public Rank convertLOCToRankForJava(LOC l) = plus() when l <= 246000;
public Rank convertLOCToRankForJava(LOC l) = neutral() when l <= 665000;
public Rank convertLOCToRankForJava(LOC l) = minus() when l <= 1310000;
public default Rank convertLOCToRankForJava(LOC l) = minusMinus();

test bool convertLOCToPlusPlus() = all(x <- [-1..66001], convertLOCToRankForJava(x) == plusPlus());
test bool convertLOCToPlus() = all(x <- [66001..246001], convertLOCToRankForJava(x) == plus());
test bool convertLOCToNeutral() = all(x <- [246001..665001], convertLOCToRankForJava(x) == neutral());
test bool convertLOCToMinus() = all(x <- [665001, 665011..1310001], convertLOCToRankForJava(x) == minus());
test bool convertLOCToMinusMinus() = all(x <- [1310001, 1310010..2000000], convertLOCToRankForJava(x) == minusMinus());