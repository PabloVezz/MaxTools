macroScript SetupNavNodes 
Category:"Matanga" 
toolTip:"SetupNavNodes"
(
	
	
	function GetName stringStr = 
	(	
		newStringStream = stringStr as stringstream
		nodeIndex = (readDelimitedString newStringStream "_" ) 
		return nodeIndex
	)
	
	parentNode = PickObject()
	
	
	
	for child in parentNode.children do
	(
		escPressed =false
		select child
		newName= child.name
		while (escPressed ==false) do
		(
			pickedNode =PickObject()
			if (pickedNode != undefined ) and  (classof pickedNode ==Dummy )do
			(
				newName = newName+"_"+(GetName pickedNode.name)
				child.name=newName 
			)
			if(keyboard.escPressed==true) do escPressed=true
		)		
	)






)