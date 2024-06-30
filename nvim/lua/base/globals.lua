local uname = vim.loop.os_uname()

_G.OS = uname.sysname
_G.IS_MAC = OS == "Darwin"
_G.IS_LINUX = OS == "Linux"
_G.IS_WINDOWS = OS:find("Windows") and true or false
_G.IS_WSL = (function()
    local output = vim.fn.systemlist("uname -r")
    local condition1 = IS_LINUX and uname.release:lower():find("microsoft") and true or false
    local condition2 = not (not string.find(output[1] or "", "WSL"))
    return condition1 or condition2
end)()

-- Wrapper of print + vim.inspect
P = function(v)
    print(vim.inspect(v))
    return v
end

-- Compiling command
function CompileRun()
    vim.cmd("w")
    if vim.bo.filetype == "c" then
        vim.cmd("!gcc % -o %<")
        vim.cmd("!time ./%<")
    elseif vim.bo.filetype == "cpp" then
        vim.cmd("!g++ % -o %<")
        vim.cmd("!time ./%<")
    elseif vim.bo.filetype == "java" then
        vim.cmd("!javac %")
        vim.cmd("!time java %")
    elseif vim.bo.filetype == "sh" then
        vim.cmd("!time bash %")
    elseif vim.bo.filetype == "python" then
        vim.cmd("!time python3 %")
    elseif vim.bo.filetype == "html" then
        vim.cmd("!google-chrome % &")
    elseif vim.bo.filetype == "go" then
        vim.cmd("!go build %<")
        vim.cmd("!time go run %")
    elseif vim.bo.filetype == "matlab" then
        vim.cmd("!time octave %")
    end
end

-- option and bufopt with desc
opt_s = function(description)
    local o = {
        noremap = true,
        silent = true
    }
    o["desc"] = description
    return o
end

bopt_s = function(description)
    local o = {
        noremap = true,
        silent = true,
        buffer = bufnr
    }
    o["desc"] = description
    return o
end
