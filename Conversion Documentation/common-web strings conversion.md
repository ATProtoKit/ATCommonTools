# Conversion for `common-web/strings.ts`

## `export const utf8Len = (str: string): number`

This is redundant and will not be converted. Use `.utf8.count` on the `String` object instead.

```swift
let string = "I am feeling great today!"
string.utf8.count
```

## `export const graphemeLen = (str: string): number`

This is redundant and will not be converted. Use `.count` on the `String` object instead.

```swift
let string = "I am feeling great today!"
string.count
```

## `export const utf8ToB64Url = (utf8: string): string`

This is redundant and will not be converted. MultiformatKit and ATCryptography both contain methods that will convert from a `String` to Base64URL. Use one of those instead.

## `export const b64UrlToUtf8 = (b64: string): string`

This is redundant and will not be converted. MultiformatKit and ATCryptography both contain methods that will convert from Base64URL to a `String` object. Use one of those instead.

## `export const parseLanguage = (langTag: string): LanguageTag | null`

This is unneeded and will not be converted. Use `Locale` instead.

## `export const validateLanguage = (langTag: string): boolean`

This is unneeded and will not be converted.

## `export type LanguageTag`

This is unneeded and will not be converted.

## `const bcp47Regexp`

This is unneeded and will not be converted.
