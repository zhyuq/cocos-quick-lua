--[[--
zq UIText控件
-- @classmod UIText

]]
local UITextUnit = class("UITextUnit")

function UITextUnit:ctor()
    self:setText("");
    self:setFont("");
    self:setSize(0);
    self:setColor(nil);
    self:setStroke(nil, 0);
    self:setVisible(true);
    self:setUnderline(false);
    self:setIcon("");
    self:setX(0);
    self:setY(0);
    self:setW(0);
    self:setH(0);
end

function UITextUnit:setText(value)
    self._text = value
end

function UITextUnit:text()
    return self._text
end

function UITextUnit:setFont(value)
    self._font = value
end

function UITextUnit:font()
    return self._font
end

function UITextUnit:setColor(value)
    self._color = value
end

function UITextUnit:color()
    return self._color
end

function UITextUnit:setSize(value)
    self._size = value
end

function UITextUnit:size()
    return self._size
end

function UITextUnit:setSize(value)
    self._size = value
end

function UITextUnit:setStroke(color, width)
    self._stroke_color = color
    self._stroke_width = width
end

function UITextUnit:strokeColor()
    return self._stroke_color
end

function UITextUnit:strokeWidth()
    return self._stroke_width
end

function UITextUnit:setVisible(visible)
    self._visible = visible
end

function UITextUnit:visible()
    return self._visible
end

function UITextUnit:setUnderline(value)
    self._underline = value
end

function UITextUnit:underline()
    return self._underline
end

function UITextUnit:setIcon(value)
    self._icon = value
end

function UITextUnit:icon()
    return self._icon
end

function UITextUnit:setIcon(value)
    self._icon = value
end

function UITextUnit:setX(x)
    self._x = x
end

function UITextUnit:x()
    return self._x
end

function UITextUnit:setY(y)
    self._y = y
end

function UITextUnit:y()
    return self._y
end

function UITextUnit:setW(width)
    self._w = width
end

function UITextUnit:w()
    return self._w
end

function UITextUnit:setH(height)
    self._h = height
end

function UITextUnit:h()
    return self._h
end

function UITextUnit:clone()
    local clone = UITextUnit.new()
    clone:setText(self:text());
    clone:setFont(self:font());
    clone:setSize(self:size());
    clone:setColor(self:color());
    clone:setStroke(self:strokeColor(), self:strokeWidth());
    clone:setVisible(self:visible());
    clone:setUnderline(self:underline());
    clone:setIcon(self:icon());
    clone:setX(self:x());
    clone:setY(self:y());
    clone:setW(self:w());
    clone:setH(self:h());
    return clone
end


local UITextLine = class("UITextLine")

function UITextLine:ctor()
    self._units = {}

    self:setWidth(0);
    self:setHeight(0);
    self:setSpacing(0);
end

function UITextLine:units()
    return self._units
end

function UITextLine:setWidth(width)
    self._width = width
end

function UITextLine:width()
    return self._width
end

function UITextLine:setHeight(height)
    self._height = height
end

function UITextLine:height()
    return self._height
end

function UITextLine:setSpacing(spacing)
    self._spacing = spacing
end

function UITextLine:spacing()
    return self._spacing
end

function UITextLine:push(line)
    table.insert(self._units, line)
end

function UITextLine:append(array)
    for k,v in pairs(array) do
        self:push(v)
    end
end

zq.UITextUnit = UITextUnit
zq.UITextLine = UITextLine


