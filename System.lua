local pairs = pairs
local error = error
local Layer = require"Layer"

module("System")
return function(camera)
	local public = {}

	local _objectInfo = {}
	local _objectCount = 0
	local _unlayeredUpdates = {}

	local _layers = {}
	local _layerCount = 0

	local _camera = camera

	public.state = {}

	public.getCamera = function()
		return _camera
	end

	---
	-- Changes a layer to a given layer or adds a new layer to
	-- the front if no layerIndex is specified
	-- @param layer Layer to set
	-- @param [layerIndex] Layer index to set, if non is specified then layer is added to the front
	public.setLayer = function(layer, layerIndex)
		if _layers[layerIndex]  then
			_layers[layerIndex] = layer
		else
			_layerCount = _layerCount + 1
			_layers[_layerCount] = layer
		end
	end

	---
	-- Loads stage from Stage data
	-- @param stageData Stage to load
	public.loadStage = function(stageData)
		public.reset()

		local unlayered = stageData.unlayered
		for j=1,#unlayered do
			public.add(unlayered[j])
		end

		local layers = stageData.layers
		for i=1,#layers do
			local layer = layers[i]
			public.setLayer(Layer(layer.xParalax, layer.yParalax))
			local objects = layer.objects
			for j=1,#objects do
				public.add(objects[j], i)
			end
		end
	end


	---
	-- Adds an object to the system
	-- @param object Object to add
	-- @param [layerIndex] Optional layer index which to add the object
	-- @return object ID
	public.add = function(object, layerIndex)
		_objectCount = _objectCount + 1
		local ID = _objectCount
		local objectInfo = {object, layerIndex}

		_objectInfo[ID] = objectInfo

		local updateFun = object.update
		local drawFun = object.draw
		if layerIndex then
			local layer = _layers[layerIndex]
			if drawFun then
				layer.addDraw(drawFun, ID)
			end
			if updateFun then
				layer.addUpdate(updateFun, ID)
			end
		else
			if updateFun then
				_unlayeredUpdates[ID] = updateFun
			end
		end

		return ID
	end

	---
	-- Removes an object from the system
	-- @param objectID ID of object to remove
	public.remove = function(objectID)

		local objectInfo = _objectInfo[objectID]
		local layer = objectInfo[2]
		if objectInfo[2] then
			_layers[layer].remove(objectID)
		else
			_unlayeredUpdates[objectID] = nil
		end

		_objectInfo[objectID] = nil
	end

	---
	-- Updates the system
	-- @param dt Delta time passed between previous update
	public.update = function(dt)
		for _,updateFun in pairs(_unlayeredUpdates) do
			updateFun(dt, -_camera.x, -_camera.y)
		end

		for i=1, _layerCount do
			_layers[i].update(dt, -_camera.x, -_camera.y)
		end
	end

	public.reset = function()
		_objectInfo = {}
		_objectCount = 0
		_unlayeredUpdates = {}

		_layers = {}
		_layerCount = 0

		_camera.x = 0
		_camera.y = 0
		_camera.lock = nil
	end

	---
	-- Draws each layer in the system
	public.draw = function()
		for i=1, _layerCount do
			_layers[i].draw(-_camera.x, -_camera.y)
		end
	end

	return public
end
