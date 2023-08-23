local jdtls = require('jdtls')
local root_markers = { 'gradlew', '.git', 'gradlew' }
local home = os.getenv('HOME')
local jdk_home = os.getenv('JAVA_HOME')
local jdtls_install_folder = home .. "/.local/share/jdt-language-server"
local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
local config = {
    -- Java17+
    cmd = {
        jdk_home .. '/bin/java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx4g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',
        '-jar', vim.fn.glob(jdtls_install_folder .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
        '-configuration', jdtls_install_folder .. '/config_linux', '-data', workspace_folder
    },

    root_dir = jdtls.setup.find_root(root_markers),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {}
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    init_options = {
        bundles = {}
    },

    on_attach = function(client, bufnr)
        jdtls.setup_dap({
            hotcodereplace = 'auto'
        })
        jdtls.setup.add_commands()
        local opts = {
            silent = true,
            buffer = bufnr
        }
        vim.keymap.set('n', "cdo", jdtls.organize_imports, opts)
        vim.keymap.set('n', "cdf", jdtls.test_class, opts)
        vim.keymap.set('n', "cdn", jdtls.test_nearest_method, opts)
        vim.keymap.set('n', "crv", jdtls.extract_variable, opts)
        vim.keymap.set('v', 'crm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
        vim.keymap.set('n', "crc", jdtls.extract_constant, opts)
    end
}
-- This starts a new client & server,
jdtls.start_or_attach(config)
