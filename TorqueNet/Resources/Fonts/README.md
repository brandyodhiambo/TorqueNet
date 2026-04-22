## Fonts

Put all custom font files (`.ttf` / `.otf`) in this folder.

### Setup checklist (Xcode)

- Ensure each font file is included in the app target and appears under **Build Phases → Copy Bundle Resources**
- Ensure `TorqueNet/Info.plist` includes each font path under `UIAppFonts` (this project expects paths like `Resources/Fonts/<FontFile>.ttf`)

### Naming

- Use the **PostScript name** in SwiftUI `.custom(...)` (e.g. `Exo2-ExtraBold`), not the filename (e.g. `Exo2-ExtraBold.ttf`).
