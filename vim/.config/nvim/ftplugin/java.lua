local home = os.getenv('HOME')
local config = {
    cmd = {home .. "/.local/share/jdt-language-server/bin/jdtls"},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw', 'pom.xml'}, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)