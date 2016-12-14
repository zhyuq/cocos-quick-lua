--[[--
   	Array: Lua ES6 Array like implementation
	refer: https://github.com/iskolbin/larrayes6
	all index began 1, like lua table
	Instructions for use: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array
]]

local Array = {
	TypeError = 'Array: TypeError',
	RangeError = 'Array: RangeError',
	MAX_RANGE = 2^32 - 1,
}

Array.__index = Array

--- Array.new
-- Array({lua index table})
-- Array(Array)
-- Array(element0, element1[, ...[, elementN]])
-- Array(arrayLength)
-- Parameters
-- elementN
-- A JavaScript array is initialized with the given elements,
-- except in the case where a single argument is passed  to the Array constructor
-- and that argument is a number (see the arrayLength parameter below).
-- Note that this special case only applies to JavaScript arrays created with the Array constructor,
-- not array literals created with the bracket syntax.
-- arrayLength
-- If the only argument passed to the Array constructor is an integer between 0 and 2^32-1 (inclusive),
-- this returns a new JavaScript array with length set to that number.
-- If the argument is any other number, a RangeError exception is thrown.
function Array.new( ... )
	local paramNum = select('#', ...)
	if paramNum == 1 and type(...) == "table" then
		return Array.newFromLuaTable(select(1, ...))
	elseif paramNum == 1 and type(...) == 'number' then
		return Array.alloc(...)
	else
		return Array.of( ... )
	end
end

-- Array({lua index table}) and Array(Array)
function Array.newFromLuaTable( table )
	local self = {}
	for i,v in pairs(table) do
		self[i] = v
	end
	self.length = #table
	return setmetatable(self, Array)
end

-- Array(element0, element1[, ...[, elementN]])
function Array.of( ... )
	local self = {...}
	self.length = #self
	return setmetatable( self, Array )
end

-- Array(arrayLength)
-- @param n arrayLength
-- @param v initial value
function Array.alloc( n, v )
	if type( n ) ~= 'number' then
		error( Array.TypeError )
	elseif n < 0 or n > Array.MAX_RANGE then
		error( Array.RangeError )
	end

	local self = Array.of()
	self.length = n
	v = v or nil
	for i = 1, n do
		self[i] = v
	end
	return self
end

function Array.isArray( obj )
	return getmetatable( obj ) == Array
end

function Array:isEmpty()
	if self.length == 0 then
		return true
	end

	return false
end

--- The slice() method returns a shallow copy of a portion of an array into a new array object
-- selected from begin to end (end not included). The original array will not be modified.
-- if want to contain end, to pass by value (omitted or Array.length+1)
function Array:slice( from, to )
	local n = self.length
	from = math.max( 1, (not from and 1) or from < 0 and from + n + 1 or from )
	to = math.min( n+1, (not to and n+1) or to < 0 and to + n + 1 or to )
	local out = Array()
	local k = 0
	for i = from, to-1 do
		k = k + 1
		out[k] = self[i]
	end
	out.length = math.max( 0, to-from )
	return out
end

function Array:splice( ... )
	local from, delcount = ...
	local n = self.length
	local out = Array.of()
	local m = select('#', ... ) - 2
	if m <= -2 then
		return out
	elseif m == -1 then
		delcount = n - from + 1
		m = 0
	end

	from = math.max( 1, (not from and 1) or from < 0 and from + n + 1 or from )
	delcount = math.max(0, math.min(delcount or 0, n - from + 1))

	out.length = delcount
	local k = 0
	for i = from, from+delcount-1 do
		k = k + 1
		out[k] = self[i]
	end

	if m > delcount then
		for i = n+1, n + m - delcount do
			self[i] = nil
		end
		for i = n + m - delcount, from + m - delcount, -1 do
			self[i] = self[i-m]
		end
	elseif m < delcount then
		for i = from + m, n-delcount+m do
			self[i] = self[i+delcount-m]
		end
		for i = n + m - delcount + 1, n do
			self[i] = nil
		end
	end

	for i = 1, m do
		self[from+i-1] = select( i+2, ... )
	end
	self.length = n + m - delcount
	return out
end

function Array:copyWithin( target, from, to )
	local n = self.length
	target = math.max( 1, (not target and 1) or target < 0 and target + n + 1 or target )
	if target >= n then
		return self
	end
	from = math.max( 1, (not from and 1) or from < 0 and from + n + 1 or from )
	to = math.min( n+1, math.max( 1, (not to and n) or to < 0 and to + n + 1 or to ))

	local buffer = self:slice( from, to )
	local num = 1
	if n - target + 1 < buffer.length then
		num = n - target + 1
	else
		num = buffer.length
	end
	for i = 1, num do
		self[i+target-1] = buffer[i]
	end
	return self
end

function Array:get( i )
	return self[i]
end

function Array:set( i, v )
	if i <= 0 then
		error(Array.RangeError)
	end

	local n = self.length
	if i > n then
		for j = n+1, i do
			self[j] = nil
		end
		self.length = i
	end

	self[i] = v
end

function Array:fill( v, from, to )
	local n = self.length
	from = math.max( 1, (not from and 1) or from < 0 and from + n + 1 or from)
	to = math.min( n, (not to and n) or to < 0 and to + n + 1 or to )
	for i = from, to do
		self[i] = v
	end
	return self
end

function Array:concat( arr )
	local out = self:slice()
	local k = out.length
	for i = 1, #arr do
		k = k + 1
		out[k] = arr[i]
	end
	out.length = k
	return out
end

function Array:every( p )
	for i = 1, self.length do
		if not p( self[i], i, self ) then
			return false
		end
	end
	return true
end

function Array:some( p )
	for i = 1, self.length do
		if p( self[i], i, self ) then
			return true
		end
	end
	return false
end

function Array:filter( p )
	local out = Array.of()
	local k = 0
	for i = 1, self.length do
		if p( self[i], i, self ) then
			k = k + 1
			out[k] = self[i]
		end
	end
	out.length = k
	return out
end

function Array:find( p )
	for i = 1, self.length do
		if p( self[i], i, self ) then
			return self[i]
		end
	end

	return nil
end

function Array:findIndex( p )
	for i = 1, self.length do
		if p( self[i], i, self ) then
			return i
		end
	end

	return -1
end

function Array:forEach( f )
	for i = 1, self.length do
		f( self[i], i, self )
	end
end

function Array:includes( v, from )
	return self:indexOf( v, from ) ~= -1
end

function Array:indexOf( v, from )
	from = (not from and 1) or from < 0 and from + self.length + 1 or from
	for i = from, self.length do
		if self[i] == v then
			return i
		end
	end

	return -1
end

function Array:join( sep )
	local t = {}
	for i = 1, self.length do
		t[i] = tostring( self[i] )
	end
	return table.concat( t, sep or ',' )
end

function Array:lastIndexOf( v, from )
	local n = self.length
	from = (not from and n) or from < 0 and from + n + 1 or from
	for i = from, 1, -1 do
		if self[i] == v then
			return i
		end
	end
	return -1
end

-- The map() method creates a new array with the results of calling a provided function
-- on every element in this  array.
function Array:map( f )
	local out = Array.of()
	for i = 1, self.length do
		out[i] = f( self[i], i, self )
	end
	out.length = self.length
	return out
end

function Array:pop()
	if self.length > 0 then
		local v = self[self.length]
		self[self.length] = nil
		self.length = self.length - 1
		return v
	end
end

function Array:push( ... )
	for i = 1, select( '#', ... ) do
		self.length = self.length + 1
		self[self.length] = select( i, ... )
	end
	return self.length
end

function Array:reduce( f, init )
	local n = self.length
	local j = 1
	if init == nil then
		if self.length <= 0 then
			error( 'Reduce of empty Array with no initial value' )
		else
			init = self[1]
			j = 2
		end
	end

	for i = j, n do
		init = f( init, self[i], i, self )
	end

	return init
end

function Array:reduceRight( f, init )
	local n = self.length
	local j = n
	if init == nil then
		if self.length <= 0 then
			error( 'Reduce of empty array with no initial value' )
		else
			init = self[n]
			j = n-1
		end
	end

	for i = j, 1, -1 do
		init = f( init, self[i], i, self )
	end

	return init
end

function Array:reverse()
	local out = Array.of()
	local n = self.length
	for i = 1, n do
		out[n-i+1] = self[i]
	end
	out.length = n
	return out
end

function Array:shift()
	if self.length > 0 then
		local v = table.remove( self, 1 )
		self.length = self.length - 1
		return v
	end
end

function Array:unshift( ... )
	for i = 1, select('#', ... ) do
		local v = select( i, ... )
		table.insert( self, i, v )
		self.length = self.length + 1
	end
	return self.length
end

function Array:sort( cmp )
	table.sort( self, cmp )
	return self
end

function Array:toString()
	if self.length == 0 then
		return 'Array length is 0'
	end

	return '[' .. self:join() .. ']'
end

-- return lua table {1, 2, ...}
function Array:keys()
	local keys = {}
	for i=1, self.length do
		table.insert(keys, i)
	end

	return keys
end

-- return lua table {value1, value2, ...}
function Array:values()
	local values = {}
	for i=1, self.length do
		table.insert(values, self[i])
	end

	return values
end

function Array:ipairs()
	return function(...)
		local _, i = ...
		i = i or 0
		if i < self.length then
			return i+1, self[i+1]
		end
	end
end

-- lua 5.2 later, do not use
function Array:__ipairs()
	return self:ipairs()
end

-- lua 5.2 later, do not use
function Array:__pairs()
	return self:ipairs()
end

function Array:__tostring()
	return self:toString()
end

function Array:__len()
	return self.length
end

function Array.__newindex(t, k, v)
	if type(k) == 'number' then
		if k > t.length then
			for i=1, k do
				if i > t.length then
					rawset(t, i, nil)
				end
			end

			t.length = k
		end
	end

	rawset(t, k, v)
end

return setmetatable( Array,
	{
	__call = function(_,...)
		return Array.new( ... )
	end
})
