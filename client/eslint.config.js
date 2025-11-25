import js from "@eslint/js";
import eslintPluginPrettierRecommended from "eslint-plugin-prettier/recommended";
import reactHooks from "eslint-plugin-react-hooks";
import reactRefresh from "eslint-plugin-react-refresh";
import { defineConfig, globalIgnores } from "eslint/config";
import globals from "globals";
import tseslint from "typescript-eslint";
import importPlugin from "eslint-plugin-import";

export default defineConfig([
  globalIgnores(["dist"]),
  {
    files: ["**/*.{ts,tsx}"],
    extends: [
      js.configs.recommended,
      ...tseslint.configs.recommended,
      reactHooks.configs.flat.recommended,
      reactRefresh.configs.vite,
      importPlugin.flatConfigs.recommended,
      importPlugin.flatConfigs.typescript,
    ],
    languageOptions: {
      ecmaVersion: 2020,
      globals: globals.browser,
    },
    settings: {
      "import/resolver": {
        typescript: {
          alwaysTryTypes: true,
        },
      },
    },
    rules: {
      "import/order": [
        "error",
        {
          groups: [
            "builtin", // Node built-ins (fs, path)
            "external", // npm packages
            "internal", // Your aliases (@/, ~/)
            ["parent", "sibling"], // Relative imports
            "index",
          ],
          "newlines-between": "always",
          alphabetize: {
            order: "asc",
            caseInsensitive: true,
          },
        },
      ],
      // Disable unresolved imports for Vite public directory assets (paths starting with /)
      "import/no-unresolved": [
        "error",
        {
          ignore: ["^/"], // Ignore absolute paths that Vite resolves from public directory
        },
      ],
    },
  },
  eslintPluginPrettierRecommended, // Must be last to override conflicting rules
]);
