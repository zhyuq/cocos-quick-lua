
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

require("prefix")

function main()
    ZYWorld:getInstance():change(ZYSceneDebug)
end

xpcall(main, __G__TRACKBACK__)



