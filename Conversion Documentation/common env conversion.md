# Conversion for `env.ts`

## `export const envInt = (name: string): number | undefined` 

This is redundant and will not be converted. Simply use `ProcessInfo` and wrap it into an `Int` initializer. A fallback can be made by using `??`.

```swift
let port = Int(ProcessInfo.processInfo.environment["PORT"] ?? "") ?? 8080
```

## `export const envStr = (name: string): string | undefined`

This is redundant and will not be converted. Simply use `ProcessInfo` and wrap it into a `String` initializer. A fallback can be made by using `??`.

```swift
let nameValue = String(ProcessInfo.processInfo.environment["NAME"] ?? "")
```

## `export const envBool = (name: string): boolean | undefined`

This is redunant and will not be converted. Simply use `ProcessInfo` for this. Creating a method for this is trivial:

```swift
func envBool(_ name: String) -> Bool? {
    guard let value = ProcessInfo.processInfo.environment[name]?.lowercased() else { return nil }
    switch value {
        case "true", "1": return true
        case "false", "0": return false
        default: return nil
    }
}
```

## `export const envList = (name: string): string[]`

This is redundant and will not be converted. Simply use `ProcessInfo` for this. This can be done with just one line:

```swift
let arrayItems = ProcessInfo.processInfo.environment["ITEMS"]?.split(separator: ",").map(String.init) ?? []
```
