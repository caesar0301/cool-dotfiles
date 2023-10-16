-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.WARN,
    -- All formatter configurations are opt-in
    filetype = {
        -- Formatter configurations for filetypes go here and will be executed in order
        lua = {
            require("formatter.filetypes.lua").luafmt
        },
        java = {
            function()
                local home = os.getenv("HOME")
                local jdk_home = os.getenv("JAVA_HOME_4GJF")
                if jdk_home == nil then
                    jdk_home = os.getenv("JAVA_HOME")
                end
                local java_bin = "java"
                if not jdk_home == nil then
                    java_bin = jdk_home .. "/bin/java"
                end
                local gjfjar = os.getenv("GJF_JAR_FILE")
                if gjfjar == nil then
                    gjfjar = home .. "/.local/share/google-java-format/google-java-format-all-deps.jar"
                end
                return {
                    exe = java_bin,
                    args = {
                        "-jar",
                        gjfjar,
                        "-"
                    },
                    stdin = true
                }
            end
        },
        cpp = {
            require("formatter.filetypes.cpp").clangformat
        },
        go = {
            require("formatter.filetypes.go").gofmt
        },
        python = {
            require("formatter.filetypes.python").black
        },
        python = {
            require("formatter.filetypes.python").black
        },
        latex = {
            require("formatter.filetypes.latex").latexindent
        },
        sh = {
            require("formatter.filetypes.sh").shfmt
        },
        cmake = {
            require("formatter.filetypes.cmake").cmakeformat
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
