return {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform", "go.mod", ".git" },
  settings = {
    terraform = {
      validation = {
        enableEnhancedValidation = true,
      },
    },
    experimentalFeatures = {
      prefillRequiredFields = true,
    },
  },
}
