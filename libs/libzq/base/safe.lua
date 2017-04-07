local Safe = zq.Safe or {}

function Safe.exec(func)
    if Safe._callback then
        xpcall(func, Safe._callback)
    else
        local status, exception = pcall(func)
        if not status then
            error(exception, 2)
        end
    end
end

function Safe.bind(callback)
    Safe._callback = callback
end

zq.Safe = Safe

return Safe



