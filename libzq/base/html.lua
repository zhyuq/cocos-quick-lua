-- $Id: html.lua,v 1.2 2007-05-12 04:37:20 tclua Exp $

module(..., package.seeall)

entity = {
  nbsp = " ",
  lt = "<",
  gt = ">",
  quot = "\"",
  amp = "&",
}

-- keep unknown entity as is
setmetatable(entity, {
  __index = function (t, key)
    return "&" .. key .. ";"
  end
})

tags = {
  font = {empty = false}
}

setmetatable(tags, {
  __index = function (t, key)
    return {empty = false}
  end
})

-- string buffer implementation
function newbuf ()
  local buf = {
    _buf = {},
    clear =   function (self) self._buf = {}; return self end,
    content = function (self) return table.concat(self._buf) end,
    append =  function (self, s)
      self._buf[#(self._buf) + 1] = s
      return self
    end,
    set =     function (self, s) self._buf = {s}; return self end,
  }
  return buf
end

-- unescape character entities
function unescape (s)
  function entity2string (e)
    return entity[e]
  end
  return s.gsub(s, "&(#?%w+);", entity2string)
end

-- iterator factory
function makeiter (f)
  local co = coroutine.create(f)
  return function ()
    local code, res = coroutine.resume(co)
    return res
  end
end

-- constructors for token
function Tag (s)
  return string.find(s, "^</") and
    {type = "End",   value = s} or
    {type = "Start", value = s}
end

function Text (s)
  local unescaped = unescape(s)
  return {type = "Text", value = unescaped}
end

-- lexer: text mode
function text (f, buf)
  local c = f:read(1)
  if c == "<" then
    if buf:content() ~= "" then coroutine.yield(Text(buf:content())) end
    buf:set(c)
    return tag(f, buf)
  elseif c then
    buf:append(c)
    return text(f, buf)
  else
    if buf:content() ~= "" then coroutine.yield(Text(buf:content())) end
  end
end

-- lexer: tag mode
function tag (f, buf)
  local c = f:read(1)
  if c == ">" then
    coroutine.yield(Tag(buf:append(c):content()))
    buf:clear()
    return text(f, buf)
  elseif c then
    buf:append(c)
    return tag(f, buf)
  else
    if buf:content() ~= "" then coroutine.yield(Tag(buf:content())) end
  end
end

function parse_starttag(tag)
  -- print(tag)
  local tagname = string.match(tag, "<%s*(%w+)")
  local elem = {_attr = {}}
  elem._tag = tagname
  -- print(tagname)
  for key, _, val, _ in string.gmatch(tag, "(%w+)%s*=%s*([\"']?)([^\"'%s>]+)(%2)", i) do
    -- print(key)
    -- print(val)
    -- print(val2)
    local unescaped = unescape(val)
    elem._attr[key] = unescaped
  end
  return elem
end

function parse_endtag(tag)
  local tagname = string.match(tag, "<%s*/%s*(%w+)")
  return tagname
end

-- find last element that satisfies given predicate
function rfind(t, pred)
  local length = #t
  for i=length,1,-1 do
    if pred(t[i]) then
      return i, t[i]
    end
  end
end

function flatten(t, acc)
  acc = acc or {}
  for i,v in ipairs(t) do
    if type(v) == "table" then
      flatten(v, acc)
    else
      acc[#acc + 1] = v
    end
  end
  return acc
end

function optional_end_p(elem)
  return false
end

function valid_child_p(child, parent)
    return true
end

-- tree builder
function parse(f)
  local root = {}
  local stack = {root}
  for i in makeiter(function () return text(f, newbuf()) end) do
    if i.type == "Start" then
      local new = parse_starttag(i.value)
      local top = stack[#stack]

      -- while
      --   top._tag ~= "#document" and
      --   optional_end_p(top) and
      --   not valid_child_p(new, top)
      -- do
        -- stack[#stack] = nil
        -- top = stack[#stack]
      -- end

      top[#top+1] = new -- appendchild
      -- if not tags[new._tag].empty then
        stack[#stack+1] = new -- push
      -- end
    elseif i.type == "End" then
      local tag = parse_endtag(i.value)
      local openingpos = rfind(stack, function(v)
          if v._tag == tag then
            return true
          else
            return false
          end
        end)
      if openingpos then
        local length = #stack
        for j=length,openingpos,-1 do
          table.remove(stack, j)
        end
      end
    else -- Text
      local top = stack[#stack]
      top[#top+1] = i.value
    end
  end
  return root
end

function parsestr(s)
  local handle = {
    _content = s,
    _pos = 1,
    read = function (self, length)
      if self._pos > string.len(self._content) then return end
      local ret = string.sub(self._content, self._pos, self._pos + length - 1)
      self._pos = self._pos + length
      return ret
    end
  }
  return parse(handle)
end
