Macroscript ConwayGOL 
category:"Conway"
(
	struct Cell
		(	
			myPos=undefined,
			myBox=undefined,
			myState=undefined,
			nextState=undefined,	

			--********************************************
			--DEBUG METHOD
			--Updates the current State of this cell based on its color
			--(Color  0      0     0  ) BLACK  means ALIVE
			--(Color 255 255 255) WHITE means DEAD
			--********************************************
			fn UpdateFromColor =
			(
					if(myBox.wirecolor==(color 0 0 0)) do
						(	
							--print "changed state"
							myState=true
						)
					if(myBox.wirecolor==(color 255 255 255)) do myState=false
			),
			--********************************************
			--Applies the stored next state of this cell and
			--updates its color accordingly
			--********************************************
			fn ApplyNextState =
			(
				myState=nextState
				print "changed state"
				if( myState==true)then myBox.wirecolor==(color 0 0 0)
											else myBox.wirecolor==(color 255 255 255)
			)
		)
		
	struct CellGrid
	(
		myGrid=#(),			--The instance of this struct grid
		cellSize=10,		--The X and Y size of the grid
		cellOffsets=#(	--Stored values for the offsets used to getting the  vneighbours of a specific cell
									[-1,-1],
									[0,-1],
									[1,-1],
									[-1,0],
									[1,0],
									[-1,1],
									[0,1],
									[1,1]
			),
		--********************************************	
		--CREATE A NEW VIRTUAL GRID
		--Creates the reference of the myGrid value using the cellSize 
		--value
		--********************************************
		fn CreateNewVirtualGrid size =
			(
				myGrid=#()
				for x=1 to size by 1 do
					(
						newRow=#()
						for y=1 to size by 1 do
						(
							newCell= Cell()
							newCell.myPos=[x,y]
							newCell.myState=false
							append newRow newCell
						)
						append myGrid newRow
					)
			),
		--********************************************	
		--Creates the 3d version of the virtual grid
		--	
		--********************************************	
		fn CreateNew3DGrid size =
			(
				currOffsetX=1
				currOffsetY=1
				for x=1 to size by 1 do
				(	
					for y=1 to size by 1 do
					(
						newBox = (Box width:1 height:1 length:1 pos:[currOffsetX,currOffsetY,0] wirecolor:(color 255 255 255) )
						myGrid[x][y].myBox=newBox
						currOffsetY=currOffsetY+1
					)	
					currOffsetY=1
					currOffsetX=currOffsetX+1					
				)				
			),
		--********************************************	
		--DEBUG METHOD
		--Update the virtual grid based on the modified colors 
		--applied to the 3d grid
		--********************************************	
		fn UpdateStateFromScene size=
			(				
				for x=1 to size by 1 do
				(
					for y=1 to size by 1 do
					(
						myGrid[x][y].UpdateFromColor()
					)
				)
			),		
			
		--********************************************	
		--GET THE VALUE OF THIS CELL    CHECK THIS
		--0 = DEAD
		--1 = ALIVE		
		--********************************************	
		fn GetCellState thePos =
			(
				theVal=0
				if(thePos.x>=1 and thePos.x<=10 and  thePos.y>=1 and thePos.y<=10)do
				(
					if(myGrid[thePos.x][thePos.y].myState==true) 	then theVal=1
																										else theVal=0				
				)	
				return theVal				
			),
		--------------------------------	
		--UPDATE THIS CELL
		--------------------------------	
		fn UpdateCell theCell =
			(
				if(theCell.myState==false)then
				(
						print "Started as dead"
						decisionMade=false
						aliveCount=0
						deadCount=0
						emptyCount=0
						for o=1 to 8 by 1 do
						(
							if(decisionMade==false)do
							(
								num=GetCellState [theCell.myPos.x+(cellOffsets[o].x) , theCell.myPos.y+(cellOffsets[o].y)]
								print ("Nehigbour "+o as string+" value is "+num as string)
								if(num==0)do deadCount=deadCount+1
								if(num==1)do aliveCount=aliveCount+1
								if(aliveCount>3) do decisionMade=true							
							)
						)	
						if(aliveCount==3) do (theCell.nextState=true	
															print "Ended as alive")					
				)
				else
				(
						print "Started as alive"					
						decisionMade=false
						aliveCount=0
						deadCount=0
						emptyCount=0
						for o=1 to 8 by 1 do
						(
							if(decisionMade==false)do
							(
								num=GetCellState [theCell.myPos.x+(cellOffsets[o].x) , theCell.myPos.y+(cellOffsets[o].y)]
								if(num==0)do deadCount=deadCount+1
								if(num==1)do aliveCount=aliveCount+1
								
								if(aliveCount==4) do decisionMade=true							
							)
						)	
						if(aliveCount==4) do (theCell.nextState=false
															print "Ended as dead"	)
						if(aliveCount<3) do (theCell.nextState=false
															print "Ended as dead"	)
				)
			),			
		--------------------------------	
		--GET THE NEXT STATE OF THE GRID
		--------------------------------			
		fn IterateGrid =
			(		
				--STORE NEXT STATES	
				for x=1 to cellSize by 1 do
				(
						for y=1 to cellSize by 1 do
						(
							UpdateCell (myGrid[x][y])
						)
				)
				--APPLY NEXT STATES
				for x=1 to cellSize by 1 do
				(
						for y=1 to cellSize by 1 do
						(
							myGrid[x][y].ApplyNextState()
						)
				)						
			),			
				
			fn DrawGrid gridState =
			(
			)
	)
	
	GC()
	
	local gridCreated=false
	local GridObject
	
	fn QueryCellNeighbours = 
	(
		myObj= PickObject()
		if (myObj != undefined) do
		(
				for x=1 to 10 by 1 do
				(
						for y=1 to 10 by 1 do
						(
							if(GridObject.myGrid[x][y].myBox == myObj) do
							(
									gridObject.UpdateCell  GridObject.myGrid[x][y]
							)
						)
				)		
		)	)

	fn QueryCell=
	(
		myObj= PickObject()
		if (myObj != undefined) do
		(
				for x=1 to 10 by 1 do
				(
						for y=1 to 10 by 1 do
						(
							if(GridObject.myGrid[x][y].myBox == myObj) do
							(
									print GridObject.myGrid[x][y].myState
							)
						)
				)		
		)
	)
	
	rollout Conway "Game Of Life"
	(
		
		button btnCreateGrid "Create new Grid " align:#center
		
		button btnMakeBlack "Set  as Live" align:#center
		
		button btnGetState "Get State " align:#center
		
		button btnQueryState "Query Cell" align:#center
		
		button btnQueryCellNeighbours "Query Neighbours" align:#center
		
		button btnIterateState "Iterate State " align:#center
		
		on btnCreateGrid pressed do
		(
			if(gridCreated==false)do
			(
					gridCreated=true
					btnCreateGrid.enabled=false
					GridObject=CellGrid()	
					GridObject.CreateNewVirtualGrid (GridObject.cellSize)					
					GridObject.CreateNew3DGrid (GridObject.cellSize)
			)
		)		
		
		on btnMakeBlack pressed do
		(
				for o in selection do o.wirecolor = (color 0 0 0)
		)
		
		on btnGetState pressed do
		(
			GridObject.UpdateStateFromScene GridObject.cellSize
		)
		
		on btnQueryState pressed do
		(
				QueryCell()
		)
		
		on btnQueryCellNeighbours pressed do
		(
				QueryCellNeighbours()
		)
		
		on btnIterateState  pressed do
		(
			GridObject.IterateGrid()
		)
		
	)	
	CreateDialog Conway width:100 height:150

)
