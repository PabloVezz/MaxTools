macroScript CreateNavNodes Category:"Matanga" toolTip:"CreateNavNodes"
(
	distThresh = 30
	dummySize = 50
	
	
	function DoProcess curObj =(		
			
			nodeParent= getnodebyname "NodeParent"		
			if nodeParent.children.count >0 do
			(
				for i = nodeParent.children.count to 1 by -1 do
				(
						delete nodeParent.children[i]
				)
			)		
		
			if classOf curObj == splineShape or classof curObj == Line then
			(
				nodesCreated=0
				--For Each spline 
				for s = 1 to (numsplines curObj) do
				(
					--For each Knot
					for k = 1 to (numknots curObj s) do 
					(
							--Knot Thresholdh
							closeByFound = false
							
						for child in nodeParent.children do
						(
							theDistance = distance child.pos  (getKnotPoint curObj s k)
							if( theDistance < distThresh)	do closeByFound= true					
						)
						
						if (closeByFound == false)  do
						(			
							nodesCreated=nodesCreated+1
							posNew = getKnotPoint curObj s k
							newDummy = Dummy pos: posNew isSelected:offs
							newDummy.name=( nodesCreated as string)
							newDummy.parent = nodeParent		
							newDummy.boxsize =[dummySize,dummySize,dummySize]
							layer = LayerManager.getLayerFromName "Road_Nodes"
							layer.addnode newDummy			 					
						)							
					)
				)
				print("Finished")			
			)
			else
				messagebox "Select only one spline!" title:"Script Error!!!"
		)


		rollout DoNavNodes "Redraw Spline"
		(
				spinner spnSegmentCount "Proximity threshold" range:[1,1000,20] type:#float align:#left 
				spinner spnDummySize "Dummy Size" range:[1,1000,20] type:#float align:#left 

				button btnDoit "Pick Spline" align:#center tooltip:"Must pick spline or it wont work"
				
				on spnSegmentCount changed val do distThresh = val
				on spnDummySize changed val do dummySize = val
					
				on btnDoit pressed do with undo on
				(
					obj = PickObject()
					DoProcess obj
					
							
				)
		)
	
	createDialog DoNavNodes
)