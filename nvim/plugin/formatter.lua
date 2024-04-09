-- Utilities for creating configurations
local util = require "formatter.util"
local formatter = require "formatter"

vim.keymap.set("n", "<leader>af", ":Format<CR>")

function getJavaBin()
    local jdkhome = os.getenv("JAVA_HOME_4GJF")
    if jdkhome == nil then
        jdkhome = os.getenv("JAVA_HOME")
    end
    if jdkhome == nil then
        return "java"
    else
        return jdkhome .. "/bin/java"
    end
end

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
formatter.setup {
    logging = true,
    log_level = vim.log.levels.DEBUG,
    filetype = {
        -- Formatter configurations for filetypes go here and will be executed in order
        lua = {
            require("formatter.filetypes.lua").luafmt
        },
        java = {
            function()
                local gjfjar = os.getenv("GJF_JAR_FILE")
                if gjfjar == nil then
                    gjfjar = "~/.local/share/google-java-format/google-java-format-all-deps.jar"
                end
                return {
                    exe = getJavaBin(),
                    args = {
                        "-jar",
                        gjfjar,
                        "-"
                    },
                    stdin = true
                }
            end
        },
        c = {
            require("formatter.filetypes.c").clangformat
        },
        cpp = {
            require("formatter.filetypes.cpp").clangformat
        },
        go = {
            require("formatter.filetypes.go").gofmt
        },
        json = {
            require("formatter.filetypes.json").jsbeautify
        },
        proto = {
            require("formatter.filetypes.proto").buf_format
        },
        python = {
            require("formatter.filetypes.python").black
        },
        yaml = {
            require("formatter.filetypes.yaml").yamlfmt
        },
        latex = {
            require("formatter.filetypes.latex").latexindent
        },
        r = {
            require("formatter.filetypes.r").styler
        },
        rust = {
            require("formatter.filetypes.rust").rustfmt
        },
        sh = {
            require("formatter.filetypes.sh").shfmt
        },
        sql = {
            require("formatter.filetypes.sql").sqlfluff
        },
        cmake = {
            require("formatter.filetypes.cmake").cmakeformat
        },
        xhtml = {
            require("formatter.filetypes.xhtml").tidy
        },
        xml = {
            require("formatter.filetypes.xml").xmllint
        },
        toml = {
            require("formatter.filetypes.toml").taplo
        },
        markdown = {
            function()
                return {
                    exe = "remark",
                    args = {
                        "--no-color",
                        "-"
                    },
                    stdin = true
                }
            end
        },
        -- Use the special "*" filetype for defining formatter configurations on
        -- any filetype
        ["*"] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require("formatter.filetypes.any").remove_trailing_whitespace
        }
    }
}
