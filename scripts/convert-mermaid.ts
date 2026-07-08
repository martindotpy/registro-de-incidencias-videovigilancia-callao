import { $, Glob } from "bun"
import path from "node:path"

// Dir
const srcDir = "src/assets/mmd"
const outDir = "src/assets/img"

// Glob
const mermaidGlob = new Glob("**/*.mmd")

await Promise.all(
  (await Array.fromAsync(mermaidGlob.scan(srcDir))).map(
    async (relativePath) => {
      const outputFilePath = path.join(
        outDir,
        relativePath.replace(/\.mmd$/, ".png")
      )

      await $`mkdir -p ${path.dirname(outputFilePath)}`
      await $`mmdc -c mermaid-config.json -i ${path.join(srcDir, relativePath)} -o ${outputFilePath} -b transparent`

      console.log(`Generated ${outputFilePath}`)
    }
  )
)
