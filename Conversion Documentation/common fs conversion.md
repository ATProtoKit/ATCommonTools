#  Conversion for `common/fs.ts`

## `export const fileExists = async (location: string): Promise<boolean>`

This is redundant and will not be converted.

Use `FileManager.default.fileExists(atPath:)` instead.

## `export const readIfExists = async (filepath: string,): Promise<Uint8Array | undefined>`

This is redundant and will not be converted.

Use `try? Data(contentsOf: URL(fileURLWithPath: filepath))` ibstead.

## `export const rmIfExists = async (filepath: string, recursive = false,): Promise<void>`

This is redundant and will not be converted.

Use `try? FileManager.default.removeItem(at: URL(fileURLWithPath:))` instead.

## `export const renameIfExists = async (oldPath: string, newPath: string,): Promise<void>`

This is redundant and will not be converted.

Use `try? FileManager.default.moveItem(at: URL(fileURLWithPath:), to: URL(fileURLWithPath:))` instead.
