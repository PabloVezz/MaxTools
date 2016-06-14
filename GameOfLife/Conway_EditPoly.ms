Macroscript EditPolyConway
category:"Matanga"
(
	theObj=$					--The object (EDITABLE POLY)
	theFacesNeighbours= #()		--This is where the list of each faces neighbours is going to be cached
	nextState=#()				--This is where the values for the next Generation are going to be placed
	debugOn=false
	


	fn GetFaceNeighboursCache =
	(
	
		subobjectLevel = 4			--For some reason we need to go into face mode in order fot the GROWSELECTION command to work

		for x=1 to polyOp.getNumFaces theObj do 
		(	
			theObj.EditablePoly.SetSelection #Face #{x}	--Select the current face
			theObj.EditablePoly.GrowSelection ()		--Grow the selection
			
			theSelection=polyOp.getFaceSelection theObj	--Store the bit collection
			
			theIndex= findItem theSelection x 			--Find the index that corresponds to the current face
			deleteItem theSelection theIndex			--Remove that index from the neighbours list
			
			append theFacesNeighbours theSelection		--Add this faces neighbours list to the cache
		)
		theObj.EditablePoly.SetSelection #Face #{}		--Deselect all faces
		subobjectLevel = 0								--Go back to object mode
	)

	fn UpdateLiveCell theFaceIndex =
	(
		if(isDebugOn==true) do print "Started as alive"
		decisionMade=false
		aliveCount=0
		deadCount=0
		emptyCount=0
		for o in theFacesNeighbours[theFaceIndex] do
		(
			if(decisionMade==false)do
			(					
				num= theObj.GetFaceMaterial o					
				if(num==1)do deadCount=deadCount+1
				if(num==2)do aliveCount=aliveCount+1
				--print num
				if(aliveCount==4) do decisionMade=true
			)
		)
		if(aliveCount > 3 or aliveCount < 2 ) then 
		(
			append nextState 1  
			if(isDebugOn==true) do print "Ended as dead" 
		)
		else
		(
			append nextState 2
			if(isDebugOn==true) do print "Ended as Alive"
		)

	)
	
	fn UpdateDeadCell theFaceIndex =
	(
		if(isDebugOn==true) do print "Started as dead"
		decisionMade=false
		aliveCount=0
		deadCount=0
		emptyCount=0
		for o in theFacesNeighbours[theFaceIndex] do
		(
			if(decisionMade==false)do
			(
				num= theObj.GetFaceMaterial o					
				if(num==1)do deadCount=deadCount+1
				if(num==2)do aliveCount=aliveCount+1
				--print num
				if(aliveCount==4) do decisionMade=true
			)
		)
		
		if(aliveCount==4) do 
		(
			append nextState 1 
			if(isDebugOn==true) do print "Ended as dead" 
		)
		if(aliveCount==3)do 
		(
			append nextState 2
			if(isDebugOn==true) do print "Ended as Alive" 
		)
		if(aliveCount<3) do 
		(
			append nextState 1 
			if(isDebugOn==true) do print "Ended as dead" 
		)
	)

	fn ApplyNextState =
	(
		for x=1 to polyOp.getNumFaces theObj do 
		(
			sele=#{x}
			polyop.setFaceMatID theObj sele nextState[x]
		)	
		
	)		

	fn IterateObj =
	(
		nextState=#()
		for x=1 to polyOp.getNumFaces theObj do 
		(
			if((theObj.GetFaceMaterial x)==1) do UpdateDeadCell x
			if((theObj.GetFaceMaterial x)==2) do UpdateLiveCell x
		)
		ApplyNextState()
	)

	Rollout roConwayGOL "Conway"
	(		
		pickbutton pbChooseObj "Select Object" width:140 
		
		button btnIterate "Iterate"
		
		on btnIterate pressed do
		(
			IterateObj()
		)
	
		on pbChooseObj picked val do
		(
			theObj=val
			pbChooseObj.text=val.name
			GetFaceNeighboursCache()
		)
	)

	createDialog roConwayGOL width:200 height:250

)
