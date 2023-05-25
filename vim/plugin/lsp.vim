lua require('lspconfig').lua_ls.setup{ on_attach = require 'on_lsp_attach' }
lua require('lspconfig').zls.setup{ on_attach = require 'on_lsp_attach' }
lua require('lspconfig').standardrb.setup{ on_attach = require 'on_lsp_attach' }
lua require('lspconfig').clangd.setup{ on_attach = require 'on_lsp_attach' }
