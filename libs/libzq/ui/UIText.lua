--[[--
zq UIText控件
-- @classmod UIText

]]
kZQTextAlignment = {
    Left    = 0,
    Right   = 1,
    Center  = 2
}

local UIImage = import(".UIImage")
local UIText = class("UIText", UIImage)

function UIText:ctor()
    UIText.super.ctor(self)

    self._lines = {}
    self._units = {}
    self._icons = {}

    self._char_map = {}

    self._global_fontname = zq.ZQTextUtil:getInstance():standardFontName()
    self._global_fontcolor = cc.WHITE
    self._global_fontsize = 23.0
    self._global_strokecolor = zq.intToc3b(0xff0000)
    self._global_strokewidth = 0
    self._global_linespacing = 0
    self._global_alignment = kZQTextAlignment.Left
    self._texture_scale = math.max(1.0, _S(1.0))
    self:setTextureScale(self._texture_scale)
end

function UIText:count()
    return #self._units;
end

function UIText:lineCount()
    return #self._lines;
end

function UIText:setText(text, font_color, font_size, underline, icon)
    self:removeAllText()
    self:insertText(self:count(), text, font_color, font_size, underline, icon)
    self:generate()
end

function UIText:addText(text, font_color, font_size, underline, icon)
    self:insertText(self:count(), text, font_color, font_size, underline, icon)
end

function UIText:insertText(index, text, font_color, font_size, underline, icon)
    if index < 0 or index > self:count() then
        return
    end

    text = text or ""
    font_color = font_color or self:globalFontColor()
    font_size  = font_size or self:globalFontSize()
    underline = underline or false
    icon = icon or nil

    local unit = zq.UITextUnit.new()
    unit:setFont(self:globalFontName())
    unit:setText(text)
    unit:setColor(font_color)
    unit:setSize(font_size*self._texture_scale)
    unit:setUnderline(underline)
    unit:setIcon(icon)
    unit:setStroke(self:globalStrokeColor(), self:globalStrokeWidth())
    unit:setVisible(not icon)

    table.insert(self._units, unit)
end

function UIText:setRichText(text, font_color, font_size)
    self:removeAllText()
    self:addRichText(text, font_color, font_size)
    self:generate()
end

function UIText:addRichText(text, font_color, font_size)
    if font_color then
        self:setGlobalFontColor(font_color)
    end

    if font_size then
        self:setGlobalFontSize(font_size)
    end

    local dealHtml
    dealHtml = function (html_table)
        local text_units = {}
        for i,v in ipairs(html_table) do
            if type(v) == "table" then
                local tmp = dealHtml(v)
                for i,val in ipairs(tmp) do
                    table.insert(text_units, val)
                end
            else
                local unit = {}
                local text = v
                if string.len(text) then
                    unit["_text"] = text
                    table.insert(text_units, unit);
                end

                if (html_table["_attr"]) then
                    unit["_attr"] = html_table["_attr"]
                end
            end
        end

        return text_units
    end

    local html_table = html.parsestr(text)
    local text_units = dealHtml(html_table)
    for i,unit in ipairs(text_units) do
        local body = unit["_text"]
        local attrs = unit["_attr"]
        local color = attrs and attrs["color"] and zq.hexToc3b(attrs["color"]) or self:globalFontColor()
        local size = attrs and attrs["size"] or self:globalFontSize()
        local underline = attrs and attrs["underline"] or "false"
        local image = attrs and attrs["image"] or nil
        self:addText(body, color, size, underline == "true", image)
    end

end

function UIText:setTextureScale(scale)
    local func = tolua.getcfunction(self, "setTextureScale")
    if func then
        func(self, scale)
    end

    self._texture_scale = scale
end

function UIText:generate()
    self:engine();

    self:render();
end

function UIText:engine()
    self._lines = {}
    self._final_size = cc.size(0, 0)
    local x_indent = self._global_strokewidth
    local y_indent = self._global_strokewidth*0.5
    local x_start = x_indent
    local y_start = y_indent
    local w_total = 0
    local h_total = 0
    local cache = {}
    local height = 0
    local w_limit = self._layout_width or self._fixed_width or zq.Int32Max
    for k,v in ipairs(self._units) do
        local unit = v
        local text = unit:text()
        local frag = ""
        local width = 0
        local unit_h = 0

        local part = unit:clone()
        part:setText("")

        while text do
            -- ZQLogD("text %s", text)
            -- ZQLogD("text len: %d", utf8.len(text))
            local ch = utf8.sub(text, 1, 1) or ""
            local unicode = utf8.unicode(ch, 1, 1)

            if unicode >= 0x1F300 and unicode <= 0x1F64F then

            end

            local sz = self:charSize(ch, unicode, unit:font(), unit:size())
            -- ZQLogD("ch %s width %d height %d", ch, sz.width, sz.height)
            height = math.max(height, sz.height)
            unit_h = math.max(unit_h, sz.height)
            if sz.width > w_limit then
                self._lines = {}
                error("max ")
                return
            end

            local is_newline = ch == "\n" or ch == "\r"
            local is_overflow = x_start + width + sz.width > w_limit
            -- ZQLogD("is_overflow %s", tostring(is_overflow))
            local is_break = is_newline or is_overflow
            -- ZQLogD("is_break %s", tostring(is_break))
            local is_last = fif(utf8.len(text) <= math.max(1, utf8.len(ch)), true, false)
            local is_finish = k == #self._units and is_last

            if not is_break then
                frag = frag .. ch
                width = width + sz.width
            end

            if (is_last or is_break) and string.len(frag) > 0 then
                part:setText(frag)
                part:setX(x_start)
                part:setY(y_start)
                part:setW(width)
                part:setH(unit_h)
                table.insert(cache, part)

                part = unit:clone()
                part:setText("")

                unit_h = 0
                x_start = x_start + width
            end

            if (is_break or is_finish) and #cache > 0 then
                local line = zq.UITextLine.new()
                line:append(cache)
                line:setWidth(x_start)
                line:setHeight(height)
                line:setSpacing(self:globalLineSpacing()*self._texture_scale)
                table.insert(self._lines, line)

                w_total = math.max(w_total, x_start)
                h_total = y_start + height
            end

            if is_break then
                frag = ""
                x_start = x_indent
                y_start = y_start + height
                -- ZQLogD("y_start %s height %s", tostring(y_start), tostring(height))
                width = 0
                height = 0
                cache = {}

                if not is_last then
                    part = unit:clone()
                    part:setText("")
                end
            end

            if is_newline or not is_overflow then
                text = fif(utf8.len(text) > utf8.len(ch), utf8.sub(text, math.max(2, utf8.len(ch)+1)), nil)
                -- ZQLogD("text new %s", text)
            end
        end

    end

    w_total = w_total + x_indent
    h_total = h_total + y_indent

    if self._fixed_width then
        w_total = self._fixed_width
    end

    local offset = 0
    local distance = 0
    for i, line in ipairs(self._lines) do
        offset = w_total - line:width()
        distance = distance + fif(i == 1, 0, self:globalLineSpacing()*self._texture_scale)

        local units = line:units()
        for j, unit in ipairs(units) do
            unit:setY(unit:y() + line:height() - unit:h() + distance)

            local globalAlignment = self:globalAlignment()
            if globalAlignment == kZQTextAlignment.Right then
                unit:setX(unint:x() + offset)
            elseif globalAlignment == kZQTextAlignment.Center then
                unit:setX(unint:x() + offset*0.5)
            end

            local unit_size = cc.size(unit:w(), unit:h())
            if unit:icon() then

            end

        end

    end

    h_total = h_total + distance
    self._final_size = cc.size(w_total, h_total)

end

function UIText:preprocessLines()
    local lines = {}
    for k,v in pairs(self._lines) do
        local line = {}
        for orig_key, orig_value in pairs(v) do
            if type(orig_value) ~= "function" and tostring(orig_key) ~= "class"
                and tostring(orig_key) ~= "_units" then
                line[orig_key] = orig_value
            elseif orig_key == "_units" then
                local units = {}
                for unitk0,unitv0 in pairs(orig_value) do
                    local unit = {}
                    -- dump(unitv0)

                    for unitk1,unitv1 in pairs(unitv0) do
                        if type(unitv1) ~= "function" and tostring(unitk1) ~= "class" then
                            unit[unitk1] = unitv1
                        end
                    end
                    units[unitk0] = unit
                end

                line["_units"] = units
            end
        end
        lines[k] = line
    end
    -- for k,v in pairs(lines) do
    --     print(k,v)
    -- end
    -- dump(lines[1]["_units"])
    return lines
end

function UIText:render()
    local lines = self:preprocessLines()
    local width = self._final_size.width/self._texture_scale
    local height = self._final_size.height/self._texture_scale
    -- ZQLogD("_texture_scale = %f", self._texture_scale)
    if (not zq.ZQTextUtil:getInstance():renderByArray(self, lines, self._final_size.width, self._final_size.height)) then
        self:clearSprite()
        return
    end

    local texture = self:getTexture()
    local size = texture:getContentSize()
    self:setTextureRect(cc.rect(0, 0, size.width, size.height), false, cc.size(width, height))

    -- if self._fixed_width then
    --     self:setWidth(self._fixed_width/self._texture_scale)
    -- end
end

function UIText:charSize(utfChar, unicode, font_name, font_size)
    if utfChar == "\r" or utfChar == "\n" then
        return cc.size(0, 0)
    end

    if unicode >= 0x4e00 and unicode <= 0x9fa5 then
        local key = font_name .. tostring(font_size)
        local find = self._char_map[key]
        if find then
            return find
        end

        local size = zq.ZQTextUtil:getInstance():sizeByFont(utfChar, font_name, font_size)
        self._char_map[key] = size
        return size
    else
        return zq.ZQTextUtil:getInstance():sizeByFont(utfChar, font_name, font_size)
    end


end

function UIText:iconClear()
    for k,v in pairs(self._icons) do
        v:removeFromParent(true)
    end

    self._icons = {}
end

function UIText:setGlobalFontName(font_name)
    self._global_fontname = font_name
end

function UIText:setGlobalFontSize(font_size)
    self._global_fontsize = font_size
end

function UIText:setGlobalFontColor(font_color)
    self._global_fontcolor = font_color
end

function UIText:setGlobalStrokeWidth(stroke_width)
    self._global_strokewidth = stroke_width
end

function UIText:setGlobalStrokeColor(stroke_color)
    self._global_strokecolor = stroke_color
end

function UIText:setGlobalLineSpacing(line_spacing)
    self._global_linespacing = line_spacing
end

function UIText:setGlobalAlignment(alignment)
    self._global_alignment = alignment
end

function UIText:setLayoutWidth(width)
    self._layout_width = width*self._texture_scale
end

function UIText:setFixedWidth(width)
    self._fixed_width = width*self._texture_scale
end

function UIText:globalFontName()
    return self._global_fontname
end

function UIText:globalFontSize()
    return self._global_fontsize
end

function UIText:globalFontColor()
    return self._global_fontcolor
end

function UIText:globalStrokeWidth()
    return self._global_strokewidth
end

function UIText:globalStrokeColor()
    return self._global_strokecolor
end

function UIText:globalLineSpacing()
    return self._global_linespacing
end

function UIText:globalAlignment()
    return self._global_alignment
end

function UIText:removeAllText()
    self._units = {}
end

function UIText:clearAllText()
    for k,v in pairs(self._units) do
        v:setText("")
    end
end


return UIText
