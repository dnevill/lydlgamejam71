class_name OverworldMapGenerator
extends Resource

# aids in generating overworld maps

const FORBIDDEN_PAIRS:Array = [[2,1], [2,2], [3,3], [4,4], [5,5]];
const FORBIDDEN_REPLACER:Array = [OverworldNode.MAPNODETYPE_FOE, OverworldNode.MAPNODETYPE_BOOK];

static func attachRandomTree(originNode:OverworldNode):
	# generate a map using a randomly selected structure and attach it to originNode
	
	match(randi()%4):
		0:
			var A:OverworldNode = OverworldMapGenerator.createChain(4);
			var AA:OverworldNode = OverworldMapGenerator.createChain(8);
			var AB:OverworldNode = OverworldMapGenerator.createChain(8);
			var AC:OverworldNode = OverworldMapGenerator.createChain(8);
			var A_FINAL:OverworldNode = OverworldMapGenerator.findFinalNode(A);
			A_FINAL.addChild(AA);
			A_FINAL.addChild(AB);
			A_FINAL.addChild(AC);
			
			A.nodeType = OverworldNode.MAPNODETYPE_BOOK;
			OverworldMapGenerator.findFinalNode(AA).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(AB).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(AC).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			
			var B:OverworldNode = OverworldMapGenerator.createChain(7);
			var BA:OverworldNode = OverworldMapGenerator.createChain(5);
			var BB:OverworldNode = OverworldMapGenerator.createChain(5);
			var BC:OverworldNode = OverworldMapGenerator.createChain(5);
			var B_FINAL:OverworldNode = OverworldMapGenerator.findFinalNode(B);
			B_FINAL.addChild(BA);
			B_FINAL.addChild(BB);
			B_FINAL.addChild(BC);
			
			B.nodeType = OverworldNode.MAPNODETYPE_SHOP;
			OverworldMapGenerator.findFinalNode(BA).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(BB).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(BC).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			
			originNode.addChild(A);
			originNode.addChild(B);
		1:
			var A:OverworldNode = OverworldMapGenerator.createChain(5);
			var AA:OverworldNode = OverworldMapGenerator.createChain(7);
			var AB:OverworldNode = OverworldMapGenerator.createChain(7);
			var A_FINAL:OverworldNode = OverworldMapGenerator.findFinalNode(A);
			A_FINAL.addChild(AA);
			A_FINAL.addChild(AB);
			
			A.nodeType = OverworldNode.MAPNODETYPE_BOOK;
			OverworldMapGenerator.findFinalNode(AA).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(AB).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			
			var B:OverworldNode = OverworldMapGenerator.createChain(8);
			var BA:OverworldNode = OverworldMapGenerator.createChain(4);
			var BB:OverworldNode = OverworldMapGenerator.createChain(4);
			var B_FINAL:OverworldNode = OverworldMapGenerator.findFinalNode(B);
			B_FINAL.addChild(BA);
			B_FINAL.addChild(BB);
			
			B.nodeType = OverworldNode.MAPNODETYPE_SHOP;
			OverworldMapGenerator.findFinalNode(BA).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(BB).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			
			var C:OverworldNode = OverworldMapGenerator.createChain(6);
			var CA:OverworldNode = OverworldMapGenerator.createChain(6);
			var CB:OverworldNode = OverworldMapGenerator.createChain(6);
			var C_FINAL:OverworldNode = OverworldMapGenerator.findFinalNode(C);
			C_FINAL.addChild(CA);
			C_FINAL.addChild(CB);
			
			C.nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(CA).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(CB).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			
			originNode.addChild(A);
			originNode.addChild(B);
			originNode.addChild(C);
		2:
			var A:OverworldNode = OverworldMapGenerator.createChain(7);
			var AA:OverworldNode = OverworldMapGenerator.createChain(5);
			var AB:OverworldNode = OverworldMapGenerator.createChain(5);
			var A_FINAL:OverworldNode = OverworldMapGenerator.findFinalNode(A);
			A_FINAL.addChild(AA);
			A_FINAL.addChild(AB);
			
			A.nodeType = OverworldNode.MAPNODETYPE_BOOK;
			OverworldMapGenerator.findFinalNode(AA).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(AB).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			
			var B:OverworldNode = OverworldMapGenerator.createChain(4);
			var BA:OverworldNode = OverworldMapGenerator.createChain(8);
			var BB:OverworldNode = OverworldMapGenerator.createChain(8);
			var BC:OverworldNode = OverworldMapGenerator.createChain(8);
			var BD:OverworldNode = OverworldMapGenerator.createChain(8);
			var B_FINAL:OverworldNode = OverworldMapGenerator.findFinalNode(B);
			B_FINAL.addChild(BA);
			B_FINAL.addChild(BB);
			B_FINAL.addChild(BC);
			B_FINAL.addChild(BD);
			
			B.nodeType = OverworldNode.MAPNODETYPE_SHOP;
			OverworldMapGenerator.findFinalNode(BA).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(BB).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(BC).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(BD).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			
			originNode.addChild(A);
			originNode.addChild(B);
		3:
			var A:OverworldNode = OverworldMapGenerator.createChain(5);
			var AA:OverworldNode = OverworldMapGenerator.createChain(7);
			var AB:OverworldNode = OverworldMapGenerator.createChain(7);
			var AC:OverworldNode = OverworldMapGenerator.createChain(7);
			var AD:OverworldNode = OverworldMapGenerator.createChain(7);
			var A_FINAL:OverworldNode = OverworldMapGenerator.findFinalNode(A);
			A_FINAL.addChild(AA);
			A_FINAL.addChild(AB);
			A_FINAL.addChild(AC);
			A_FINAL.addChild(AD);
			
			A.nodeType = OverworldNode.MAPNODETYPE_BOOK;
			OverworldMapGenerator.findFinalNode(AA).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(AB).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(AC).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(AD).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			
			var B:OverworldNode = OverworldMapGenerator.createChain(8);
			var BA:OverworldNode = OverworldMapGenerator.createChain(4);
			var BB:OverworldNode = OverworldMapGenerator.createChain(4);
			var B_FINAL:OverworldNode = OverworldMapGenerator.findFinalNode(B);
			B_FINAL.addChild(BA);
			B_FINAL.addChild(BB);
			
			B.nodeType = OverworldNode.MAPNODETYPE_SHOP;
			OverworldMapGenerator.findFinalNode(BA).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			OverworldMapGenerator.findFinalNode(BB).nodeType = OverworldNode.MAPNODETYPE_CAMP;
			
			originNode.addChild(A);
			originNode.addChild(B);

static func createChain(requiredLength:int):
	# builds a chain of requiredLength random nodes and returns the root
	var resultNode:OverworldNode = OverworldNode.new(OverworldNode.MAPNODETYPE_RANDOM);
	for n in (requiredLength-1):
		resultNode.addToChain(OverworldNode.new(OverworldNode.MAPNODETYPE_RANDOM));
	return resultNode;

static func findFinalNode(thisNode:OverworldNode):
	# recursively finds final node connected to this one, traveling down child 0
	if(thisNode.childNodes.size() < 1): return thisNode;
	return findFinalNode(thisNode.childNodes[0]);

static func scrubTree(thisNode:OverworldNode, previousNodeType:int):
	# recursively goes through a tree, looking for forbidden pairs
	# and replacing the 2nd node with a FORBIDDEN_REPLACER
	
	if(previousNodeType == OverworldNode.MAPNODETYPE_EMPTY):
		pass;
	else:
		for thisPairArr:Array in FORBIDDEN_PAIRS:
			if((thisPairArr[0] == previousNodeType) && (thisPairArr[1] == thisNode.nodeType)):
				thisNode.nodeType = FORBIDDEN_REPLACER[randi() % FORBIDDEN_REPLACER.size()];
	
	if(thisNode.childNodes.size() < 1): return;
	else:
		for thisChildIdx:int in range(thisNode.childNodes.size()):
			OverworldMapGenerator.scrubTree(thisNode.childNodes[thisChildIdx], thisNode.nodeType);
